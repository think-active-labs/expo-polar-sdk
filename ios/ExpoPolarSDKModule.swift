import ExpoModulesCore
import CoreBluetooth
import PolarBleSdk
import RxSwift

public class ExpoPolarSDKModule: Module, PolarBleApiObserver, PolarBleApiPowerStateObserver, PolarBleApiDeviceInfoObserver, PolarBleApiDeviceFeaturesObserver, PolarBleApiDeviceHrObserver, PolarBleApiLogger {
  var blePowerState = false
  var api: PolarBleApi?
    
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('ExpoPolarSDK')` in JavaScript.
    Name("ExpoPolarSDK")

    // Defines event names that the module can send to JavaScript.
    Events("onBLEPowerStateChanged", "onDeviceConnecting", "onDeviceConnected", "onDeviceDisconnected", "onDisInformationReceived", "onStreamingFeaturesReady", "onHRValueReceived", "onHRFeatureReady", "onFTPFeatureReady", "onBatteryLevelReceived", "onLogReceived")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("initialize") {
      api = PolarBleApiDefaultImpl.polarImplementation(DispatchQueue.main, features: Features.allFeatures.rawValue)
      api!.observer = self
      api!.deviceHrObserver = self
      api!.powerStateObserver = self
      api!.deviceFeaturesObserver = self
      api!.deviceInfoObserver = self
      api!.logger = self
    }
      
    Function("connectToDevice") { (deviceId: String) throws in
      try api!.connectToDevice(deviceId)
    }

    Function("foregroundEntered") {
      // not relevant for iOS
    }

    Function("shutdown") {
      api!.cleanup()
      api = nil
    }
  }
    
  public func deviceConnecting(_ polarDeviceInfo: PolarDeviceInfo) {
    self.sendEvent("onDeviceConnecting", [
      "deviceId": polarDeviceInfo.deviceId,
      "address": polarDeviceInfo.address,
      "name": polarDeviceInfo.name,
      "isConnectable": polarDeviceInfo.connectable,
      "rssi": polarDeviceInfo.rssi,
    ])
  }
        
  public func deviceConnected(_ polarDeviceInfo: PolarDeviceInfo) {
    self.sendEvent("onDeviceConnected", [
      "deviceId": polarDeviceInfo.deviceId,
      "address": polarDeviceInfo.address,
      "name": polarDeviceInfo.name,
      "isConnectable": polarDeviceInfo.connectable,
      "rssi": polarDeviceInfo.rssi,
    ])
  }
        
  public func deviceDisconnected(_ polarDeviceInfo: PolarDeviceInfo) {
    self.sendEvent("onDeviceDisconnected", [
      "deviceId": polarDeviceInfo.deviceId,
      "address": polarDeviceInfo.address,
      "name": polarDeviceInfo.name,
      "isConnectable": polarDeviceInfo.connectable,
      "rssi": polarDeviceInfo.rssi,
    ])
  }
        
  public func batteryLevelReceived(_ identifier: String, batteryLevel: UInt) {
    self.sendEvent("onBatteryLevelReceived", [
      "identifier": identifier,
      "level": batteryLevel
    ])
  }
        
  public func disInformationReceived(_ identifier: String, uuid: CBUUID, value: String) {
      self.sendEvent("onDisInformationReceived", [
        "identifier": identifier,
        "uuid": uuid.uuidString,
        "value": value,
    ])
  }
        
  public func hrValueReceived(_ identifier: String, data: PolarHrData) {
    self.sendEvent("onHRValueReceived", [
      "identifier": identifier,
      "data": [
          "hr": data.hr,
          "rrsMs": data.rrsMs,
          "rrs": data.rrs,
          "contactStatus": data.contact,
          "contactStatusSupported": data.contactSupported
      ]
    ])
  }
            
  public func hrFeatureReady(_ identifier: String) {
    self.sendEvent("onHRFeatureReady", [
      "identifier": identifier
    ])
  }
        
  public func ftpFeatureReady(_ identifier: String) {
    self.sendEvent("onFTPFeatureReady", [
      "identifier": identifier,
    ])
  }
        
  public func streamingFeaturesReady(_ identifier: String, streamingFeatures: Set<DeviceStreamingFeature>) {
    self.sendEvent("onStreamingFeaturesReady", [
      "identifier": identifier,
      "features": streamingFeatures.map { String(describing: $0) }
    ])
  }
    
  public func blePowerOn() {
    if blePowerState {
      return
    }
    blePowerState = true
    self.sendEvent("onBLEPowerStateChanged", [
      "powered": true
    ])
  }
        
  public func blePowerOff() {
    if !blePowerState {
      return
    }
    blePowerState = false
    self.sendEvent("onBLEPowerStateChanged", [
      "powered": false
    ])
  }
    
  public func message(_ str: String) {
    self.sendEvent("onLogReceived", [
        "message": str
    ])
  }
}
