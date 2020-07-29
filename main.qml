import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

import io.encode.handler 1.0

ApplicationWindow {
    id: root
    visible: true

    width: 250
    height: 125

    minimumWidth: 225
    minimumHeight: 100

    maximumWidth: 300

    title: qsTr("subtitle fixer");

    SettingsView{
        id:settingView
        visible: false;
    }

    DragAndDropView{
        id:dragDropView

        visible: false;
        encodeHandler:
            EncodeHandler{}
    }
    About{
        id: aboutView
    }

    ColumnLayout{
        visible: true;

        anchors.fill: parent
        spacing: 0;

        Rectangle{
            id: headerView

            Layout.fillWidth: true
            height: 25

            z: 99

            states:
                State {
                    when: headerToggle.state !== 'menu'
                    PropertyChanges {
                        target: headerView
                        color:'#f5f5f5'
                    }
                }

            transitions: Transition {
                ColorAnimation {duration: 300 }
            }

            RowLayout {
                width: parent.width
                y: 3
                spacing: 3

                HambergerToggle{
                    id: headerToggle
                    width: headerView.height - 3
                    Layout.leftMargin: 3
                    barColor: Qt.lighter(settingView.mainColor,1.3)

                    onPressed: {
                        if(headerToggle.state === 'back')
                        {
                            mainStackView.pop();
                            headerToggle.state = 'close'
                            settingButton.opacity = 1
                            infoButton.opacity = 1
                        }
                        else if (headerToggle.state === 'close')
                        {
                            headerToggle.state = 'menu'
                            settingButton.opacity = 0
                            infoButton.opacity = 0
                        }
                        else
                        {
                            headerToggle.state = 'close'
                            settingButton.opacity = 1
                            infoButton.opacity = 1
                        }
                    }
                }

                Rectangle{
                    id: spacer
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: 'Transparent'
                }

                ImageButton {
                    id: infoButton
                    source: 'qrc:/res/resources/buttonIcons/settings_3.png'

                    width: headerView.height - 6
                    height: width

                    mainColor:settingView.mainColor

                    Layout.rightMargin: 3
                    Layout.alignment: Qt.AlignTop

                    opacity: 0

                    onPressed: {
                        if(mainStackView.depth <= 1)
                        {
                            mainStackView.push(settingView)
                            headerToggle.state = 'back'
                            settingButton.opacity = 0
                            infoButton.opacity = 0
                        }
                    }
                }

                ImageButton {
                    id: settingButton
                    source: 'qrc:/res/resources/buttonIcons/info.png'

                    width: headerView.height - 6
                    height: width
                    mainColor:settingView.mainColor

                    Layout.rightMargin: 3
                    Layout.alignment: Qt.AlignTop

                    opacity: 0

                    onPressed: {
                        if(mainStackView.depth <= 1)
                        {
                            mainStackView.push(aboutView)
                            headerToggle.state = 'back'
                            settingButton.opacity = 0
                            infoButton.opacity = 0
                        }
                    }
                }
            }
        }

        Rectangle {
            id: bodyView

            Layout.fillWidth: true
            Layout.fillHeight: true

            StackView{
                id:mainStackView

                anchors.fill: parent
                initialItem: dragDropView
            }
        }
    }
}
