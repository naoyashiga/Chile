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
        addBestScore()
        addRetry()
        addRanking()
    }
    
    func addScore(){
        let ud = NSUserDefaults.standardUserDefaults()
        var resultLabel = SKLabelNode()
        
        resultLabel.text = String(ud.integerForKey("currentScore"))
        resultLabel.fontSize = 100
        resultLabel.fontColor = UIColor.whiteColor()
        resultLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: 200))
        
        resultLabel.fontName = "Marker Felt Thin"
        self.addChild(resultLabel)
    }
    
    func addBestScore(){
        let ud = NSUserDefaults.standardUserDefaults()
        var bestScoreLabel = SKLabelNode()
        
        bestScoreLabel.text = "Best:" + String(ud.integerForKey("bestScore"))
        bestScoreLabel.fontSize = 30
        bestScoreLabel.fontColor = UIColor.whiteColor()
        bestScoreLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 50))
        bestScoreLabel.fontName = "Marker Felt Thin"
        
        self.addChild(bestScoreLabel)
    }
    func addRetry(){
        var retryLabel = SKLabelNode()
        
        retryLabel.text = "Retry"
        retryLabel.fontSize = 60
        retryLabel.fontColor = UIColor.whiteColor()
        retryLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 50))
        
        retryLabel.fontName = "Marker Felt Thin"
        retryLabel.name = "retry"
        self.addChild(retryLabel)
    }
    
    func addRanking(){
        var rankingLabel = SKLabelNode()
        
        rankingLabel.text = "Ranking"
        rankingLabel.fontSize = 60
        rankingLabel.fontColor = UIColor.whiteColor()
        rankingLabel.position = convertPointFromView(CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 150))
        rankingLabel.fontName = "Marker Felt Thin"
        rankingLabel.name = "ranking"
        
        self.addChild(rankingLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            var location = touch.locationInNode(self)
            var touchedName = self.nodeAtPoint(location)
            
            if touchedName.name == "retry" {
                delegate_escape?.sceneEscape(self)
            }else if touchedName.name == "ranking" {
                
            }
        }
        
    }
}
