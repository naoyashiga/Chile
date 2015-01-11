//
//  GameViewController.swift
//  Chile
//
//  Created by naoyashiga on 2014/11/26.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, SceneEscapeProtocol {
    var chileScene:GameScene?
    var skView:SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = self.view as? SKView
        skView!.ignoresSiblingOrder = true
        goGame()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func goGame(){
        var gameScene = GameScene(size: skView!.bounds.size)
        gameScene.delegate_escape = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.skView!.presentScene(gameScene)
    }
    
    func goResult(){
        var resultScene = ResultScene(size: skView!.bounds.size)
        resultScene.delegate_escape = self
        resultScene.scaleMode = SKSceneScaleMode.AspectFill
        self.skView!.presentScene(resultScene)
    }
    
    //デリゲートメソッド
    func sceneEscape(scene: SKScene) {
        if scene.isKindOfClass(GameScene) {
            println("result")
            goResult()
        } else if scene.isKindOfClass(ResultScene){
            println("game")
            goGame()
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
