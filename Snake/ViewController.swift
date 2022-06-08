//
//  ViewController.swift
//  Snake
//
//  Created by anny on 2022/6/6.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var timer:Timer?
    
    let size = 20
    
    //範圍 CGFloat
    var areaWidth: CGFloat!
    var areaHeight: CGFloat!
    
    //範圍 格子
    var areaX: Int!
    var areaY: Int!
    
    //水果
    var foodX: Int!
    var foodY: Int!
    
    var foodView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))

    // 預設方向朝右
    var direction: Direction = .right

    // 蛇身view
    var snakeView = [UIView]()
    
    // 蛇身節點位置
    var points = [Point]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for direction in [UISwipeGestureRecognizer.Direction.up,
                          UISwipeGestureRecognizer.Direction.down,
                          UISwipeGestureRecognizer.Direction.left,
                          UISwipeGestureRecognizer.Direction.right] {
    
            let swipe = UISwipeGestureRecognizer(target:self, action:#selector(swipe))
            swipe.direction = direction
            swipe.numberOfTouchesRequired = 1
            self.view.addGestureRecognizer(swipe)
        }
    }
    
    @objc func swipe(recognizer: UISwipeGestureRecognizer){
        let direction = recognizer.direction
        
        switch direction {
            case .up:
                print("up")
                self.direction = .up
            
            case .down:
                print("down")
                self.direction = .down
            
            case .left:
                print("left")
                self.direction = .left
            
            case .right:
                print("right")
                self.direction = .right
            
            default:
                print("")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        areaWidth = areaView.frame.size.width
        areaHeight = areaView.frame.size.height
        
        areaX = Int(areaWidth) / 20
        areaY = Int(areaHeight) / 20
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }

    @IBAction func startGame(_ sender: Any) {
        self.startButton.isHidden = true
        self.startButton.setTitle("Try again !", for: .normal)
        self.start()
    }
    
    func resetGame() {
        self.foodView.removeFromSuperview()
        
        for snake in snakeView {
            snake.removeFromSuperview()
        }
        snakeView = [UIView]()
        points = [Point]()
    }
    
    func start(){
        self.resetGame()
        
        points.append(Point(x: areaX / 2, y: areaY / 2))
        snakeView.append(UIView.init(frame: CGRect(x: points[0].x * 20,
                                                   y: points[0].y * 20,
                                                   width: 20, height: 20)))
        
        points.append(Point(x: (areaX / 2) - 1 , y: areaY / 2))
        
        snakeView.append(UIView.init(frame: CGRect(x: (points[1].x) * 20,
                                                   y: points[1].y * 20,
                                                   width: 20, height: 20)))
        
        
        snakeView[0].backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        snakeView[1].backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        self.areaView.insertSubview(snakeView[0], belowSubview: startButton)
        self.areaView.insertSubview(snakeView[1], belowSubview: startButton)
        
        self.makeNewFood()
        
        print("~~~~~ start point")
        print(points)
        print("===============")
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
          
    @objc func timerAction() {
        
        if (points[0].x == foodX) && (points[0].y == foodY) {
            print("碰到水果")
            self.increaseSnakeLength()
        }
        
        self.move()
        self.drewSnake()
    }
    
    func move(){
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
        
        points.insert(newPoint, at: 0)
        points.remove(at: points.count - 1)

        print(points)
        print("~~~~~")
        
        self.checkArea()
    }
    
    func drewSnake() {
        
        for i in 0..<points.count {
            
            snakeView[i].frame = CGRect(x: points[i].x * 20, y: points[i].y * 20,
                                        width: 20, height: 20)
        }
    }
    
    
    func makeNewFood(){
        foodX = Int.random(in: 0..<areaX - 1)
        foodY = Int.random(in: 0..<areaY - 1)

        for point in points {
            if (point.x == foodX) && (point.y == foodY) {
                print("~~~ 食物長在蛇身上了！！！")
                makeNewFood()
                break
            }
        }
        
        print("!!! makeNewFruit x: \(foodX), y: \(foodY)")
        
        foodView.frame = CGRect(x: foodX * 20, y: foodY * 20, width: 20, height: 20)
        foodView.backgroundColor = .red
        
        self.areaView.insertSubview(foodView, belowSubview: startButton)
    }
    
    func increaseSnakeLength(){
        
        points.append(Point(x: foodX, y: foodY))
        snakeView.append(UIView.init(frame: CGRect(x: foodX * 20,
                                                   y: foodY * 20,
                                                   width: 20, height: 20)))
        snakeView[snakeView.count - 1].backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        self.areaView.insertSubview(snakeView[snakeView.count - 1], belowSubview: startButton)
        
        self.makeNewFood()
        
    }
    
    func checkArea(){
        
        // 碰到範圍結束遊戲
        if Int(points[0].x) < 0 || Int(points[0].x + 1) * 20 >= Int(areaWidth) {
            print("!!!!! Game Over")
            self.endGame()
        }
        if Int(points[0].y) < 0 || Int(points[0].y + 1) * 20 >= Int(areaHeight) {
            print("!!!!! Game Over")
            self.endGame()
        }
        
        // 碰到蛇自己身體結束遊戲
        let headPoint = points[0]
        for bodyPoint in self.points[1..<points.count]{
            if (bodyPoint.x == headPoint.x) && (bodyPoint.y == headPoint.y) {
                print("!!!!! Game Over")
                self.endGame()
            }
        }
        
    }
    
    func endGame() {
        self.startButton!.isHidden = false
        self.timer!.invalidate()
        self.timer = nil
    }
}

enum Direction: Int {
    case left
    case right
    case up
    case down
}

struct Point {
    var x: Int
    var y: Int
}
