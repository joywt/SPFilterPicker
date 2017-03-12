//
//  OnOffSwitch.swift
//  SPFilterPicker
//
//  Created by wang tie on 2017/3/10.
//  Copyright © 2017年 360jk. All rights reserved.
//

import Foundation

protocol Togglable {
    mutating func toggle()
}
public enum OnOffSwitch:Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        case .On:
            self = .Off
        }
    }
}
