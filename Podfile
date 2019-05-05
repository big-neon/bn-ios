platform :ios, '11.0'
use_frameworks!

  target 'Big Neon Core' do
    pod 'Stripe'
    pod 'Alamofire', '~> 5.0.0.beta.1'
    pod 'SwiftKeychainWrapper'
    pod 'JWTDecode' # '~> 2.2'
    pod 'PhoneNumberKit', '~> 2.1'
    pod 'Sync', '~> 5'
  
    # Pods for Big Neon
    target 'Big Neon' do
      inherit! :search_paths
        pod 'Alamofire', '~> 5.0.0.beta.1'
        pod 'Stripe'
        pod 'QRCodeReader.swift'
        pod 'PresenterKit'
        pod 'pop'
        pod 'JWTDecode'
        pod 'PWSwitch'
        pod 'SwiftKeychainWrapper'
        pod 'Sync', '~> 5'
    end
    
    target 'Big Neon UI' do
      inherit! :search_paths
      pod 'Crashlytics'
      pod 'Stripe'
      pod 'Sync', '~> 5'
      pod 'Alamofire', '~> 5.0.0.beta.1'
      pod 'TransitionButton'
      pod 'pop'
      pod 'JWTDecode'
      pod 'PWSwitch'
      pod 'DTGradientButton'
      pod 'PINCache', '3.0.1-beta.6'
      pod 'PINRemoteImage', '3.0.0-beta.13'
      pod 'UITextField+Shake'
      pod 'PhoneNumberKit', '~> 2.1'
    end
  end



