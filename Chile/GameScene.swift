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
        
//        addBox()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name == "box"{
                touchedNode.position = location
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if touchedNode.name == "box"{
                touchedNode.position = location
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    }
    
//    func addBox(){
//        // 四角を作成
//        var box = SKSpriteNode(
//            color: UIColor.greenColor(),
//            size: CGSizeMake(80, 80)
//        )
//        let size:CGFloat = 100
//        box.size = CGSizeMake(size, size)
//        box.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.size.height - size)
//        
//        box.physicsBody = SKPhysicsBody(rectangleOfSize: box.size)
//        box.name = "box"
//        
//        self.addChild(box)
//    }
    
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
