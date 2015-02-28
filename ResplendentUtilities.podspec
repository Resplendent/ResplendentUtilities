#
# Be sure to run `pod lib lint ResplendentUtilities.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ResplendentUtilities"
  s.version          = "0.1.1"
  s.summary          = "An Objective-C library for all kinds of things"
  # s.description      = <<-DESC                       
  #                          An optional longer description of ResplendentUtilities
  #                          
  #                          * Markdown format.
  #                          * Don't worry about the indent, we strip it!
  #                          DESC
  s.homepage         = "https://github.com/Resplendent/ResplendentUtilities"
  # s.screenshots    = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "BenMaer" => "ben@resplendent.co" }
  s.source           = { :git => "https://github.com/Resplendent/ResplendentUtilities.git", :tag => "v#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ResplendentUtilities' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
