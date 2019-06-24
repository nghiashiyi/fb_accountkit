#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'fb_accountkit_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Facebook Account Kit Plugin for Flutter'
  s.description      = <<-DESC
Facebook Account Kit Plugin for Flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AccountKit'
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end

