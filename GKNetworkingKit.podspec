Pod::Spec.new do |s|

  s.name                  = 'GKNetworkingKit'
  s.version               = '2.0.0'
  s.summary               = 'GKNetworkingKit framework.'
  s.description           = <<-DESC
                            * GKNetworkingKit framework
                              DESC
  s.homepage              = 'https://github.com/gligorkot/GKNetworkingKit'
  s.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author                = { 'Gligor Kotushevski' => 'gligorkot@gmail.com' }
  s.social_media_url      = 'https://twitter.com/gligor_nz'
  s.platform              = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/gligorkot/GKNetworkingKit.git', :tag => s.version.to_s }

  s.source_files          = 'Classes/**', 'Classes/**/*.{swift}'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.0' }

  s.dependency 'Moya', '~> 14.0.x'
  s.dependency 'GKBaseKit', '~> 1.0.x'
  s.requires_arc          = true
  s.swift_versions        = ['4.0', '4.1', '4.2', '5.0', '5.1', '5.2']

end
