use_frameworks!

pod "TextFieldEffects"
pod "Koloda"
pod "WYMaterialButton"
pod 'SCLAlertView'
pod 'EasyAnimation'
pod 'PermissionScope'


post_install do |installer|
    `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end