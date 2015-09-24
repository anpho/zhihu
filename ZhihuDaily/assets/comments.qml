import bb.cascades 1.4
import bb.data 1.0
import bb.system 1.2
import cn.anpho 1.0
Page {
    id: commentspage
    property int count_long_comments
    property int count_short_comments
    property string articleid
    property variant nav
    function loadData() {
        long_act.running = true
        short_act.running = true

        adm_long_comments.clear();
        ds_long_comments.load();
        adm_short_comments.clear();
        ds_short_comments.load();
    }
    attachedObjects: [
        SystemToast {
            id: sst
        },

        ListItemComponent {
            id: listItemComp
            type: ""
            Container {
                leftPadding: 20.0
                rightPadding: 20.0
                topPadding: 20.0
                bottomPadding: 20.0
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    WebImageView {
                        url: ListItemData.avatar
                        scalingMethod: ScalingMethod.AspectFit
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Top
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0

                        }
                    }
                    Label {
                        text: ListItemData.content
                        multiline: true
                        textFormat: TextFormat.Plain
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        textFit.mode: LabelTextFitMode.Default
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Top
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 6.0
                        }
                    }
                }
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    topPadding: 10.0
                    bottomPadding: 10.0
                    leftPadding: 10.0
                    rightPadding: 10.0
                    Container {
                        horizontalAlignment: HorizontalAlignment.Right
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        opacity: 0.8
                        Label {
                            text: qsTr("By %1 ").arg(ListItemData.author)
                            textStyle.fontSize: FontSize.XSmall
                            verticalAlignment: VerticalAlignment.Center
                        }
                        Label {
                            text: qsTr("Likes(%1) ").arg(ListItemData.likes)
                            textStyle.fontSize: FontSize.XSmall
                            verticalAlignment: VerticalAlignment.Center
                        }
                    }
                }
                Divider {
                    
                }
            }
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Compact
    actionBarFollowKeyboardPolicy: ActionBarFollowKeyboardPolicy.Default
    Container {
        SegmentedControl {
            options: [
                Option {
                    id: op_long_comments
                    text: qsTr("Long Comments(%1)").arg(count_long_comments)
                },
                Option {
                    id: op_short_comments
                    text: qsTr("Short Comments(%1)").arg(count_short_comments)
                }
            ]
        }
        ActivityIndicator {
            running: true
            horizontalAlignment: HorizontalAlignment.Center
            id: long_act
            visible: op_long_comments.selected && running
        }

        ActivityIndicator {
            running: true
            horizontalAlignment: HorizontalAlignment.Center
            id: short_act
            visible: op_short_comments.selected && running
        }
        ListView {
            visible: op_long_comments.selected
            dataModel: ArrayDataModel {
                id: adm_long_comments
            }
            listItemComponents: [ listItemComp ]

            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            attachedObjects: [
                DataSource {
                    id: ds_long_comments
                    source: "http://news-at.zhihu.com/api/4/story/%1/long-comments".arg(articleid)
                    type: DataSourceType.Json
                    remote: true
                    onDataLoaded: {
                        long_act.running = false
                        var comments = data["comments"] ? data["comments"] : [];
                        count_long_comments = comments.length;
                        if (count_long_comments == 0) {
                            //bypass
                        } else {
                            adm_long_comments.append(comments)
                        }
                    }
                    onError: {
                        long_act.running = false
                        sst.body = qsTr("Load long comments failed, error is : %1").arg(errorMessage)
                        sst.show();
                    }
                }
            ]
        }
        ListView {
            visible: op_short_comments.selected
            dataModel: ArrayDataModel {
                id: adm_short_comments
            }
            listItemComponents: [ listItemComp ]

            scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
            attachedObjects: [
                DataSource {
                    id: ds_short_comments
                    source: "http://news-at.zhihu.com/api/4/story/%1/short-comments".arg(articleid)
                    type: DataSourceType.Json
                    remote: true
                    onDataLoaded: {
                        short_act.running = false
                        var comments = data["comments"] ? data["comments"] : [];
                        count_short_comments = comments.length;
                        if (count_short_comments == 0) {
                            //bypass
                        } else {
                            adm_short_comments.append(comments)
                        }
                    }
                    onError: {
                        short_act.running = false
                        sst.body = qsTr("Load short comments failed, error is : %1").arg(errorMessage)
                        sst.show();
                    }
                }
            ]
        }
    }
}
