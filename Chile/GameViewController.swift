//
//  GameViewController.swift
//  Chile
//
//  Created by naoyashiga on 2014/11/26.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

import UIKit
import SpriteKit
import Social

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

class GameViewController: UIViewController {
    var chileScene:GameScene?
    
    @IBOutlet weak var bgImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            chileScene = scene
            
            skView.presentScene(scene)
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
    
    @IBAction func shareBtn(sender: UIBarButtonItem) {
        //UIActionSheet
        let actionSheet:UIAlertController = UIAlertController(title:"Share",
            message: "Share screen capture image.",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })
        
        //Facebook
        let fbAction:UIAlertAction = UIAlertAction(title: "Facebook",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                var vc:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                self.shareVC(vc)
        })
        
        //Twitter
        let twitterAction:UIAlertAction = UIAlertAction(title: "Twitter",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                var vc:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                self.shareVC(vc)
        })
        
        //LINE
        let lineAction:UIAlertAction = UIAlertAction(title: "LINE",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                
                var pasteboard:UIPasteboard = UIPasteboard.generalPasteboard()
                //投稿画像を設定
                pasteboard.image = self.createScreenCapture()
                
                var imageURL: NSURL! = NSURL(string: "line://msg/image/" + pasteboard.name)
                
                if (UIApplication.sharedApplication().canOpenURL(imageURL)) {
                    UIApplication.sharedApplication().openURL(imageURL)
                }
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(fbAction)
        actionSheet.addAction(twitterAction)
        actionSheet.addAction(lineAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func shareVC(vc:SLComposeViewController){
        var shareText:String = "#Chile"
        //テキストを設定
        vc.setInitialText(shareText)
        
        //投稿画像を設定
        vc.addImage(createScreenCapture())
        
        self.presentViewController(vc,animated:true,completion:nil)
    }
    
    func createScreenCapture() -> UIImage{
        //キャプチャを作成
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        self.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
