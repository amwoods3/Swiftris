//
//  GameViewController.swift
//  Swiftris
//
//  Created by Andrew Woods on 2017/02/27.
//  Copyright © 2017年 Andrew Woods. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {

    var scene: GameScene!
    var swiftris: Swiftris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // create the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        // present the scene
        
        skView.presentScene(scene)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            // #16
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(swiftris: Swiftris) {
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
    
    }
    
    func gameShapeDidDrop(swiftris: Swiftris) {
        
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        nextShape()
    }
    
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
