platform :ios, '11.0'
use_frameworks!
  target 'Big Neon Core' do
    pod 'Crashlytics'
    pod 'Fabric'
    pod 'PanModal', :git => 'https://github.com/slackhq/PanModal'
    pod 'Alamofire', '~> 5.0.0-rc.2'
    pod 'SwiftKeychainWrapper'
    pod 'JWTDecode'
    pod 'DTGradientButton'
    pod 'PhoneNumberKit', '~> 2.1'
    pod 'Sync', :git => 'https://github.com/3lvis/Sync.git', :branch => 'issue-555' # '~> 5'
  
    # Pods for Big Neon
    target 'Big Neon' do
      inherit! :search_paths
        pod 'PanModal', :git => 'https://github.com/slackhq/PanModal'
        pod 'Crashlytics'
        pod 'Fabric'
        pod 'Answers'
        pod 'Alamofire', '~> 5.0.0-rc.2'
        pod 'PresenterKit'
        pod 'pop'
        pod 'JWTDecode'
        pod 'DTGradientButton'
        pod 'SwiftKeychainWrapper'
        pod 'PullUpController'
        pod 'Sync', :git => 'https://github.com/3lvis/Sync.git', :branch => 'issue-555' # '~> 5'
    end
    
    target 'Big Neon UI' do
      inherit! :search_paths
      pod 'Crashlytics'
      pod 'Fabric'
      pod 'PanModal', :git => 'https://github.com/slackhq/PanModal'
      pod 'Sync', :git => 'https://github.com/3lvis/Sync.git', :branch => 'issue-555' # '~> 5'
      pod 'Alamofire', '~> 5.0.0-rc.2'
      pod 'TransitionButton'
      pod 'pop'
      pod 'JWTDecode'
      pod 'DTGradientButton'
      pod 'PINCache', '3.0.1-beta.6'
      pod 'PINRemoteImage', '3.0.0-beta.13'
      pod 'UITextField+Shake'
      pod 'PhoneNumberKit', '~> 2.1'
    end
    
    target 'BigNeonStudioTests' do
      inherit! :search_paths
      pod 'Sync', :git => 'https://github.com/3lvis/Sync.git', :branch => 'issue-555' # '~> 5'
    end
  end



