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
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.backgroundColor = UIColor.blackColor()
        
    }
    
    func addChile(){
        let chileImg = SKSpriteNode(imageNamed: "chile.png")
        let size:CGFloat = 30
        let num:CGFloat = 10
        chileImg.size = CGSizeMake(275 / num, 183 / num)
        chileImg.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - size)
        chileImg.zRotation = CGFloat(arc4random_uniform(360))
        
        chileImg.physicsBody = SKPhysicsBody(rectangleOfSize: chileImg.size)
        
        self.addChild(chileImg)
    }
    
    func removeNode(){
        self.removeAllChildren()
    }
   
    override func update(currentTime: CFTimeInterval) {
        if Int(currentTime) % 2 == 0{
            if isCreated{
                for var i = 0;i < 10;i++ {
                    addChile()
                    
                }
                isCreated = false
            }
        }else{
            isCreated = true
        }
    }
}
