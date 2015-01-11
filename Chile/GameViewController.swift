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

class GameViewController: UIViewController, SceneEscapeProtocol,GADBannerViewDelegate {
    var skView:SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("bestScore") == nil){
            ud.setObject(0, forKey: "bestScore")
        }
        
        skView = self.view as? SKView
        skView!.ignoresSiblingOrder = true
        settingAd()
        goGame()
    }

    func settingAd(){
        var origin = CGPointMake(0.0,
            self.view.frame.size.height -
                CGSizeFromGADAdSize(kGADAdSizeBanner).height); // place at bottom of view
        
        var size = GADAdSizeFullWidthPortraitWithHeight(50)
        var adB = GADBannerView(adSize: size, origin: origin)
        adB.adUnitID = "ca-app-pub-9360978553412745/9042363511"
        adB.delegate = self
        adB.rootViewController = self
        self.view.addSubview(adB)
        var request = GADRequest()
        //test
        request.testDevices = [ GAD_SIMULATOR_ID ];
        adB.loadRequest(request)
    }
    
    func goGame(){
//        var transition:SKTransition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        var gameScene = GameScene(size: skView!.bounds.size)
        gameScene.delegate_escape = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
//        self.skView!.presentScene(gameScene, transition: transition)
        self.skView!.presentScene(gameScene)
    }
    
    func goResult(){
//        var transition:SKTransition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        var resultScene = ResultScene(size: skView!.bounds.size)
        resultScene.delegate_escape = self
        resultScene.scaleMode = SKSceneScaleMode.AspectFill
//        self.skView!.presentScene(resultScene, transition: transition)
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
    
    override func shouldAutorotate() -> Bool {
        return true
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
