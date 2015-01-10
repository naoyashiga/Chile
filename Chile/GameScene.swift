//
//  GameScene.swift
//  Chile
//
//  Created by naoyashiga on 2014/11/26.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var isCreated:Bool = true
    var chiles:NSMutableArray!
    var scoreLabel:SKLabelNode!
    override func didMoveToView(view: SKView) {
        chiles = NSMutableArray()
        self.size = view.bounds.size
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        self.physicsWorld.gravity = CGVectorMake(0, 3.0)
        
        self.physicsBody = SKPhysicsBody(
            edgeFromPoint:CGPoint(x: CGRectGetMidX(self.frame) - 100, y: 10),
            toPoint: CGPoint(x: CGRectGetMidX(self.frame) + 100, y: 10))
        self.backgroundColor = UIColor.blackColor()
        
        
        self.view?.showsNodeCount = true
        self.view?.showsFPS = true
        
        // タップを認識.
        let myTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        myTap.numberOfTapsRequired = 1
        myTap.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(myTap)
        
        addGround()
        addScore()
    }
    
    func addScore(){
        scoreLabel = SKLabelNode()
        
        scoreLabel.text = "Chile:0"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: 100))
        
        scoreLabel.fontName = "Apple-SD-GothicNeo-ExtraBold"
        self.addChild(scoreLabel)
    }
    
    func addGround(){
        var ground = SKSpriteNode(
            color: UIColor.greenColor(),
            size: CGSizeMake(200, 10)
        )
        
        let size:CGFloat = 10
        let num:CGFloat = 10
        ground.position = CGPoint(x: CGRectGetMidX(self.frame), y: size)
//        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        
        self.addChild(ground)
    }
    
    func addChile(pos:CGPoint) -> Chile{
        var chile = Chile()
        chile.position = CGPoint(x: pos.x, y: pos.y)
//        chileImg.zRotation = CGFloat(arc4random_uniform(360))
        
//        chileImg.physicsBody = SKPhysicsBody(rectangleOfSize: chileImg.size)
        
        self.addChild(chile)
        
        return chile
    }
    
    func removeNode(){
        self.removeAllChildren()
    }
   
    override func update(currentTime: CFTimeInterval) {
        for child in self.children {
            //画面外
            if child.position.y < 0 {
                child.removeFromParent()
                scoreLabel.text = "Chile:" + String(self.children.count)
                println("out")
            }
        }
        
//        if Int(currentTime) % 2 == 0{
//            if isCreated{
//                for _ in 1...10 {
//                    addChile()
//                }
//                isCreated = false
//            }
//        }else{
//            isCreated = true
//        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("start")
        println(self.children.count)
        
//        scoreLabel.text = "Chile:" + String(self.children.count - 1)
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            chiles.addObject(self.addChile(location))
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var chile = chiles.lastObject as Chile
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            chile.position = location
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        println("end")
        var chile = chiles.lastObject as Chile
        chile.physicsBody = SKPhysicsBody(rectangleOfSize: chile.size)
        scoreLabel.text = "Chile:" + String(self.children.count - 2)
    }
    
    func tapGesture(sender: UITapGestureRecognizer){
        println("tap")
//        var tapPositionOneFingerTap = sender.locationInView(self.view)
        
        //ビュー座標からシーン座標に変換
//        tapPositionOneFingerTap = convertPointFromView(tapPositionOneFingerTap)
//        addChile(tapPositionOneFingerTap)
        var chile = chiles.lastObject as Chile
        chile.physicsBody = SKPhysicsBody(rectangleOfSize: chile.size)
        scoreLabel.text = "Chile:" + String(self.children.count - 2)
    }
}
