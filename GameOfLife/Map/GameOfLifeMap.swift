//
//  GameOfLifeMap.swift
//  GameOfLife
//
//  Created by Vyacheslav Konopkin on 20.05.2022.
//

import CoreGraphics
import GameplayKit

enum State: CaseIterable {
    case dead
    case live
}

struct GameOfLifeMap: Map {
    private let size: Size
    private var grid: [[State]]
    private var noise: GKNoiseMap
    
    init(_ size: Size) {
        self.size = size
        let row = Array(repeating: State.dead, count: size.width)
        self.grid = Array(repeating: row, count: size.height)
        self.noise = Self.createNoiseMap(size)
        reset()
    }
    
    mutating func reset() {
        self.noise = Self.createNoiseMap(size)
        for y in 0..<grid.count {
            for x in 0..<grid[0].count {
                let value = noise.value(at: vector_int2(Int32(x), Int32(y)))
                grid[y][x] = (value < 0.6) ? State.live : State.dead
            }
        }
        
//        insertGlider(at: Point(0, 0))
//        insertGlider(at: Point(size.width / 2, size.height / 2))
//        insertBlock(at: Point(size.width / 4, size.height / 4))
    }
    
    private mutating func insertGlider(at point: Point) {
        grid[point.y][point.x + 1] = State.live
        grid[point.y + 1][point.x + 2] = State.live
        for i in point.x+0..<point.x+3 {
            grid[point.y + 2][i] = State.live
        }
    }
    
    private mutating func insertBlinker(at point: Point) {
        for i in point.x+0..<point.x+3 {
            grid[point.y][i] = State.live
        }
    }
    
    private mutating func insertBlock(at point: Point) {
        grid[point.y][point.x] = State.live
        grid[point.y + 1][point.x] = State.live
        grid[point.y][point.x + 1] = State.live
        grid[point.y + 1][point.x + 1] = State.live
    }
    
    mutating func updateObjects() -> [Point] {
        var result = [Point]()
        var newGrid = grid
                
        for y in 0..<grid.count {
            for x in 0..<grid[0].count {
                newGrid[y][x] = getState(at: Point(x, y), grid)
                if newGrid[y][x] == .live {
                    result.append(Point(x, y))
                }
            }
        }
        
        grid = newGrid
        
        return result
    }
    
    private func getState(at point: Point, _ grid: [[State]]) -> State {
        let liveCount = getNeighbors(point, grid)
            .filter { grid[$0.y][$0.x] == State.live }.count
        var result = State.dead
        
        switch grid[point.y][point.x] {
        case State.live:
            result = (liveCount == 2 || liveCount == 3) ? State.live : State.dead
            
        case State.dead:
            result = (liveCount == 3) ? State.live : State.dead
        }
        
        return result
    }
    
    private func getNeighbors(_ point: Point, _ grid: [[State]]) -> [Point] {
        [
            Point(point.x, point.y + 1), // up
            Point(point.x, point.y - 1), // down
            Point(point.x - 1, point.y), // left
            Point(point.x + 1, point.y), // right
            Point(point.x - 1, point.y + 1), // up-left
            Point(point.x + 1, point.y + 1), // up-right
            Point(point.x - 1, point.y - 1), // down-left
            Point(point.x + 1, point.y - 1) // down-right
        ].filter { ($0.x >= 0 && $0.x < grid[0].count) &&
            ($0.y >= 0 && $0.y < grid.count) }
    }
    
    private static func createNoiseMap(_ size: Size) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = -20.0
        source.frequency = -20.0
        source.octaveCount = 12
        source.lacunarity = 1
        source.seed = Int32.random(in: 0..<Int32.max)
        return GKNoiseMap(GKNoise(source),
                          size: vector_double2(1.0, 1.0), origin: vector_double2(0.0, 0.0),
                          sampleCount: vector_int2(Int32(size.width), Int32(size.height)),
                          seamless: false)
    }
}
