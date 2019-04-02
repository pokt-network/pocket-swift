#
#  Be sure to run `pod spec lint PocketSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |main|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  main.name                = "PocketSwift"
  main.version             = "0.0.1"
  main.summary             = "A short description of PocketSwift."
  main.homepage            = "https://github.com/wgarcia4190/BlockchainSwift"
  main.license             = { :type => 'MIT' }
  main.author              = { 
                              "Wilson Garcia" => "wilson@pokt.network",
                              "Luis C. de Leon" => "luis@pokt.network",
                              "Pabel Nunez" => "pabel@pokt.network" 
                            }

  # main.source              = { :git => "https://github.com/pokt-network/pocket-swift.git", :tag => "s.version.to_s" }
  main.source              = { :git => "https://github.com/pokt-network/pocket-swift.git", :branch => "pocket-swift-0.01" }
  main.source_files        = "PocketSwift/PocketSwift/**/*.{h,m,swift}"
  main.exclude_files       = "PocketSwift/PocketSwiftTests/**/*.{h,m,swift}", "PocketSwift/Pods/*"

  main.swift_version       = "4.2"
  main.cocoapods_version   = ">= 1.4.0"
  main.platform            = :ios, "11.0"

  main.subspec 'Core' do |core|
    core.source_files      = "PocketSwift/PocketSwift/Packages/Core/**/*.{h,m,swift}"
  end

  main.subspec 'Eth' do |eth|
    eth.source_files      = "PocketSwift/PocketSwift/Packages/Eth/**/*.{h,m,swift}"
    eth.dependency "PocketSwift/Core"
    eth.dependency "web3swift", "~> 2.1.2"
    eth.dependency "CryptoSwift"
  end

  main.subspec 'Aion' do |aion|
    aion.source_files      = "PocketSwift/PocketSwift/Packages/Aion/**/*.{h,m,swift}"
    aion.dependency "PocketSwift/Core"
  end

  # Framework dependencies
  main.dependency "RxSwift",    "~> 4.0"
  main.dependency "RxBlocking",    "~> 4.0"
  main.dependency "BigInt"


end
