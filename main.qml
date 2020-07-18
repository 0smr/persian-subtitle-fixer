import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

import io.encode.handler 1.0

ApplicationWindow {
    id: root
    visible: true

//    width: 225
//    height: 75
    width: 400
    height: 250

    minimumWidth: 225
    minimumHeight: 75

    title: qsTr("subtitle fixer");

    SettingsView{
        id:settingView
    }

    DragAndDropView{
        id:dragDropView

        encodeHandler:
            EncodeHandler{}
    }


    ColumnLayout{

        anchors.fill: parent
        spacing: 0;

        Rectangle{
            id: headerView

            Layout.fillWidth: true
            height: 30

            RowLayout{
                spacing: 0;
                Button {
                    id: backButton


                    background:
                        Rectangle {
                        color: 'gray';
                        height: headerView.height
                        width: 40
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked:{}
                    }
                }
            }
        }

        Rectangle{
            id: bodyView

            Layout.fillWidth: true
            Layout.fillHeight: true

            StackView{
                id:mainStackView

                anchors.fill: parent
                initialItem: settingView
            }
        }
    }
}
