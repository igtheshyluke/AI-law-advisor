//
//  APIkeyPropertyWrapper.swift
//  LegalAdvice
//
//  Created by Rakan on 2023/10/19.
//

import Foundation

@propertyWrapper
struct APIKey {
    private let key: String
    private let defaultValue: String

    init(_ key: String, default defaultValue: String) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: String {
        get {
            return UserDefaults.standard.string(forKey: key) ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
