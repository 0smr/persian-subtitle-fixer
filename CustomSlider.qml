import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Slider {
    id:control

    property var color: 'blue'
    property var colorTheme: control.enabled ? color : 'black'
    property bool showValue: false

    background: Rectangle {

        x: control.leftPadding ;
        y: control.topPadding + (control.availableHeight / 2 - height / 2)

        width: control.availableWidth
        height: 1

        color: control.pressed ? Qt.lighter(colorTheme,1.3) : Qt.lighter(colorTheme,1.6)
    }

    handle: Rectangle {
        id: sliderHandle
        x: control.leftPadding  + control.visualPosition * (control.availableWidth- width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        height: width
        width: control.height

        radius: width/2

        border{

            width: control.pressed ? width/2 : 1
            color: control.pressed ? Qt.lighter(colorTheme,1.2)
                                                  : Qt.lighter(colorTheme,1.5)
            Behavior on width{
               NumberAnimation {
                   duration: 100;
               }
           }
        }

        ToolTip{


            parent: sliderHandle
            visible: hovered
            delay: 500
            timeout: 0

            contentItem: Text{
                topPadding: -8;
                bottomPadding: -8;
                text: value.toPrecision(2)
                font.pixelSize: 7
            }

            opacity: .8

            background: Rectangle{
                color: "Transparent"
                radius: width/2
            }
        }
    }
}
