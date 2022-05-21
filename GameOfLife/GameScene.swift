//
//  GameScene.swift
//  GameOfLife
//
//  Created by Vyacheslav Konopkin on 20.05.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var dimensions: GameDimensions!
    private var gameMap: Map!
    
    private var spriteMap = SKNode()
    
    private var timer = GameTimer(seconds: 1.0 / 3)
    
    override func didMove(to view: SKView) {
        dimensions = GameDimensions(size)
        gameMap = GameOfLifeMap(dimensions.mapSize())
        
        gameMap.updateObjects().forEach {
            let node = createLifeNode()
            node.position = getPosition(from: $0)
            spriteMap.addChild(node)
        }
        
        addChild(spriteMap)
    }
    
    override func update(_ currentTime: TimeInterval) {
        timer.update(time: currentTime)
        guard timer.isTimeout() else { return }

        clear()

        for (index, object) in gameMap.updateObjects().enumerated() {
            let node = getLifeNode(at: index)
            node.position = getPosition(from: object)
            node.isHidden = false
        }

        timer.reset()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Fade in/out
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        spriteMap.run(SKAction.sequence([fadeOut, fadeOut.reversed()]))

        // Reset
        gameMap.reset()
        timer.reset()
    }
    
    private func clear() {
        spriteMap.children.forEach { $0.isHidden = true }
    }
    
    private func createLifeNode() -> SKNode {
        let node = SKShapeNode(rectOf: dimensions.tileSize(), cornerRadius: 4)
        node.fillColor = UIColor.red
        node.strokeColor = UIColor.blue
        node.glowWidth = 0.5
        return node
    }
    
    private func getLifeNode(at index: Int) -> SKNode {
        if index >= spriteMap.children.count {
            let node = createLifeNode()
            spriteMap.addChild(node)
        }
        return spriteMap.children[index]
    }
    
    private func getPosition(from point: Point) -> CGPoint {
        let tileSize = dimensions.tileSize()
        return CGPoint(x: (CGFloat(point.x) * tileSize.width),
                       y: (CGFloat(point.y) * tileSize.height))
    }
}
