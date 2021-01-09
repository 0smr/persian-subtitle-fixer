import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id:control

    ScrollView {
        anchors.fill: parent
        ColumnLayout {

            width: parent.width
            spacing: 10

            Rectangle{
                Layout.fillWidth: true
                height: applicationIcon.height + 8

                RowLayout {
                    anchors{
                        fill: parent
                        leftMargin: 5
                    }

                    spacing: 10

                    Rectangle {
                        id: applicationIcon
                        width: 20
                        height: width * 1.33
                        Image{
                            anchors.fill: parent
                            source: 'qrc:/res/resources/SVG/icon_light_shadow.png'
                        }
                    }

                    Text {
                        id: description

                        Layout.alignment: Qt.AlignBottom
                        text: qsTr("Subtitle Fixer");
                        font.pixelSize: 15
                    }

                    Text{
                        Layout.alignment: Qt.AlignBottom
                        Layout.bottomMargin: -3
                        Layout.leftMargin: -10
                        font.pixelSize: 8
                        text: qsTr("(64-bit)");

                    }

                    Rectangle{
                        Layout.fillWidth: true
                    }

                    Text {
                        Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                        Layout.rightMargin: 5
                        opacity: 0.8
                        text: qsTr(
                                  "<a href='https://qt.io'>built with Qt</a><br>"+
                                  "<a href='https://github.com/SMR76/persian-subtitle-fixer/blob/master/LICENSE'>Licenses</a>"
                                  );
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                height: 1
                color:'#eee'
            }

            Text {
                //id:
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 10
                text: qsTr("description: (see page below)<br>" +
                           "github page: <a href='https://github.com/SMR76/persian-subtitle-fixer'>" +
                           "SMR76/persian-subtitle-fixer</a><br>" +
                           "version: 0.5 (2020.7.29)<br>" +
                           "Copyright © 2020 smr76.github.io")
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
