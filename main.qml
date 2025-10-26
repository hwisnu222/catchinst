import QtQuick
import QtQuick.Window
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Instagram Downloader")

    property var media_files: []

    Component.onCompleted: {
        DownloaderInstance.list_media()
    }

    Connections{
        target: DownloaderInstance
        function onDownloadProgress(message){
            statusLabel.text = message
            console.log("test1")
        }
        function onMediaListReady(data){
                console.log("QML: Received media list with", data.length, "items")

                var temp = []
                for (var i = 0; i < data.length; i++) {
                    var item = data[i]
                    console.log("Item:", JSON.stringify(item))
                    temp.push({
                        name: item.name,
                        url: item.url,
                        type: item.type
                    })
                }

                media_files = temp
                console.log("Final media_files:", media_files.length)
            }
    }

    Page{
        padding: 8
        anchors.fill: parent

        Rectangle{
            anchors.fill: parent




            ColumnLayout{
                spacing: 4
                anchors{
                    left: parent.left
                    right: parent.right
                }
                height: 400


                TextField{
                    id: urlField
                    placeholderText: "Instagram Url"
                    Layout.fillWidth: true
                    padding: 10
                    color: "#000000"
                    placeholderTextColor: "#000000"
                    background: Rectangle{
                        color: "#f2f2f2"
                        radius: 4
                        border{
                            color: "#14213d"
                            width: 1
                        }
                    }

                }
                Button{
                    text: "Download"
                    padding: 10
                    Layout.fillWidth: true
                    contentItem: Text{
                        text: parent.text
                        color: "#e5e5e5"

                        // buat text ditengah
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle{
                        color: "#14213d"
                    }
                    onClicked: {
                        // call method from instance backend after register in main.py
                        DownloaderInstance.downloader(urlField.text)
                        DownloaderInstance.list_media()
                    }
                }

                Label{
                    id: statusLabel
                }

                Text{
                    text: "History"
                    font: {
                        bold: true
                        pixelSize: 230
                    }

                }

                ScrollView{
                    anchors.fill: parent

                    ListView {
                        model: media_files
                        height: 300
                        width: parent.width

                        delegate: Item {
                            width: parent.width
                            height: 80


                            Rectangle{

                                ColumnLayout{
                                    spacing: 4
                                    Image {
                                        width: 70
                                        height: 70

                                        // anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        // fillMode: Image.PreserveAspectFit
                                        source: media_files[index].url

                                    }
                                    Text{
                                        text: media_files[index].name
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
    }
}
