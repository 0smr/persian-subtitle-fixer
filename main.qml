import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

import io.encode.handler 1.0

ApplicationWindow {
    id:root
    visible: true

    width: 225
    height: 75

    minimumWidth: 225
    minimumHeight: 75

    title: qsTr("subtitle fixer");

    EncodeHandler{
        id:encodeHandler
    }


    Text {
        id: caption

        anchors.centerIn: parent
        color: 'gray'
        text: qsTr("Drag and Drop Here.");
    }

    ListModel {
        id: urlListModel
    }

    ColumnLayout{
        id: colLayout

        anchors.fill: parent
        visible:false

        CustomButton{
            id:btn

            property real state: 1
            Layout.fillWidth: true
            height: 40

            onPressed: {
                if(state === 1)
                {
                    var selectedUrls = [];

                    for(var i = 0 ; i < urlListModel.count ; ++i)
                    {
                        if(urlListModel.get(i).val === true)
                            selectedUrls.push(urlListModel.get(i).subUrl);
                        else
                            selectedUrls.push("");
                    }

                    var states = encodeHandler.fixSubtitles(selectedUrls);

                    for(var j = 0 ; j < urlListModel.count ; ++j)
                    {
                        urlListModel.get(j).cMode = states[j] === true ? 1 : 2;
                    }

                    state = 2
                    title.text = '⭯'
                    title.font.pixelSize = 20

                    anim.from= 0
                    anim.to= 720
                    anim.restart();
                }
                else if(state === 2)
                {
                    btn.state = 1
                    anim.from= 720
                    anim.to= 0
                    anim.duration = 1000
                    anim.restart();
                    opacityAnim.restart()
                    urlListModel.clear();
                }
            }

            NumberAnimation
            {
                id: opacityAnim
                targets: [btn,checkall]
                property: "opacity"
                duration: anim.duration
                from:1
                to:0
                onFinished:{
                    btn.opacity = 1
                    checkall.opacity = 1
                }
            }

            NumberAnimation{
                id: anim
                target: btn.title
                property: "rotation"
                easing.type: Easing.OutQuint
                duration: 4500

                onFinished: {
                    if(btn.state === 1)
                    {
                        root.height = root.minimumHeight
                        colLayout.visible = false;
                        droparea.visible = true
                        droparea.focus = true
                        caption.visible = true;

                        btn.state = 1
                        btn.title.text = "Fix"
                        btn.title.font.pixelSize = 15;
                    }
                }
            }
        }

        CustomCheckDelegate {
            id:checkall

            text: "Check All"
            checked: true

            Layout.fillWidth: true
            indecatorSize: 15
            z:2

            property int allChildren

            onPressed: {
                var check = !checked
                for(var i = 0 ; i < urlListModel.count; ++i)
                {
                    urlListModel.get(i).val = check;
                }
                checked = !checked
            }

            background: Rectangle{
                width: checkall.width
                height: checkall.height
            }
        }

        ListView {
            id: urlListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: urlListModel
            delegate: CustomCheckDelegate
            {
                id:checkDelegate

                text: subUrl
                checkState: val ? Qt.Checked : Qt.Unchecked
                onCheckStateChanged:{
                    val = checked
                    checkall.allChildren += checked == true ? 1 : -1
                    if(checkall.allChildren === urlListModel.count)
                        checkall.checked = true
                    else
                        checkall.checked = false
                }

                width: root.width
                colorMode: cMode

                ToolTip{
                    parent: checkDelegate.indicator
                    visible: hovered
                    delay: 2000
                    timeout: 4000
                    contentItem: TextArea{
                        text: subUrl
                        font.pixelSize: 9
                    }
                    opacity: .8
                    background: Rectangle{
                        color: "#ffbb00"
                        opacity: .5
                        radius: 5
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            }
        }
    }

    DropArea{
        id:droparea
        anchors.fill: parent
        focus: true

        onDropped: {
            if(drop.hasUrls)
            {
                var subtitles = encodeHandler.extractSubtitles(drop.urls);

                if(subtitles.length > 1 || urlListModel.count > 1)
                {
                    for(var i in subtitles)
                    {
                        urlListModel.append({"subUrl":subtitles[i],"val":true,"cMode":0})
                    }

                    checkall.allChildren = subtitles.length;

                    caption.visible = false;
                    colLayout.visible = true
                    root.height = 300
                    visible = false
                }
                else if(subtitles.length === 1)
                {
                    encodeHandler.fixSingleSubtitle(subtitles[0])
                }
            }
        }
    }
}
