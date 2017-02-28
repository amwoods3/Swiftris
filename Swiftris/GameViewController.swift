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
    var panPointReference:CGPoint?
    
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
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    @IBAction func didPan(_ sender: Any) {
        /*
         If This function is removed, it also needs to be removed from the Storyboard. This function
         reacts to pan, and will change what happens when the user slides their finger along the screen
         */
        let currentPoint = (sender as AnyObject).translation(in: self.view)
        if let originalPoint = panPointReference {
            // #3
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // #4
                if (sender as AnyObject).velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if (sender as AnyObject).state == .began {
            panPointReference = currentPoint
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
}
