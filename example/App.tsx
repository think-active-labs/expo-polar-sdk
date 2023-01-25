import * as ExpoPolarSDK from "expo-polar-sdk";
import { Button, StyleSheet, Text, View } from "react-native";

const deviceId = "XXXX";

export default function App() {
  let logs = "";

  ExpoPolarSDK.addBLEPowerStateChangedListener((event) => {
    logs += `BLE POWER STATE: ${event}\n`;
  });

  ExpoPolarSDK.addDeviceConnectingListener((event) => {
    logs += `DEVICE CONNECTING: ${event}\n`;
  });

  ExpoPolarSDK.addDeviceConnectedListener((event) => {
    logs += `DEVICE CONNECTED: ${event}\n`;
  });

  ExpoPolarSDK.addDeviceDisconnectedListener((event) => {
    logs += `DEVICE DISCONNECTED: ${event}\n`;
  });

  ExpoPolarSDK.addDisInformationReceivedListener((event) => {
    logs += `DEVICE DISINFORMATION RECEIVED: ${event}\n`;
  });

  ExpoPolarSDK.addBatteryLevelReceived((event) => {
    logs += `BATTERY LEVEL RECEIVED: ${event}\n`;
  });

  ExpoPolarSDK.initialize();

  return (
    <View style={styles.container}>
      <Text>{logs}</Text>
      <Button
        title="Connect"
        onPress={() => ExpoPolarSDK.connectToDevice(deviceId)}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
