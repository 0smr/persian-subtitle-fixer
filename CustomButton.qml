import QtQuick 2.12

Rectangle{
    id: control

    property alias title: title
    signal pressed()
    signal hovered(bool hover);

    color: "#ffc226"

    clip: true;
    z:2

    Text {
        id: title
        text: "Fix"
        color: "white"
        opacity: .9
        font.pixelSize: 15
        anchors.centerIn: parent
    }

    Rectangle{
        id: clickMotion

        width: parent.width
        height: width

        radius: width/2


        opacity: 0.1 * mouseArea.pressed
        scale: 2 * mouseArea.pressed

        Behavior on scale{
            NumberAnimation{duration: width}
        }

        Behavior on opacity{
            NumberAnimation{duration: 100}
        }

        color: 'gray'
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            clickMotion.x = -width/2 + mouseArea.mouseX
            clickMotion.y = -width/2 + mouseArea.mouseY

            control.pressed()
        }

        onEntered: hovered(true)
        onExited: hovered(false)
    }
}
