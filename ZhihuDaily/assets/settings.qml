import bb.cascades 1.4

Page {
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
        }
    }
}
