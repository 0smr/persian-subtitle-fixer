import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.1

Rectangle {
    id: control
    anchors.fill: parent

    property var themeColor: Qt.hsla(colorSlider.value,1,0.50)

    color: Qt.hsla(colorSlider.value,0,0.95)

    Column {
        id:colViewer

        Rectangle{

            color: 'Transparent'
            width: control.width
            height: 40
            Text {
                id:colorSliderLabel
                padding: 4
                text: qsTr("theme color:")
                color: 'gray'
            }

            CustomSlider {
                id: colorSlider

                anchors.top: colorSliderLabel.bottom
                color: Qt.hsla(value,1,0.50)

                from: 0;
                value: 0.1;
                to: 1;
                stepSize: 0.001;

                width: control.width
                height: 20
            }
        }


        Rectangle{
            id: fileExten

            property real typeExtentionState: 0

            color: 'Transparent'
            width: control.width
            height: 90

            Text {
                id: fileExtenlabel
                padding: 4
                text: qsTr("new file name extentions:")
                color: 'gray'
            }

            ScrollView{
                anchors.top: fileExtenlabel.bottom
                width: control.width
                clip: true
                height: 50

                TextArea {

                    background: Rectangle {
                        color: 'white';
                        anchors.fill: parent
                    }
                    placeholderText: qsTr("extera file name extentions: *.srt *.ass")
                    wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere
                    selectByMouse: true
                    selectionColor: Qt.lighter(control.themeColor,1.6)

                    onTextChanged:{
                        if(text.trim().length === 0)
                            fileExten.typeExtentionState = 0;
                        else if(/((^|\s+)\*\.\w{2}\w\b\s*)+\s*$/.test(text))
                        {
                            fileExten.typeExtentionState = 1
                            text.match(/\*\.\w{2}\w\b/ig)
                        }
                        else
                            fileExten.typeExtentionState = 2
                    }
                    Keys.onReturnPressed: {} //disable <return key> press
                }
            }

            Text {
                text: fileExten.typeExtentionState == 1 ? qsTr("valid") :
                            fileExten.typeExtentionState == 2? qsTr("invalid type extention") : ""
                anchors.bottom: parent.bottom
                padding: 4
                color:  fileExten.typeExtentionState == 1 ? Qt.hsla(0.4,0.7,0.70) : Qt.hsla(1,0.7,0.70)
            }
        }

        Rectangle{

            width: control.width
            height: 90

            color: 'Transparent'

            CustomCheckBox{
                width: 20
                color: Qt.lighter(control.themeColor,1.4)
                text: 'Create Backup'
            }
        }
    }

    Rectangle {
        id: button

        property bool hovered: false
        property alias pressed: saveBtnMouseArea.pressed

        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: 10
        }

        width: 30
        height: width

        radius: height/2

        color: pressed ? Qt.lighter(control.themeColor,.9)
                 : hovered ? Qt.lighter(control.themeColor,1.4)
                           : Qt.lighter(control.themeColor,1.6)

        Text {
            text: qsTr("")
        }

        MouseArea{
            id:saveBtnMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
        }
    }

    Settings{
        id: setting
        category : "general"
        property var colorSliderValue: colorSlider.value;
    }

    Component.onCompleted: {
        colorSlider.value = setting.colorSliderValue
    }
}
