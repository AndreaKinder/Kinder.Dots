pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool apiKeyMissing: true
    property bool loading: false
    property string lastError: ""

    // Credit info
    property real totalCredits: 0
    property real monthlyLimit: 0
    property real creditsUsed: 0
    property real creditsRemaining: 0
    property string creditResetDate: ""

    // Model pricing
    property var models: []
    property var cheapestModels: []
    property int maxModelsShown: 10

    // Poll interval
    property int pollIntervalMs: 300000

    readonly property string apiBase: "https://openrouter.ai/api/v1"

    function getApiKey() {
        return pluginSettings.apiKey || ""
    }

    function isConfigured() {
        return getApiKey().length > 0
    }

    function refresh() {
        if (!isConfigured()) {
            apiKeyMissing = true
            loading = false
            return
        }
        apiKeyMissing = false
        loading = true
        lastError = ""
        fetchCredits()
        fetchModels()
    }

    function fetchCredits() {
        creditsProc.command = [
            "curl", "-s", "-H", "Authorization: Bearer " + getApiKey(),
            apiBase + "/credits"
        ]
        creditsProc.running = true
    }

    function fetchModels() {
        modelsProc.command = [
            "curl", "-s", "-H", "Authorization: Bearer " + getApiKey(),
            apiBase + "/models"
        ]
        modelsProc.running = true
    }

    function formatCurrency(amount) {
        if (amount === undefined || amount === null)
            return "$0.00"
        return "$" + amount.toFixed(2)
    }

    function formatPct(value) {
        if (value === undefined || value === null || isNaN(value))
            return "0%"
        return Math.round(value * 100) + "%"
    }

    function sortModelsByPrice(modelsList) {
        if (!modelsList || modelsList.length === 0)
            return []
        var sorted = modelsList.slice()
        sorted.sort(function(a, b) {
            var aPrice = a.pricing || {}
            var bPrice = b.pricing || {}
            var aInput = parseFloat(aPrice.input) || Infinity
            var bInput = parseFloat(bPrice.input) || Infinity
            if (aPrice.input === undefined && aPrice.output === undefined) aInput = Infinity
            if (bPrice.input === undefined && bPrice.output === undefined) bInput = Infinity
            return aInput - bInput
        })
        return sorted.slice(0, root.maxModelsShown)
    }

    Process {
        id: creditsProc
        stdout: StdioCollector {
            onStreamFinished: {
                root.loading = false
                try {
                    var parsed = JSON.parse(text)
                    if (parsed && parsed.data) {
                        root.totalCredits = parseFloat(parsed.data.total_credits) || 0
                        root.monthlyLimit = parseFloat(parsed.data.monthly_limit) || 0
                        root.creditsUsed = parseFloat(parsed.data.total_usage) || 0
                        root.creditsRemaining = root.totalCredits - root.creditsUsed
                        if (parsed.data.period_end) {
                            var d = new Date(parsed.data.period_end * 1000)
                            root.creditResetDate = Qt.formatDate(d, "dd/MM/yyyy")
                        }
                        root.lastError = ""
                    } else if (parsed && parsed.error) {
                        root.lastError = parsed.error.message || "Error fetching credits"
                        root.totalCredits = 0
                        root.monthlyLimit = 0
                        root.creditsUsed = 0
                        root.creditsRemaining = 0
                    } else {
                        root.lastError = "Unexpected response format"
                    }
                } catch (e) {
                    root.lastError = "Failed to parse credits response"
                }
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0 && root.lastError === "")
                root.lastError = "Credits request failed (exit " + exitCode + ")"
        }
    }

    Process {
        id: modelsProc
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var parsed = JSON.parse(text)
                    if (parsed && parsed.data && Array.isArray(parsed.data)) {
                        root.models = parsed.data
                        root.cheapestModels = root.sortModelsByPrice(parsed.data)
                        root.lastError = ""
                    } else if (parsed && parsed.error) {
                        root.lastError = parsed.error.message || "Error fetching models"
                        root.models = []
                        root.cheapestModels = []
                    } else {
                        root.lastError = "Unexpected models response format"
                        root.models = []
                        root.cheapestModels = []
                    }
                } catch (e) {
                    root.lastError = "Failed to parse models response"
                    root.models = []
                    root.cheapestModels = []
                }
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0 && root.lastError === "")
                root.lastError = "Models request failed (exit " + exitCode + ")"
        }
    }

    Timer {
        interval: root.pollIntervalMs
        repeat: true
        running: root._binaryProbed && !root.apiKeyMissing
        onTriggered: root.refresh()
    }

    Process {
        id: probeProc
        command: ["sh", "-c", "command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1"]
        running: true
        onExited: exitCode => {
            root._binaryProbed = true
            if (exitCode === 0 && isConfigured())
                root.refresh()
        }
    }

    property bool _binaryProbed: false
}
