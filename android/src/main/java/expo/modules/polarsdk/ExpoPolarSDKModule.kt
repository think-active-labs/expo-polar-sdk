package expo.modules.polarsdk

import android.content.Context
import com.polar.sdk.api.PolarBleApi
import com.polar.sdk.api.PolarBleApiCallback
import com.polar.sdk.api.PolarBleApiDefaultImpl
import com.polar.sdk.api.model.PolarDeviceInfo
import com.polar.sdk.api.model.PolarHrData
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.util.*

class ExpoPolarSDKModule(
        context: Context,
) : Module() {
  private val api: PolarBleApi by lazy {
    // Notice PolarBleApi.ALL_FEATURES are enabled
    PolarBleApiDefaultImpl.defaultImplementation(context, PolarBleApi.ALL_FEATURES)
  }

  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('ExpoPolarSDK')` in JavaScript.
    Name("ExpoPolarSDK")

    // Defines event names that the module can send to JavaScript.
    Events("onBLEPowerStateChanged", "onDeviceConnecting", "onDeviceConnected", "onDeviceDisconnected", "onDisInformationReceived", "onHRValueReceived", "onHRFeatureReady", "onFTPFeatureReady", "onBatteryLevelReceived")

    // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
    Function("initialize") {
      api.setApiCallback(object : PolarBleApiCallback() {
        override fun blePowerStateChanged(powered: Boolean) {
          sendEvent("onBLEPowerStateChanged", mapOf(
            "powered" to powered
          ))
        }

        override fun deviceConnected(polarDeviceInfo: PolarDeviceInfo) {
          sendEvent("onDeviceConnected", mapOf(
            "deviceId" to polarDeviceInfo.deviceId,
            "address" to polarDeviceInfo.address,
            "name" to polarDeviceInfo.name,
            "isConnectable" to polarDeviceInfo.isConnectable,
            "rssi" to polarDeviceInfo.rssi,
          ))
        }

        override fun deviceConnecting(polarDeviceInfo: PolarDeviceInfo) {
          sendEvent("onDeviceConnecting", mapOf(
            "deviceId" to polarDeviceInfo.deviceId,
            "address" to polarDeviceInfo.address,
            "name" to polarDeviceInfo.name,
            "isConnectable" to polarDeviceInfo.isConnectable,
            "rssi" to polarDeviceInfo.rssi,
          ))
        }

        override fun deviceDisconnected(polarDeviceInfo: PolarDeviceInfo) {
          sendEvent("onDeviceDisconnected", mapOf(
            "deviceId" to polarDeviceInfo.deviceId,
            "address" to polarDeviceInfo.address,
            "name" to polarDeviceInfo.name,
            "isConnectable" to polarDeviceInfo.isConnectable,
            "rssi" to polarDeviceInfo.rssi,
          ))
        }

        override fun disInformationReceived(identifier: String, uuid: UUID, value: String) {
          sendEvent("onDisInformationReceived", mapOf(
            "identifier" to identifier,
            "uuid" to uuid,
            "value" to value,
          ))
        }

        override fun streamingFeaturesReady(identifier: String, features: Set<PolarBleApi.DeviceStreamingFeature>) {
          sendEvent("onStreamingFeaturesReady", mapOf(
            "identifier" to identifier,
            "features" to features.map { it.name }
          ))
        }

        override fun hrFeatureReady(identifier: String) {
          sendEvent("onHRFeatureReady", mapOf(
            "identifier" to identifier
          ))
        }

        override fun batteryLevelReceived(identifier: String, level: Int) {
          sendEvent("onBatteryLevelReceived", mapOf(
            "identifier" to identifier,
            "level" to level
          ))
        }

        override fun hrNotificationReceived(identifier: String, data: PolarHrData) {
          sendEvent("onHRValueReceived", mapOf(
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
          sendEvent("onFTPFeatureReady", mapOf(
            "identifier" to identifier,
          ))
        }
      })
    }

    Function("connectToDevice") { deviceId: String ->
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
