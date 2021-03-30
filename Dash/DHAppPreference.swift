//
//  AppPreference.swift
//  Dash iOS
//
//  Created by chenhaoyu.1999 on 2021/3/29.
//  Copyright © 2021 Kapeli. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefaultsBacked<Value> {
    var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }

    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults

    init(wrappedValue defaultValue: Value,
         key: String,
         storage: UserDefaults = .standard) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

@objc class DHAppPreference: NSObject {
    @UserDefaultsBacked(wrappedValue: UITraitCollection.current.userInterfaceStyle.rawValue, key: "customInterfaceStyle") private var customInterfaceStyleRawValue: Int
    var customInterfaceStyle: UIUserInterfaceStyle {
        set {
            customInterfaceStyleRawValue = newValue.rawValue
            NotificationCenter.default.post(name: DHUserInterfaceStyleHasChanged, object: nil, userInfo: [DHThemeKey: newValue])
        }
        get {
            UIUserInterfaceStyle(rawValue: customInterfaceStyleRawValue)!
        }
    }
    
    @UserDefaultsBacked(wrappedValue: true, key: "followSystemSetting") var followSystemSetting: Bool
    
    static var shared = DHAppPreference()
    
    private override init() { }
}
