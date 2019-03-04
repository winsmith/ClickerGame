//
//  GameScene.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import SpriteKit
import GameplayKit
#if os(iOS)
import CoreMotion
#endif

class GameScene: SKScene {
    let pointsReceiver = PointsReceiverComponent()
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    #if os(iOS)
    private let motionManager = CMMotionManager()
    #endif
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnyNode : SKShapeNode?
    private var label : SKLabelNode?
    private var previewLabel : SKLabelNode?
    
    private var emojiFactory: EmojiFactory?
    
    private let numberFormatter = NumberFormatter()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        #if os(iOS)
        // Prepare MotionManager
        motionManager.startDeviceMotionUpdates()
        #endif
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Get label node from scene and store it for use later
        previewLabel = self.childNode(withName: "//emitterIconPrototype") as? SKLabelNode
        
        if let previewLabel = previewLabel {
            emojiFactory = EmojiFactory(emitterIconPrototype: previewLabel)
        }
        
        // Update Points Label
        label?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run { self.updatePointsLabel() },
            SKAction.wait(forDuration: 0.1)
        ])))
        
        // Update Preview Label
        label?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run { self.updatePreviewLabel() },
            SKAction.wait(forDuration: 0.2)
        ])))
        
        
        
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
    
    #if os(iOS)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
   #elseif os(OSX)
    override func mouseUp(with event: NSEvent) {
        let pos = event.location(in: self)
        touchUp(atPoint: pos)
    }
    #endif
    
    func touchUp(atPoint pos : CGPoint) {
        guard let emitter = emojiFactory?.gimmeTheBestEmitterICanGet(withPointsReceiver: pointsReceiver) else { return }
        
        // Pay the price
        pointsReceiver.pay(points: emitter.price)
        
        // Set correct position
        emitter.node.position = pos
        self.addChild(emitter.node)
        emitter.node.run(SKAction.fadeIn(withDuration: 2.0))
        
        // Add price label
        let pricelabel = SKLabelNode(text: numberFormatter.string(from: NSNumber(value: emitter.price)))
        self.addChild(pricelabel)
        pricelabel.fontSize = 12
        pricelabel.position = pos
        pricelabel.run(SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 2.0))
        pricelabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 2.0), SKAction.removeFromParent()]))
        
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
        
        #if os(iOS)
        // Update Gravity
        if motionManager.isDeviceMotionActive, let gravity = motionManager.deviceMotion?.gravity {
            physicsWorld.gravity = CGVector(dx: gravity.x, dy: gravity.y)
        }
        #endif
        
        self.lastUpdateTime = currentTime
    }
    
    private func updatePointsLabel() {
        label?.text = numberFormatter.string(from: NSNumber(value: pointsReceiver.points))
    }
    
    private func updatePreviewLabel() {
        if let preview = emojiFactory?.previewTheBestEmitterICanGet(withPointsReceiver: pointsReceiver) {
            previewLabel?.text = preview.node.text
            previewLabel?.fontSize = preview.node.fontSize
        }
    }
}
