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
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
//            addChile(location)
        }
    }
    
    func addChile(){
        let chileImg = SKSpriteNode(imageNamed: "cat.jpeg")
        let size:CGFloat = 30
        chileImg.size = CGSizeMake(size, size)
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
