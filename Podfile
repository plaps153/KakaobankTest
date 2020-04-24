platform :ios, '11.0'

target 'KakaoBankTest' do
  use_frameworks!

  # Realm
  pod 'RealmSwift', '~> 3.18.0'
  pod 'RxRealm'
  pod 'ObjectMapper+Realm'

  # RxSwift
  pod 'RxGesture'
  pod 'RxCocoa'
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch => 'webview-compiler-based'
  
  # R.swift
  pod 'R.swift'

  # JSon
  pod 'SwiftyJSON'

  # Log
  pod 'SwiftyBeaver'

post_install do |installer|
    myTargets = ['R.swift.Library']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.2'
            end
        end
    end
end

end
