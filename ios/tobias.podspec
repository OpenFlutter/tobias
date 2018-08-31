#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
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
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AliPay','~> 2.0'
  
  s.ios.deployment_target = '8.0'
end

