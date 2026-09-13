var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "ItemGeometries-1920x1080": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        },
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "ItemGeometries-1920x1080": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "1",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        },
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "ItemGeometries-1680x1050": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "2",
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
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupWidth": "400"
                        }
                    },
                    "plugin": "org.kpple.kppleMenu"
                },
                {
                    "config": {
                    },
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
                    "config": {
                    },
                    "plugin": "org.kde.plasma.appmenu"
                },
                {
                    "config": {
                    },
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
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "438",
                            "popupWidth": "333"
                        },
                        "/General": {
                            "darkTheme": "XMacTahoe.Dark",
                            "elements": "9,0,6,7,13,14,5,10,8",
                            "labelsToggles": "false",
                            "lightTheme": "XMacTahoe.Light",
                            "radiusCardCustom": "36",
                            "selected_theme": "custom",
                            "usePlasmaDesing": "false",
                            "xElements": "0,2,0,0,0,3,1,0,2",
                            "yElements": "0,0,2,3,4,4,4,1,4"
                        }
                    },
                    "plugin": "Plasma.Flex.Hub"
                },
                {
                    "config": {
                    },
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
                            "popupHeight": "375",
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
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "375",
                            "popupWidth": "525"
                        },
                        "/General": {
                            "icon": "xmactahoe-transparent",
                            "powerButtonsMigrated": "true"
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
            "height": 1.5,
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
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "launchers": ""
                        },
                        "/General": {
                            "iconSpacing": "0",
                            "indicateAudioStreams": "false",
                            "launchers": "applications:xmactahoe-appgrid.desktop,applications:org.kde.dolphin.desktop,applications:org.mozilla.firefox.desktop,applications:org.kde.discover.desktop,applications:org.kde.gwenview.desktop,applications:org.kde.konsole.desktop,applications:systemsettings.desktop,applications:org.inkscape.Inkscape.desktop,applications:libreoffice-writer.desktop,applications:libreoffice-calc.desktop",
                            "maxStripes": "1"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                },
                {
                    "config": {
                    },
                    "plugin": "zayron.simple.separator"
                },
                {
                    "config": {
                    },
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
                    "config": {
                    },
                    "plugin": "org.kde.plasma.trash"
                },
                {
                    "config": {
                    },
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
            "hiding": "dodgewindows",
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

// Chapdel: raccourci Meta (grille complète) sur le widget AppGrid (invisible, barre du haut)
for (var i = 0; i < panelIds.length; i++) {
    var ws = panelById(panelIds[i]).widgets();
    for (var j = 0; j < ws.length; j++) {
        if (ws[j].type == "dev.xarbit.appgrid") { ws[j].globalShortcut = "Meta"; }
    }
}
