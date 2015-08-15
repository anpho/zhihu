/*
 * all rights reserved anpho@bbdev.cn
 */
import bb.cascades 1.4
import bb.data 1.0
import cn.anpho 1.0
NavigationPane {
    id: navigationPane
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                navigationPane.push(aboutpage.createObject())
            }
            attachedObjects: ComponentDefinition {
                source: "about.qml"
                id: aboutpage
            }
        }
    }
    Page {
        property int currentdate: + Qt.formatDate(new Date(), "yyyyMMdd")
        property bool loading: false
        function load() {
            if (loading) return;
            loading = true;
            var b4date = (currentdate) + '';
            var endpoint = "http://news.at.zhihu.com/api/4/news/before/%1".arg(b4date)
            ds.source = endpoint;
            ds.load();
        }
        attachedObjects: Common {
            id: co
        }
        titleBar: TitleBar {
            kind: TitleBarKind.FreeForm
            kindProperties: FreeFormTitleBarKindProperties {
                Container {
                    topPadding: 10.0

                    leftPadding: 20.0
                    bottomPadding: 10.0
                    rightPadding: 20.0
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    ImageView {
                        imageSource: "asset:///image/logo.png"
                        scalingMethod: ScalingMethod.AspectFit
                        gestureHandlers: TapHandler {
                            onTapped: {
                                adm.clear()
                                ds.abort();
                                ds.source = "http://news-at.zhihu.com/api/4/news/latest";
                                ds.load()
                            }
                        }
                    }
                    Container {
                        visible: toppage.loading
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0

                        }
                        verticalAlignment: VerticalAlignment.Center
                        layout: StackLayout {
                            orientation: LayoutOrientation.RightToLeft

                        }

                        ActivityIndicator {
                            running: true
                            horizontalAlignment: HorizontalAlignment.Right
                        }
                        Label {
                            text: qsTr("Loading")
                        }
                    }
                    Container {
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Fill
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 0.2
                        }
                        layout: StackLayout {
                            orientation: LayoutOrientation.RightToLeft
                        }
                        CheckBox {
                            checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
                            onCheckedChanged: {
                                _app.setv("use_dark_theme", checked ? "dark" : "bright");
                                try {
                                    Application.themeSupport.setVisualStyle(checked ? VisualStyle.Dark : VisualStyle.Bright);
                                } catch (e) {

                                }
                            }
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Right
                            id: themecheckbox
                        }
                        Label {
                            text: themecheckbox.checked ? String.fromCharCode(0x263d) : String.fromCharCode(0x263c)
                            verticalAlignment: VerticalAlignment.Center
                        }
                    }
                }
            }
            scrollBehavior: TitleBarScrollBehavior.NonSticky
            title: qsTr("ZhiHu Daily")

        }
        id: toppage
        onCreationCompleted: {
            ds.load()
        }
        ListView {
            dataModel: ArrayDataModel {
                id: adm
            }
            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            snapMode: SnapMode.Default

            function itemType(data, indexPath) {
                return (data.header ? 'header' : 'item');
            }
            function requestView(id) {
                var page = webv.createObject(navigationPane);
                page.id = id;
                navigationPane.push(page);
            }
            listItemComponents: [
                ListItemComponent {
                    type: "header"
                    Container {
                        Container {
                            background: Color.create("#ff0da3d7")
                            horizontalAlignment: HorizontalAlignment.Left
                            verticalAlignment: VerticalAlignment.Center
                            leftPadding: 40.0
                            rightPadding: 40.0
                            topPadding: 20.0
                            bottomPadding: 20.0
                            Label {
                                text: ListItemData.title
                                textStyle.color: Color.White
                            }
                        }
                        Divider {
                            horizontalAlignment: HorizontalAlignment.Fill

                        }
                    }
                },
                ListItemComponent {
                    type: "item"
                    Container {
                        id: itemroot
                        gestureHandlers: TapHandler {
                            onTapped: {
                                itemroot.ListItem.view.requestView(ListItemData.id)
                            }
                        }
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight

                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        leftPadding: 50.0
                        rightPadding: 40.0
                        topMargin: 40.0
                        bottomMargin: 40.0
                        WebImageView {
                            id: webimage
                            verticalAlignment: VerticalAlignment.Center
                            scalingMethod: ScalingMethod.AspectFill
                            url: ListItemData.images[0]
                            enabled: ListItemData.images[0]
                            preferredHeight: ui.du(15)
                            preferredWidth: ui.du(15)
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1.0

                            }
                        }
                        Label {
                            multiline: true
                            textFormat: TextFormat.Plain
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.textAlign: TextAlign.Left
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Center
                            text: ListItemData.title
                            textStyle.fontSize: FontSize.Medium
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 5.0
                            }
                        }
                    }
                }
            ]

            attachedObjects: [
                DataSource {
                    id: ds
                    source: "http://news-at.zhihu.com/api/4/news/latest"
                    remote: true
                    type: DataSourceType.Json
                    onDataLoaded: {
                        if (data.date) {
                            adm.append({
                                    "header": true,
                                    "title": data.date
                                })
                            toppage.currentdate = + data.date;
                        }
                        if (data.stories) {
                            adm.append(data.stories)
                        }
                        toppage.loading = false;
                    }
                    onError: {
                        toppage.loading = false
                        console.log(errorMessage)
                    }
                },
                ComponentDefinition {
                    id: webv
                    source: "webviewer.qml"
                },
                ListScrollStateHandler {
                    id: lss
                    onScrollingChanged: {
                        if (scrolling && lss.atEnd && ! toppage.loading) {
                            toppage.load();
                        }
                    }
                }
            ]
            bufferedScrollingEnabled: true
        }
    }

    onPopTransitionEnded: {
        page.destroy();
    }
}
