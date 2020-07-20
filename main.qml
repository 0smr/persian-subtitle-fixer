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
        visible: false;
    }

    DragAndDropView{
        id:dragDropView

        encodeHandler:
            EncodeHandler{}
    }




    ColumnLayout{

        visible: true;

        anchors.fill: parent
        spacing: 0;

        Rectangle{
            id: headerView

            Layout.fillWidth: true
            height: 30
            color: headerToggle.state ? '#f5f5f5' : 'Transparent'

            Behavior on color {
                ColorAnimation {
                    duration: 2000
                }}

            RowLayout{
                y: 3
                x: 1
                spacing: 0;

                HambergerToggle{
                    id: headerToggle
                    width: headerView.height - 3
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
                initialItem: dragDropView
            }
        }
    }
}
