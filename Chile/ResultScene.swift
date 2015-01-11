//
//  ResultScene.swift
//  Chile
//
//  Created by naoyashiga on 2015/01/10.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import spriteKit

class ResultScene: SKScene {
    var delegate_escape: SceneEscapeProtocol?
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        
        addScore()
        addRetry()
        addRanking()
    }
    
    func addScore(){
        var resultLabel = SKLabelNode()
        
        resultLabel.text = "100"
        resultLabel.fontSize = 100
        resultLabel.fontColor = UIColor.whiteColor()
        resultLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: 200))
        
        resultLabel.fontName = "Marker Felt Thin"
        self.addChild(resultLabel)
    }
    
    func addRetry(){
        var retryLabel = SKLabelNode()
        
        retryLabel.text = "Retry"
        retryLabel.fontSize = 100
        retryLabel.fontColor = UIColor.whiteColor()
        retryLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: 300))
        
        retryLabel.fontName = "Marker Felt Thin"
        retryLabel.name = "retry"
        self.addChild(retryLabel)
    }
    
    func addRanking(){
        var rankingLabel = SKLabelNode()
        
        rankingLabel.text = "Ranking"
        rankingLabel.fontSize = 100
        rankingLabel.fontColor = UIColor.whiteColor()
        rankingLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: 400))
        
        rankingLabel.fontName = "Marker Felt Thin"
        self.addChild(rankingLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
            var touchedName = self.nodeAtPoint(location)
            
            if touchedName.name == "retry" {
                delegate_escape?.sceneEscape(self)
//                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 1)
//                let skView:SKView = self.view as SKView!
//                let newScene = GameScene(size: self.size)
//                newScene.scaleMode = SKSceneScaleMode.AspectFill
//                skView.presentScene(newScene, transition: transition)
            }
        }
        
    }
}
