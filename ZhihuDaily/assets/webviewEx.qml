import bb.cascades 1.4
import bb.system 1.2
Page {
    property variant nav
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: sst
        }
    ]
    onCreationCompleted: {
        if (id) {
            loading = true;
            load("http://news-at.zhihu.com/api/4/news/%1".arg(id))
        }
        scrview.scrollRole = ScrollRole.Main
    }
    property string changeFontSize: "var a=document.createElement('style');a.innerHTML='.content { font-size: %1px }';document.head.appendChild(a);"
    property int fontsize: _app.getv("fontsize", webv.settings.defaultFontSize)
    onFontsizeChanged: {
        _app.setv("fontsize", fontsize)
    }

    property string id
    property bool loading: false
    onIdChanged: {
        if (! loading) {
            loading = true;
            load("http://news-at.zhihu.com/api/4/news/%1".arg(id))
        }
    }
    property string webcontent
    function load(url) {
        co.ajax("GET", url, [], function(d) {
                loading = false
                if (d['success']) {
                    var dt = JSON.parse(d['data']);
                    webcontent = dt.body;
                    webv.url = dt.share_url;
                } else {
                    console.log(d['data'])
                    sst.body = d['data'];
                    sst.show();
                }
            }, [], false)
    }
    Container {
        layout: DockLayout {

        }
        ImageView {
            imageSource: "asset:///image/bg.png"
            scalingMethod: ScalingMethod.AspectFill
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
        ScrollView {
            id: scrview
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            scrollViewProperties.pinchToZoomEnabled: true
            // FIX #7 , won't scroll when content doesn't zoomed.
            scrollViewProperties.scrollMode: scrview.contentScale > 1 ? ScrollMode.Both : ScrollMode.Vertical
            WebView {
                id: webv
                horizontalAlignment: HorizontalAlignment.Fill
                settings.userStyleSheetLocation: "ad.css"
                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
                onNavigationRequested: {
                    if (request.navigationType == WebNavigationType.OpenWindow || request.navigationType == WebNavigationType.LinkClicked) {
                        request.action = WebNavigationRequestAction.Ignore
                        var newWebPageView = Qt.createComponent("webviewer.qml").createObject(nav);
                        newWebPageView.nav = nav;
                        newWebPageView.uri = request.url;
                        nav.push(newWebPageView);
                    }
                }
                onLoadingChanged: {
                    if (! loading) {
                        webv.evaluateJavaScript(changeFontSize.arg(fontsize))
                    }
                }
                //            settings.viewport: { "initial-scale" : 1.0 }
                onMinContentScaleChanged: {
                    scrview.scrollViewProperties.minContentScale = minContentScale;
                }
                onMaxContentScaleChanged: {
                    scrview.scrollViewProperties.maxContentScale = maxContentScale;
                }
                settings.webInspectorEnabled: true
                settings.imageDownloadingEnabled: _app.getv("web_image_enabled", "true") == "true"
            }
        }
        Container {
            visible: webv.loading
            ProgressIndicator {
                value: webv.loadProgress
                fromValue: 0
                toValue: 100
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
        }

    }
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay

    actions: [
        ActionItem {
            title: qsTr("Zoom -")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                var newsize = Math.max(12, fontsize - 2)
                webv.evaluateJavaScript(changeFontSize.arg(newsize))
                fontsize = newsize;
            }
            imageSource: "asset:///icon/ic_zoom_out.png"
        },
        ActionItem {
            title: qsTr("Zoom +")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                var newsize = Math.min(28, fontsize + 2)
                webv.evaluateJavaScript(changeFontSize.arg(newsize))
                fontsize = newsize;
            }
            imageSource: "asset:///icon/ic_zoom_in.png"
        },
        ActionItem {
            title: qsTr("Share")
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                _app.shareURL(webv.url.toString());
            }
            imageSource: "asset:///icon/ic_share.png"
        },
        ActionItem {
            title: qsTr("Open in Browser")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                Qt.openUrlExternally(webv.url.toString());
            }
            imageSource: "asset:///icon/ic_open.png"
        },
        ActionItem {
            title: qsTr("Send Text to Remember")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                _app.shareHTML(webv.url, webv.title, webcontent);
            }
            imageSource: "asset:///icon/ic_notes.png"

        }
    ]
}
