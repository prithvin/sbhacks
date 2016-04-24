source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod "TextFieldEffects"
pod "Koloda"
pod "WYMaterialButton"
pod 'SCLAlertView'
pod 'EasyAnimation'
pod 'PermissionScope'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'Alamofire', '~> 3.3'


post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end