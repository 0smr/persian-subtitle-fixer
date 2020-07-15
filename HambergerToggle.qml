import QtQuick 2.0

Rectangle {
    id: control

    color: 'transparent'
    property var barColor: enabled ? 'black' : 'gray'
    property alias press: mouseArea.pressed
    property bool hover: false
    property real state: press ? 1 : 2
    signal hovered();
    signal pressed();

    onPressed: press

    width: 50
    height: 50

    Rectangle {
        id: top
        y: control.state == 2 ? parent.height/3 : 0.03

        width: parent.width
        height: parent.height * 0.2

        color: parent.barColor
        radius: height/2

        rotation: control.state == 2 ? 45 : 0
        Behavior on rotation{
            NumberAnimation{duration: 200}
        }
        Behavior on y{
            NumberAnimation{duration: 200}
        }
    }

    Rectangle {
        id: midlle
        y: parent.height * 0.33

        width: parent.width
        height: parent.height * 0.2

        opacity: control.state == 2 ? 0 : 1

        color: parent.barColor
        radius: height/2

        Behavior on opacity{
            NumberAnimation{duration: 200}
        }
    }

    Rectangle {
        id: bottom
        y: control.state == 2 ? parent.height * 0.33 : parent.height * 0.66

        width: parent.width
        height: parent.height * 0.2

        color: parent.barColor
        radius: height/2

        rotation: control.state == 2 ?-45 : 0

        Behavior on rotation{
            NumberAnimation{duration: 200}
        }
        Behavior on y{
            NumberAnimation{duration: 200}
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            hover = true;
            control.hovered()
        }
        onExited: hover = false
        onPressed: control.pressed()
    }
}
