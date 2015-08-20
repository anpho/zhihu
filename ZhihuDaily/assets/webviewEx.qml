import bb.cascades 1.4
import bb.system 1.2
Page {
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
    property string id
    property bool loading: false
    property double deviceRatio: parseFloat(_app.getv('ratio', '4.0'))
    onDeviceRatioChanged: {
        _app.setv("ratio", deviceRatio);
    }
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
                    webv.url = dt.share_url;
                } else {
                    console.log(d['data'])
                    sst.body = d['data'];
                    sst.show();
                }
            }, [], false)
    }
    ScrollView {
        id: scrview
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        scrollViewProperties.pinchToZoomEnabled: true
        scrollViewProperties.scrollMode: ScrollMode.Both
        onContentScaleChanged: {
        }
        WebView {
            id: webv
            horizontalAlignment: HorizontalAlignment.Fill
            settings.webInspectorEnabled: true
            settings.userStyleSheetLocation: "ad.css"
            settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
            onNavigationRequested: {
                if (request.navigationType == WebNavigationType.OpenWindow || request.navigationType == WebNavigationType.LinkClicked) {
                    request.action = WebNavigationRequestAction.Ignore
                    Qt.openUrlExternally(request.url)
                }
            }
            settings.devicePixelRatio: deviceRatio
//            settings.viewport: { "initial-scale" : 1.0 }
            onMinContentScaleChanged: {
                scrview.scrollViewProperties.minContentScale = minContentScale;
            }
            onMaxContentScaleChanged: {
                scrview.scrollViewProperties.maxContentScale = maxContentScale;
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
        }
    ]
}
