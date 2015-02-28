Pod::Spec.new do |spec|
  spec.name         = 'ResplendentUtilities'
  spec.version      = '0.0.1'
  spec.license      = 'MIT'
  spec.summary      = 'An Objective-C library for all kinds of things'
  spec.homepage     = 'https://github.com/Resplendent/ResplendentUtilities'
  spec.author       = 'Ben Maer'
  spec.source       =  :git => 'https://github.com/Resplendent/ResplendentUtilities.git', :tag => '0.0.1-1'
  spec.source_files = 'ResplendentUtilities/*'
  spec.requires_arc = true
end
