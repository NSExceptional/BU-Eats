inhibit_all_warnings!
platform :ios, '8.0'

target 'BU Eats' do
  pod 'NSDate-Extensions'
  pod 'ObjectiveGumbo'
  pod 'TBAlertController'
  pod 'Masonry'
  pod 'AutoCoding'
  pod 'Mantle'
  pod 'TBURLRequestOptions'

  target 'BU EatsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
    end
  end
end
