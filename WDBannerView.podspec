

Pod::Spec.new do |s|
  s.name             = 'WDBannerView'
  s.version          = '0.0.1'
  s.summary          = '轮播控件'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/summerCodeing/WDBannerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'summerCodeing' => '596175302@qq.com' }
  s.source           = { :git => 'https://github.com/summerCodeing/WDBannerView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'WDBannerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WDBannerView' => ['WDBannerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end