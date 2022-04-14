
Pod::Spec.new do |spec|

  spec.name         = "TdoDevice"
  spec.version      = "1.0.0"
  spec.summary      = "双动设备连接sdk"
  spec.description  = "双动设备连接sdk"
  spec.homepage     = "https://github.com/szq5331802/TdoDevice"
  spec.license      = "MIT"
  spec.author       = { "szq" => "691855180@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/szq5331802/TdoDevice.git", :tag => "#{spec.version}" }
  spec.requires_arc = true
  spec.resources = "TdoDevice/TdoDeviceB.bundle"
  spec.vendored_frameworks = "TdoDevice/TdoDevice.framework"
  spec.dependency "AFNetworking", "3.1.0"
  spec.dependency "YYKit", "1.0.9"
  spec.dependency "MBProgressHUD", "1.0.0"
  spec.dependency "Charts", "3.2.1"
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
end
