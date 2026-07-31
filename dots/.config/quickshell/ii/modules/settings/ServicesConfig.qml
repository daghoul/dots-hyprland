import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        id: systemUpdate
        icon: "sync"
        title: Translation.tr("System Updates")

        readonly property bool updateChecksPresent: Config.options.updates.enableCheck

        ConfigSwitch {
            text: Translation.tr("Enable system update checks")
            buttonIcon: "published_with_changes"
            checked: Config.options.updates.enableCheck
            onCheckedChanged: {
                Config.options.updates.enableCheck = checked;
            }
        }

        ContentSubsection {
            visible: systemUpdate.updateChecksPresent
            title: Translation.tr("System update check settings")
            Layout.fillWidth: false
            ConfigSpinBox {
                visible: systemUpdate.updateChecksPresent
                icon: "hourglass"
                text: Translation.tr("Update check interval (in minutes)")
                value: Config.options.updates.checkInterval
                from: 10
                to: 120
                stepSize: 1
                onValueChanged: {
                    Config.options.updates.checkInterval = value;
                }
            }

            ConfigSpinBox {
                visible: systemUpdate.updateChecksPresent
                icon: "av_timer"
                text: Translation.tr("Advise update threshold (in packages)")
                value: Config.options.updates.adviseUpdateThreshold
                from: 10
                to: 100
                stepSize: 1
                onValueChanged: {
                    Config.options.updates.adviseUpdateThreshold = value;
                }
            }

            ConfigSpinBox {
                visible: systemUpdate.updateChecksPresent
                icon: "sync_problem"
                text: Translation.tr("Strongly advise update threshold (in packages)")
                value: Config.options.updates.stronglyAdviseUpdateThreshold
                from: 200
                to: 500
                stepSize: 1
                onValueChanged: {
                    Config.options.updates.stronglyAdviseUpdateThreshold = value;
                }
            }
        }
    }

    ContentSection {
        icon: "cell_tower"
        title: Translation.tr("Networking")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("User agent (for services that require it)")
            text: Config.options.networking.userAgent
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.networking.userAgent = text;
            }
        }
    }

    ContentSection {
        icon: "memory"
        title: Translation.tr("Resources")

        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (ms)")
            value: Config.options.resources.updateInterval
            from: 100
            to: 10000
            stepSize: 100
            onValueChanged: {
                Config.options.resources.updateInterval = value;
            }
        }
        
    }

    ContentSection {
        icon: "file_open"
        title: Translation.tr("Save paths")

        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("Video Recording Path")
            text: Config.options.screenRecord.savePath
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.screenRecord.savePath = text;
            }
        }
        
        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("Screenshot Path (leave empty to just copy)")
            text: Config.options.screenSnip.savePath
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.screenSnip.savePath = text;
            }
        }
    }

    ContentSection {
        icon: "search"
        title: Translation.tr("Search")

        ConfigSwitch {
            text: Translation.tr("Use Levenshtein distance-based algorithm instead of fuzzy")
            checked: Config.options.search.sloppy
            onCheckedChanged: {
                Config.options.search.sloppy = checked;
            }
            StyledToolTip {
                text: Translation.tr("Could be better if you make a ton of typos,\nbut results can be weird and might not work with acronyms\n(e.g. \"GIMP\" might not give you the paint program)")
            }
        }

        ContentSubsection {
            title: Translation.tr("Prefixes")
            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Action")
                    text: Config.options.search.prefix.action
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.action = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Clipboard")
                    text: Config.options.search.prefix.clipboard
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.clipboard = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Emojis")
                    text: Config.options.search.prefix.emojis
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.emojis = text;
                    }
                }
            }

            ConfigRow {
                uniform: true
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Math")
                    text: Config.options.search.prefix.math
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.math = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Shell command")
                    text: Config.options.search.prefix.shellCommand
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.shellCommand = text;
                    }
                }
                MaterialTextArea {
                    Layout.fillWidth: true
                    placeholderText: Translation.tr("Web search")
                    text: Config.options.search.prefix.webSearch
                    wrapMode: TextEdit.Wrap
                    onTextChanged: {
                        Config.options.search.prefix.webSearch = text;
                    }
                }
            }
        }
        ContentSubsection {
            title: Translation.tr("Web search")
            MaterialTextArea {
                Layout.fillWidth: true
                placeholderText: Translation.tr("Base URL")
                text: Config.options.search.engineBaseUrl
                wrapMode: TextEdit.Wrap
                onTextChanged: {
                    Config.options.search.engineBaseUrl = text;
                }
            }
        }
    }

    // There's no update indicator in ii for now so we shouldn't show this yet
    // ContentSection {
    //     icon: "deployed_code_update"
    //     title: Translation.tr("System updates (Arch only)")

    //     ConfigSwitch {
    //         text: Translation.tr("Enable update checks")
    //         checked: Config.options.updates.enableCheck
    //         onCheckedChanged: {
    //             Config.options.updates.enableCheck = checked;
    //         }
    //     }

    //     ConfigSpinBox {
    //         icon: "av_timer"
    //         text: Translation.tr("Check interval (mins)")
    //         value: Config.options.updates.checkInterval
    //         from: 60
    //         to: 1440
    //         stepSize: 60
    //         onValueChanged: {
    //             Config.options.updates.checkInterval = value;
    //         }
    //     }
    // }

    ContentSection {
        icon: "weather_mix"
        title: Translation.tr("Weather")
        ConfigRow {
            ConfigSwitch {
                buttonIcon: "check"
                text: Translation.tr("Enable weather service")
                checked: Config.options.weather.enable
                onCheckedChanged: {
                    Config.options.weather.enable = checked;
                }
                StyledToolTip {
                    text: Translation.tr("Master switch for enabling the weather service across the shell")
                }
            }
            ConfigSwitch {
                buttonIcon: "assistant_navigation"
                text: Translation.tr("Enable GPS based location")
                enabled: Config.options.weather.enable
                checked: Config.options.weather.enableGPS
                onCheckedChanged: {
                    Config.options.weather.enableGPS = checked;
                }
            }
        }
        
        MaterialTextArea {
            Layout.fillWidth: true
            placeholderText: Translation.tr("City name")
            text: Config.options.weather.city
            enabled: Config.options.weather.enable && !Config.options.weather.enableGPS
            wrapMode: TextEdit.Wrap
            onTextChanged: {
                Config.options.weather.city = text;
            }
        }
        ConfigSwitch {
            buttonIcon: "thermometer"
            text: Translation.tr("Fahrenheit unit")
            enabled: Config.options.weather.enable
            checked: Config.options.weather.useUSCS
            onCheckedChanged: {
                Config.options.weather.useUSCS = checked;
            }
            StyledToolTip {
                extraVisibleCondition: Config.options.weather.enable
                text: Translation.tr("It may take a few seconds to update")
            }
        }
        ConfigSpinBox {
            icon: "av_timer"
            text: Translation.tr("Polling interval (m)")
            enabled: Config.options.weather.enable
            value: Config.options.weather.fetchInterval
            from: 5
            to: 50
            stepSize: 5
            onValueChanged: {
                Config.options.weather.fetchInterval = value;
            }
        }
    }
}
