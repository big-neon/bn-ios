platform :ios, '11.0'
use_frameworks!

target 'Big Neon Core' do

	pod 'Stripe'
    pod 'Alamofire', '~> 5.0.0.beta.1'
    pod 'Mixpanel'
    pod 'SwiftKeychainWrapper'
    pod 'JWTDecode', '~> 2.2'
    pod 'PhoneNumberKit', '~> 2.1'

  	# Pods for Big Neon
	target 'Big Neon' do
		inherit! :search_paths
        pod 'PresenterKit'
        pod 'pop'
        pod 'PWSwitch'
        pod 'SwiftKeychainWrapper'
	end
end

target 'Big Neon UI' do
    inherit! :search_paths
	pod 'pop'
    pod 'DTGradientButton'
    pod 'PINCache', '3.0.1-beta.6'
    pod 'PINRemoteImage', '3.0.0-beta.13'
    pod 'UITextField+Shake'
    pod 'PhoneNumberKit', '~> 2.1'
end
