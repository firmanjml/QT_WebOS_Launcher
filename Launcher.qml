// Copyright (c) 2017-2018 LG Electronics, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.4
import Eos.Window 0.1
import Eos.Controls 0.1
import WebOS.Global 1.0
import WebOSServices 1.0
import WebOSCompositorBase 1.0

import "qrc:/WebOSCompositor"
import "file:///usr/lib/qml/WebOSCompositor"

FocusableView {
    id: root
    layerNumber: 4

    onOpening: root.requestFocus();
    onClosed: root.releaseFocus();

    LaunchPointsModel {
        id: launchPointsModel
        appId: LS.appId
    }

    function launch(id, params) {
        Utils.performanceLog.time("APP_LAUNCH", {"APP_ID": id});
        LS.adhoc.call("luna://com.webos.applicationManager", "/launch",
                      "{\"id\":\"" + id + "\", \"params\":" + JSON.stringify(params) + "}");
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        enabled: root.isOpen
        visible: enabled
        hoverEnabled: enabled
        onClicked: {
            if (mouse.button == Qt.LeftButton)
                root.closeView();
        }
    }

    Button {
        id: settingsButton
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Settings.local.launcher.defaultMargin
        anchors.rightMargin: Settings.local.launcher.defaultMargin
        iconSource: Settings.local.imageResources.settings
        KeyNavigation.left: powerButton
        KeyNavigation.down: listArea.currentItem
        implicitWidth: Settings.local.launcher.settingsIconSize
        implicitHeight: Settings.local.launcher.settingsIconSize
        onClicked: {
            launch("com.palm.app.settings", {});
            root.closeView();
        }
    }

    Text {
        anchors.right: parent.right
        anchors.topMargin: Settings.local.launcher.defaultMargin
        anchors.rightMargin: Settings.local.launcher.defaultMargin
        anchors.top: settingsButton.bottom
        color: "#fff"
        font.pointSize: 30
        text: "2:34pm"
    }

    Button {
        id: powerButton
        anchors.top: parent.top
        anchors.right: settingsButton.left
        anchors.topMargin: Settings.local.launcher.defaultMargin
        anchors.rightMargin: Settings.local.launcher.defaultMargin
        KeyNavigation.left: rebootButton
        KeyNavigation.right: settingsButton
        KeyNavigation.down: listArea.currentItem
        iconSource: Settings.local.imageResources.power
        implicitWidth: Settings.local.launcher.powerIconSize
        implicitHeight: Settings.local.launcher.powerIconSize
        onClicked: {
            LS.adhoc.call("luna://com.webos.service.power", "/shutdown/machineOff", "{\"reason\":\"power off\"}");
        }
    }

    Button {
        id: rebootButton
        anchors.top: parent.top
        anchors.right: powerButton.left
        anchors.topMargin: Settings.local.launcher.defaultMargin
        anchors.rightMargin: Settings.local.launcher.defaultMargin
        KeyNavigation.left: headButton
        KeyNavigation.right: powerButton
        KeyNavigation.down: listArea.currentItem
        iconSource: Settings.local.imageResources.power
        implicitWidth: Settings.local.launcher.powerIconSize
        implicitHeight: Settings.local.launcher.powerIconSize
        onClicked: {
            LS.adhoc.call("luna://com.webos.service.power", "/shutdown/machineReboot", "{\"reason\":\"power off\"}");
        }
    }


    Button {
        id: headButton
        anchors.top: parent.top
        anchors.right: rebootButton.left
        anchors.topMargin: Settings.local.launcher.defaultMargin
        anchors.rightMargin: Settings.local.launcher.defaultMargin
        KeyNavigation.right: rebootButton
        KeyNavigation.down: listArea.currentItem
        iconSource: Settings.local.imageResources.head
        implicitWidth: Settings.local.launcher.headIconSize
        implicitHeight: Settings.local.launcher.headIconSize
        onClicked: {
            LS.adhoc.call("luna://com.webos.notification", "/createToast", "{\"message\": \"Hello from Firman Jamal\",\"noaction\":false,\"persistent\":true}");
        }
    }

    Rectangle {
        id: background
        height: 200
        anchors.topMargin: -height
        anchors.bottom: parent.bottom
        width: parent.width
        color: Settings.local.launcher.backgroundColor
        opacity: 1

        AnimatedImage {
            anchors.centerIn: parent
            source: Settings.local.imageResources.spinner
            visible: launchPointsModel.status != ServiceModel.Ready
            playing: visible
        }

        FocusScope {
            focus: true
            anchors.fill: parent
            visible: launchPointsModel.status == ServiceModel.Ready

            ListView {
                id: listArea
                focus: true
                anchors.fill: parent
                KeyNavigation.up: settingsButton
                model: launchPointsModel
                orientation: ListView.Horizontal
                move: Transition {
                    NumberAnimation { properties: "x,y"; duration: 1000 }
                }
                delegate: Rectangle {
                    height: 200
                    width: 120
                    color: "red"
                    Text {
                        text: title
                        color: "#fff"
                        font.pointSize: 30
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    openAnimation: SequentialAnimation {
        PropertyAnimation {
            target: background
            property: "anchors.topMargin"
            to: 0
            duration: Settings.local.launcher.slideAnimationDuration
            easing.type: Easing.OutElastic
        }
    }

    closeAnimation: SequentialAnimation {
        PropertyAnimation {
            target: background
            property: "anchors.topMargin"
            to: -200
            duration: Settings.local.launcher.slideAnimationDuration
            easing.type: Easing.InOutCubic
        }
    }

    function toggleHome() {
        if (root.access) {
            if (!root.isTransitioning) {
                if (root.isOpen)
                    root.closeView();
                else
                    root.openView();
            }
        } else {
            console.warn("AccessControl: Launcher is restricted by the access control policy.");
        }
    }
}




