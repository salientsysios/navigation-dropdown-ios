Pod::Spec.new do |s|
  s.name = 'NavigationDropdown'
  s.summary = 'Navigation Dropdown in Swift'
  s.version = '0.0.3'
  s.homepage = 'https://github.com/salientsys/navigation-dropdown-ios'
  s.license = 'MIT'
  s.author = { "Salient Systems Corporation" => "mobile.salientsys@gmail.com" }
  s.source = {
    :git => 'https://github.com/salientsys/navigation-dropdown-ios.git',
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://www.salientsys.com/'
  s.requires_arc = true

  s.ios.deployment_target = '11.0'
  s.ios.source_files = 'Sources/**/*'
  s.ios.frameworks = 'UIKit'
  s.ios.resource = 'Assets/**/*.xcassets'
  s.swift_version = '5.0'
end
