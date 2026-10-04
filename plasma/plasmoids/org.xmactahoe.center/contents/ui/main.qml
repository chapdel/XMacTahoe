/*
    XMacTahoe Notification Center.

    In the menu bar it shows the date and the time, like macOS. Clicking it opens one panel with the
    notifications on top, then the month, then the weather - the Notification Center of macOS, built
    on Plasma's own notification service and calendar.
*/
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami
import org.kde.notificationmanager as NotificationManager

PlasmoidItem {
    id: root

    property date now: new Date()
    property date today: new Date()

    preferredRepresentation: compactRepresentation
    toolTipMainText: i18n("Notification Center")
    toolTipSubText: notifications.unreadNotificationsCount > 0
        ? i18np("%1 unread notification", "%1 unread notifications", notifications.unreadNotificationsCount)
        : i18n("No new notification")

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.now = new Date();
            if (root.now.getDate() !== root.today.getDate()) {
                root.today = new Date();   // the month view only needs the day, not the minute
            }
        }
    }

    NotificationManager.Notifications {
        id: notifications
        showExpired: true
        showDismissed: true
        showJobs: false
        sortMode: NotificationManager.Notifications.SortByDate
        groupMode: NotificationManager.Notifications.GroupDisabled
        limit: Plasmoid.configuration.notificationLimit
    }

    compactRepresentation: MouseArea {
        id: compact

        Layout.minimumWidth: label.implicitWidth + Kirigami.Units.largeSpacing * 2
        Layout.preferredWidth: Layout.minimumWidth
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        Text {
            id: label
            anchors.centerIn: parent
            text: Qt.formatDateTime(root.now, Plasmoid.configuration.timeFormat)
            color: Kirigami.Theme.textColor
            font: Kirigami.Theme.defaultFont
            opacity: compact.containsMouse ? 0.75 : 1
        }

        Rectangle {        // the dot macOS puts next to the clock when something is waiting
            visible: notifications.unreadNotificationsCount > 0
            anchors { right: parent.right; top: parent.top; topMargin: Kirigami.Units.smallSpacing }
            width: Kirigami.Units.smallSpacing
            height: width
            radius: width / 2
            color: Kirigami.Theme.highlightColor
        }
    }

    fullRepresentation: Item {
        id: center

        readonly property int cardWidth: width - Kirigami.Units.largeSpacing * 2

        // Plasma sizes the popup from the implicit size; the Layout hints alone leave it at zero
        implicitWidth: Kirigami.Units.gridUnit * 21
        implicitHeight: Kirigami.Units.gridUnit * 32

        Layout.minimumWidth: Kirigami.Units.gridUnit * 20
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20
        Layout.maximumWidth: Kirigami.Units.gridUnit * 24
        Layout.minimumHeight: Kirigami.Units.gridUnit * 20
        Layout.preferredHeight: Kirigami.Units.gridUnit * 32
        Layout.maximumHeight: Kirigami.Units.gridUnit * 36

        RowLayout {
            id: header
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: Kirigami.Units.largeSpacing
            }

            Kirigami.Heading {
                level: 4
                text: Qt.formatDateTime(root.now, "dddd d MMMM")
                Layout.fillWidth: true
            }

            PlasmaComponents3.ToolButton {
                icon.name: "edit-clear-history"
                display: PlasmaComponents3.AbstractButton.IconOnly
                visible: notifications.count > 0
                text: i18n("Clear notifications")
                onClicked: notifications.clear(NotificationManager.Notifications.ClearExpired)
                PlasmaComponents3.ToolTip.text: text
                PlasmaComponents3.ToolTip.visible: hovered
                PlasmaComponents3.ToolTip.delay: Kirigami.Units.toolTipDelay
            }
        }

        QQC2.ScrollView {
            id: scroll
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: Kirigami.Units.largeSpacing
                topMargin: 0
            }
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                width: scroll.availableWidth
                spacing: Kirigami.Units.largeSpacing

                // ---- notifications ------------------------------------------------------------
                Card {
                    visible: notifications.count === 0

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: Kirigami.Units.largeSpacing
                        Layout.bottomMargin: Kirigami.Units.largeSpacing
                        spacing: Kirigami.Units.largeSpacing

                        Kirigami.Icon {
                            source: "preferences-desktop-notification"
                            opacity: 0.5
                            Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                            Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                        }
                        Text {
                            text: i18n("No notifications")
                            color: Kirigami.Theme.textColor
                            opacity: 0.6
                            font: Kirigami.Theme.smallFont
                            Layout.fillWidth: true
                        }
                    }
                }

                Repeater {
                    model: notifications

                    Card {
                        id: item

                        required property int index
                        required property var model

                        TapHandler {
                            enabled: item.model.hasDefaultAction === true
                            onTapped: notifications.invokeDefaultAction(notifications.makePersistentModelIndex(item.index),
                                                                        NotificationManager.Notifications.Close)
                        }

                        HoverHandler { id: itemHover }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.largeSpacing

                            Kirigami.Icon {
                                source: item.model.applicationIconName || "dialog-information"
                                Layout.alignment: Qt.AlignTop
                                Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                                Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: item.model.applicationName || ""
                                        color: Kirigami.Theme.textColor
                                        opacity: 0.6
                                        font: Kirigami.Theme.smallFont
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: item.model.created ? Qt.formatTime(item.model.created, "h:mm AP") : ""
                                        color: Kirigami.Theme.textColor
                                        opacity: 0.5
                                        font: Kirigami.Theme.smallFont
                                    }
                                }

                                Text {
                                    text: item.model.summary || ""
                                    color: Kirigami.Theme.textColor
                                    font.bold: true
                                    elide: Text.ElideRight
                                    visible: text !== ""
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: (item.model.body || "").replace(/<[^>]*>/g, "").trim()
                                    color: Kirigami.Theme.textColor
                                    opacity: 0.8
                                    font: Kirigami.Theme.smallFont
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 3
                                    elide: Text.ElideRight
                                    visible: text !== ""
                                    Layout.fillWidth: true
                                }
                            }

                            PlasmaComponents3.ToolButton {
                                icon.name: "window-close"
                                display: PlasmaComponents3.AbstractButton.IconOnly
                                Layout.alignment: Qt.AlignTop
                                opacity: itemHover.hovered ? 1 : 0
                                Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }
                                onClicked: notifications.close(notifications.makePersistentModelIndex(item.index))
                            }
                        }
                    }
                }

                // ---- month --------------------------------------------------------------------
                Card {
                    visible: Plasmoid.configuration.showCalendar
                    title: Qt.formatDateTime(root.today, "MMMM yyyy")

                    MiniMonth {
                        today: root.today
                        Layout.fillWidth: true
                    }
                }

                // ---- weather ------------------------------------------------------------------
                Card {
                    visible: Plasmoid.configuration.showWeather
                    title: i18n("Weather")

                    WeatherCard {
                        id: weatherContent
                        latitude: Plasmoid.configuration.latitude
                        longitude: Plasmoid.configuration.longitude
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    }
                }
            }
        }
    }
}
