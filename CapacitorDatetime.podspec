
  Pod::Spec.new do |s|
    s.name = 'CapacitorDatetime'
    s.version = '0.0.1'
    s.summary = 'Native Datetime Plugin for Capacitor Apps'
    s.license = 'MIT'
    s.homepage = 'https://github.com/stewwan/capacitor-datetime'
    s.author = 'Stewan Silva'
    s.source = { :git => 'https://github.com/stewwan/capacitor-datetime', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
    s.dependency 'UIColor-HexString'
  end