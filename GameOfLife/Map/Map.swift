//
//  Map.swift
//  GameOfLife
//
//  Created by Vyacheslav Konopkin on 20.05.2022.
//

import CoreGraphics

typealias Point = (x: Int, y: Int)
typealias Size = (width: Int, height: Int)

protocol Map {
    mutating func reset()
    mutating func updateObjects() -> [Point]
}
