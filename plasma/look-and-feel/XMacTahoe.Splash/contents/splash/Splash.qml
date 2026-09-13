import QtQuick

// XMacTahoe splash: continues the Plymouth boot screen (black, white logo, thin progress bar)
Rectangle {
    id: root
    color: "#000000"
    property int stage
    onStageChanged: if (stage >= 1) bar.width = Math.min(1, (stage - 1) / 5) * track.width
    Image {
        id: logo
        source: "images/logo.png"
        width: 150; height: 150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -60
        smooth: true
    }
    Rectangle {
        id: track
        width: 220; height: 6; radius: 3
        color: "#404040"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 60
        Rectangle {
            id: bar
            height: parent.height; radius: 3; width: 0
            color: "#ffffff"
            Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        }
    }
}
