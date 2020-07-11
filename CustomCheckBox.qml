import QtQuick 2.12
import QtQuick.Controls 2.12

CheckBox {
    id: control
    text: qsTr("CheckBox")
    checked: true

    property var color: 'gray'
    property var textColor: 'gray'

    indicator: Rectangle {

        width: control.width
        height: width

        x: control.leftPadding
        y: parent.height / 2 - height / 2

        radius: width/10

        color: 'Transparent'

        border
        {
            color: control.down ? Qt.lighter(control.color,1.2) : control.color
            width: 1
        }


        Rectangle{
            width: control.checked ? parent.width - 4 : 0
            height: width

            color: control.color

            anchors.centerIn: parent
            radius: parent.radius

            Behavior on width{
                NumberAnimation{
                    duration: 100
                }
            }
        }
    }

    contentItem: Text {
        text: control.text

        font: control.font

        opacity: enabled ? 1.0 : 0.3

        color: control.down ? Qt.lighter(textColor,1.2) : textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}

