import {
  NativeModulesProxy,
  EventEmitter,
  Subscription,
} from "expo-modules-core";

// Import the native module. On web, it will be resolved to ExpoPolarSDK.web.ts
// and on native platforms to ExpoPolarSDK.ts
import {
  BatteryLevelReceivedEventPayload,
  DeviceDisInformationReceivedEventPayload,
  HRValueReceivedEventPayload,
  PolarDeviceInfoEventPayload,
  StreamingFeaturesReadyEventPayload,
} from "./ExpoPolarSDK.types";
import ExpoPolarSDKModule from "./ExpoPolarSDKModule";

export function initialize(): void {
  ExpoPolarSDKModule.initialize();
}

export function connectToDevice(deviceId: string) {
  ExpoPolarSDKModule.connectToDevice(deviceId);
}

export function foregroundEntered() {
  ExpoPolarSDKModule.foregroundEntered();
}

export function shutdown() {
  ExpoPolarSDKModule.shutdown();
}

const emitter = new EventEmitter(
  ExpoPolarSDKModule ?? NativeModulesProxy.ExpoPolarSDK
);

export function addBLEPowerStateChangedListener(
  listener: (powered: boolean) => void
): Subscription {
  return emitter.addListener<boolean>("onBLEPowerStateChanged", listener);
}

export function addDeviceConnectingListener(
  listener: (event: PolarDeviceInfoEventPayload) => void
): Subscription {
  return emitter.addListener<PolarDeviceInfoEventPayload>(
    "onDeviceConnecting",
    listener
  );
}

export function addDeviceConnectedListener(
  listener: (event: PolarDeviceInfoEventPayload) => void
): Subscription {
  return emitter.addListener<PolarDeviceInfoEventPayload>(
    "onDeviceConnected",
    listener
  );
}

export function addDeviceDisconnectedListener(
  listener: (event: PolarDeviceInfoEventPayload) => void
): Subscription {
  return emitter.addListener<PolarDeviceInfoEventPayload>(
    "onDeviceDisconnected",
    listener
  );
}

export function addDisInformationReceivedListener(
  listener: (event: DeviceDisInformationReceivedEventPayload) => void
): Subscription {
  return emitter.addListener<DeviceDisInformationReceivedEventPayload>(
    "onDisInformationReceived",
    listener
  );
}

export function addHRValueReceivedListener(
  listener: (event: HRValueReceivedEventPayload) => void
): Subscription {
  return emitter.addListener<HRValueReceivedEventPayload>(
    "onHRValueReceived",
    listener
  );
}

export function addHRFeatureReadyListener(
  listener: (identifier: string) => void
): Subscription {
  return emitter.addListener<string>("onHRFeatureReady", listener);
}

export function addFTPFeatureReadyListener(
  listener: (identifier: string) => void
): Subscription {
  return emitter.addListener<string>("onFTPFeatureReady", listener);
}

export function addStreamingFeaturesReadyListener(
  listener: (event: StreamingFeaturesReadyEventPayload) => void
): Subscription {
  return emitter.addListener<StreamingFeaturesReadyEventPayload>(
    "onStreamingFeaturesReady",
    listener
  );
}

export function addBatteryLevelReceived(
  listener: (event: BatteryLevelReceivedEventPayload) => void
): Subscription {
  return emitter.addListener<BatteryLevelReceivedEventPayload>(
    "onBatteryLevelReceived",
    listener
  );
}

export {
  BatteryLevelReceivedEventPayload,
  DeviceDisInformationReceivedEventPayload,
  HRValueReceivedEventPayload,
  PolarDeviceInfoEventPayload,
  StreamingFeaturesReadyEventPayload,
};
