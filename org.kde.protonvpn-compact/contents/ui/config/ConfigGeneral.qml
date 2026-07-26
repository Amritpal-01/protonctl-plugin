import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami

Kirigami.FormLayout {

    TextField {
        Kirigami.FormData.label: i18n("Package name:")
        text: plasmoid.configuration.packageName

        onTextChanged: {
            plasmoid.configuration.packageName = text
        }
    }

    TextField {
        Kirigami.FormData.label: i18n("Connect argument:")
        text: plasmoid.configuration.connectArgument

        onTextChanged: {
            plasmoid.configuration.connectArgument = text
        }
    }

    TextField {
        Kirigami.FormData.label: i18n("Disconnect argument:")
        text: plasmoid.configuration.disconnectArgument

        onTextChanged: {
            plasmoid.configuration.disconnectArgument = text
        }
    }

    TextField {
        Kirigami.FormData.label: i18n("Status argument:")
        text: plasmoid.configuration.statusArgument

        onTextChanged: {
            plasmoid.configuration.statusArgument = text
        }
    }
}