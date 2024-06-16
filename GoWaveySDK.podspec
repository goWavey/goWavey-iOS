Pod::Spec.new do |spec|

  spec.name         = "GoWaveySDK"
  spec.version      = "1.0.0"
  spec.summary      = "Reward SDK."
  spec.authors      = { 'Nikola Matijevic' => 'nikolamatijevic101@gmail.com' }
  spec.platform     = :ios, '15.0'
  spec.source       = { :git => 'https://github.com/goWavey/goWavey-iOS.git', :tag => '1.0.0' }
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.swift_version = '5.3'
  spec.ios.deployment_target  = '15.0'
  spec.homepage     = 'https://github.com/goWavey/goWavey-iOS'

  spec.source_files = 'GoWaveySDK/Sources/GoWaveySDK/**/*.swift'
  spec.resource_bundles = {
    'GoWaveySDKResources' => ['GoWaveySDK/Sources/GoWaveySDK/Resources/*.{json,xcassets}']
  }

  spec.dependency 'lottie-ios', '~> 4.0'

end
