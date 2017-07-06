#
# Be sure to run `pod lib lint ESJSON.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ESJSON'
  s.version          = '0.2.0'
  s.summary          = 'ESJSON makes going between JSON and objects dead simple.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ESJSON uses the Objective C runtime to go from objects to JSON and back. For most classes, it's as simple as calling `toJson:` and `modelOfClass:fromJson:`. These methods automatically convert between snake case and llama case, convert primitives to the right type, and make `NSDate`s into ISO8601 format. Customization of keys can be accomplished by implementing a class method returning a dictionary of property names and json keys.
                       DESC

  s.homepage         = 'https://github.com/schrockblock/esjson'
  s.author           = { 'Elliot' => '' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/schrockblock/esjson.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/schrockblock'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ESJSON/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ISO8601DateFormatter'
end
