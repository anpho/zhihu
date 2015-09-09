import bb.cascades 1.4

Page {
    function setActive() {
        scrollview.scrollRole = ScrollRole.Main;
        scrollview.requestFocus()
    }
    property alias uri: webv.url
    property variant nav
    titleBar: TitleBar {
        title: webv.title
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    actions: [
        ActionItem {
            title: qsTr("Open in browser")
            onTriggered: {
                Qt.openUrlExternally(uri)
            }
            imageSource: "asset:///icon/ic_open.png"
            ActionBar.placement: ActionBarPlacement.Signature
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Disabled
    actionBarVisibility: ChromeVisibility.Compact
    Container {
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: ui.palette.background
        ImageView {
            imageSource: "asset:///image/bg.png"
            scalingMethod: ScalingMethod.AspectFill
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
        layout: DockLayout {

        }
        ScrollView {
            id: scrollview
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            scrollRole: ScrollRole.Main
            WebView {
                id: webv
                property bool isDapenti: webv.url.toString().indexOf("dapenti.com") > -1
                property bool fontsizeset: false
                visible: loadProgress > 10
                horizontalAlignment: HorizontalAlignment.Fill
                settings.userStyleSheetLocation: "ad.css"
                preferredHeight: Infinity
                onNavigationRequested: {
                    if (url.toString().trim().length == 0) {
                        return;
                    }
                    if (request.navigationType == WebNavigationType.LinkClicked || request.navigationType == WebNavigationType.OpenWindow) {
                        request.action = WebNavigationRequestAction.Ignore
                        var page = Qt.createComponent("webviewer.qml").createObject(nav);
                        page.uri = request.url;
                        page.nav = nav;
                        nav.push(page)
                    }
                }
                settings.userAgent: "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7"
                settings.zoomToFitEnabled: true
                settings.defaultFontSizeFollowsSystemFontSize: true
                settings.textAutosizingEnabled: false
                settings.imageDownloadingEnabled: _app.getv("web_image_enabled", "true") == "true"
            }
        }
        ProgressIndicator {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Top
            fromValue: 0.0
            toValue: 100.0
            value: webv.loadProgress
            visible: webv.loading
        }

    }
}