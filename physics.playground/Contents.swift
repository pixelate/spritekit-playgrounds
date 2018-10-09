//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

let w: CGFloat = 565
let h: CGFloat = 800

class Scene: SKScene {
    private let ballRadius: CGFloat = 25.0
    
    private let ballCategory: UInt32 = 0b0001
    private let edgeCategory: UInt32 = 0b0010

    private let colorTerracotta = NSColor.init(red: 0.93, green: 0.21, blue: 0.25, alpha: 1.0)
    private let colorOcean = NSColor(red: 0.22, green:0.18, blue: 0.52, alpha: 1.0)
    private let colorWhite = NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    override func didMove(to view: SKView) {
        backgroundColor = colorOcean
        
        createEdge()
        createObstacles()
    }

    override func mouseDown(with event: NSEvent) {
        createBall(position: event.location(in: self))
    }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        if(event.keyCode == 15) { // R for restart
            if let newScene = Scene(fileNamed: "Scene") {
                let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 0.5)
                self.scene!.view?.presentScene(newScene, transition: transition)
            }
        }
    }
    
    func createEdge() {
        let edgeNode = SKShapeNode(rect: CGRect(x:-w/2, y: -h/2, width: w, height: h))
        
        let edge = SKPhysicsBody(edgeLoopFrom: CGRect(x:-w/2 , y: -h/2, width: w, height: h))
        edge.categoryBitMask = edgeCategory
        edge.contactTestBitMask = ballCategory
        edge.collisionBitMask = ballCategory
        edgeNode.physicsBody = edge
        edgeNode.strokeColor = SKColor.clear

        addChild(edgeNode)
    }
    
    func createObstacles() {
        for _ in 1...5 {
            let radius: CGFloat = CGFloat.random(in: 10.0...100.0)
            
            let minPosX: CGFloat = -w/2 + ballRadius*2 + radius
            let maxPosX: CGFloat =  w/2 - ballRadius*2 - radius

            let minPosY: CGFloat = -h/2 + ballRadius*2 + radius
            let maxPosY: CGFloat =  h/2 - ballRadius*2 - radius

            let x: CGFloat = CGFloat.random(in: minPosX...maxPosX)
            let y: CGFloat = CGFloat.random(in: minPosY...maxPosY)

            let obstacleNode = SKShapeNode(circleOfRadius: radius)
            
            let obstacle = SKPhysicsBody(circleOfRadius: radius)
            obstacle.isDynamic = false
            obstacle.categoryBitMask = edgeCategory
            obstacle.contactTestBitMask = ballCategory
            obstacle.collisionBitMask = ballCategory
            obstacleNode.fillColor = colorWhite
            obstacleNode.physicsBody = obstacle
            obstacleNode.position.x = x
            obstacleNode.position.y = y

            addChild(obstacleNode)
        }
    }

    func createBall(position: CGPoint) {
        let ball = SKShapeNode(circleOfRadius: ballRadius)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        ball.fillColor = colorTerracotta
        ball.strokeColor = SKColor.clear
        ball.position = position

        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = ballCategory | edgeCategory
        ball.physicsBody?.collisionBitMask = ballCategory | edgeCategory
        addChild(ball)
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
let sceneView = SKView(frame: CGRect(x:0, y:0, width: w, height: h))
if let scene = Scene(fileNamed: "Scene") {
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
