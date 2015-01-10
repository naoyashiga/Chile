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
    override func didMoveToView(view: SKView) {
        self.size = view.bounds.size
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = SKPhysicsBody(
            edgeFromPoint:CGPoint(x: CGRectGetMidX(self.frame) - 40, y: 0),
            toPoint: CGPoint(x: CGRectGetMidX(self.frame) + 40, y: 0))
        self.backgroundColor = UIColor.blackColor()
        
        
        self.view?.showsNodeCount = true
        self.view?.showsFPS = true
        
        // タップを認識.
        let myTap = UITapGestureRecognizer(target: self, action: "tapGesture:")
        myTap.numberOfTapsRequired = 1
        myTap.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(myTap)
        
        addGround()
    }
    
    func addGround(){
        var ground = SKSpriteNode(
            color: UIColor.greenColor(),
            size: CGSizeMake(80, 80)
        )
        
        let size:CGFloat = 30
        let num:CGFloat = 10
        ground.position = CGPoint(x: CGRectGetMidX(self.frame), y: size)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        
        self.addChild(ground)
    }
    
    func addChile(pos:CGPoint){
        let chileImg = SKSpriteNode(imageNamed: "chile.png")
        let size:CGFloat = 30
        let num:CGFloat = 10
        chileImg.size = CGSizeMake(275 / num, 183 / num)
//        chileImg.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - size)
        chileImg.position = CGPoint(x: pos.x, y: pos.y)
//        chileImg.zRotation = CGFloat(arc4random_uniform(360))
        
        chileImg.physicsBody = SKPhysicsBody(rectangleOfSize: chileImg.size)
        
        self.addChild(chileImg)
    }
    
    func removeNode(){
        self.removeAllChildren()
    }
   
    override func update(currentTime: CFTimeInterval) {
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
    
    func tapGesture(sender: UITapGestureRecognizer){
        println("tap")
        var tapPositionOneFingerTap = sender.locationInView(self.view)
        
        //ビュー座標からシーン座標に変換
        tapPositionOneFingerTap = convertPointFromView(tapPositionOneFingerTap)
        addChile(tapPositionOneFingerTap)
    }
}
