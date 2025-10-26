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

    Connections {
        target: DownloaderInstance
        function onDownloadProgress(message) {
            statusLabel.text = message
            console.log("test1")
        }
        function onMediaListReady(data) {
            media_files = data
            console.log("Final media_files:", media_files.length)
        }
    }

    Page {
        padding: 8
        anchors.fill: parent
        background: Rectangle {
            color: "#111111"
        }

        Rectangle {
            anchors.fill: parent
            color: "#111111"

            ColumnLayout {
                spacing: 4
                anchors {
                    fill: parent
                }

                TextField {
                    id: urlField
                    placeholderText: "https://instagram.com/p/jgUGIj23/"
                    Layout.fillWidth: true
                    padding: 15
                    color: "#7a7a7a"
                    placeholderTextColor: "#7a7a7a"
                    background: Rectangle {
                        color: "#000000"
                        radius: 4
                        border {
                            color: "#232323"
                            width: 1
                        }
                    }
                }
                Button {
                    text: "Download"
                    padding: 15
                    Layout.fillWidth: true
                    contentItem: Text {
                        text: parent.text
                        color: "#e5e5e5"

                        // buat text ditengah
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "#000000"
                        radius: 6
                        border {
                            color: "#4cc9f0"
                        }
                    }
                    onClicked: {
                        // call method from instance backend after register in main.py
                        DownloaderInstance.downloader(urlField.text)
                        DownloaderInstance.list_media()
                    }
                }

                Label {
                    id: statusLabel
                }

                Text {
                    text: "History"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#7a7a7a"
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        width: 8
                        background: Rectangle {
                            color: "transparent"
                        }
                        contentItem: Rectangle {
                            color: "#4cc9f0"
                            radius: 4
                            implicitWidth: 6
                        }
                    }

                    ListView {
                        model: media_files
                        width: parent.width
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: Item {
                            width: parent.width
                            height: 80

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 4
                                color: "#000000"
                                border.color: "#232323"
                                border.width: 2
                                radius: 6

                                Row {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 12

                                    Rectangle {
                                        width: 54
                                        height: 54
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "#f8f9fa"
                                        radius: 4

                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 2
                                            fillMode: Image.PreserveAspectFit
                                            source: media_files[index].url || ""
                                            asynchronous: true

                                            // Fallback for loading errors
                                            onStatusChanged: {
                                                if (status === Image.Error) {
                                                    source = "qrc:/icons/file-icon.png"
                                                }
                                            }
                                        }
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 66
                                        spacing: 2

                                        Text {
                                            text: media_files[index].name || "Unknown"
                                            font.pixelSize: 14
                                            font.bold: true
                                            elide: Text.ElideRight
                                            width: parent.width
                                            color: "#7a7a7a"
                                        }

                                        Text {
                                            text: media_files[index].type
                                                  || "File"
                                            font.pixelSize: 11
                                            color: "#7a7a7a"
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
}
