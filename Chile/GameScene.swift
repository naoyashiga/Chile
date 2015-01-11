//
//  GameScene.swift
//  Chile
//
//  Created by naoyashiga on 2014/11/26.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var delegate_escape: SceneEscapeProtocol?
    var chiles:NSMutableArray!
    var scoreLabel:SKLabelNode!
    override func didMoveToView(view: SKView) {
        let wallHeight:CGFloat = 103.0
        chiles = NSMutableArray()
        self.size = view.bounds.size
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        self.physicsWorld.gravity = CGVectorMake(0, 3.0)
        
        self.physicsBody = SKPhysicsBody(
            edgeFromPoint:CGPoint(x: CGRectGetMidX(self.frame) - 100, y: wallHeight),
            toPoint: CGPoint(x: CGRectGetMidX(self.frame) + 100, y: wallHeight))
        self.backgroundColor = UIColor.blackColor()
        
        
        self.view?.showsNodeCount = true
        self.view?.showsFPS = true
        
        // タップを認識.
//        let myTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
//        myTap.numberOfTapsRequired = 1
//        myTap.numberOfTouchesRequired = 1
//        self.view?.addGestureRecognizer(myTap)
        
        addGround()
        addScore()
    }
    
    func addScore(){
        scoreLabel = SKLabelNode()
        
        scoreLabel.text = "0"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: 200))
        
        scoreLabel.fontName = "Marker Felt Thin"
        self.addChild(scoreLabel)
    }
    
    func addGround(){
        var ground = SKSpriteNode(
            color: UIColor.greenColor(),
            size: CGSizeMake(200, 50)
        )
        
        let size:CGFloat = 100
        let num:CGFloat = 10
        ground.position = CGPoint(x: CGRectGetMidX(self.frame), y: size)
//        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        
        self.addChild(ground)
    }
    
    func addChile(pos:CGPoint) -> Chile{
        var chile = Chile()
        chile.position = CGPoint(x: pos.x, y: pos.y)
        self.addChild(chile)
        
        return chile
    }
    
    override func update(currentTime: CFTimeInterval) {
        for child in self.children {
            //画面外
            if child.frame.midY < 0 {
                println("out")
                var chileCount = self.children.count - 2
                let ud = NSUserDefaults.standardUserDefaults()
                
                child.removeFromParent()
                scoreLabel.text = String(chileCount)
                
                //ベストスコア更新
                if chileCount > ud.integerForKey("bestScore") {
                    ud.setInteger(chileCount, forKey: "bestScore")
                }
                
                //今回のスコア
                ud.setInteger(chileCount, forKey: "currentScore")
                
                delegate_escape?.sceneEscape(self)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("start")
        println(self.children.count)
        
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
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
        for chile:AnyObject in chiles {
            var c = chile as Chile
            c.physicsBody = SKPhysicsBody(rectangleOfSize: chile.size)
        }
        scoreLabel.text = String(self.children.count - 2)
    }
    
    func tapGesture(sender: UITapGestureRecognizer){
        println("tap")
//        var tapPositionOneFingerTap = sender.locationInView(self.view)
        
        //ビュー座標からシーン座標に変換
//        tapPositionOneFingerTap = convertPointFromView(tapPositionOneFingerTap)
//        addChile(tapPositionOneFingerTap)
        for chile:AnyObject in chiles {
            var c = chile as Chile
            c.physicsBody = SKPhysicsBody(rectangleOfSize: chile.size)
            
        }
//        var chile = chiles.lastObject as Chile
//        chile.physicsBody = SKPhysicsBody(rectangleOfSize: chile.size)
        scoreLabel.text = String(self.children.count - 2)
    }
}
