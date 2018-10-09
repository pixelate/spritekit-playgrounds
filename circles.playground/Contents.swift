//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class Scene: SKScene {
    
    private var circlesEffectNode: SKEffectNode!
    
    private var circles: [SKShapeNode] = []
    
    private let colorWhite = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    private let colorBlack = NSColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    private let colorTerracotta = NSColor.init(red: 0.93, green: 0.21, blue: 0.25, alpha: 1.0)
    private let colorTransparent = NSColor(red: 1, green: 1, blue: 1, alpha: 0)
    
    private let colorInvertFilter = CIFilter(name: "CIColorInvert")
    
    override func didMove(to view: SKView) {
        backgroundColor = colorBlack
        createCircles()
    }
    
    override func mouseDown(with event: NSEvent) {
        moveCirclesTo(position: event.location(in: self))
        circlesEffectNode.filter = colorInvertFilter
    }

    override func mouseUp(with event: NSEvent) {
        circlesEffectNode.filter = nil
    }

    func createCircles() {
        circlesEffectNode = SKEffectNode.init()
        addChild(circlesEffectNode)
        
        let baseSize: CGFloat = 100
    
        for index in 1...10 {
            let circleSize: CGFloat = baseSize + CGFloat(index) * 30
            let circleNode = SKShapeNode(rectOf: CGSize(width: circleSize, height: circleSize), cornerRadius: circleSize * 0.5)
            circleNode.fillColor = colorTransparent
            circleNode.strokeColor = colorTerracotta
            circleNode.lineWidth = 0.03
            circleNode.zPosition = CGFloat(index)
        
            circles.append(circleNode)
            circlesEffectNode.addChild(circleNode)
        }
    }
    
    func moveCirclesTo(position: CGPoint) {
        var durationMultiplier: Double = 1.0
        for circleNode in circles {
            circleNode.run(SKAction.move(to: position, duration: durationMultiplier * 0.1))
            durationMultiplier += 1
        }
    }
    
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// Load the SKScene from 'Scene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 565, height: 800))
if let scene = Scene(fileNamed: "Scene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
