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
                            "popupHeight": "289",
                            "popupWidth": "210"
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
                            "extraItems": "org.kde.plasma.clipboard,org.kde.plasma.notifications,org.kde.plasma.battery,org.kde.plasma.brightness,org.kde.plasma.networkmanagement,org.kde.plasma.bluetooth,org.kde.plasma.volume,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier,org.kde.plasma.printmanager,org.kde.plasma.keyboardlayout,org.kde.plasma.keyboardindicator,org.kde.plasma.cameraindicator,org.kde.plasma.manage-inputmethod",
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
                            "popupHeight": "519",
                            "popupWidth": "333"
                        },
                        "/General": {
                            "customCardColor": "#ffffff",
                            "customControlCommand": "@XMT_BIN@/xmactahoe glass toggle,@XMT_BIN@/xmactahoe auto toggle,@XMT_BIN@/xmactahoe motion toggle",
                            "customControlEnabledButton": "true,true,true",
                            "customControlEnabledIcons": "true,true,true",
                            "customControlHeights": "1,1,1",
                            "customControlIcons": "view-preview,weather-clear,media-playback-pause",
                            "customControlIdSensor": ",,",
                            "customControlIsPercentage": "false,false,false",
                            "customControlNames": "Glass,Auto appearance,Reduce motion",
                            "customControlSubTitle": ",,",
                            "customControlWidths": "1,1,1",
                            "darkTheme": "XMacTahoe.Dark",
                            "elements": "16,11,13,14,6,7,2,8",
                            "enabledCustomColor": "true",
                            "gridHeight": "6",
                            "gridWidth": "4",
                            "labelsToggles": "true",
                            "lightTheme": "XMacTahoe.Light",
                            "listControlsX": "1,2,3",
                            "listControlsY": "5,5,5",
                            "listCustomControls": "Glass,Auto appearance,Reduce motion",
                            "opacityCardCustom": "14",
                            "radiusCardCustom": "28",
                            "selected_theme": "custom",
                            "shadowOpacity": "0",
                            "usePlasmaDesing": "false",
                            "xElements": "0,2,2,3,0,0,0,0",
                            "yElements": "0,0,1,1,2,3,4,5"
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
                            "recentApps": "claude-desktop-unofficial.desktop,gparted.desktop,org.kde.discover.desktop,io.github.shiftey.Desktop.desktop,org.kde.partitionmanager.desktop"
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
            "hiding": "autohide",
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

// XMacTahoe: Plasma pins a panel to one screen, so give every screen its own menu bar and dock.
// The AppGrid widget stays on the first screen only: the Meta shortcut needs a single live widget.
if (screenCount > 1) {
    var tpl = layout.panels, all = [];
    for (var s = 0; s < screenCount; s++) {
        for (var t = 0; t < tpl.length; t++) {
            var p = JSON.parse(JSON.stringify(tpl[t]));
            if (s > 0 && p.applets) {
                var keep = [];
                for (var a = 0; a < p.applets.length; a++) {
                    if (p.applets[a].plugin != "dev.xarbit.appgrid") keep.push(p.applets[a]);
                }
                p.applets = keep;
            }
            all.push(p);
        }
    }
    layout.panels = all;
}

plasma.loadSerializedLayout(layout);

// give the copies their screen (loadSerializedLayout puts everything on the first one)
if (screenCount > 1) {
    var ids = panelIds.slice(0).sort(function (a, b) { return a - b; });
    var per = ids.length / screenCount;
    for (var i = 0; i < ids.length; i++) { panelById(ids[i]).screen = Math.floor(i / per); }
}

// XMacTahoe: Meta shortcut (full grid) on the AppGrid widget (invisible, top bar)
for (var i = 0; i < panelIds.length; i++) {
    var ws = panelById(panelIds[i]).widgets();
    for (var j = 0; j < ws.length; j++) {
        if (ws[j].type == "dev.xarbit.appgrid") { ws[j].globalShortcut = "Meta"; }
    }
}
