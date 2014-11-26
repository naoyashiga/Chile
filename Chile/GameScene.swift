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
        addWall()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            addSquare(location)
        }
    }
    
    func addSquare(location:CGPoint){
        var square:SKSpriteNode = SKSpriteNode(
            color: UIColor.redColor(), size: CGSizeMake(20, 20))
        
        square.position = location
        square.physicsBody = SKPhysicsBody(rectangleOfSize: square.size)
        
        self.addChild(square)
    }
   
    func addWall(){
        var wall:SKSpriteNode = SKSpriteNode(
            color: UIColor.blackColor(), size: CGSizeMake(self.frame.size.width, 40))
        
        wall.position = CGPoint(x:CGRectGetMidX(self.frame), y:0)
        wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
        
        //重力を無視
        wall.physicsBody?.affectedByGravity = false
        
        //ぶつかっても動かない
        wall.physicsBody?.dynamic = false
        
        self.addChild(wall)
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
