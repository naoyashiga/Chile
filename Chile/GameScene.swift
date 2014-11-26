//
//  GameScene.swift
//  Chile
//
//  Created by naoyashiga on 2014/11/26.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.size = view.bounds.size
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        addWall()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            addChile(location)
        }
    }
    
    func addChile(location:CGPoint){
        let chileImg = SKSpriteNode(imageNamed: "cat.jpeg")
        chileImg.size = CGSizeMake(40, 40)
        chileImg.position = location
        
        chileImg.position = location
        chileImg.physicsBody = SKPhysicsBody(rectangleOfSize: chileImg.size)
        
        self.addChild(chileImg)
    }
   
//    func addWall(){
//        let thickness:CGFloat = 10
//        let screenWidth:CGFloat = self.frame.size.width
//        let screenHeight:CGFloat = self.frame.size.height
//        
//        var wall:SKSpriteNode = SKSpriteNode(
//            color: UIColor.blackColor(),
//            size: CGSizeMake(screenWidth, thickness)
//            )
//        
//        wall.position = CGPoint(x:CGRectGetMidX(self.frame), y:0)
//        wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
//        
//        //重力を無視
//        wall.physicsBody?.affectedByGravity = false
//        
//        //ぶつかっても動かない
//        wall.physicsBody?.dynamic = false
//        
//        self.addChild(wall)
//        
//        //右壁
//        var rightWall:SKSpriteNode = SKSpriteNode(
//            color: UIColor.blackColor(),
//            size: CGSizeMake(thickness, screenHeight)
//            )
//        
//        println(CGRectGetMaxX(self.frame))
//        println(CGRectGetMidX(self.frame))
//        println(screenWidth)
//        rightWall.position = CGPoint(x:CGRectGetMaxX(self.frame), y:CGRectGetMidY(self.frame))
////        rightWall.position = CGPoint(x:screenWidth - thickness, y:0)
//        rightWall.physicsBody = SKPhysicsBody(rectangleOfSize: rightWall.size)
//        
//        //重力を無視
//        rightWall.physicsBody?.affectedByGravity = false
//        
//        //ぶつかっても動かない
//        rightWall.physicsBody?.dynamic = false
//        
//        self.addChild(rightWall)
//    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
