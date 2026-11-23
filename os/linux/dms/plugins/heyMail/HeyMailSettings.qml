import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import qs.Modules.Settings.Widgets

PluginSettings {
    id: settingsRoot

    pluginId: "heyMail"

    SettingsCard {
        title: "HEY Mail"
        iconName: "mail"

        SelectionSetting {
            settingKey: "pollSeconds"
            label: "Refresh interval"
            description: "How often the widget checks HEY for new emails"
            options: [
                { label: "30 seconds", value: "30" },
                { label: "1 minute", value: "60" },
                { label: "2 minutes", value: "120" },
                { label: "5 minutes", value: "300" }
            ]
            defaultValue: "60"
        }

        ToggleSetting {
            settingKey: "showCount"
            label: "Show unread count in bar"
            description: "Display the number of unread Imbox emails next to the mail icon"
            defaultValue: true
        }

        ToggleSetting {
            settingKey: "onlyUnread"
            label: "Only show unread emails"
            description: "Filter the popout list to unread threads only"
            defaultValue: false
        }
    }
}
