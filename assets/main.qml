
import bb.cascades 1.2
import bb.data 1.0
NavigationPane {
    id: nav
    Page {
        Container {
            horizontalAlignment: HorizontalAlignment.Fill

            ListView {
                id: theList

                dataModel: dataModel
                property bool isTouched: false
                onTouch: {
                    if (event.isDown() | event.isMove()) {
                        isTouched = true
                    } else {
                        isTouched = false
                    }
                }
                leadingVisual: PullToRefresh {
                    id: pullRefresh
                    preferredWidth: listhandler.layoutFrame.width
                    touchActive: theList.isTouched
                    onRefreshTriggered: {

                        dataSource.load();

                    }
                }
                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        Container {
                            Container {
                                topPadding: 10
                                bottomPadding: 10
                                leftPadding: 15
                                rightPadding: 15
                                Label {
                                    text: ListItemData.title
                                    textStyle.base: SystemDefaults.TextStyles.TitleText
                                    multiline: true
                                }
                            }

                            Divider {

                            }

                        }
                    }
                ]

                onTriggered: {

                    if (indexPath.length > 1) {
                        var chosenItem = dataModel.data(indexPath);
                        var contentpage = itemPageDefinition.createObject();
                        contentpage.itemPageTitle = chosenItem.title
                        nav.push(contentpage);
                    }
                }

            }
            attachedObjects: [
                ComponentDefinition {
                    id: itemPageDefinition
                    source: "ItemPage.qml"
                },
                GroupDataModel {
                    id: dataModel
                },
                DataSource {
                    id: dataSource
                    source: "http://feeds.feedburner.com/blackberry/CAxx?format=xml"
                    remote: true
                    type: DataSourceType.Xml
                    query: "/rss/channel/item"
                    onDataLoaded: {
                        dataModel.clear()
                        dataModel.insertList(data)
                        theList.scrollToPosition(ScrollPosition.Beginning, ScrollAnimation.Smooth);
                    }
                },
                LayoutUpdateHandler {
                    id: listhandler
                    onLayoutFrameChanged: {
                        console.log(layoutFrame.width)
                    }
                }
            ]
            onCreationCompleted: {
                dataSource.load()
            }
        }
    }

    onPopTransitionEnded: {
        page.destroy();
    }
}
