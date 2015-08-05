import bb.cascades 1.2
import cn.anpho 1.0
import bb.system 1.2
Page {
    attachedObjects: Common {
        id: co
    }
    onCreationCompleted: {
        if (id) {
            loading = true;
            load("http://news-at.zhihu.com/api/4/news/%1".arg(id))
        }
    }
    property bool loading: false
    property string id
    onIdChanged: {
        if (! loading) {
            loading = true;
            load("http://news-at.zhihu.com/api/4/news/%1".arg(id))
        }
    }
    property alias uri: webv.url
    property alias body: webv.html

    property alias image: title_image.url
    property alias title: title_text.text
    property alias source: title_source.text
    function load(url) {
        co.ajax("GET", url, [], function(d) {
                loading = false
                if (d['success']) {
                    var dt = JSON.parse(d['data']);
                    source = dt.image_source;
                    title = dt.title;
                    image = dt.image;
                    if (dt.css && dt.css.length > 0) {
                        webv.settings.userStyleSheetLocation = dt.css[0];
                    }
                    body = dt.body;
                } else {
                    console.log(d['data'])
                }
            }, [], false)
    }
    ScrollView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        scrollRole: ScrollRole.Main
        Container {
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                layout: DockLayout {

                }
                WebImageView {
                    id: title_image
                    scalingMethod: ScalingMethod.AspectFill
                    loadEffect: ImageViewLoadEffect.FadeZoom
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Center
                    attachedObjects: LayoutUpdateHandler {
                        onLayoutFrameChanged: {
                            title_image.preferredHeight = layoutFrame.width * 0.5
                        }
                    }
                }
                Container {
                    background: Color.create("#b0ffffff")
                    leftPadding: 20.0
                    topPadding: 20.0
                    rightPadding: 20.0
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Bottom
                    Label {
                        id: title_text
                        multiline: true
                        textStyle.color: Color.Black
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Bottom
                        textStyle.fontSize: FontSize.Large
                    }
                    Label {
                        id: title_source
                        textStyle.color: Color.Black
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Right
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Bottom
                        textStyle.fontSize: FontSize.Small
                    }

                }
            }
            WebView {
                id: webv
                horizontalAlignment: HorizontalAlignment.Fill
                preferredHeight: Infinity
                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
                settings.defaultFontSizeFollowsSystemFontSize: true
                settings.zoomToFitEnabled: false
                settings.activeTextEnabled: false
                onNavigationRequested: {
                    if (request.navigationType == WebNavigationType.OpenWindow || request.navigationType == WebNavigationType.LinkClicked) {
                        request.action = WebNavigationRequestAction.Ignore
                        Qt.openUrlExternally(request.url)
                    }
                }
            }
        }
    }
}