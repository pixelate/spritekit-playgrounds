//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class Scene: SKScene {
    private var circlePatternNode: SKNode!
    private var circleNode: SKShapeNode!
    private let circleSize: CGFloat = 10.0
    private let circleMargin: CGFloat = 4.5
    
    private var wavePatternNode: SKNode!

    private let colorSand = NSColor(red:0.93, green: 0.91, blue: 0.88, alpha: 1.0)
    private let colorTerracotta = NSColor.init(red: 0.93, green: 0.21, blue: 0.25, alpha: 1.0)
    private let colorOcean = NSColor(red:0.22, green:0.18, blue:0.52, alpha:1.0)
    
    override func didMove(to view: SKView) {
        backgroundColor = colorSand
        
        createCirclePattern(columns: 9, rows: 19)
        createWavePattern(columns: 11, rows: 4)
    }
    
    func createCirclePattern(columns: Int, rows: Int) {
        circlePatternNode = SKNode.init()
        circlePatternNode.position = CGPoint(x: -240, y: -250)
        addChild(circlePatternNode)

        circleNode = SKShapeNode(rectOf: CGSize(width: circleSize, height: circleSize), cornerRadius: circleSize * 0.5)
        circleNode.lineWidth = 1
        circleNode.strokeColor = colorTerracotta

        var i = 0
        
        let zoomInDuration = 0.1
        let zoomOutDuration = 0.25
        let totalDuration = Double(columns) * Double(rows) * zoomInDuration
        
        for column in 1...columns {
            for row in 1...rows {
                i += 1
                
                guard let n = circleNode.copy() as? SKShapeNode else { return }
                var x = CGFloat(column) * (circleSize + circleMargin)
                
                if(row % 2 != 0) {
                    x += circleSize / 2 + circleMargin / 2
                }
                
                let y = CGFloat(row) * (circleSize + circleMargin)
                n.position = CGPoint.init(x: x, y: y)
                n.fillColor = colorTerracotta
                circlePatternNode.addChild(n)
                
                let waitBeforeDuration = Double(i) / 10
                let waitBefore = SKAction.wait(forDuration: waitBeforeDuration)
 
                let zoomIn = SKAction.scale(to: 1.5, duration: zoomInDuration)
                let zoomOut = SKAction.scale(to: 1.0, duration: zoomOutDuration)

                let waitAfterDuration = totalDuration - waitBeforeDuration
                let waitAfter = SKAction.wait(forDuration: waitAfterDuration)

                let zoomSequence = SKAction.sequence([waitBefore, zoomIn, zoomOut, waitAfter])
                
                n.run(SKAction.repeatForever(zoomSequence))
            }
        }
    }
    
    func createWavePattern(columns: Int, rows: Int) {
        wavePatternNode = SKNode.init()
        wavePatternNode.position = CGPoint(x: 124, y: 100)
        addChild(wavePatternNode)

        var points: [CGPoint] = getWavePoints(length: columns * 2)

        let waveLineHeight: CGFloat = 9;
        
        for row in 1...rows {
            let waveNode = SKShapeNode(points: &points, count: points.count)
            waveNode.lineWidth = 3
            waveNode.strokeColor = colorOcean
            waveNode.position.y = CGFloat(row) * waveLineHeight
            
            wavePatternNode.addChild(waveNode)
        }
    }
    
    func getWavePoints(length: Int) -> [CGPoint] {
        var points: [CGPoint] = []
        
        for i in 0...length-1 {
            var y = 0
            
            if(i % 2 != 0) {
                y = 4
            }
            
            points.append(CGPoint(x: i*7, y: y))
        }
        
        return points
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
