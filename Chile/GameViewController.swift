//
//  GameViewController.swift
//  Chile
//
//  Created by naoyashiga on 2014/11/26.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

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

class GameViewController: UIViewController, SceneEscapeProtocol,GADBannerViewDelegate, GKGameCenterControllerDelegate, GameCenterProtocol{
    var skView:SKView?
    var gameCenterEnabled: Bool = false
    var gcDefaultLeaderBoard = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("bestScore") == nil){
            ud.setObject(0, forKey: "bestScore")
        }
        
        skView = self.view as? SKView
        skView!.ignoresSiblingOrder = true
        authenticateLocalPlayer()
        settingAd()
        goGame()
    }

    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.presentViewController(ViewController, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                println("Local player already authenticated")
                self.gameCenterEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer
                    }
                })
            } else {
                self.gameCenterEnabled = false
                println("Local player could not be authenticated, disabling game center")
                println(error)
            }
        }
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
        resultScene.delegate_gameCenter = self
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
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showLeaderboard(){
        println("iii")
        //スコア送信
        submitScore()
        //スコア表示
        var gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "ChileScore"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }
    
    func submitScore(){
        let ud = NSUserDefaults.standardUserDefaults()
        var leaderboardID = "ChileScore"
        var sScore = GKScore(leaderboardIdentifier: leaderboardID)
        var currentScore = ud.integerForKey("currentScore")
        sScore.value = Int64(currentScore)
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError!) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                println("Score submitted")
                
            }
        })
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
