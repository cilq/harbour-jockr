import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Jockr 1.0

XmlListModel {
    property string api: "flickr.contacts.getList"
    property string strStatus

    query: "/rsp/contacts/contact"

    XmlRole { name: "nsid"; query: "@nsid/string()" }
    XmlRole { name: "username"; query: "@username/string()" }
    XmlRole { name: "iconserver"; query: "@iconserver/string()" }
    XmlRole { name: "iconfarm"; query: "@iconfarm/string()" }
    XmlRole { name: "realname"; query: "@realname/string()" }
}