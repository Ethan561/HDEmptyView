Pod::Spec.new do |s|
    s.name             = 'HDEmptyView'
    s.version          = '1.1.0'
    s.summary          = 'A Swift language packaged EmptyView display library'
    s.homepage         = 'https://www.jianshu.com/p/6f2760647b77'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Ethan561' => 'liuyi5683@163.com' }
    s.source           = { :git => 'https://github.com/Ethan561/HDEmptyView.git', :tag => s.version.to_s }
    s.source_files     = 'HDEmptyView/*.{swift}'
    s.ios.deployment_target = '9.0'
    s.requires_arc = true
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
    s.frameworks = 'Foundation', 'UIKit'
end
