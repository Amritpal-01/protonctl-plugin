import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    property string packageName: plasmoid.configuration.packageName

    property string ctlcmd: ("/usr/bin/" + packageName)
    
    property string useConnect:
        (ctlcmd + " " + plasmoid.configuration.connectArgument)
    
    property string useDisconnect:
        (ctlcmd + " " + plasmoid.configuration.disconnectArgument)
    
    property string useGetStatus:
        (ctlcmd + " " + plasmoid.configuration.statusArgument)

    property bool connectionStatus: false
    property bool isLoading: false

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"

        onNewData: function(source, data) {
            disconnectSource(source)

            if (source === useGetStatus) {
                // Check if output contains "Connected"
                connectionStatus = data.stdout ? data.stdout.includes("Connected") : false
                isLoading = false
            } else {
                // A connect/disconnect command finished; now fetch updated status
                updateConnectionStatusInternal()
            }
        }

        function exec(cmd) {
            if (isLoading) return;
            isLoading = true
            connectSource(cmd)
        }

        // Internal bypass so status updates can run immediately after action commands finish
        function execForce(cmd) {
            connectSource(cmd)
        }
    }

    function toggleConnection() {
        if (connectionStatus) {
            executable.exec(useDisconnect)
        } else {
            executable.exec(useConnect)
        }
    }

    function updateConnectionStatus() {
        executable.exec(useGetStatus)
    }

    function updateConnectionStatusInternal() {
        executable.execForce(useGetStatus)
    }

    Component.onCompleted: {
        updateConnectionStatus()
    }

    Column {
        spacing: 10

        Row {
            Item {
                width: 20
                height: 20

                Image {
                    anchors.fill: parent
                    source: isLoading
                    ? "assets/proton-vpn-loading.png"
                    : (connectionStatus ? "assets/proton-vpn-connected.png" : "assets/proton-vpn-disconnected.png")
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.toggleConnection()
                }
            }
        }
    }
}
