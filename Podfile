# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SampleApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SampleApp
  pod 'Alamofire'
	pod 'AlamofireImage', '~> 4.3'
	pod 'IQKeyboardManagerSwift'
	pod 'SkeletonView'
	pod 'SwiftLint'
	pod 'SwiftKeychainWrapper'
	pod 'TweeTextField'
	pod 'NotificationBannerSwift', '~> 3.0.0'
	pod 'PaddingLabel', '1.2'
	pod 'Refreshable'
	pod "SwiftSignatureView"
	pod 'FittedSheets'
	pod 'AlamofireImage', '~> 4.3'
	pod "BSImagePicker", "~> 3.1"

  target 'SampleAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SampleAppUITests' do
    # Pods for testing
  end

end

# post install
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'No'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
	config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
  
     end
  end
end

