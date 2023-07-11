
Pod::Spec.new do |s|
  s.name             = 'WDBannerView'
  s.version          = '0.0.1'
  s.summary          = 'A short description of WDBannerView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/SummerCodeing/WDBannerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SummerCodeing' => '596175302@qq.com' }
  s.source           = { :git => 'https://github.com/SummerCodeing/WDBannerView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'WDBannerView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WDBannerView' => ['WDBannerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
