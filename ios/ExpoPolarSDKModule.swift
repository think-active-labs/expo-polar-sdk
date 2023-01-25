import ExpoModulesCore

public class ExpoPolarSDKModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('ExpoPolarSDK')` in JavaScript.
    Name("ExpoPolarSDK")

    // Defines event names that the module can send to JavaScript.
    Events("onBLEPowerStateChanged", "onDeviceConnecting", "onDeviceConnected", "onDeviceDisconnected", "onDisInformationReceived", "onHRValueReceived", "onHRFeatureReady", "onFTPFeatureReady", "onBatteryLevelReceived")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("initialise") {
      api.setApiCallback(object : PolarBleApiCallback() {
              override fun blePowerStateChanged(powered: Boolean) {
                  self.sendEvent("onBLEPowerStateChanged", [
                  "powered" to powered
                ])
              }

              override fun deviceConnected(polarDeviceInfo: PolarDeviceInfo) {
                  self.sendEvent("onDeviceConnected", [
                  "deviceId" to polarDeviceInfo.deviceId,
                  "address" to polarDeviceInfo.address,
                  "name" to polarDeviceInfo.name,
                  "isConnectable" to polarDeviceInfo.isConnectable,
                  "rssi" to polarDeviceInfo.rssi,
                ])
              }

              override fun deviceConnecting(polarDeviceInfo: PolarDeviceInfo) {
                  self.sendEvent("onDeviceConnecting", mapOf(
                  "deviceId" to polarDeviceInfo.deviceId,
                  "address" to polarDeviceInfo.address,
                  "name" to polarDeviceInfo.name,
                  "isConnectable" to polarDeviceInfo.isConnectable,
                  "rssi" to polarDeviceInfo.rssi,
                ))
              }

              override fun deviceDisconnected(polarDeviceInfo: PolarDeviceInfo) {
                  self.sendEvent("onDeviceDisconnected", mapOf(
                  "deviceId" to polarDeviceInfo.deviceId,
                  "address" to polarDeviceInfo.address,
                  "name" to polarDeviceInfo.name,
                  "isConnectable" to polarDeviceInfo.isConnectable,
                  "rssi" to polarDeviceInfo.rssi,
                ))
              }

              override fun disInformationReceived(identifier: String, uuid: UUID, value: String) {
                  self.sendEvent("onDisInformationReceived", mapOf(
                  "identifier" to identifier,
                  "uuid" to uuid,
                  "value" to value,
                ))
              }

              override fun streamingFeaturesReady(identifier: String, features: Set<PolarBleApi.DeviceStreamingFeature>) {
                  self.sendEvent("onStreamingFeaturesReady", mapOf(
                  "identifier" to identifier,
                  "features" to features.map { it.name }
                ))
              }

              override fun hrFeatureReady(identifier: String) {
                  self.sendEvent("onHRFeatureReady", mapOf(
                  "identifier" to identifier
                ))
              }

              override fun batteryLevelReceived(identifier: String, level: Int) {
                  self.sendEvent("onBatteryLevelReceived", mapOf(
                  "identifier" to identifier,
                  "level" to level
                ))
              }

              override fun hrNotificationReceived(identifier: String, data: PolarHrData) {
                  self.sendEvent("onHRValueReceived", mapOf(
                  "identifier" to identifier,
                  "data" to mapOf(
                    "hr" to data.hr,
                    "rrsMs" to data.rrsMs,
                    "rrs" to data.rrs,
                    "contactStatus" to data.contactStatus,
                    "contactStatusSupported" to data.contactStatusSupported
                  )
                ))
              }

              override fun polarFtpFeatureReady(identifier: String) {
                  self.sendEvent("onFTPFeatureReady", mapOf(
                  "identifier" to identifier,
                ))
              }
            })
          }

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("setValueAsync") { (value: String) in
      // Send an event to JavaScript.
      self.sendEvent("onChange", [
        "value": value
      ])
    }
      
    Function("connectToDevice") { (deviceId: String) in
      api.connectToDevice(deviceId)
    }

    Function("foregroundEntered") {
      api.foregroundEntered()
    }

    Function("shutdown") {
      api.shutDown()
    }
  }
}
