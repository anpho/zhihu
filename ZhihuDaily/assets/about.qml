/*
 * all rights reserved anpho@bbdev.cn
 */
import bb.cascades 1.4

Page {
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
                text: "Merrick Zhang ( anpho@bbdev.cn )"
                horizontalAlignment: HorizontalAlignment.Center
                textFormat: TextFormat.Html
            }
            Label {
                text: "<a href='http://bbdev.cn'>BBDev.CN Official Website</a>"
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Center
            }
            Header {
                title: qsTr("CONTRIBUTE")
            }
            Label {
                text: qsTr("You can help me to make this app better")
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                text: qsTr("<a href='https://github.com/BBDev-CN/zhihu'>Project on Github</a>")
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                text: qsTr("<a href='https://github.com/BBDev-CN/zhihu/issues'>Issues / Bug Report</a>")
                textFormat: TextFormat.Html
                horizontalAlignment: HorizontalAlignment.Center
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
