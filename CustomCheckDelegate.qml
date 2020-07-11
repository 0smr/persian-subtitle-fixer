import QtQuick 2.12
import QtQuick.Controls 2.12

CheckDelegate {
    id: control
    text: qsTr("text")
    checked: true

    property real indecatorSize: 15
    property var themeColor: "#ffc226"
    property real colorMode: 0

    clip: true;

    contentItem: Text {
        leftPadding: control.indicator.width + control.spacing

        text: control.text
        font: control.font

        opacity: enabled ? 1.0 : 0.3
        color: colorMode == 0 ? (control.down ? "#757575" : "#595959") : "white"
        elide: Text.ElideLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        id: indecatorRect

        implicitWidth: control.indecatorSize
        implicitHeight: implicitWidth
        x: control.rightPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        radius: 3
        color: "transparent"
        border.color: colorMode == 0 ? (control.down ? "#ffc226" : "#ffb700") : "white"

        Rectangle {
            width: parent.width*.80
            height: width
            x: width/8
            y: x
            radius: 2
            color: colorMode == 0 ? (control.down ? "#ffc226" : "#ffcc00") : "white"

            scale: control.checked * 1

            Behavior on scale{
                NumberAnimation{duration: 150}
            }
        }
    }


    background: Rectangle{
        id:backG

        width: control.width
        height: control.height

        color: colorMode == 0 ? "gray" : (colorMode == 1? "green" : "red")
        opacity: colorMode == 0 ? .1 * control.down: 0.3

        Behavior on opacity{
            NumberAnimation{duration: 150}
        }

        NumberAnimation on width{
            running: colorMode == 1 || colorMode == 2
            from:50
            to:control.width
            duration: control.width*2

        }
    }
}
