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
    function trimHTML(htmltext) {
        var c = htmltext.replace(/<(br|p|\/p|\/span).*?>/ig, "@MRK@#");
        console.log(c);
        c = c.replace(/(<[^>]*>)/g, "");
        c = c.replace(/\s+/g, "");
        c = c.replace("查看知乎讨论", "@MRK@#@MRK@#");
        c = c.replace(/@MRK@#/g, "\r\n　　");
        return c;
    }
    property string changeFontSize: "var a=document.createElement('style');a.innerHTML='.content { font-size: %1px }';document.head.appendChild(a);"
    property double fontsize: _app.getv("txtfontsize", "12")
    onFontsizeChanged: {
        _app.setv("txtfontsize", fontsize)
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
    property string weburl
    property string webtitle
    function load(url) {
        co.ajax("GET", url, [], function(d) {
                loading = false
                if (d['success']) {
                    var dt = JSON.parse(d['data']);
                    webcontent = trimHTML(dt.body);
                    webtitle=dt.title;
                    weburl = dt.share_url;
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
            Container {
                leftPadding: 20.0
                rightPadding: 20.0
                topPadding: 20.0
                bottomPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                implicitLayoutAnimationsEnabled: false
                Label {
                    id: textcontent
                    text: webcontent
                    multiline: true
                    textFormat: TextFormat.Html
                    textStyle.fontSizeValue: fontsize
                    textStyle.fontSize: FontSize.PointValue
                    implicitLayoutAnimationsEnabled: false
                }
            }
        }
    }
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay

    actions: [
        ActionItem {
            title: qsTr("Zoom -")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                fontsize *= 0.8;
            }
            imageSource: "asset:///icon/ic_zoom_out.png"
        },
        ActionItem {
            title: qsTr("Zoom +")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                fontsize *= 1.25;
            }
            imageSource: "asset:///icon/ic_zoom_in.png"
        },
        ActionItem {
            title: qsTr("Share")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                _app.shareURL(weburl);
            }
            imageSource: "asset:///icon/ic_share.png"
        },
        ActionItem {
            title: qsTr("Open in Browser")
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                Qt.openUrlExternally(weburl);
            }
            imageSource: "asset:///icon/ic_open.png"
        },
        ActionItem {
            title: qsTr("Remember")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                sst.body = qsTr("Processing content, please wait. \r\nRemember will show up if the content is not too long.");
                sst.show();
                var cc = webcontent.replace(/\s+/g, "\n");
                _app.shareTXT(weburl, webtitle, cc);
            }
            imageSource: "asset:///icon/ic_notes.png"
        },ActionItem {
            title: qsTr("Web View")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///icon/ic_browser.png"
            onTriggered: {
                var webviewer = Qt.createComponent("webviewEx.qml").createObject(nav);
                webviewer.nav = nav;
                webviewer.id = id;
                nav.push(webviewer);
            }
        },
        ActionItem {
            title: qsTr("Comments")
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                var commentsReader = Qt.createComponent("comments.qml").createObject(nav);
                commentsReader.articleid = id;
                commentsReader.nav = nav;
                commentsReader.loadData();
                nav.push(commentsReader);
            }
            imageSource: "asset:///icon/ic_feedback.png"
        }
        
    ]
}
