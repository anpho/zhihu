import bb.cascades 1.4
import bb.data 1.0
import cn.anpho 1.0
NavigationPane {
    id: navigationPane

    Page {
        id: toppage
        onCreationCompleted: {
            ds.load()
        }
        ListView {
            dataModel: ArrayDataModel {
                id: adm
            }
            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            snapMode: SnapMode.LeadingEdge
            layout: GridListLayout {
                columnCount: 1
                headerMode: ListHeaderMode.Sticky
                horizontalCellSpacing: 15.0
                verticalCellSpacing: 15.0
            }
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
                    Header {
                        title: ListItemData.title
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
                        leftPadding: 40.0
                        rightPadding: 40.0
                        topMargin: 40.0
                        bottomMargin: 40.0
                        WebImageView {
                            id: webimage
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Fill
                            scalingMethod: ScalingMethod.AspectFill
                            url: ListItemData.images[0]
                            enabled: ListItemData.images[0]
                            attachedObjects: LayoutUpdateHandler {
                                onLayoutFrameChanged: {
                                    webimage.preferredHeight = layoutFrame.width
                                }
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
                        }
                        if (data.stories) {
                            adm.append(data.stories)
                        }
                    }
                    onError: {

                    }
                },
                ComponentDefinition {
                    id: webv
                    source: "webviewer.qml"
                }
            ]
        }
    }

    onPopTransitionEnded: {
        page.destroy();
    }
}
