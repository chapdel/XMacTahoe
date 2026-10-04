/*
    The month, drawn the way the macOS Notification Center shows it: day initials, the days of the
    month, today in a filled circle. Written here rather than reusing Plasma's calendar view, which
    needs a host applet to drive it.
*/
import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: month

    property date today: new Date()
    readonly property int year: today.getFullYear()
    readonly property int monthIndex: today.getMonth()
    readonly property int firstWeekday: new Date(year, monthIndex, 1).getDay()      // 0 = Sunday
    readonly property int daysInMonth: new Date(year, monthIndex + 1, 0).getDate()
    readonly property int offset: (firstWeekday - Qt.locale().firstDayOfWeek + 7) % 7

    spacing: Kirigami.Units.smallSpacing

    GridLayout {
        columns: 7
        rowSpacing: Kirigami.Units.smallSpacing
        columnSpacing: 0
        Layout.fillWidth: true

        Repeater {
            model: 7
            Text {
                required property int index
                text: Qt.locale().dayName((Qt.locale().firstDayOfWeek + index) % 7, Locale.ShortFormat).charAt(0).toUpperCase()
                color: Kirigami.Theme.textColor
                opacity: 0.5
                font: Kirigami.Theme.smallFont
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }

        Repeater {
            model: month.offset + month.daysInMonth

            Item {
                id: cell
                required property int index
                readonly property int day: index - month.offset + 1
                readonly property bool isToday: day === month.today.getDate()

                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 1.6

                Rectangle {
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height)
                    height: width
                    radius: width / 2
                    visible: cell.isToday && cell.day > 0
                    color: Kirigami.Theme.highlightColor
                }

                Text {
                    anchors.centerIn: parent
                    visible: cell.day > 0
                    text: cell.day
                    color: cell.isToday ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
                    font: Kirigami.Theme.defaultFont
                    opacity: cell.isToday ? 1 : 0.85
                }
            }
        }
    }
}
