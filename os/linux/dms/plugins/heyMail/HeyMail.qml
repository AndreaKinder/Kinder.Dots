import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    readonly property int pollSeconds: parseInt(pluginData.pollSeconds) || 60
    readonly property bool showCount: pluginData.showCount === undefined ? true : pluginData.showCount === true
    readonly property bool onlyUnread: pluginData.onlyUnread === true

    readonly property var visiblePostings: {
        if (!HeyMailService.postings)
            return [];
        if (onlyUnread)
            return HeyMailService.postings.filter(p => p.seen !== true);
        return HeyMailService.postings;
    }

    readonly property string statusText: {
        if (HeyMailService.heyMissing)
            return "hey CLI not installed";
        if (!HeyMailService.authenticated)
            return "Not logged in";
        if (HeyMailService.loading && HeyMailService.postings.length === 0)
            return "Loading…";
        if (HeyMailService.imboxUnreadCount > 0)
            return HeyMailService.imboxUnreadCount + " unread in Imbox";
        return "All caught up";
    }

    Binding {
        target: HeyMailService
        property: "pollIntervalMs"
        value: root.pollSeconds * 1000
    }

    popoutWidth: 440

    IpcHandler {
        target: "heyMail"

        function popout(): string {
            root.triggerPopout();
            return "toggled";
        }

        function refresh(): string {
            HeyMailService.refresh();
            return "refreshed";
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS
            anchors.verticalCenter: parent.verticalCenter

            Item {
                width: barIcon.width
                height: barIcon.height
                anchors.verticalCenter: parent.verticalCenter

                DankIcon {
                    id: barIcon
                    name: HeyMailService.imboxUnreadCount > 0 ? "mark_email_unread" : "mail"
                    size: root.iconSizeLarge - 4
                    color: HeyMailService.imboxUnreadCount > 0 ? Theme.primary : Theme.widgetIconColor
                    anchors.centerIn: parent
                }

                DankIcon {
                    visible: HeyMailService.heyMissing || !HeyMailService.authenticated
                    name: "priority_high"
                    filled: true
                    size: barIcon.size * 0.5
                    color: Theme.error
                    anchors.right: barIcon.right
                    anchors.top: barIcon.top
                    anchors.rightMargin: -3
                    anchors.topMargin: -2
                }
            }

            StyledText {
                visible: HeyMailService.authenticated && root.showCount && HeyMailService.imboxUnreadCount > 0
                text: String(HeyMailService.imboxUnreadCount)
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Bold
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                width: barIconV.width
                height: barIconV.height
                anchors.horizontalCenter: parent.horizontalCenter

                DankIcon {
                    id: barIconV
                    name: HeyMailService.imboxUnreadCount > 0 ? "mark_email_unread" : "mail"
                    size: root.iconSizeLarge
                    color: HeyMailService.imboxUnreadCount > 0 ? Theme.primary : Theme.widgetIconColor
                    anchors.centerIn: parent
                }

                DankIcon {
                    visible: HeyMailService.heyMissing || !HeyMailService.authenticated
                    name: "priority_high"
                    filled: true
                    size: barIconV.size * 0.5
                    color: Theme.error
                    anchors.right: barIconV.right
                    anchors.top: barIconV.top
                    anchors.rightMargin: -3
                    anchors.topMargin: -2
                }
            }

            StyledText {
                visible: HeyMailService.authenticated && root.showCount && HeyMailService.imboxUnreadCount > 0
                text: String(HeyMailService.imboxUnreadCount)
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Bold
                color: Theme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popout

            readonly property bool detailsVisible: parentPopout?.shouldBeVisible ?? false
            onDetailsVisibleChanged: {
                if (detailsVisible)
                    HeyMailService.refresh();
            }

            headerText: "HEY Mail"
            detailsText: root.statusText
            showCloseButton: true

            headerActions: Component {
                Row {
                    spacing: Theme.spacingXS

                    DankActionButton {
                        iconName: "open_in_new"
                        iconColor: Theme.surfaceVariantText
                        buttonSize: 28
                        tooltipText: "Open HEY"
                        tooltipSide: "bottom"
                        onClicked: {
                            root.closePopout();
                            HeyMailService.openInHey("");
                        }
                    }

                    DankActionButton {
                        iconName: "refresh"
                        iconColor: Theme.surfaceVariantText
                        buttonSize: 28
                        tooltipText: "Refresh"
                        tooltipSide: "bottom"
                        onClicked: HeyMailService.refresh()
                    }

                    DankActionButton {
                        iconName: "settings"
                        iconColor: Theme.surfaceVariantText
                        buttonSize: 28
                        tooltipText: "Plugin settings"
                        tooltipSide: "bottom"
                        onClicked: {
                            root.closePopout();
                            PopoutService.openSettingsWithTab("plugins");
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: Theme.spacingM

                // Missing binary or unauthenticated state
                StyledRect {
                    visible: HeyMailService.heyMissing || !HeyMailService.authenticated
                    width: parent.width
                    height: authCol.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    border.width: 1
                    border.color: Theme.outlineVariant

                    Column {
                        id: authCol
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS

                        StyledText {
                            width: parent.width
                            text: HeyMailService.heyMissing
                                ? "The 'hey' CLI binary was not found in PATH."
                                : "Authenticate with HEY CLI to view your emails from the top bar."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            wrapMode: Text.WordWrap
                        }

                        Row {
                            spacing: Theme.spacingS
                            visible: !HeyMailService.heyMissing

                            DankButton {
                                text: "Login in Terminal"
                                iconName: "terminal"
                                onClicked: {
                                    root.closePopout();
                                    HeyMailService.loginInTerminal();
                                }
                            }

                            DankButton {
                                text: "Retry"
                                iconName: "refresh"
                                onClicked: HeyMailService.refresh()
                            }
                        }
                    }
                }

                // Box tabs (when authenticated and not reading a thread)
                Flow {
                    visible: HeyMailService.authenticated && !HeyMailService.selectedPosting
                    width: parent.width
                    spacing: Theme.spacingXS

                    Repeater {
                        model: HeyMailService.boxes

                        delegate: StyledRect {
                            required property var modelData
                            readonly property bool active: HeyMailService.currentBox === modelData.id

                            width: tabLabel.implicitWidth + Theme.spacingM * 2
                            height: 28
                            radius: Theme.cornerRadius
                            color: active ? Theme.primary : Theme.surfaceContainerHigh
                            border.width: 1
                            border.color: active ? Theme.primary : Theme.outlineVariant

                            StyledText {
                                id: tabLabel
                                anchors.centerIn: parent
                                text: modelData.label
                                font.pixelSize: Theme.fontSizeSmall
                                font.weight: active ? Font.Bold : Font.Normal
                                color: active ? Theme.primaryText : Theme.surfaceText
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: HeyMailService.selectBox(modelData.id)
                            }
                        }
                    }
                }

                // Error banner
                StyledRect {
                    visible: HeyMailService.authenticated && HeyMailService.lastError !== "" && !HeyMailService.selectedPosting
                    width: parent.width
                    height: errText.implicitHeight + Theme.spacingS * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    border.width: 1
                    border.color: Theme.error

                    StyledText {
                        id: errText
                        anchors.fill: parent
                        anchors.margins: Theme.spacingS
                        text: HeyMailService.lastError
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.error
                        wrapMode: Text.WordWrap
                    }
                }

                // Email list
                Flickable {
                    visible: HeyMailService.authenticated && !HeyMailService.selectedPosting
                    width: parent.width
                    height: Math.min(400, Math.max(120, listCol.implicitHeight))
                    contentHeight: listCol.implicitHeight
                    clip: true

                    Column {
                        id: listCol
                        width: parent.width
                        spacing: Theme.spacingXS

                        StyledText {
                            visible: root.visiblePostings.length === 0 && !HeyMailService.loading
                            width: parent.width
                            text: root.onlyUnread ? "No unread emails in this box." : "No emails in this box."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            horizontalAlignment: Text.AlignHCenter
                            topPadding: Theme.spacingL
                            bottomPadding: Theme.spacingL
                        }

                        Repeater {
                            model: root.visiblePostings

                            delegate: StyledRect {
                                required property var modelData
                                readonly property bool unread: modelData.seen !== true

                                width: listCol.width
                                height: rowCol.implicitHeight + Theme.spacingS * 2
                                radius: Theme.cornerRadius
                                color: rowMouse.containsMouse ? Theme.surfaceContainerHighest : Theme.surfaceContainerHigh
                                border.width: 1
                                border.color: unread ? Theme.primary : Theme.outlineVariant

                                Column {
                                    id: rowCol
                                    anchors.fill: parent
                                    anchors.margins: Theme.spacingS
                                    spacing: 2

                                    Row {
                                        width: parent.width
                                        spacing: Theme.spacingXS

                                        Rectangle {
                                            visible: unread
                                            width: 6
                                            height: 6
                                            radius: 3
                                            color: Theme.primary
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        StyledText {
                                            width: parent.width - timeTxt.implicitWidth - (unread ? 14 : 0) - Theme.spacingXS
                                            text: HeyMailService.senderNames(modelData) || modelData.name || "(No subject)"
                                            font.pixelSize: Theme.fontSizeSmall
                                            font.weight: unread ? Font.Bold : Font.Medium
                                            color: Theme.surfaceText
                                            elide: Text.ElideRight
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        StyledText {
                                            id: timeTxt
                                            text: HeyMailService.formatTime(modelData.created_at)
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: Theme.surfaceVariantText
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    StyledText {
                                        width: parent.width
                                        text: modelData.name || "(No subject)"
                                        font.pixelSize: Theme.fontSizeSmall
                                        font.weight: unread ? Font.Bold : Font.Normal
                                        color: Theme.surfaceText
                                        elide: Text.ElideRight
                                    }

                                    StyledText {
                                        visible: (modelData.summary || "").length > 0
                                        width: parent.width
                                        text: modelData.summary || ""
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceVariantText
                                        elide: Text.ElideRight
                                    }
                                }

                                MouseArea {
                                    id: rowMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: HeyMailService.openThread(modelData)
                                }
                            }
                        }
                    }
                }

                // Inline Thread Reader
                Column {
                    visible: HeyMailService.authenticated && HeyMailService.selectedPosting !== null
                    width: parent.width
                    spacing: Theme.spacingS

                    Row {
                        width: parent.width
                        spacing: Theme.spacingXS

                        DankActionButton {
                            iconName: "arrow_back"
                            iconColor: Theme.surfaceText
                            buttonSize: 28
                            tooltipText: "Back"
                            onClicked: HeyMailService.closeThread()
                        }

                        StyledText {
                            width: parent.width - 28 * 3 - Theme.spacingXS * 3
                            text: (HeyMailService.selectedPosting && HeyMailService.selectedPosting.name) || ""
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.Bold
                            color: Theme.surfaceText
                            elide: Text.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        DankActionButton {
                            iconName: (HeyMailService.selectedPosting && HeyMailService.selectedPosting.seen === true)
                                ? "mark_email_unread"
                                : "mark_email_read"
                            iconColor: Theme.surfaceVariantText
                            buttonSize: 28
                            tooltipText: (HeyMailService.selectedPosting && HeyMailService.selectedPosting.seen === true)
                                ? "Mark unread"
                                : "Mark read"
                            onClicked: HeyMailService.toggleSeen(HeyMailService.selectedPosting)
                        }

                        DankActionButton {
                            iconName: "open_in_new"
                            iconColor: Theme.surfaceVariantText
                            buttonSize: 28
                            tooltipText: "Open in HEY"
                            onClicked: {
                                const url = HeyMailService.selectedPosting ? HeyMailService.selectedPosting.app_url : "";
                                root.closePopout();
                                HeyMailService.openInHey(url);
                            }
                        }
                    }

                    StyledText {
                        visible: HeyMailService.threadLoading
                        width: parent.width
                        text: "Loading thread…"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                    }

                    StyledText {
                        visible: HeyMailService.threadError !== ""
                        width: parent.width
                        text: HeyMailService.threadError
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.error
                        wrapMode: Text.WordWrap
                    }

                    Flickable {
                        visible: !HeyMailService.threadLoading && HeyMailService.selectedThread !== null
                        width: parent.width
                        height: Math.min(360, Math.max(100, threadCol.implicitHeight))
                        contentHeight: threadCol.implicitHeight
                        clip: true

                        Column {
                            id: threadCol
                            width: parent.width
                            spacing: Theme.spacingS

                            Repeater {
                                model: (HeyMailService.selectedThread && HeyMailService.selectedThread.entries) || []

                                delegate: StyledRect {
                                    required property var modelData
                                    width: threadCol.width
                                    height: entryCol.implicitHeight + Theme.spacingS * 2
                                    radius: Theme.cornerRadius
                                    color: Theme.surfaceContainerHigh
                                    border.width: 1
                                    border.color: Theme.outlineVariant

                                    Column {
                                        id: entryCol
                                        anchors.fill: parent
                                        anchors.margins: Theme.spacingS
                                        spacing: Theme.spacingXS

                                        Row {
                                            width: parent.width
                                            spacing: Theme.spacingXS

                                            StyledText {
                                                width: parent.width - entryTime.implicitWidth - Theme.spacingXS
                                                text: {
                                                    const who = modelData.sender || modelData.creator;
                                                    return who ? (who.name || who.email_address || "") : "";
                                                }
                                                font.pixelSize: Theme.fontSizeSmall
                                                font.weight: Font.Bold
                                                color: Theme.primary
                                                elide: Text.ElideRight
                                            }

                                            StyledText {
                                                id: entryTime
                                                text: HeyMailService.formatTime(modelData.created_at)
                                                font.pixelSize: Theme.fontSizeSmall
                                                color: Theme.surfaceVariantText
                                            }
                                        }

                                        StyledText {
                                            width: parent.width
                                            text: (modelData.body || modelData.content || modelData.summary || "").trim()
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: Theme.surfaceText
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
