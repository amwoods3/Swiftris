/*
 This class seems to be the one responsible for having all of the images and keeping track of time,
 updating the game for each frame.
 */

import SpriteKit
import GameplayKit

let TickLengthLevelOne = TimeInterval(600)
let BlockSize:CGFloat = 20.0

class GameScene: SKScene {
    /*
     GameScene is a SKScene class. SKScene information can be found here: https://developer.apple.com/reference/spritekit/skscene
     It is basically the rootnode of SKNode objects. The Scene is used for rendering and animating
     the content for display.
     */
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick: NSDate?
    
    // textureCache is just a quick way to access an already created Texture.
    var textureCache = Dictionary<String, SKTexture>()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // CGPoint is a structure that contains a point in a two-dimensional coordinate system.
        // The guide for it is here: https://developer.apple.com/reference/coregraphics/cgpoint
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        // add the background to the Scene for display
        //addChild(background)
        
        // add the gameLayer to the Scene for display
        addChild(gameLayer)
        
        // SKTexture lets you apply images to the SpriteNode
        // Note: the file extension is not needed
        // More Information: https://developer.apple.com/reference/spritekit/sktexture
        let gameBoardTexture = SKTexture(imageNamed: "gameboard")
        
        // SKSpriteNode draws textures to the screen.
        // Guide on using SKSpriteNode: https://developer.apple.com/reference/spritekit/skspritenode
        // Note: CGSizeMake has been removed from Swift and CGSize should be used instead
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width: BlockSize * CGFloat(NumColumns), height: BlockSize * CGFloat(NumRows)))
        
        
        // anchorPoint is where the node rotates on the image. In the case here.
        // The anchorPoint uses a standard coordinate system where the center is (0.5, 0.5) and
        // (0, 0) is at the bottom-left of the image. 
        // Here the anchorPoint is set to the top-left of the image.
        // More Information: https://developer.apple.com/reference/spritekit/skspritenode
        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        //shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        /*
         Get the position of the block on the screen.
         */
        let x = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPoint(x: x, y: y)
    }
    
    func addPreviewShapeToScene(shape:Shape, completion: @escaping () -> Void) {
        for block in shape.blocks {
            var texture = textureCache[block.spriteName]
            if texture == nil {
                // Load the texture into the program
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            // Add a new node to the shape layer
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = pointForColumn(column: block.column, row:block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            // Animation
            sprite.alpha = 0
            //
            let moveAction = SKAction.move(to: pointForColumn(column: block.column, row: block.row), duration: TimeInterval(0.2))
            moveAction.timingMode = .easeOut
            let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.4)
            fadeInAction.timingMode = .easeOut
            sprite.run(SKAction.group([moveAction, fadeInAction]))
        }
        run(SKAction.wait(forDuration: 0.4), completion: completion)
    }
    
    func movePreviewShape(shape:Shape, completion: @escaping () -> ()) {
        for block in shape.blocks {
            let sprite = block.sprite!
            let moveTo = pointForColumn(column: block.column, row:block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.2)
            moveToAction.timingMode = .easeOut
            sprite.run(
                SKAction.group([moveToAction, SKAction.fadeAlpha(to: 1.0, duration: 0.2)]), completion: {})
        }
        run(SKAction.wait(forDuration: 0.2), completion: completion)
    }
    
    func redrawShape(shape:Shape, completion: @escaping () -> ()) {
        for block in shape.blocks {
            let sprite = block.sprite!
            let moveTo = pointForColumn(column: block.column, row:block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.05)
            moveToAction.timingMode = .easeOut
            if block == shape.blocks.last {
                sprite.run(moveToAction, completion: completion)
            } else {
                sprite.run(moveToAction)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        guard let lastTick = lastTick else {
            return
        }
        
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        
        if timePassed > tickLengthMillis {
            self.lastTick = NSDate()
            
            tick?()
        }
    }
    
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
}
