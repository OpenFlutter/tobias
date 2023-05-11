#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))

if cfg['tobias'] && cfg['tobias']['url_scheme']
    url_scheme = cfg['tobias']['url_scheme']
    system("ruby #{current_dir}/tobias_setup.rb -u #{url_scheme} -p #{project_dir} -n Runner.xcodeproj")
else
    abort("required values:[url_scheme] are missing. Please add them in pubspec.yaml:\ntobias:\n  url_scheme: ${url scheme}\n")
end

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
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
  s.libraries             = 'z', 'c++'
  s.resource              = 'AlipaySDK/AlipaySDK.bundle'
  s.vendored_frameworks   = 'AlipaySDK/AlipaySDK.framework'
  s.dependency 'Flutter'
  s.requires_arc          = true

#  s.dependency 'OpenAliPaySDK', '~> 15.6.5'
#  s.dependency 'AliPay', '~> 2.1.2'
#  s.dependency 'AlipaySDK-iOS', '~> 15.7.9'

  s.ios.deployment_target = '9.0'
end

