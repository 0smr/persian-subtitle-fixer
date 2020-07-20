import QtQuick 2.0

Rectangle {
    id: control

    color: 'transparent'
    property var barColor: 'orange';
    property var explicitBarColor: enabled ?
                               hover ? Qt.lighter(barColor,1.2) : barColor : 'gray'
    property alias press: mouseArea.pressed
    property bool hover: false
    property bool state: false

    signal hovered();
    signal pressed();

    width: 50
    height: width

    Rectangle {
        id: top
        y: control.state ? parent.height/3 : 0.03

        width: parent.width
        height: parent.height * 0.2

        color: parent.explicitBarColor
        radius: height/2

        rotation: control.state ? -45 : 0
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

        opacity: control.state ? 0 : 1

        color: parent.explicitBarColor
        radius: height/2

        Behavior on opacity{
            NumberAnimation{duration: 200}
        }
    }

    Rectangle {
        id: bottom
        y: control.state ? parent.height * 0.33 : parent.height * 0.66

        width: parent.width
        height: parent.height * 0.2

        color: parent.explicitBarColor
        radius: height/2

        rotation: control.state ? 45 : 0

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

        onPressed: {
            control.pressed()
            control.state = !control.state;
        }
    }
}
