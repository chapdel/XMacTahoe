/*
    A card of the Notification Center, in the style of the Control Center tiles: a translucent
    rounded rectangle whose shade follows the light or dark variant.

    Children go into a column; the card takes the height of that column. Nothing inside may fill the
    card, or its height would depend on a child whose height depends on the card.
*/
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Rectangle {
    id: card

    default property alias contents: column.data
    property string title: ""
    readonly property bool dark: Kirigami.Theme.backgroundColor.hsvValue < 0.5

    Layout.fillWidth: true
    implicitHeight: column.implicitHeight + Kirigami.Units.largeSpacing * 2
    radius: Kirigami.Units.gridUnit
    color: dark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08)
    border.width: 1
    border.color: dark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.06)

    ColumnLayout {
        id: column
        spacing: Kirigami.Units.smallSpacing
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Kirigami.Units.largeSpacing
        }

        Kirigami.Heading {
            level: 5
            text: card.title
            visible: card.title !== ""
            opacity: 0.6
            Layout.fillWidth: true
        }
    }
}
