cd $(cd `dirname $0`; pwd)
zip -q -r TdoDevice.zip Podfile Podfile.lock Pods TdoDeviceDemo TdoDeviceDemo.xcodeproj TdoDeviceDemo.xcworkspace
