//
//  Timer.swift
//  GameOfLife
//
//  Created by Vyacheslav Konopkin on 20.05.2022.
//

import Foundation

struct GameTimer {
    private var startTime = TimeInterval.zero
    private var lastTime = TimeInterval.zero
    private let timeout: TimeInterval
    
    init(seconds timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    mutating func update(time: TimeInterval) {
        self.lastTime = time
        if self.startTime == TimeInterval.zero {
            self.startTime = time
        }
    }
    
    mutating func reset() {
        startTime = TimeInterval.zero
    }
    
    func isTimeout() -> Bool {
        return (lastTime - startTime) > timeout
    }
}
