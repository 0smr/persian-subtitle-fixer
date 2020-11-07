import QtQuick 2.12

Rectangle{
    id: control

    property alias title: title
    property bool clickEffect: true
    signal pressed()
    signal hovered();

    color: 'orange'

    clip: true;

    Text {
        id: title
        text: '.'
        color: 'white'
        opacity: .9
        font.pixelSize: 15
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -font.pixelSize/ 20
    }

    Rectangle{
        id: clickMotion

        width: parent.width
        height: width

        radius: width/2

        visible: control.clickEffect

        opacity: 0.1 * mouseArea.pressed
        scale: 2 * mouseArea.pressed

        Behavior on scale{
            NumberAnimation{duration: 4 * width}
        }

        Behavior on opacity{
            NumberAnimation{duration: 100}
        }

        color: 'gray'
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            clickMotion.x = -width/2 + mouseArea.mouseX
            clickMotion.y = -width/2 + mouseArea.mouseY

            control.pressed()
        }

        onEntered: control.hovered()
    }
}
