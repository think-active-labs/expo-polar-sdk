export type BLEPowerStateChangedEventPayload = {
  powered: boolean;
};

export type PolarDeviceInfoEventPayload = {
  deviceId: string;
  address: string;
  name: string;
  isConnectable: boolean;
  rssi: number;
};

export type PolarHRData = {
  hr: number;
  rrsMs: number;
  rrs: number;
  contactStatus: boolean;
  contactStatusSupported: boolean;
};

export type BatteryLevelEventPayload = {
  identifier: string;
  batteryLevel: number;
};

export type DeviceDisInformationReceivedEventPayload = {
  identifier: string;
  uuid: string;
  value: string;
};

export type HRFeatureReadyEventPayload = {
  identifier: string;
};

export type HRValueReceivedEventPayload = {
  idenitifier: string;
  data: PolarHRData;
};

export type StreamingFeaturesReadyEventPayload = {
  identifier: string;
  stringFeatures: string[];
};

export type BatteryLevelReceivedEventPayload = {
  identifier: string;
  level: number;
};

export type LogReceivedEventPayload = {
  message: string;
};
