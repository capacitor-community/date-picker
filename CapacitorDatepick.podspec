
  Pod::Spec.new do |s|
    s.name = 'CapacitorDatepick'
    s.version = '0.0.1'
    s.summary = 'Native Datetime Picker Plugin for Capacitor Apps'
    s.license = 'MIT'
    s.homepage = 'https://github.com/stewwan/capacitor-datepick'
    s.author = 'Stewan Silva'
    s.source = { :git => 'https://github.com/stewwan/capacitor-datepick', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end