//
//  DefaultSettings.swift
//  Weather App v2.0
//
//  Created by Ilya Senchukov on 17.03.2021.
//

import Foundation

class DefaultSettings {

    static let shared = DefaultSettings()

    private let defaultIDs = [
        "703448",
        "702658"
    ]

    private let key = "cities"

    func setDefaultIDs() {
        if getIDs() == nil {
            setIDs(defaultIDs)
        }
    }

    func addId(id: String) {
        guard var ids = getIDs() else {
            return
        }

        ids.append(id)

        setIDs(ids)
    }

    func getIDs() -> [String]? {
        return UserDefaults.standard.stringArray(forKey: key)
    }

    private func setIDs(_ ids: [String]) {
        UserDefaults.standard.setValue(ids, forKey: key)
    }
}
