/*
 * all rights reserved anpho@bbdev.cn
 */
import bb.cascades 1.4
import bb.data 1.0
import cn.anpho 1.0
import bb.system 1.2
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
        property bool showTimeMachinePanel: false
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
        id: toppage
        onCreationCompleted: {
            ds.load()
        }
        Container {
            layout: DockLayout {

            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill

            ListView {
                property int columnsInGrid: + _app.getv("columns", "2")
                onColumnsInGridChanged: {
                    _app.setv("columns", columnsInGrid);
                }
                gestureHandlers: PinchHandler {
                    onPinchEnded: {
                        console.log(event.pinchRatio)
                        if (event.pinchRatio > 1) {
                            lv.columnsInGrid = Math.max(lv.columnsInGrid - 1, 1);
                        } else {
                            lv.columnsInGrid = Math.min(lv.columnsInGrid + 1, 4);
                        }
                    }
                }
                id: lv
                dataModel: ArrayDataModel {
                    id: adm
                }
                scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
                snapMode: SnapMode.Default

                function itemType(data, indexPath) {
                    return (data.header ? 'header2' : 'item2');
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
                        type: "header2"
                        Container {
                            background: Color.create("#ff0da3d7")
                            layout: DockLayout {

                            }
                            Label {
                                text: ListItemData.title
                                textStyle.color: Color.White
                                verticalAlignment: VerticalAlignment.Center
                                horizontalAlignment: HorizontalAlignment.Center
                                textStyle.fontSize: FontSize.Large
                                textStyle.fontWeight: FontWeight.W100
                            }
                        }
                    },
                    ListItemComponent {
                        type: "item1"
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
                    },
                    ListItemComponent {
                        type: "item2"
                        Container {
                            id: itemroot2
                            layout: DockLayout {

                            }
                            gestureHandlers: TapHandler {
                                onTapped: {
                                    itemroot2.ListItem.view.requestView(ListItemData.id)
                                }
                            }
                            WebImageView {
                                scalingMethod: ScalingMethod.AspectFill
                                loadEffect: ImageViewLoadEffect.FadeZoom
                                verticalAlignment: VerticalAlignment.Fill
                                horizontalAlignment: HorizontalAlignment.Fill
                                url: ListItemData.images[0]
                            }
                            Container {
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Bottom
                                background: Color.create("#93000000")
                                leftPadding: 10.0
                                rightPadding: 10.0
                                topPadding: 10.0
                                bottomPadding: 10.0
                                Label {
                                    text: ListItemData.title
                                    multiline: true
                                    autoSize.maxLineCount: 2
                                    textFormat: TextFormat.Plain
                                    textStyle.textAlign: TextAlign.Left
                                    textStyle.fontWeight: FontWeight.W100
                                    textStyle.color: Color.White
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
                        source: "webviewEx.qml"
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
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                scrollRole: ScrollRole.Main
                layout: GridListLayout {
                    columnCount: lv.columnsInGrid
                    headerMode: ListHeaderMode.None
                    cellAspectRatio: lv.columnsInGrid == 1 ? 16 / 9 : 1
                }
            }
            Container {
                visible: toppage.showTimeMachinePanel
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Fill
                background: ui.palette.background
                topPadding: 20.0
                bottomPadding: 60.0
                Header {
                    title: qsTr("Time Machine")
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    leftPadding: 40.0
                    rightPadding: 40.0
                    topPadding: 20.0
                    Button {
                        imageSource: "asset:///icon/ic_resume.png"
                        preferredWidth: 1.0
                        appearance: ControlAppearance.Primary
                        verticalAlignment: VerticalAlignment.Center
                        onClicked: {
                            dt.value = new Date();
                        }
                    }
                    DateTimePicker {
                        id: dt
                        mode: DateTimePickerMode.Date
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        minimum: new Date("2013/05/19")
                        enabled: true
                    }
                    Button {
                        imageSource: "asset:///icon/ic_done.png"
                        preferredWidth: 1.0
                        appearance: ControlAppearance.Primary
                        verticalAlignment: VerticalAlignment.Center
                        onClicked: {
                            var ndate = dt.value;
                            ndate.setDate(dt.value.getDate() + 1);
                            ndate = Qt.formatDate(ndate, "yyyyMMdd");
                            toppage.currentdate = + ndate;
                            adm.clear();
                            toppage.load();
                            toppage.showTimeMachinePanel = false;
                        }
                    }
                }

            }
        }
        actions: [
            ActionItem {
                title: qsTr("Jump To")
                ActionBar.placement: ActionBarPlacement.Signature
                onTriggered: {
                    toppage.showTimeMachinePanel = ! toppage.showTimeMachinePanel;
                }
                imageSource: "asset:///icon/ic_browser.png"
            }
        ]
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        actionBarVisibility: ChromeVisibility.Compact

    }

    onPopTransitionEnded: {
        page.destroy();
        lv.scrollRole = ScrollRole.Main
    }
}
