import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: settingsRoot

    pluginId: "openRouter"

    SettingsCard {
        title: "OpenRouter"
        iconName: "router"

        TextFieldSetting {
            settingKey: "apiKey"
            label: "API Key"
            description: "Your OpenRouter API key (get one at openrouter.ai/keys)"
            placeholderText: "sk-or-v1-..."
            echoMode: TextInput.Password
            defaultValue: ""
        }

        SelectionSetting {
            settingKey: "pollSeconds"
            label: "Refresh interval"
            description: "How often the widget fetches credit and model data"
            options: [
                { label: "5 minutes", value: "300" },
                { label: "10 minutes", value: "600" },
                { label: "30 minutes", value: "1800" },
                { label: "1 hour", value: "3600" }
            ]
            defaultValue: "300"
        }

        ToggleSetting {
            settingKey: "showCredits"
            label: "Show credit balance in bar"
            description: "Display remaining credits next to the router icon in the top bar"
            defaultValue: true
        }

        ToggleSetting {
            settingKey: "showModels"
            label: "Show cheapest models in popout"
            description: "Display a ranked list of the cheapest models by input token price"
            defaultValue: true
        }

        ToggleSetting {
            settingKey: "showCostPerToken"
            label: "Show cost per token"
            description: "Display input/output pricing per 1M tokens in the model list"
            defaultValue: true
        }
    }
}
