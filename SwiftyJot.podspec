#
# Be sure to run `pod lib lint SwiftyJot.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'SwiftyJot'
s.version          = '0.1.0'
s.summary          = 'Annotate an image with the touch of a finger.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
Give your images the finger with SwiftyJot! Lightweight library lets users mark up a photo/image.
Options to allow user to select color and brush size. Multi-level undo and one level redo. Inspired
by the (now abandoned) jot object-C library from IFTTT but all new code, 100% Swift.
DESC

s.homepage         = 'https://github.com/DavidLari/SwiftyJot'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'DavidLari' => 'David@DavidLariStudios.com' }
s.source           = { :git => 'https://github.com/DavidLari/SwiftyJot.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/DavidLari'

s.ios.deployment_target = '9.0'

s.source_files = 'SwiftyJot/Classes/**/*'

s.resource_bundles = {
'SwiftyJot' => ['SwiftyJot/Assets/**/*.xcassets']
}
s.resources = 'SwiftyJot/Assets/**/*.xcassets'

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit'
# s.dependency 'AFNetworking', '~> 2.3'
end

