import QtQuick
import QtQuick.Effects
import qs.modules.common

MultiEffect {
    property color sourceColor: "black"

    colorization: 1
    brightness: 1 - sourceColor.hslLightness

    Behavior on colorizationColor {
        enabled: Appearance.animationsEnabled
        animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
    }
}
