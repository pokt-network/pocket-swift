# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

def base_pods
  pod 'RxSwift',    '4.5.0'
  pod 'RxBlocking', '4.0'
  pod 'BigInt', '3.1.0'
  pod 'SwiftKeychainWrapper', '3.2.0'
  pod 'RNCryptor', '5.0.3'
  pod 'pocket-web3swift', '~> 2.1.5'
  pod 'CryptoSwift', '0.15.0'
end
target 'PocketSwift' do
  base_pods
  # inhibit_all_warnings!

  target 'PocketSwiftTests' do
    inherit! :complete

    pod 'Quick', :inhibit_warnings => true
    pod 'Nimble', :inhibit_warnings => true
  end

end
