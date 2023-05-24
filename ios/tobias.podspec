#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))

puts Psych::VERSION
psych_version_gte_500 = Gem::Version.new(Psych::VERSION) >= Gem::Version.new('5.0.0')
if psych_version_gte_500 == true
    cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'), aliases: true)
else
    cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
end

if cfg['tobias'] && cfg['tobias']['no_utdid'] == true
    tobias_subspec = 'no_utdid'
else
    tobias_subspec = 'normal'
end

Pod::UI.puts "using sdk with #{tobias_subspec}"

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
  s.dependency 'Flutter'
  s.requires_arc          = true

  s.ios.deployment_target = '9.0'

  s.default_subspec = tobias_subspec

  s.subspec 'normal' do |sp|
    sp.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
    sp.libraries             = 'z', 'c++'
    sp.resource              = 'AlipaySDK/Normal/AlipaySDK.bundle'
    sp.vendored_frameworks   = 'AlipaySDK/Normal/AlipaySDK.framework'
  end

  s.subspec 'no_utdid' do |sp|
    sp.frameworks            = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit'
    sp.libraries             = 'z', 'c++'
    sp.resource              = 'AlipaySDK/NoUtdid/AlipaySDK.bundle'
    sp.vendored_frameworks   = 'AlipaySDK/NoUtdid/AlipaySDK.framework'
  end

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

end

