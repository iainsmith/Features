Pod::Spec.new do |spec|
  spec.name             = 'Features'
  spec.version          = '0.1.2'
  spec.license          = { :type => 'MIT' }
  spec.homepage         = 'https://github.com/iainsmith/Features'
  spec.authors          = { 'Iain Smith' => '' }
  spec.summary          = 'Feature Flags for your app.'
  spec.source           = { :git => 'https://github.com/iainsmith/features.git', :tag => 'v0.1.2' }
  spec.source_files     = 'Features/*'
  spec.requires_arc     = true
  spec.ios.deployment_target = '8.0'
end
