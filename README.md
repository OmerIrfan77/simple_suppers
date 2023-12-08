# Simple_suppers

This is an app aimed at students who want to cook in a hurry! Here they can view various, filter them by time and difficulty and even create their own.

## Prerequisites

This app is built on flutter with a node backend, both flutter and node must be installed to run the app, as well as a simulator or an actual device that can be connected to the computer will be needed.

## Run instructions

### To start the Server/API:

1. Navigate to the /backend folder and move the `.env` file attached with the submission into this folder.
2. Next in the `.env` file edit this line: `DB_CA=/path/to/certificate/DigiCertGlobalRootCA.crt.pem` to match your path for the `DigiCertGlobalRootCA.crt.pem` (which is also attached with the submission).
3. Now, whilst in the /backend folder run `npm install`
4. Once all dependencies are installed run `node server.js` and now the server has started!

### To build app:

1. As the app is built on flutter, to run we require you to have flutter installed. If it is not installed you can follow these steps to install: https://docs.flutter.dev/get-started/install
2. Now you need to open a simulator of your choice, either iOS or Android.
3. Once flutter is installed and a simulator is running, go into the project directory and simply run `flutter run` (Note: API must be running to work the app)
