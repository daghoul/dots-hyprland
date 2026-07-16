pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.modules.common

SequentialAnimation {
    id: root

    required property Item target
    property real distance: 30

    NumberAnimation { target: root.target; property: "Layout.leftMargin"; to: -root.distance; duration: Appearance.animationsEnabled ? 50 : 0 }
    NumberAnimation { target: root.target; property: "Layout.leftMargin"; to: root.distance; duration: Appearance.animationsEnabled ? 50 : 0 }
    NumberAnimation { target: root.target; property: "Layout.leftMargin"; to: -root.distance / 2; duration: Appearance.animationsEnabled ? 40 : 0 }
    NumberAnimation { target: root.target; property: "Layout.leftMargin"; to: root.distance / 2; duration: Appearance.animationsEnabled ? 40 : 0 }
    NumberAnimation { target: root.target; property: "Layout.leftMargin"; to: 0; duration: Appearance.animationsEnabled ? 30 : 0 }
}
