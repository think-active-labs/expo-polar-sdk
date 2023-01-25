import { StyleSheet, Text, View } from 'react-native';

import * as ExpoPolarSDK from 'expo-polar-sdk';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ExpoPolarSDK.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
