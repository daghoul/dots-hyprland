import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import QtQuick.Window

RippleButton {
    id: root

    readonly property int count: Updates.count
    readonly property bool checking: Updates.checking
    readonly property bool advised: Updates.updateAdvised
    readonly property bool stronglyAdvised: Updates.updateStronglyAdvised
    readonly property bool hasUpdates: count > 0
    property bool vertical: false

    readonly property string urgency: {
        if (stronglyAdvised) return "critical";
        if (advised) return "warning";
        if (hasUpdates) return "info";
        return "none";
    }

    // For MaterialSymbol
    readonly property string iconName: {
        if (checking) return "autorenew";
        if (urgency === "critical") return "error";
        if (urgency === "warning") return "release_alert";
        return "system_update_alt";
    }
    readonly property int iconPixelSize: vertical ? 18 : Appearance.font.pixelSize.larger

    readonly property color stateColor: {
        if (urgency === "critical") return Appearance.colors.colErrorContainer;
        if (urgency === "warning") return Appearance.colors.colTertiaryContainer;
        if (urgency === "info") return Appearance.colors.colPrimaryContainer;
        return Appearance.colors.colLayer2;
    }
    readonly property color stateColorHover: {
        if (urgency === "critical") return Appearance.colors.colErrorContainerHover;
        if (urgency === "warning") return Appearance.colors.colTertiaryContainerHover;
        if (urgency === "info") return Appearance.colors.colPrimaryContainerHover;
        return Appearance.colors.colLayer2Hover;
    }
    readonly property color stateTextColor: {
        if (urgency === "critical") return Appearance.colors.colOnErrorContainer;
        if (urgency === "warning") return Appearance.colors.colOnTertiaryContainer;
        if (urgency === "info") return Appearance.colors.colOnPrimaryContainer;
        return Appearance.colors.colOnLayer2;
    }
    readonly property color stateColorActive: {
        if (urgency === "critical") return Appearance.colors.colErrorContainerActive;
        if (urgency === "warning") return Appearance.colors.colTertiaryContainerActive;
        if (urgency === "info") return Appearance.colors.colPrimaryContainerActive;
        return Appearance.colors.colLayer2Active;
    }

    readonly property real calculatedWidth: vertical ? Appearance.sizes.verticalBarWidth - 10 : 80
    readonly property real calculatedHeight: vertical ? 70 : Appearance.sizes.baseBarHeight - 8

    implicitWidth: calculatedWidth
    implicitHeight: calculatedHeight
    visible: Config.options.updates.enableCheck && hasUpdates
    opacity: visible ? 1 : 0
    scale: opacity > 0 ? 1 : 0.8

    Behavior on opacity {
        enabled: Appearance.animationsEnabled
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    Behavior on scale {
        enabled: Appearance.animationsEnabled
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    buttonRadius: Appearance.rounding.full
    toggled: advised || stronglyAdvised
    colBackground: stateColor
    colBackgroundHover: stateColorHover
    colRipple: stateColorActive
    colBackgroundToggled: stateColor
    colBackgroundToggledHover: stateColor

    releaseAction: Updates.performUpdate
    altAction: Updates.refresh

    // Content
    contentItem: Item {
        anchors.fill: parent

        GridLayout {
            anchors.centerIn: parent
            flow: root.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
            rowSpacing: 2
            columnSpacing: 4

            MaterialSymbol {
                id: materialSymbol
                Layout.alignment: root.vertical ? Qt.AlignHCenter : Qt.AlignVCenter
                text: root.iconName
                iconSize: root.vertical ? 18 : Appearance.font.pixelSize.larger
                color: root.stateTextColor

                RotationAnimation on rotation {
                    running: root.checking && Appearance.animationsEnabled
                    from: 0
                    to: 360
                    duration: 1500
                    loops: Animation.Infinite
                    direction: RotationAnimation.Clockwise
                    onRunningChanged: {
                        if (!running) materialSymbol.rotation = 0;
                    }
                }
            }

            StyledText {
                Layout.alignment: root.vertical ? Qt.AlignHCenter : Qt.AlignVCenter
                Layout.preferredWidth: root.vertical ? undefined : 32
                horizontalAlignment: Text.AlignHCenter
                text: {
                    if (root.checking) return "…";
                    if (root.count === 0) return "✓";
                    if (root.count >= 100) return "99+";
                    return root.count.toString();
                }
                font.pixelSize: root.vertical ? 12 : Appearance.font.pixelSize.normal
                font.weight: root.vertical ? Font.DemiBold : Font.Normal
                color: root.count === 0 ? Appearance.colors.colSubtext : root.stateTextColor
            }
        }
    }
}