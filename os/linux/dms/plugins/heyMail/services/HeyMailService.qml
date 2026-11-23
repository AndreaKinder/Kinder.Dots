pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool heyMissing: false
    property bool _binaryProbed: false
    property bool authenticated: false
    property bool loading: false
    property string lastError: ""

    property string currentBox: "imbox"
    property var postings: []
    property int imboxUnreadCount: 0

    property var selectedThread: null
    property var selectedPosting: null
    property bool threadLoading: false
    property string threadError: ""

    property int pollIntervalMs: 60000

    readonly property var boxes: [
        { id: "imbox", label: "Imbox" },
        { id: "feed", label: "The Feed" },
        { id: "papertrail", label: "Paper Trail" },
        { id: "setaside", label: "Set Aside" },
        { id: "replylater", label: "Reply Later" }
    ]

    function senderNames(posting) {
        if (!posting)
            return "";
        if (posting.contacts && posting.contacts.length > 0) {
            return posting.contacts.map(c => c.name || c.email_address || "").filter(s => s.length > 0).join(", ");
        }
        return posting.kind === "bundle" ? "Bundle" : "";
    }

    function formatTime(isoStr) {
        if (!isoStr)
            return "";
        const d = new Date(isoStr);
        if (isNaN(d.getTime()))
            return "";
        const now = new Date();
        const sameDay = d.getFullYear() === now.getFullYear()
            && d.getMonth() === now.getMonth()
            && d.getDate() === now.getDate();
        if (sameDay)
            return Qt.formatTime(d, "hh:mm");
        return Qt.formatDate(d, "dd/MM");
    }

    function refresh() {
        if (heyMissing)
            return;
        if (!boxProc.running) {
            loading = true;
            lastError = "";
            boxProc.boxTarget = currentBox;
            boxProc.command = ["hey", "box", "view", currentBox, "--limit", "25", "--json"];
            boxProc.running = true;
        }
        if (currentBox !== "imbox" && !imboxCountProc.running) {
            imboxCountProc.running = true;
        }
    }

    function selectBox(boxId) {
        if (currentBox === boxId && postings.length > 0)
            return;
        currentBox = boxId;
        closeThread();
        refresh();
    }

    function openThread(posting) {
        if (!posting)
            return;
        if (!posting.topic_id) {
            if (posting.app_url)
                openInHey(posting.app_url);
            return;
        }
        selectedPosting = posting;
        selectedThread = null;
        threadError = "";
        threadLoading = true;
        threadProc.command = ["hey", "thread", "read", String(posting.topic_id), "--json"];
        threadProc.running = true;
    }

    function closeThread() {
        selectedThread = null;
        selectedPosting = null;
        threadLoading = false;
        threadError = "";
    }

    function toggleSeen(posting) {
        if (!posting || !posting.id)
            return;
        const cmd = posting.seen === true ? "unseen" : "seen";
        actionProc.command = ["hey", cmd, String(posting.id), "--json"];
        actionProc.running = true;
    }

    function openInHey(url) {
        if (url && url.length > 0) {
            Quickshell.execDetached(["xdg-open", url]);
        } else {
            Quickshell.execDetached(["firefoxpwa", "site", "launch", "01M7Y10CWF0X27PJ6RNVS9M5YQ"]);
        }
    }

    function loginInTerminal() {
        Quickshell.execDetached(["ghostty", "-e", "hey", "auth", "login"]);
    }

    Process {
        id: probeProc
        command: ["sh", "-c", "command -v hey >/dev/null 2>&1"]
        running: true
        onExited: exitCode => {
            root._binaryProbed = true;
            root.heyMissing = (exitCode !== 0);
            if (!root.heyMissing)
                root.refresh();
        }
    }

    Process {
        id: boxProc
        property string boxTarget: "imbox"
        stdout: StdioCollector {
            onStreamFinished: {
                root.loading = false;
                let parsed = null;
                try {
                    parsed = JSON.parse(text);
                } catch (e) {
                    root.lastError = "Invalid JSON from hey CLI";
                    return;
                }
                if (!parsed || parsed.ok !== true) {
                    if (parsed && parsed.code === "auth") {
                        root.authenticated = false;
                        root.postings = [];
                        root.imboxUnreadCount = 0;
                        root.lastError = parsed.error || "Not logged in";
                    } else {
                        root.lastError = (parsed && parsed.error) ? parsed.error : "Failed to load mailbox";
                    }
                    return;
                }
                root.authenticated = true;
                root.lastError = "";
                const list = (parsed.data && parsed.data.postings) ? parsed.data.postings : [];
                root.postings = list;
                if (boxProc.boxTarget === "imbox") {
                    root.imboxUnreadCount = list.filter(p => p.seen !== true).length;
                }
            }
        }
        onExited: exitCode => {
            root.loading = false;
            if (exitCode !== 0 && root.lastError === "" && root.authenticated) {
                root.lastError = "hey exited with status " + exitCode;
            }
        }
    }

    Process {
        id: imboxCountProc
        command: ["hey", "box", "view", "imbox", "--limit", "50", "--json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(text);
                    if (parsed && parsed.ok === true && parsed.data && parsed.data.postings) {
                        root.imboxUnreadCount = parsed.data.postings.filter(p => p.seen !== true).length;
                    }
                } catch (e) {}
            }
        }
    }

    Process {
        id: threadProc
        stdout: StdioCollector {
            onStreamFinished: {
                root.threadLoading = false;
                try {
                    const parsed = JSON.parse(text);
                    if (parsed && parsed.ok === true && parsed.data) {
                        root.selectedThread = parsed.data;
                        root.threadError = "";
                    } else {
                        root.threadError = (parsed && parsed.error) ? parsed.error : "Failed to load thread";
                    }
                } catch (e) {
                    root.threadError = "Failed to parse thread";
                }
            }
        }
        onExited: exitCode => {
            root.threadLoading = false;
        }
    }

    Process {
        id: actionProc
        onExited: exitCode => {
            if (exitCode === 0) {
                if (root.selectedPosting) {
                    const updated = Object.assign({}, root.selectedPosting);
                    updated.seen = !(updated.seen === true);
                    root.selectedPosting = updated;
                }
                root.refresh();
            }
        }
    }

    Timer {
        interval: root.pollIntervalMs
        repeat: true
        running: root._binaryProbed && !root.heyMissing
        onTriggered: root.refresh()
    }
}
