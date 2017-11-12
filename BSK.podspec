Pod::Spec.new do |spec|

  spec.name          = "BSK"
  spec.version       = "0.1"
  spec.summary       = "Simple framework for making payments on `ispp.spbmetropoliten.ru`."
  spec.homepage      = "https://github.com/m3g0byt3/BSK"
  spec.license       = "MIT"
  spec.author        = { "m3g0byt3" => "m3g0byt3@gmail.com" }
  spec.platform      = :ios, "9.3"
  spec.ios.deployment_target = "9.3"
  spec.source        = { :git => "https://github.com/m3g0byt3/BSK.git", :tag => "#{spec.version}" }
  spec.source_files  = 'BSK/*/*.swift'
  spec.requires_arc  = true
  spec.dependency 'Moya'
  # Explicitly adding Alamofire as dependency due to https://github.com/Moya/Moya/issues/681
  spec.dependency 'Alamofire'
 
end
