import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    readonly property int pollSeconds: parseInt(pluginData.pollSeconds) || 300
    readonly property bool showCredits: pluginData.showCredits === undefined ? true : pluginData.showCredits === true
    readonly property bool showModels: pluginData.showModels === undefined ? true : pluginData.showModels === true
    readonly property bool showCostPerToken: pluginData.showCostPerToken !== false

    readonly property string statusText: {
        if (OpenRouterService.apiKeyMissing)
            return "No API key";
        if (OpenRouterService.loading && OpenRouterService.models.length === 0)
            return "Loading…";
        if (OpenRouterService.lastError !== "")
            return OpenRouterService.lastError;
        if (OpenRouterService.creditsRemaining <= 0)
            return "Credits depleted";
        return OpenRouterService.formatCurrency(OpenRouterService.creditsRemaining) + " remaining";
    }

    readonly property string barTooltip: {
        if (OpenRouterService.apiKeyMissing)
            return "OpenRouter: API key not configured";
        if (OpenRouterService.loading)
            return "Fetching OpenRouter data…";
        var parts = []
        parts.push("Credits: " + OpenRouterService.formatCurrency(OpenRouterService.creditsRemaining) + " / " + OpenRouterService.formatCurrency(OpenRouterService.totalCredits))
        if (OpenRouterService.monthlyLimit > 0)
            parts.push("Monthly limit: " + OpenRouterService.formatCurrency(OpenRouterService.monthlyLimit))
        parts.push("Used: " + OpenRouterService.formatPct(OpenRouterService.creditsUsed / Math.max(1, OpenRouterService.monthlyLimit)))
        if (OpenRouterService.cheapestModels.length > 0)
            parts.push("Cheapest: " + OpenRouterService.cheapestModels[0].id)
        return parts.join("\n")
    }

    Binding {
        target: OpenRouterService
        property: "pollIntervalMs"
        value: root.pollSeconds * 1000
    }

    IpcHandler {
        target: "openRouter"

        function popout(): string {
            root.triggerPopout();
            return "toggled";
        }

        function refresh(): string {
            OpenRouterService.refresh();
            return "refreshed";
        }

        function configure(): string {
            root.closePopout();
            PopoutService.openSettingsWithTab("plugins");
            return "opened settings";
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
                    name: "router"
                    size: root.iconSizeLarge - 4
                    color: OpenRouterService.creditsRemaining < OpenRouterService.totalCredits * 0.2 ? Theme.error : Theme.widgetIconColor
                    anchors.centerIn: parent
                }

                DankIcon {
                    visible: OpenRouterService.apiKeyMissing
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
                visible: !OpenRouterService.apiKeyMissing && root.showCredits && OpenRouterService.creditsRemaining > 0
                text: OpenRouterService.formatCurrency(OpenRouterService.creditsRemaining)
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Bold
                color: OpenRouterService.creditsRemaining < OpenRouterService.totalCredits * 0.2 ? Theme.error : Theme.primary
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
                    name: "router"
                    size: root.iconSizeLarge
                    color: OpenRouterService.creditsRemaining < OpenRouterService.totalCredits * 0.2 ? Theme.error : Theme.widgetIconColor
                    anchors.centerIn: parent
                }

                DankIcon {
                    visible: OpenRouterService.apiKeyMissing
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
                visible: !OpenRouterService.apiKeyMissing && root.showCredits && OpenRouterService.creditsRemaining > 0
                text: OpenRouterService.formatCurrency(OpenRouterService.creditsRemaining)
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Bold
                color: OpenRouterService.creditsRemaining < OpenRouterService.totalCredits * 0.2 ? Theme.error : Theme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popout

            headerText: "OpenRouter"
            detailsText: root.statusText
            showCloseButton: true

            headerActions: Component {
                Row {
                    spacing: Theme.spacingXS

                    DankActionButton {
                        iconName: "refresh"
                        iconColor: Theme.surfaceVariantText
                        buttonSize: 28
                        tooltipText: "Refresh"
                        tooltipSide: "bottom"
                        onClicked: OpenRouterService.refresh()
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

                // Not configured state
                StyledRect {
                    visible: OpenRouterService.apiKeyMissing
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
                            text: "Add your OpenRouter API key in plugin settings to monitor credits and model prices."
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceText
                            wrapMode: Text.WordWrap
                        }

                        DankButton {
                            text: "Open Settings"
                            iconName: "settings"
                            onClicked: {
                                root.closePopout();
                                PopoutService.openSettingsWithTab("plugins");
                            }
                        }
                    }
                }

                // Error banner
                StyledRect {
                    visible: !OpenRouterService.apiKeyMissing && OpenRouterService.lastError !== ""
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
                        text: OpenRouterService.lastError
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.error
                        wrapMode: Text.WordWrap
                    }
                }

                // Credits overview
                StyledRect {
                    visible: !OpenRouterService.apiKeyMissing && !OpenRouterService.loading
                    width: parent.width
                    height: creditsCol.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    border.width: 1
                    border.color: Theme.outlineVariant

                    Column {
                        id: creditsCol
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS

                        StyledText {
                            width: parent.width
                            text: "Credit Balance"
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.Bold
                            color: Theme.primary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Row {
                            width: parent.width
                            spacing: Theme.spacingM
                            anchors.horizontalCenter: parent.horizontalCenter

                            Column {
                                spacing: 2
                                StyledText {
                                    text: "Remaining"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                StyledText {
                                    text: OpenRouterService.formatCurrency(OpenRouterService.creditsRemaining)
                                    font.pixelSize: Theme.fontSizeLarge
                                    font.weight: Font.Bold
                                    color: OpenRouterService.creditsRemaining < OpenRouterService.totalCredits * 0.2 ? Theme.error : Theme.primary
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            Column {
                                spacing: 2
                                StyledText {
                                    text: "Used"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                StyledText {
                                    text: OpenRouterService.formatCurrency(OpenRouterService.creditsUsed)
                                    font.pixelSize: Theme.fontSizeLarge
                                    font.weight: Font.Bold
                                    color: Theme.warning
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            Column {
                                spacing: 2
                                StyledText {
                                    text: "Total"
                                    font.pixelSize: Theme.fontSizeSmall
                                    color: Theme.surfaceVariantText
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                StyledText {
                                    text: OpenRouterService.formatCurrency(OpenRouterService.totalCredits)
                                    font.pixelSize: Theme.fontSizeLarge
                                    font.weight: Font.Bold
                                    color: Theme.surfaceText
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        // Progress bar
                        StyledRect {
                            width: parent.width
                            height: 6
                            radius: 3
                            color: Theme.surfaceContainerHighest

                            Rectangle {
                                width: parent.width * Math.min(1, OpenRouterService.creditsUsed / Math.max(1, OpenRouterService.monthlyLimit))
                                height: parent.height
                                radius: 3
                                color: OpenRouterService.creditsUsed / Math.max(1, OpenRouterService.monthlyLimit) > 0.8 ? Theme.error : Theme.primary
                            }
                        }

                        StyledText {
                            width: parent.width
                            text: "Monthly limit: " + OpenRouterService.formatCurrency(OpenRouterService.monthlyLimit) + " · Reset: " + OpenRouterService.creditResetDate
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.surfaceVariantText
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                // Loading state
                StyledRect {
                    visible: !OpenRouterService.apiKeyMissing && OpenRouterService.loading
                    width: parent.width
                    height: 60
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh

                    StyledText {
                        anchors.centerIn: parent
                        text: "Fetching OpenRouter data…"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                    }
                }

                // Cheapest models list
                StyledRect {
                    visible: !OpenRouterService.apiKeyMissing && !OpenRouterService.loading && root.showModels && OpenRouterService.cheapestModels.length > 0
                    width: parent.width
                    height: modelsList.implicitHeight + Theme.spacingM * 2
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh
                    border.width: 1
                    border.color: Theme.outlineVariant

                    Column {
                        id: modelsList
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingS

                        StyledText {
                            width: parent.width
                            text: "Top " + OpenRouterService.cheapestModels.length + " Cheapest Models (input token price)"
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.Bold
                            color: Theme.primary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Repeater {
                            model: OpenRouterService.cheapestModels

                            delegate: StyledRect {
                                required property var modelData
                                width: parent.width
                                height: rowCol.implicitHeight + Theme.spacingS * 2
                                radius: Theme.cornerRadius
                                color: Theme.surfaceContainerHighest
                                border.width: 1
                                border.color: Theme.outlineVariant

                                Column {
                                    id: rowCol
                                    anchors.fill: parent
                                    anchors.margins: Theme.spacingS
                                    spacing: 2

                                    Row {
                                        width: parent.width
                                        spacing: Theme.spacingXS

                                        StyledText {
                                            width: parent.width - priceTxt.implicitWidth - Theme.spacingXS
                                            text: modelData.id || "(unknown model)"
                                            font.pixelSize: Theme.fontSizeSmall
                                            font.weight: Font.Medium
                                            color: Theme.surfaceText
                                            elide: Text.ElideRight
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        StyledText {
                                            id: priceTxt
                                            text: "$" + (parseFloat((modelData.pricing || {}).input) || "?").toFixed(4) + "/1M tokens"
                                            font.pixelSize: Theme.fontSizeSmall
                                            font.weight: Font.Bold
                                            color: Theme.primary
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }

                                    Row {
                                        spacing: Theme.spacingXS

                                        StyledText {
                                            text: "Output: $" + (parseFloat((modelData.pricing || {}).output) || "?").toFixed(4) + "/1M"
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: Theme.surfaceVariantText
                                        }

                                        StyledText {
                                            visible: (modelData.context_length || 0) > 0
                                            text: "· " + (modelData.context_length || 0).toLocaleString() + " ctx"
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: Theme.surfaceVariantText
                                        }

                                        StyledText {
                                            visible: modelData.architecture && modelData.architecture.provider
                                            text: "· " + (modelData.architecture.provider || "")
                                            font.pixelSize: Theme.fontSizeSmall
                                            color: Theme.surfaceVariantText
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // No models
                StyledRect {
                    visible: !OpenRouterService.apiKeyMissing && !OpenRouterService.loading && root.showModels && OpenRouterService.cheapestModels.length === 0 && OpenRouterService.models.length === 0
                    width: parent.width
                    height: 60
                    radius: Theme.cornerRadius
                    color: Theme.surfaceContainerHigh

                    StyledText {
                        anchors.centerIn: parent
                        text: "No models data available"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                    }
                }
            }
        }
    }
}
