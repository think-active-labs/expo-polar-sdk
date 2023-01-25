import * as ExpoPolarSDK from "expo-polar-sdk";
import { useEffect, useState } from "react";
import { Button, ScrollView, StyleSheet, Text, View } from "react-native";

const deviceId = "B382092D";

export default function App() {
  const [logs, setLogs] = useState<string>("APPLICATION INITIALISED...\n");

  useEffect(() => {
    ExpoPolarSDK.addLogReceivedListener((event) => {
      setLogs((l) => (l += `🗒 POLAR LOG RECEIVED: ${event.message}\n`));
    });

    ExpoPolarSDK.addBLEPowerStateChangedListener((event) => {
      setLogs((l) => (l += `BLE POWER STATE: ${event.powered}\n`));
    });

    ExpoPolarSDK.addDeviceConnectingListener((event) => {
      setLogs((l) => (l += `🟡 DEVICE CONNECTING: ${JSON.stringify(event)}\n`));
    });

    ExpoPolarSDK.addDeviceConnectedListener((event) => {
      setLogs((l) => (l += `🟢 DEVICE CONNECTED: ${JSON.stringify(event)}\n`));
    });

    ExpoPolarSDK.addDeviceDisconnectedListener((event) => {
      setLogs(
        (l) => (l += `🔴 DEVICE DISCONNECTED: ${JSON.stringify(event)}\n`)
      );
    });

    ExpoPolarSDK.addDisInformationReceivedListener((event) => {
      setLogs(
        (l) =>
          (l += `❗ DEVICE DISINFORMATION RECEIVED: ${JSON.stringify(event)}\n`)
      );
    });

    ExpoPolarSDK.addBatteryLevelReceivedListener((event) => {
      setLogs(
        (l) => (l += `🔋 BATTERY LEVEL RECEIVED: ${JSON.stringify(event)}\n`)
      );
    });

    ExpoPolarSDK.initialize();
  }, []);

  return (
    <View style={styles.container}>
      <ScrollView>
        <Text>{logs}</Text>
      </ScrollView>
      <Button
        title="Connect"
        onPress={() => ExpoPolarSDK.connectToDevice(deviceId)}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginTop: 80,
    marginBottom: 20,
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
