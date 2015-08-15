/*
 * all rights reserved anpho@bbdev.cn
 */
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
        scrview.scrollRole = ScrollRole.Main
    }

    property double deviceRatio: parseFloat(_app.getv('ratio', '4.0'))
    onDeviceRatioChanged: {
        _app.setv("ratio", deviceRatio);
    }
    property alias body: webv.html
    property alias image: title_image.url
    property alias title: title_text.text
    property alias source: title_source.text
    property bool loading: false
    property string shareurl: ''

    property string id
    onIdChanged: {
        if (! loading) {
            loading = true;
            load("http://news-at.zhihu.com/api/4/news/%1".arg(id))
        }
    }

    function load(url) {
        co.ajax("GET", url, [], function(d) {
                loading = false
                if (d['success']) {
                    var dt = JSON.parse(d['data']);
                    source = dt.image_source;
                    title = dt.title;
                    image = dt.image;
                    shareurl = dt.share_url;
                    var css_ex = "";
                    if (dt.css && dt.css.length > 0) {
                        css_ex = '<link rel="stylesheet" type="text/css" href="%1">'.arg(dt.css[0])
                    }
                    //                    lbl.text = dt.body;
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
        attachedObjects: LayoutUpdateHandler {
            onLayoutFrameChanged: {
                scrview.preferredWidth = layoutFrame.width
                title_image.preferredHeight = layoutFrame.width * 0.5
            }
        }
        id: scrview
        Container {
            bottomPadding: 50.0
            Container {
                preferredWidth: scrview.preferredWidth
                layout: DockLayout {

                }
                implicitLayoutAnimationsEnabled: false
                WebImageView {
                    id: title_image
                    preferredWidth: scrview.preferredWidth
                    scalingMethod: ScalingMethod.AspectFill
                    loadEffect: ImageViewLoadEffect.FadeZoom
                    verticalAlignment: VerticalAlignment.Center
                }
                Container {
                    visible: !loading
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    background: bk.imagePaint
                    attachedObjects: ImagePaintDefinition {
                        id: bk
                        imageSource: "asset:///image/dim.amd"
                        repeatPattern: RepeatPattern.X
                    }

                }
                Container {
                    leftPadding: 20.0
                    topPadding: 20.0
                    rightPadding: 20.0
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Bottom
                    Label {
                        id: title_text
                        multiline: true
                        textStyle.color: Color.White
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Bottom
                        textStyle.fontSize: FontSize.Large
                    }
                    Label {
                        id: title_source
                        textStyle.color: Color.White
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Right
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Bottom
                        textStyle.fontSize: FontSize.Small
                        textStyle.fontStyle: FontStyle.Italic
                    }
                }

            }
            
            ActivityIndicator {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                running: true
                visible: loading
            }
            WebView {
                id: webv
                preferredWidth: scrview.preferredWidth
                preferredHeight: Infinity
                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
                onNavigationRequested: {
                    if (request.navigationType == WebNavigationType.OpenWindow || request.navigationType == WebNavigationType.LinkClicked) {
                        request.action = WebNavigationRequestAction.Ignore
                        Qt.openUrlExternally(request.url)
                    }
                }
                settings.webInspectorEnabled: true
                settings.textAutosizingEnabled: true
                settings.devicePixelRatio: deviceRatio
                settings.userStyleSheetLocation: "custom.css"
            }
            
        }
    }
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay

    actions: [
        ActionItem {
            title: qsTr("Zoom -")
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: deviceRatio > 1.0
            onTriggered: {
                deviceRatio = deviceRatio - 0.5
            }
            imageSource: "asset:///icon/ic_zoom_out.png"
        },
        ActionItem {
            title: qsTr("Zoom +")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                deviceRatio = deviceRatio + 0.5
            }
            imageSource: "asset:///icon/ic_zoom_in.png"
        },
        ActionItem {
            title: qsTr("Zoom Reset")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                deviceRatio = 4.0
            }
            imageSource: "asset:///icon/ic_reload.png"
        },
        ActionItem {
            title: qsTr("Share")
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                _app.shareURL(shareurl);
            }
            imageSource: "asset:///icon/ic_share.png"
        },
        ActionItem {
            title: qsTr("Open in Browser")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                Qt.openUrlExternally(shareurl);
            }
            imageSource: "asset:///icon/ic_open.png"
        }
    ]

}