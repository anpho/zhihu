import bb.cascades 1.4

Dialog {
    Container {
        leftPadding: 20.0
        rightPadding: 20.0
        bottomPadding: 20.0
        topPadding: 20.0
        Header {
            title: qsTr("Time Machine")
        }
        Label {
            text: qsTr("Choose a date to navigate to.")
        }
        DateTimePicker {
        }

        Button {
            text: qsTr("GO")
            appearance: ControlAppearance.Primary
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
    onClosed: {
        
    }
    onOpened: {
        
    }
}