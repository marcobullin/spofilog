source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!
pod 'UAAppReviewManager'
pod 'Realm', '~> 0.85'
pod 'iOSPlot', '~> 1.0'
#pod 'FLEX', '~> 1.1'
pod 'GoogleAnalytics-iOS-SDK', '~> 3.0'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
