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
    
    let gridSize = 20
    
    //safe area
    var areaWidth: CGFloat!
    var areaHeight: CGFloat!
    
    //safe area grid
    var areaX: Int!
    var areaY: Int!
    
    // food
    var foodPoint: Point!
    var foodView = UIView.init()

    // snake
    var snake: Snake?
    var snakeView = [UIView]()

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
                self.snake?.direction = .up
         
            case .down:
                self.snake?.direction = .down

            case .left:
                self.snake?.direction = .left

            case .right:
                self.snake?.direction = .right
            
            default:
                print("")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        areaWidth = areaView.frame.size.width
        areaHeight = areaView.frame.size.height
        
        areaX = Int(areaWidth) / gridSize
        areaY = Int(areaHeight) / gridSize
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }

    @IBAction func start(_ sender: Any) {
        self.startButton.isHidden = true
        self.startButton.setTitle("Try again !", for: .normal)
        self.startGame()
    }
    
    func endGame() {
        self.startButton.isHidden = false
        self.timer!.invalidate()
        self.timer = nil
    }
    
    func resetGame() {

        self.foodView.removeFromSuperview()
        
        for snake in snakeView {
            snake.removeFromSuperview()
        }
        snakeView = [UIView]()
    }
    
    func startGame(){
        self.resetGame()
        
        // set snake init point
        var points = [Point]()
        
        for i in 0...2 {
            points.append(Point(x: (areaX / 2) - i, y: areaY / 2))
        }
        
        self.snake = Snake(points: points)
        
        // set snake init body view
        for i in 0...2 {
            self.createSnakeView(point: points[i])
        }

        self.makeNewFood()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
          
    @objc func timerAction() {
        
        guard let newHeadPoint = self.snake?.getNewHeadPoint() else { return }
        
        self.snake?.move()
        self.drewSnake()
        
        if self.snake?.isHitBody(newHeadPoint: newHeadPoint) == true ||
            self.isHitArea(newHeadPoint: newHeadPoint) == true {
            
            self.endGame()
            return
        }
        
        if (newHeadPoint.x == foodPoint.x) && (newHeadPoint.y == foodPoint.y) {
            self.snake?.increaseSnakeLength(point: foodPoint)
            self.createSnakeView(point: foodPoint)
            self.makeNewFood()
        }
    }
    
    func makeNewFood(){
        var x = 0, y = 0
        guard let points = self.snake?.points else { return }

        while (true){
            var isInSnakeBody = false
            x = Int.random(in: 0..<areaX)
            y = Int.random(in: 0..<areaY)
            
            for point in points {
                if (point.x == x) && (point.y == y) {
                    isInSnakeBody = true
                    break
                }
            }
            
            if !isInSnakeBody{
                break
            }
        }

        foodPoint = Point(x: x, y: y)
        foodView.frame = CGRect(x: x * gridSize, y: y * gridSize, width: gridSize, height: gridSize)
        foodView.backgroundColor = .red
        self.areaView.insertSubview(foodView, belowSubview: snakeView[0])

    }
    
    func isHitArea(newHeadPoint: Point) -> Bool {
        
        if Int(newHeadPoint.x) < 0 || Int(newHeadPoint.x + 1) * gridSize > Int(areaWidth) {
            return true
        }
        if Int(newHeadPoint.y) < 0 || Int(newHeadPoint.y + 1) * gridSize > Int(areaHeight) {
            return true
        }

        return false
    }
    
    func createSnakeView(point:Point){
        let view = UIView.init(frame: CGRect(x: point.x * gridSize,
                                             y: point.y * gridSize,
                                             width: gridSize, height: gridSize))
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        if snakeView.count == 0 {
            view.backgroundColor = self.snake?.headColor
            self.areaView.insertSubview(view, belowSubview: startButton)
            
        }else{
            view.backgroundColor = self.snake?.bodyColor
            self.areaView.insertSubview(view, belowSubview: snakeView[0])
        }
        
        snakeView.append(view)
        
    }
    
    func drewSnake() {
        
        guard let points = self.snake?.points else { return }
        
        for i in 0..<points.count {
            
            snakeView[i].frame.origin.x = CGFloat(points[i].x * gridSize)
            snakeView[i].frame.origin.y = CGFloat(points[i].y * gridSize)
        }
    }
}
