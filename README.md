Goal: Create a macOS App acting as a Simulator to facilitate the development of Apps using the ActiveLook technology

How to Use:
- Demo App Sending the commands: Clone this repo https://github.com/bszakal/ActiveLook-demo-app and build on an iOS device
- Clone this repo and build the ActiveLookSimulatorMacOS target onto Mac for the destination 
- !! It is important to select the MacOS scheme not iOS one and to build on Mac. Building the iOS scheme on Mac (optimized for iPAD) will not work with bluetooth
- Make sure bluetooth is enabled on the Mac

- Run the demo App on the iOS device and you should see an Unamed Glasses in the list
- Tap on it
- Go to graphics: and test the different commands
- Go to General: Tap on shif left right or reset to test

- The drawings will appear on the left screen and logs on the right screen

Details:
- Built on Swiftui using MVVM + Manager + Services along with abstractions via protocols for full testability.
- <img width="1029" height="555" alt="Screenshot 2025-08-13 at 12 51 41" src="https://github.com/user-attachments/assets/c5b92683-866d-45c3-b0d5-46729b91c676" />
