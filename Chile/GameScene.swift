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
        
        addBg()
    }
    
    func addBg(){
        let background = SKSpriteNode(imageNamed: "bg.jpg")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
    }
    func addChile(){
        let chileImg = SKSpriteNode(imageNamed: "chile.png")
        let size:CGFloat = 30
        let num:CGFloat = 5
        chileImg.size = CGSizeMake(275 / num, 183 / num)
        chileImg.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - size)
        
        chileImg.physicsBody = SKPhysicsBody(rectangleOfSize: chileImg.size)
        
        self.addChild(chileImg)
    }
   
    override func update(currentTime: CFTimeInterval) {
        if Int(currentTime) % 3 == 0{
            if isCreated{
                addChile()
                isCreated = false
            }
        }else{
            isCreated = true
        }
    }
}
