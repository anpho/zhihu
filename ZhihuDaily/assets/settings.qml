import bb.cascades 1.4
import cn.anpho 1.0
import bb.system 1.2

Page {
    property variant nav
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Disabled
    ScrollView {
        Container {
            Header {
                title: qsTr("Visual Style")
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftMargin: 20.0
                rightMargin: 20.0
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                ImageView {
                    imageSource: "asset:///icon/icon_211.png"
                    scalingMethod: ScalingMethod.AspectFit
                    filterColor: Color.DarkGray
                    verticalAlignment: VerticalAlignment.Center
                }
                Label {
                    text: qsTr("Use Dark Theme")
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                }
                ToggleButton {
                    checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
                    onCheckedChanged: {
                        checked ? _app.setv("use_dark_theme", "dark") : _app.setv("use_dark_theme", "bright")
                        try {
                            Application.themeSupport.setVisualStyle(checked ? VisualStyle.Dark : VisualStyle.Bright);
                        } catch (e) {
                            console.log("ERROR: %1".arg(e))
                        }
                    }
                    verticalAlignment: VerticalAlignment.Center
                }
            }
            Header {
                title: qsTr("Web Viewer Settings")
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftMargin: 20.0
                rightMargin: 20.0
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                ImageView {
                    imageSource: "asset:///icon/icon_187.png"
                    scalingMethod: ScalingMethod.AspectFit
                    filterColor: Color.DarkGray
                    verticalAlignment: VerticalAlignment.Center
                }
                Label {
                    text: qsTr("Show Images")
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                }
                ToggleButton {
                    checked: _app.getv("web_image_enabled", "true") == "true"
                    onCheckedChanged: {
                        checked ? _app.setv("web_image_enabled", "true") : _app.setv("web_image_enabled", "false")
                    }
                    verticalAlignment: VerticalAlignment.Center
                }
            }
            Header {
                title: qsTr("FrontPage Style")
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                Label {
                    text: qsTr("Choose the style of zhihu frontpage. Please be aware that this will take effect on next app start.")
                    multiline: true
                }
                RadioGroup {
                    options: [
                        Option {
                            text: qsTr("Grid Layout")
                            description: qsTr("Default layout, better for larger devices.")
                            id: gridoption
                            value: 0
                            imageSource: "asset:///icon/ic_view_grid.png"
                        },
                        Option {
                            text: qsTr("List Layout")
                            description: qsTr("Official app style.")
                            id: listoption
                            value: 1
                            imageSource: "asset:///icon/ic_view_list.png"
                        }
                    ]
                    selectedIndex: + _app.getv("style", "0")
                    onSelectedValueChanged: {
                        _app.setv("style", selectedValue);
                    }
                    dividersVisible: true
                }
            }
            Header {
                title: qsTr("Cache Management")
            }
            Container {
                topPadding: 20.0
                leftPadding: 20.0
                bottomPadding: 20.0
                rightPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                Label {
                    text: qsTr("Press the button below to clean the cache files.")
                    multiline: true
                }
                Button {
                    text: qsTr("Purge Cache")
                    appearance: ControlAppearance.Primary
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: {
                        invisibleWebview.storage.clear()
                        invisibleImageView.clearCache()
                        sst.show()
                    }
                    attachedObjects: [
                        WebView {
                            id: invisibleWebview
                        },
                        WebImageView {
                            id: invisibleImageView
                        },
                        SystemToast {
                            id: sst
                            body: qsTr("Cache Cleared")
                            
                        }
                    ]
                }
            }
            
            Divider {
                topMargin: 50
                opacity: 0.1
            }
            
            
        }
    }
}
