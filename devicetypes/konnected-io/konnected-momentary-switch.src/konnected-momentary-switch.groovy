/**
 *  Konnected Switch
 *
 *  Copyright 2017 konnected.io
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License. You may obtain a copy of the License at:
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 *  on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License
 *  for the specific language governing permissions and limitations under the License.
 *
 */
metadata {
  definition (name: "Konnected Momentary Switch", namespace: "konnected-io", author: "konnected.io") {
    capability "Switch"
    capability "Actuator"
    capability "Momentary"
  }

  preferences {
    input name: "invertTrigger", type: "bool", title: "Low Level Trigger",
          description: "Select if the attached relay uses a low-level trigger. Default is high-level trigger"
  }

  tiles {
    multiAttributeTile(name:"main", type: "generic", width: 6, height: 4, canChangeIcon: true) {
      tileAttribute ("device.switch", key: "PRIMARY_CONTROL") {
        attributeState "off", label: 'Push', action: "momentary.push", backgroundColor: "#ffffff", nextState: "on"
        attributeState "on", label: 'Push', action: "momentary.push", backgroundColor: "#53a7c0"
      }
    }
    main "main"
    details "main"
  }
}

def off() {
  sendEvent([name: "switch", value: "off"])
  def val = invertTrigger ? 1 : 0
  parent.deviceUpdateDeviceState(device.deviceNetworkId, val)
}

def on() {
  sendEvent([name: "switch", value: "on"])
  def val = invertTrigger ? 0 : 1
  parent.deviceUpdateDeviceState(device.deviceNetworkId, val)
}

def push() {
  sendEvent([name: "switch", value: "on", isStateChange: true, display: false])
  sendEvent([name: "switch", value: "off", isStateChange: true, display: false])
  sendEvent([name: "momentary", value: "pushed", isStateChange: true])
  def val = invertTrigger ? 0 : 1
  parent.deviceUpdateDeviceState(device.deviceNetworkId, val, 300)
}