var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [],
            "config": {
                "/": {
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupWidth": "400"
                        },
                        "/Advanced": {
                            "forceQuitSettings": "gdbus call --session --dest org.kde.KWin --object-path /KWin --method org.kde.KWin.killWindow",
                            "lockScreenSettings": "loginctl lock-session",
                            "logOutSettings": "gdbus call --session --dest org.kde.LogoutPrompt --object-path /LogoutPrompt --method org.kde.LogoutPrompt.promptLogout",
                            "restartSettings": "gdbus call --session --dest org.kde.LogoutPrompt --object-path /LogoutPrompt --method org.kde.LogoutPrompt.promptReboot",
                            "shutDownSettings": "gdbus call --session --dest org.kde.LogoutPrompt --object-path /LogoutPrompt --method org.kde.LogoutPrompt.promptShutDown",
                            "systemPreferencesSettings": "systemsettings"
                        },
                        "/General": {
                            "aboutThisComputerSettings": "kinfocenter",
                            "appStoreSettings": "plasma-discover",
                            "forceQuitSettings": "gdbus call --session --dest org.kde.KWin --object-path /KWin --method org.kde.KWin.killWindow",
                            "lockScreenSettings": "loginctl lock-session",
                            "logOutSettings": "gdbus call --session --dest org.kde.LogoutPrompt --object-path /LogoutPrompt --method org.kde.LogoutPrompt.promptLogout",
                            "restartSettings": "gdbus call --session --dest org.kde.LogoutPrompt --object-path /LogoutPrompt --method org.kde.LogoutPrompt.promptReboot",
                            "shutDownSettings": "gdbus call --session --dest org.kde.LogoutPrompt --object-path /LogoutPrompt --method org.kde.LogoutPrompt.promptShutDown",
                            "sleepSettings": "systemctl suspend",
                            "systemPreferencesSettings": "systemsettings"
                        }
                    },
                    "plugin": "org.kpple.kppleMenu"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/General": {
                            "customText": "true",
                            "showIcon": "false",
                            "textDefault": "Desktop"
                        }
                    },
                    "plugin": "org.kde.windowtitle.Fork"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.appmenu"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/General": {
                            "iconSpacing": "3",
                            "scaleIconsToFit": "false"
                        }
                    },
                    "plugin": "org.kde.plasma.systemtray"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "438",
                            "popupWidth": "333"
                        },
                        "/General": {
                            "customCardColor": "#ffffff",
                            "darkTheme": "XMacTahoe.Dark",
                            "elements": "9,0,6,7,13,14,5,10,8",
                            "enabledCustomColor": "true",
                            "labelsToggles": "false",
                            "lightTheme": "XMacTahoe.Light",
                            "opacityCardCustom": "14",
                            "radiusCardCustom": "28",
                            "selected_theme": "custom",
                            "shadowOpacity": "0",
                            "usePlasmaDesing": "false",
                            "xElements": "0,2,0,0,0,3,1,0,2",
                            "yElements": "0,0,2,3,4,4,4,1,4"
                        }
                    },
                    "plugin": "Plasma.Flex.Hub"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/General": {
                            "bold": "true",
                            "command": "echo \"$(date +\"%a\" | awk '{print toupper(substr($0,1,1)) substr($0,2)}') $(date +\"%d\") $(date +\"%b\" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')\"",
                            "fontSize": "10"
                        }
                    },
                    "plugin": "com.github.zren.commandoutput"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "451",
                            "popupWidth": "525"
                        },
                        "/Appearance": {
                            "autoFontAndSize": "false",
                            "boldText": "true",
                            "customDateFormat": "ddd d MMM",
                            "dateDisplayFormat": "BesideTime",
                            "dateFormat": "custom",
                            "fontStyleName": "bold",
                            "fontWeight": "700",
                            "showDate": "false",
                            "use24hFormat": "0"
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "376",
                            "popupWidth": "529"
                        },
                        "/General": {
                            "icon": "xmactahoe-transparent",
                            "recentApps": "gparted.desktop,org.kde.discover.desktop,io.github.shiftey.Desktop.desktop,org.kde.partitionmanager.desktop,org.mozilla.firefox.desktop"
                        }
                    },
                    "plugin": "dev.xarbit.appgrid"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 2,
            "hiding": "normal",
            "lengthMode": "fill",
            "location": "top",
            "maximumLength": 120,
            "minimumLength": 120,
            "offset": 0,
            "opacity": "translucent"
        },
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "launchers": ""
                        },
                        "/General": {
                            "groupPopups": "true",
                            "highlightWindows": "true",
                            "iconSpacing": "0",
                            "indicateAudioStreams": "false",
                            "launchers": "applications:xmactahoe-appgrid.desktop,applications:org.kde.dolphin.desktop,applications:org.kde.konsole.desktop",
                            "maxStripes": "1",
                            "separateLaunchers": "true",
                            "showToolTips": "true"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                },
                {
                    "config": {},
                    "plugin": "zayron.simple.separator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "375",
                            "popupWidth": "525"
                        }
                    },
                    "plugin": "org.kde.plasma.calculator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.trash"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 4.125,
            "hiding": "normal",
            "lengthMode": "fit",
            "location": "bottom",
            "maximumLength": 120,
            "minimumLength": 120,
            "offset": 0,
            "opacity": "translucent"
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);

// XMacTahoe: Meta shortcut (full grid) on the AppGrid widget (invisible, top bar)
for (var i = 0; i < panelIds.length; i++) {
    var ws = panelById(panelIds[i]).widgets();
    for (var j = 0; j < ws.length; j++) {
        if (ws[j].type == "dev.xarbit.appgrid") { ws[j].globalShortcut = "Meta"; }
    }
}
