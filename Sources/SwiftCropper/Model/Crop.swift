//
//  Crop.swift
//
//
//  Created by mohamed ahmed on 16/10/2023.
//

import Foundation

//MARK: - Crop Config

public enum Crop: Equatable {
    case circle(Double)
    case rectangle(CGSize)
    case square(Double)
    case custom(CGSize)
    
    func name() -> String {
        switch self {
        case let .circle(diameter):
            return "Circle (r = \(diameter/2)"
        case let .rectangle(cGSize):
            return "Rectangle \(Int(cGSize.width))*\(Int(cGSize.height))"
        case let .square(cGSize):
            return "Square \(Int(cGSize))*\(Int(cGSize))"
        case let .custom(cGSize):
            return "Custom \(Int(cGSize.width))*\(Int(cGSize.height))"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case let .circle(diameter):
            return .init(width: diameter, height: diameter)
        case let .rectangle(cGSize):
            return .init(width: cGSize.width, height: cGSize.height)
        case let .square(cGSize):
            return .init(width: cGSize, height: cGSize)
        case let .custom(cGSize):
            return .init(width: cGSize.width, height: cGSize.height)
        }
    }
}
