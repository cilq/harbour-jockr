import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import Sailfish.TransferEngine 1.0

ShareDialog {
    id: root
    allowedOrientations: Orientation.Portrait
    property string titleMedia

    width: Screen.width
    height: Screen.height

    Component.onCompleted: {
        var pathArr = path.split("/")
        var filename = pathArr[pathArr.length - 1]
        titleMedia = filename.substr(0, filename.lastIndexOf("."))
    }

    property string path: source

    property int viewWidth: root.isPortrait ? Screen.width : Screen.width / 2
    property string uploadUrl: "https://up.flickr.com/services/upload/"

    onAccepted: {
        shareItem.userData = {"title": mediaTitle.text,
            "description": mediaDesc.text + "," + //"description"
            mediaTags.text + "," + //"tags"
            (mediaType.currentIndex + 1) + "," + //"mediaType"
            (mediaPrivacy.currentIndex == 1 || mediaPrivacy.currentIndex == 3 ? 1 : 0) + "," + //"is_friend"
            (mediaPrivacy.currentIndex == 2 || mediaPrivacy.currentIndex == 3 ? 1 : 0) + "," + //"is_family"
            (mediaPrivacy.currentIndex == 4 ? 1 : 0) + "," + //"is_public"
            (mediaSafety.currentIndex + 1) + "," + //"safety_level"
            (mediaPublicReserch.text == "yes" ?  1 : 2) + "," + //"hidden"
            xmlListModel.get(albumList.currentIndex - 1).pId}
        console.debug("shareItem.userData = " + shareItem.userData);
        shareItem.start()
    }

    SailfishShare {
        id: shareItem
        source: root.source
        metadataStripped: true
        serviceId: root.methodId
    }

    DialogHeader {
        id: dialogHeader
        acceptText: qsTrId("Jockr Share")
    }

    SilicaFlickable {
        anchors {
            top: dialogHeader.bottom
            topMargin: Theme.paddingLarge
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge

            TextField {
                id: mediaTitle
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                text: titleMedia
                label: "Title"
            }

            TextField {
                id: mediaDesc
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                placeholderText: qsTr("Description")
                text: ""
                label: qsTr("Description")
            }

            TextField {
                id: mediaTags
                width: parent.width
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                placeholderText: qsTr("Tags")
                text: ""
                label: qsTr("Tags")
            }

            XmlListModel {
                id: xmlListModel
                property string strStatus
                source: "file:///home/nemo/.config/marco73f/harbour-jockr-album-model.xml"
                query: "/rsp/photosets/photoset"
                XmlRole { name: "pId"; query: "@id/string()" }
                XmlRole { name: "primary"; query: "@primary/string()" }
                XmlRole { name: "secret"; query: "@secret/string()" }
                XmlRole { name: "server"; query: "@server/string()" }
                XmlRole { name: "farm"; query: "@farm/string()" }
                XmlRole { name: "photos"; query: "@photos/string()" }
                XmlRole { name: "videos"; query: "@videos/string()" }
                XmlRole { name: "needs_interstitial"; query: "@needs_interstitial/string()" }
                XmlRole { name: "visibility_can_see_set"; query: "@visibility_can_see_set/string()" }
                XmlRole { name: "count_comments"; query: "@count_comments/string()" }
                XmlRole { name: "can_comment"; query: "@can_comment/string()" }
                XmlRole { name: "count_views"; query: "@count_views/string()" }
                XmlRole { name: "date_create"; query: "@date_create/string()" }
                XmlRole { name: "date_update"; query: "@date_update/string()" }
                XmlRole { name: "title"; query: "title/string()" }
                XmlRole { name: "description"; query: "description/string()" }

                onStatusChanged: {
                    if (status === XmlListModel.Ready) { strStatus = count + " Items loaded"; console.log(strStatus) }
                    if (status === XmlListModel.Loading) { strStatus = "Loading"; console.log(strStatus)  }
                    if (status === XmlListModel.Error) { loading = false; strStatus = "Error:\n" + errorString; console.log(strStatus)  }
                    if (status === XmlListModel.Null) { strStatus = "Loading"; console.log(strStatus)  }
                }
            }

            ComboBox {
                id: albumList
                width: parent.width
                label: qsTr("Add to album: ")
                menu: ContextMenu {
                    MenuItem { text: "no" }
                    Repeater {
                        model: xmlListModel
                        MenuItem { text: model.title }
                    }
                }
//                onCurrentIndexChanged: {
//                    console.log("https://farm" + xmlListModel.get(albumList.currentIndex).farm + ".staticflickr.com/" + xmlListModel.get(albumList.currentIndex).server + "/" + xmlListModel.get(albumList.currentIndex).pId + "_" + xmlListModel.get(albumList.currentIndex).secret + "_m.jpg")
//                }
            }

//            Image {
//                id: photo
//                visible: albumList.currentIndex > 0
//                anchors { horizontalCenter: parent.horizontalCenter }
//                source: "https://farm" + xmlListModel.get(albumList.currentIndex).farm + ".staticflickr.com/" + xmlListModel.get(albumList.currentIndex).server + "/" + xmlListModel.get(albumList.currentIndex).pId + "_" + xmlListModel.get(albumList.currentIndex).secret + "_m.jpg"
//            }

            ComboBox {
                id: mediaType
                width: parent.width
                label: qsTr("Content Type: ")

                menu: ContextMenu {
                    MenuItem { text: "photo" }
                    MenuItem { text: "screenshot" }
                    MenuItem { text: "video" }
                }
            }

            ComboBox {
                id: mediaPrivacy
                width: parent.width
                label: qsTr("Privacy: ")

                menu: ContextMenu {
                    MenuItem { text: "private - only visible to me" }
                    MenuItem { text: "private - visible by friends" }
                    MenuItem { text: "private - visible by family" }
                    MenuItem { text: "private - visible by friends and family" }
                    MenuItem { text: "public  - visible from all" }
                }
            }

            TextSwitch {
                id: mediaPublicReserch
                text: "no"
                description: qsTr("will be visible in public research")
                onCheckedChanged: {
                    text = checked ? qsTr("yes") : qsTr("no")
                }
            }

            ComboBox {
                id: mediaSafety
                width: parent.width
                label: "Safety level: "

                menu: ContextMenu {
                    MenuItem { text: "safe" }
                    MenuItem { text: "moderate" }
                    MenuItem { text: "limited" }
                }
            }
        }
    }
}
