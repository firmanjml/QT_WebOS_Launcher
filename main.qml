import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    id: root
    visible: true
    width: 1000
    height: 500

    ListModel {
        id: appModel

        ListElement {
            title: "Netflix"
            colour: "#E50914"
        }
        ListElement {
            title: "Facebook"
            colour: "#4267B2"
        }
        ListElement {
            title: "Twitter"
            colour: "#1DA1F2"
        }
        ListElement {
            title: "Youtube"
            colour: "#FF0000"
        }
        ListElement {
            title: "Hulu"
            colour: "green"
        }
        ListElement {
            title: "nocolor"
            colour: ""
        }
        ListElement {
            title: "longtexttesting"
            colour: "green"
        }
        ListElement {
            title: "Web Browser"
            colour: "#4267B2"
        }
        ListElement {
            title: "IOTActivity"
            colour: "#FF0000"
        }
    }

    RoundButton {
        id: firstBtn
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.topMargin: 10
        text: "\u2713"
    }

    Text {
        id: timeTxt
        anchors.top: firstBtn.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        text: "10:44am"
        font.pointSize: 25
    }


    Rectangle {
        id: background
        anchors.bottom: parent.bottom
        //anchors.bottomMargin: -200 //animation from bottom
        width: parent.width
        height: 220

        FocusScope {
            focus: true
            anchors.fill: parent
            anchors.bottom: parent.bottom
            visible: true

            Rectangle {
                height: 200
                anchors.bottom: parent.bottom
                width: parent.width
                color: "#383838"
            }
            
            ListView {
                id: listArea
                orientation: ListView.Horizontal
                anchors.fill: parent
                model: appModel
                focus: true

                delegate: Rectangle {
                    id: appContainer
                    width: 120
                    height: 200
                    anchors.bottom: parent.bottom
                    color: (colour != "" ? colour : '#2d142c')

                    clip: true

                    Image {
                        source: photo
                        height: 50
                        width: 50
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: appTitle
                        text: title
                        color: "#fff"
                        font.pointSize: 13
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: false
                        //font.capitalization: Font.AllUppercase
                        //font.family: "Arial"
                        //font.italic: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            listArea.currentIndex = index;
                            listArea.currentItem.focus = true;
                            animateUp.start()
                            animateDown.stop()

                        }
                        onExited: {
                            animateUp.stop()
                            animateDown.start()
                        }
                    }

                    PropertyAnimation {
                        id: animateUp
                        target: appContainer
                        properties: "anchors.bottomMargin"
                        to: 20
                        duration: 150
                        loops: Animation.Infinite
                        easing {
                            type: Easing.OutElastic
                        }
                    }

                    PropertyAnimation {
                        id: animateDown
                        target: appContainer
                        properties: "anchors.bottomMargin";
                        to: 0
                        duration: 150
                        easing {
                            type: Easing.InOutBounce
                        }
                    }
                }
            }
        }
    }
}
