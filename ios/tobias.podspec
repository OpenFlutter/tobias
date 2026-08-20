#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
# NOTE: Since 6.0.0 this podspec no longer modifies your Xcode project.
# You have to configure Info.plist (CFBundleURLTypes / LSApplicationQueriesSchemes /
# NSAppTransportSecurity) and Runner.entitlements (associated domains) yourself.
# See README.md -> "iOS Configuration".
#
Pod::Spec.new do |s|
  s.name             = 'tobias'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin For Alipay.'
  s.description      = <<-DESC
A Flutter plugin For Alipay.
                       DESC
  s.homepage         = 'https://github.com/OpenFlutter/tobias'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JarvanMo' => 'jarvan.mo@gmail.com' }
  s.source           = { :path => '.' }

  s.source_files        = 'tobias/Sources/tobias/**/*.{h,m}'
  s.public_header_files = 'tobias/Sources/tobias/include/**/*.h'
  s.static_framework    = true
  s.requires_arc        = true
  s.dependency 'Flutter'

  s.ios.deployment_target = '13.0'

  s.frameworks          = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'Network', 'CoreMotion', 'WebKit'
  s.libraries           = 'z', 'c++'
  s.resource            = 'tobias/Sources/tobias/Resources/AlipaySDK.bundle'
  s.vendored_frameworks = 'tobias/AlipaySDK.xcframework'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.resource_bundles = { 'tobias_privacy' => ['tobias/Sources/tobias/Resources/PrivacyInfo.xcprivacy'] }
end
