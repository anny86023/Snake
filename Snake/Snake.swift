//
//  Snake.swift
//  Snake
//
//  Created by anny on 2022/6/8.
//

import Foundation
import UIKit

struct Point {
    var x: Int
    var y: Int
}

enum Direction: Int {
    case left
    case right
    case up
    case down
}

class Snake {
    
    var headColor: UIColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    var bodyColor: UIColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    var points = [Point]()
    var direction:Direction = .right
    
    init(points: [Point]) {
        self.points = points
    }
    
    func getNewHeadPoint() -> (Point){
        var newPoint = points[0]
        
        switch direction {
            case .up:
                print("往上移動")
                newPoint.y -= 1
            
            case .down:
                print("往下移動")
                newPoint.y += 1
            
            case .left:
                print("往左移動")
                newPoint.x -= 1
    
            case .right:
                print("往右移動")
                newPoint.x += 1
            
        }
        
        return newPoint
    }
       
    func move() {
        points.removeLast()
        let head = getNewHeadPoint()
        points.insert(head, at: 0)

    }
    
    func increaseSnakeLength(foodX: Int, foodY: Int){
        points.append(Point(x: foodX, y: foodY))
    }
    
    func isHitBody(newHeadPoint: Point) -> Bool {
        
        for bodyPoint in self.points[1..<points.count]{
            if (bodyPoint.x == newHeadPoint.x) && (bodyPoint.y == newHeadPoint.y) {
                print("!!!!! 撞到身體")
                return true
            }
        }
        
        return false
    }
}
