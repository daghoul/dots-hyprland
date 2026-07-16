import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "domino_mask"
        title: Translation.tr("Privacy Indicators")

        ConfigSwitch {
            buttonIcon: "mic"
            text: Translation.tr("Enable mic active indicator")
            checked: Config.options.privacy.micActiveIndicator
            onCheckedChanged: {
                Config.options.privacy.micActiveIndicator = checked;
            }
            StyledToolTip {
                text: Translation.tr("See if your mic is active in right side of the bar.")
            }
        }

        ConfigSwitch {
            buttonIcon: "screen_share"
            text: Translation.tr("Enable screenshare indicator")
            checked: Config.options.privacy.screenShareIndicator
            onCheckedChanged: {
                Config.options.privacy.screenShareIndicator = checked;
            }
            StyledToolTip {
                text: Translation.tr("See if you're sharing a screen in right side of the bar.")
            }
        }
    }
}