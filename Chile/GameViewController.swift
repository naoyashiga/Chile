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
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
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

class GameViewController: UIViewController, SceneEscapeProtocol,GADBannerViewDelegate,GADInterstitialDelegate,GKGameCenterControllerDelegate, GameCenterProtocol{
    var skView:SKView?
    var gameCenterEnabled: Bool = false
    var gcDefaultLeaderBoard = String()
    
    var resultCount:Int = 0
    var interstitial:GADInterstitial = GADInterstitial()
    let INTERSTITIAL_ADUNIT_ID = "ca-app-pub-9360978553412745/5495187510"
    let INTERSTITIAL_COUNT = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("bestScore") == nil){
            ud.setObject(0, forKey: "bestScore")
        }
        
        interstitial.adUnitID = INTERSTITIAL_ADUNIT_ID
        interstitial.delegate = self
        interstitial.loadRequest(GADRequest())
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
                print("Local player already authenticated")
                self.gameCenterEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer
                    }
                })
            } else {
                self.gameCenterEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
        }
    }
    
    func settingAd(){
        let origin = CGPointMake(0.0,
            self.view.frame.size.height -
                CGSizeFromGADAdSize(kGADAdSizeBanner).height); // place at bottom of view
        
        let size = GADAdSizeFullWidthPortraitWithHeight(50)
        let adB = GADBannerView(adSize: size, origin: origin)
        adB.adUnitID = "ca-app-pub-9360978553412745/9042363511"
        adB.delegate = self
        adB.rootViewController = self
        self.view.addSubview(adB)
        let request = GADRequest()
        //test
//        request.testDevices = [ GAD_SIMULATOR_ID ];
        adB.loadRequest(request)
    }
    
    func goGame(){
//        var transition:SKTransition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        let gameScene = GameScene(size: skView!.bounds.size)
        gameScene.delegate_escape = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
//        self.skView!.presentScene(gameScene, transition: transition)
        self.skView!.presentScene(gameScene)
    }
    
    func goResult(){
//        var transition:SKTransition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
        let resultScene = ResultScene(size: skView!.bounds.size)
        resultScene.delegate_escape = self
        resultScene.delegate_gameCenter = self
        resultScene.scaleMode = SKSceneScaleMode.AspectFill
//        self.skView!.presentScene(resultScene, transition: transition)
        self.skView!.presentScene(resultScene)
    }
    
    //デリゲートメソッド
    func sceneEscape(scene: SKScene) {
        if scene.isKindOfClass(GameScene) {
            print("result")
            goResult()
        } else if scene.isKindOfClass(ResultScene){
            print("game")
            checkInterstitialAd()
            goGame()
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkInterstitialAd(){
        let ud = NSUserDefaults.standardUserDefaults()
        
        if(ud.objectForKey("interstitialAdCounter") == nil){
            ud.setObject(0, forKey: "interstitialAdCounter")
            resultCount = 1
        }else{
            //2回目以降起動時
            resultCount = ud.integerForKey("interstitialAdCounter")
        }
        
        
        if resultCount % INTERSTITIAL_COUNT == 0{
            if(interstitial.isReady){
                interstitial.presentFromRootViewController(self)
            }
            
            //次の広告の準備
            interstitial = GADInterstitial()
            interstitial.adUnitID = INTERSTITIAL_ADUNIT_ID
            interstitial.delegate = self
            interstitial.loadRequest(GADRequest())
        }
        
        print(resultCount)
        //カウントアップ
        resultCount = resultCount + 1
        ud.setObject(resultCount, forKey: "interstitialAdCounter")
    }
    
    func showLeaderboard(){
        print("iii")
        //スコア送信
        submitScore()
        //スコア表示
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "chileScore"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }
    
    func submitScore(){
        let ud = NSUserDefaults.standardUserDefaults()
        var leaderboardID = "chileScore"
        var sScore = GKScore(leaderboardIdentifier: leaderboardID)
        var currentScore = ud.integerForKey("currentScore")
        sScore.value = Int64(currentScore)
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
            if error != nil {
                print(error.localizedDescription)
            } else {
                print("Score submitted")
                
            }
        })
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
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
