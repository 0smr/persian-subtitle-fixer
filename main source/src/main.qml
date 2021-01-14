import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

import io.subtitle.handler 1.0

import "views"
import "controls"

ApplicationWindow {
    id: root
    visible: true

    width: 250
    height: dragDropView.height + headerView.height

    minimumWidth: 225
    minimumHeight: 200

    maximumWidth: 300

    title: qsTr('subtitle fixer');

    SettingsView{
        id:settingView
        visible: false;
    }

    DragAndDropView{
        id:dragDropView

        visible: false;
        subtitleHandler:
            SubtitleHandler{
                parent: dragDropView

            }
        color: settingView.mainColor
        onFilesDroped: {
            headerToggle.state = 'close';
            settingButton.opacity = 0;
            infoButton.opacity = 0;
        }
        onFinished: {
            headerToggle.state = 'menu';
        }
    }

    About{
        id: aboutView
        visible: false;
    }

    Connections {
        target: appInstance
        onMessageReceived: {
            dragDropView.externalFileAdded(message.split("\n"));
        }
    }

    Component.onCompleted: {
        dragDropView.addExternalFileToView(argv)
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
            color: 'White'

            states:
                State {
                    when: headerToggle.state !== 'menu'
                    PropertyChanges {
                        target: headerView
                        color: Qt.lighter(settingView.mainColor,1.9)
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
                            headerToggle.state = 'close';
                            settingButton.appear.start();
                            infoButton.appear.start();
                        }
                        else if (headerToggle.state === 'close')
                        {
                            // for drag and drop view
                            dragDropView.cancelPressed();

                            headerToggle.state = 'menu';
                            settingButton.disappear.start();
                            infoButton.disappear.start();
                        }
                        else
                        {
                            headerToggle.state = 'close';
                            settingButton.appear.start();
                            infoButton.appear.start();
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
                    visible: false

                    onPressed: {
                        if(mainStackView.depth <= 1)
                        {
                            mainStackView.push(settingView)
                            headerToggle.state = 'back';
                            settingButton.disappear.start();
                            infoButton.disappear.start();
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
                    visible: false

                    onPressed: {
                        if(mainStackView.depth <= 1)
                        {
                            mainStackView.push(aboutView);
                            headerToggle.state = 'back';
                            settingButton.disappear.start();
                            infoButton.disappear.start();
                        }
                    }
                }
            }
        }

        StackView{
            id:mainStackView
            Layout.fillWidth: true
            Layout.fillHeight: true

            initialItem: dragDropView
        }
    }
}
