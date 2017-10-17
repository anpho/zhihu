/*
 * all rights reserved anpho@bbdev.cn
 */
import bb.cascades 1.4

Page {
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Disabled
    actionBarVisibility: ChromeVisibility.Compact
    property variant nav
    ScrollView {
        Container {
            horizontalAlignment: HorizontalAlignment.Fill

            topPadding: 50.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 50.0
            ImageView {
                imageSource: "asset:///image/logo.png"
                scalingMethod: ScalingMethod.AspectFit
                horizontalAlignment: HorizontalAlignment.Center

            }
            Label {
                text: qsTr("Re-built with BlackBerry Cascades")
                textStyle.textAlign: TextAlign.Right
                horizontalAlignment: HorizontalAlignment.Right
            }
            Header {
                title: qsTr("AUTHOR")
            }
            Label {
                text: "Merrick Zhang ( me@anpho.cn )"
                horizontalAlignment: HorizontalAlignment.Center
                textFormat: TextFormat.Html
            }
            
            Label {
                text: qsTr("Please DON'T email me for bug report or feature request, use the links below.")
                multiline: true
                textStyle.textAlign: TextAlign.Center
                horizontalAlignment: HorizontalAlignment.Fill
                textFormat: TextFormat.Html
            }
            Header {
                title: qsTr("CONTRIBUTE")
            }
            Label {
                text: qsTr("You can help me to make this app better")
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                text: qsTr("Project on Github") + String.fromCharCode(0x2197)
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Center
                gestureHandlers: TapHandler {
                    onTapped: {
                        var target_url = "http://github.com/BBDev-CN/zhihu";
                        var webv = Qt.createComponent("webviewer.qml").createObject(nav);
                        webv.nav = nav;
                        webv.uri = target_url;
                        nav.push(webv);
                    }
                }
                textStyle.color: ui.palette.primary
            }
            Label {
                text: qsTr("Issues / Bug Report") + String.fromCharCode(0x2197)
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Center
                gestureHandlers: TapHandler {
                    onTapped: {
                        var target_url = "https://github.com/BBDev-CN/zhihu/issues";
                        var webv = Qt.createComponent("webviewer.qml").createObject(nav);
                        webv.nav = nav;
                        webv.uri = target_url;
                        nav.push(webv);
                    }
                }
                textStyle.color: ui.palette.primary
            }
            Header {
                title: qsTr("DONATE")
            }
            Label {
                text: qsTr("Please make donations to support my development, my paypal/alipay account is : <u>anphorea@gmail.com</u> , Thank you !")
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
                textFormat: TextFormat.Html
                textStyle.fontWeight: FontWeight.Default
            }
        }
    }
}
