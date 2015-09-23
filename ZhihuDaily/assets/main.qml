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
                var about_page_obj = aboutpage.createObject();
                about_page_obj.nav = navigationPane;
                navigationPane.push(about_page_obj);
            }
            attachedObjects: ComponentDefinition {
                source: "about.qml"
                id: aboutpage
            }
        }
        settingsAction: SettingsActionItem {
            onTriggered: {
                var settings_page_obj = settingspage.createObject();
                settings_page_obj.nav = navigationPane;
                navigationPane.push(settings_page_obj);
            }
            attachedObjects: ComponentDefinition {
                source: "settings.qml"
                id: settingspage
            }
        }
        actions: [
            ActionItem {
                title: qsTr("Review")
                imageSource: "asset:///icon/ic_edit_bookmarks.png"
                onTriggered: {
                    Qt.openUrlExternally("appworld://content/58370266")
                }
            },
            ActionItem {
                title: qsTr("Theme")
                onTriggered: {
                    var isDarkNow = (Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark);
                    var newtheme = ! isDarkNow;
                    _app.setv("use_dark_theme", newtheme ? "dark" : "bright");
                    Application.themeSupport.setVisualStyle(newtheme ? VisualStyle.Dark : VisualStyle.Bright);
                }
                imageSource: "asset:///icon/icon_211.png"
            }
        ]
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
        /*
         * layout style
         * 0 : grid layout
         * 1: list layout
         */
        property int layoutstyle: + _app.getv("style", 0)

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
                        if (toppage.layoutstyle == 1) {
                            /*
                             * if is using list layout, dismiss.
                             */
                            return;
                        }
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
                    if (toppage.layoutstyle == 0) {
                        return (data.header ? 'header2' : 'item2');
                    } else if (toppage.layoutstyle == 1) {
                        return (data.header ? 'header' : 'item1');
                    }

                }
                function requestView(id) {
                    var page = webv.createObject(navigationPane);
                    page.nav = navigationPane;
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
                    },
                    ComponentDefinition {
                        id: gridlayoutDef
                        GridListLayout {
                            columnCount: lv.columnsInGrid
                            headerMode: ListHeaderMode.None
                            cellAspectRatio: lv.columnsInGrid == 1 ? 16 / 5 : 1
                        }
                    },
                    ComponentDefinition {
                        id: defaultLayoutDef
                        StackLayout {

                        }
                    }
                ]
                bufferedScrollingEnabled: true
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                scrollRole: ScrollRole.Main
                layout: toppage.layoutstyle == 0 ? gridlayoutDef.createObject() : defaultLayoutDef.createObject()
            }
            Container {
                visible: toppage.showTimeMachinePanel
                onVisibleChanged: {
                    if (visible) {
                        dt.expanded = true;
                    }
                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                background: ui.palette.background
                topPadding: 20.0
                bottomPadding: 60.0
                Header {
                    title: qsTr("Time Machine")
                }
                Container {
                    leftPadding: 20
                    rightPadding: leftPadding
                    topPadding: leftPadding
                    bottomPadding: leftPadding
                    Label {
                        text: qsTr("Use this feature to navigate back in time.")
                    }
                    DateTimePicker {
                        id: dt
                        mode: DateTimePickerMode.Date
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Center
                        minimum: new Date("2013/05/19")
                        enabled: true
                        title: qsTr("Date")
                        expanded: true
                    }
                }

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    leftPadding: 20.0
                    rightPadding: 20.0
                    topPadding: 20.0
                    horizontalAlignment: HorizontalAlignment.Fill
                    Button {
                        imageSource: "asset:///icon/ic_resume.png"
                        appearance: ControlAppearance.Primary
                        verticalAlignment: VerticalAlignment.Center
                        onClicked: {
                            dt.value = new Date();
                        }
                        text: qsTr("Back to Today")
                        horizontalAlignment: HorizontalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                    }
                    Button {
                        imageSource: "asset:///icon/ic_done.png"
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
                        text: qsTr("Go!")
                        horizontalAlignment: HorizontalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                    }

                }
            }
        }
        actions: [
            ActionItem {
                title: qsTr("Time Machine")
                ActionBar.placement: ActionBarPlacement.Signature
                onTriggered: {
                    toppage.showTimeMachinePanel = ! toppage.showTimeMachinePanel;
                }
                imageSource: "asset:///icon/ic_history.png"
            }
        ]
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        actionBarVisibility: ChromeVisibility.Overlay

    }

    onPopTransitionEnded: {
        page.destroy();
        if (top == toppage) {
            Application.menuEnabled = true
            lv.scrollRole = ScrollRole.Main
        }
    }
    onPushTransitionEnded: {
        // FIX #12
        if (top != toppage) {
            Application.menuEnabled = false
        }
    }
}
