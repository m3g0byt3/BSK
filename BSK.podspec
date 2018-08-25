Pod::Spec.new do |spec|

  spec.name          = "BSK"
  spec.version       = "0.4.2"
  spec.summary       = "Simple framework for making payments on `ispp.spbmetropoliten.ru`."
  spec.homepage      = "https://github.com/m3g0byt3/BSK"
  spec.license       = "MIT"
  spec.author        = { "m3g0byt3" => "m3g0byt3@gmail.com" }
  spec.platform      = :ios, "9.3"
  spec.ios.deployment_target = "9.3"
  spec.source        = { :git => "https://github.com/m3g0byt3/BSK.git", :tag => "#{spec.version}" }
  spec.source_files  = 'BSK/**/*.swift'
  spec.resource_bundles = { 'BSKStubData' => ['BSK/**/*.{txt,xml,json}'] }
  spec.requires_arc  = true
  spec.dependency 'Moya'
 
end
