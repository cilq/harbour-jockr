import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.jockr 1.0

XmlListModel {
    property string api: "flickr.favorites.remove"
    property string params: "photo_id:"
    property string strStatus

    //query: "/rsp/photos/photo"
}
