import QtQuick 2.0
import QtQuick.Layouts 1.11

Item {
    id:control

    ColumnLayout{
        Text {
            id: description

            color: 'gray'
            text: qsTr(
                      "Subtitle Fixer <font>(64-bit)</font><br>"+
                      "Version: 2.4"
                       );
        }
        Text {
            //id:
            color: 'gray'
            text: qsTr("github page")
        }
    }

}
