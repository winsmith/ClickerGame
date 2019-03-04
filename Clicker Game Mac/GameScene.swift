//
//  GameScene.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let pointsReceiver = PointsReceiverComponent()
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    private var label : SKLabelNode?
    
    private var emojiFactory: EmojiFactory?
    
    private let numberFormatter = NumberFormatter()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Get label node from scene and store it for use later
        let emitterIconPrototype = self.childNode(withName: "//emitterIconPrototype") as? SKLabelNode
        
        if let emitterIconPrototype = emitterIconPrototype {
            emitterIconPrototype.alpha = 0.0
            
            emojiFactory = EmojiFactory(emitterIconPrototype: emitterIconPrototype)
        }
        
        // Border around scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    func setupScene() {
        // Setup Entities
        let pointsReceiverEntity = GKEntity()
        pointsReceiverEntity.addComponent(pointsReceiver)
        entities.append(pointsReceiverEntity)
        
        // Setup Number Formatter
        numberFormatter.groupingSeparator = "."
        numberFormatter.roundingMode = .floor
    }
    
    override func mouseUp(with event: NSEvent) {
        guard let emitter = emojiFactory?.gimmeTheBestEmitterICanGet(withPointsReceiver: pointsReceiver) else { return }
        
        // Pay the price
        pointsReceiver.pay(points: emitter.price)
        
        // Set correct position
        let pos = event.location(in: self)
        emitter.node.position = pos
        self.addChild(emitter.node)
        emitter.node.run(SKAction.fadeIn(withDuration: 2.0))
        
        // Add price label
        let pricelabel = SKLabelNode(text: numberFormatter.string(from: NSNumber(value: emitter.price)))
        self.addChild(pricelabel)
        pricelabel.fontSize = 10
        pricelabel.position = pos
        pricelabel.run(SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.0))
        pricelabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
        
        // Save entities
        entities.append(emitter.entity)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in entities {
            entity.update(deltaTime: dt)
        }
        
        // Update Label
        label?.text = numberFormatter.string(from: NSNumber(value: pointsReceiver.points))
        
        self.lastUpdateTime = currentTime
    }
}






/*


//
//  GameScene.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

 */
