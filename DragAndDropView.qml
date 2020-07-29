import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

Rectangle {
    id:control

    property var encodeHandler: null
    property var mainColor: 'orange'

    /*
        list model containing droped files.
    */
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

            color: Qt.lighter(control.mainColor,1.5);

            title.text: 'Fix'
            title.font.pixelSize: 15
            title.font.family: 'Font Awesome 5 Pro Solid'
            z: 2

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
                        urlListModel.get(j).cMode = states[j];
                        urlListModel.get(j).enable = false;
                    }
                    checkall.enabled = false;

                    state = 2
                    title.text = '\uf0e2'

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
                    checkall.enabled = true;
                }
            }

            NumberAnimation {
                id: opacityAnim

                targets: [btn,checkall]
                property: 'opacity'
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
                property: 'rotation'
                easing.type: Easing.OutQuint
                duration: 4500

                onFinished: {
                    if(btn.state === 1)
                    {
                        colLayout.visible = false;
                        droparea.visible = true
                        droparea.focus = true
                        caption.opacity = 1;

                        btn.state = 1
                        btn.title.text = 'Fix'
                    }
                }
            }
        }

        // single CustomCheckDelegate for checkall CheckBox.
        CustomCheckDelegate {
            id:checkall

            text: "Check All"
            checked: true

            Layout.fillWidth: true
            indecatorSize: 15

            mainColor: Qt.lighter(control.mainColor,1.3)
            // z order 2 for being in top of urlListView
            z:2

            /*
                all children count.
                it will initialized in drag and drom function when multi files droped.
            */
            property int allChildren: 0

            // on pressed check all CheckBox in urlListView
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

        //a list view to show multi selected subtitles.
        ListView {
            id: urlListView

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: urlListModel
            delegate: CustomCheckDelegate
            {
                id:checkDelegate

                text: subUrl
                //set value to check delegate
                checkState: val ? Qt.Checked : Qt.Unchecked

                //chek or uncheck checkall CheckBox
                onCheckStateChanged:{
                    val = checked
                    checkall.allChildren += checked == true ? 1 : -1
                    if(checkall.allChildren === urlListModel.count)
                        checkall.checked = true
                    else
                        checkall.checked = false
                }

                mainColor: Qt.lighter(control.mainColor,1.3)
                width: control.width
                // indicades color animation to be shown.
                colorMode: cMode
                enabled: enable

                // tooltip to show full file path.
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
                        color: Qt.lighter(control.mainColor,1.5)
                        opacity: .5
                        radius: 5
                    }
                }
            }
            //a scroll bar to scroll through items
            ScrollBar.vertical: ScrollBar {}
            add: Transition {
                NumberAnimation { property: 'opacity'; from: 0; to: 1.0; duration: 400 }
            }
        }
    }

    Text {
        id: caption

        anchors.centerIn: control
        color: 'gray'
        text: qsTr("Drag and Drop Here.");
    }

    DropArea{
        id:droparea
        anchors.fill: parent
        focus: true

        onDropped: {
            if(drop.hasUrls)
            {
                // extract .srt and .ass files and return thier urles
                var subtitles = encodeHandler.extractSubtitles(drop.urls);

                if(subtitles.length > 1)
                {
                    checkall.checked = true;
                    for(var i in subtitles)
                    {
                        urlListModel.append({"subUrl":subtitles[i],"val":true,"cMode":0,"enable":true})
                    }

                    checkall.allChildren = subtitles.length;

                    caption.opacity = 0;
                    colLayout.visible = true
                    control.height = 250
                }
                else if(subtitles.length === 1)
                {
                    encodeHandler.fixSubtitles([subtitles[0]])
                }
            }
        }
    }
}
