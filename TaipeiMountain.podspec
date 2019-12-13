#
# Be sure to run `pod lib lint TaipeiMountain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TaipeiMountain'
  s.version          = '1.1.0'
  s.summary          = 'TaipeiMountain is album photo picker written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TaipeiMountain is album photo picker written in Swift.
                       DESC

  s.homepage         = 'https://github.com/WayneLin1215/TaipeiMountain'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wayne' => 'waynelin1215@gmail.com' }
  s.source           = { :git => 'https://github.com/WayneLin1215/TaipeiMountain.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/antiso_help'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'
  s.source_files = 'TaipeiMountain/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TaipeiMountain' => ['TaipeiMountain/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
