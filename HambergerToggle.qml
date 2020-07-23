import QtQuick 2.0

Rectangle {
    id: control

    property real barHeight: control.height * 0.15
    property var barColor: 'orange';
    property var explicitBarColor: enabled ?
                               hover ? Qt.lighter(barColor,1.2) : barColor : 'gray'



    property alias press: mouseArea.pressed
    property bool hover: false

    signal hovered();
    signal pressed();

    width: 50
    height: width

    color: 'transparent'
    state: 'menu'

    states: [
        State {
            name: 'menu'
            PropertyChanges {
                target: top
                y: 0
                rotation: 0
            }
            PropertyChanges {
                target: bottom
                y: control.height * 0.66
                rotation: 0
            }
        },
        State {
            name: 'close'
            PropertyChanges {
                target: top
                y: control.height * 0.33
                rotation: -45
            }
            PropertyChanges {
                target: middle
                x: control.height * 0.3
                width: 0
            }
            PropertyChanges {
                target: bottom
                y: control.height * 0.33
                rotation: 45
            }
        },
        State {
            name: 'back'
            PropertyChanges {
                target: top
                y: control.height * 0.15
                width: control.width * 0.7
                rotation: -35
            }
            PropertyChanges {
                target: middle
                x: control.height * 0.13
            }
            PropertyChanges {
                target: bottom
                y: control.height * 0.52
                width: control.width * 0.7
                rotation: 35
            }
        }
    ]

    transitions: Transition {
            NumberAnimation {
                properties: 'x,y,rotation,width';
            }
        }

    Rectangle {
        id: top
        y: 0.03

        width: control.width
        height: control.barHeight

        color: parent.explicitBarColor
        radius: height/2
    }

    Rectangle {
        id: middle
        y: control.height * 0.33

        width: control.width
        height: control.barHeight
        opacity: 1

        color: parent.explicitBarColor
        radius: height/2
    }

    Rectangle {
        id: bottom
        y: control.height * 0.66

        width: control.width
        height: control.barHeight

        color: control.explicitBarColor
        radius: height/2
    }

    MouseArea {
        id: mouseArea
        anchors.fill: control
        hoverEnabled: true
        onEntered: {
            hover = true;
            control.hovered()
        }
        onExited: hover = false
        onPressed: control.pressed()
    }
}
