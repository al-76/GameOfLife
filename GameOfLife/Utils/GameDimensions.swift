//
//  GameDimensions.swift
//  GameOfLife
//
//  Created by Vyacheslav Konopkin on 20.05.2022.
//

import Foundation
import UIKit

struct GameDimensions {
    let size: CGSize
    
    init(_ scene: CGSize) {
        self.size = scene
    }
    
    func tileSize() -> CGSize {
        let width = min(size.width, size.height)
        return CGSize(width: (width / 24), height: (width / 24))
    }
    
    func mapSize() -> Size {
        let tileSize = tileSize()
        return Size(Int(size.width / tileSize.width),
                    Int(size.height / tileSize.height))
    }
}
