//
//  EmojiFactory.swift
//  Clicker Game Mac
//
//  Created by Daniel Jilg on 04.03.19.
//  Copyright © 2019 breakthesystem. All rights reserved.
//

import SpriteKit
import GameplayKit

class EmojiFactory {
    private let progression = ["😊", "🥰", "😈", "🤓", "😙", "🍑", "😍", "🍔", "🧐", "😡", "🐷", "🤯", "🥶", "😨", "🙂",
                               "😑", "😮", "🤢", "🤠", "💩", "🤖", "😏", "👹", "🤪", "👻", "☠️", "👽", "🤓",
                               "👾", "🎃", "😺", "😻", "😽"]
    
    init(emitterIconPrototype: SKLabelNode) {
        self.emitterIconPrototype = emitterIconPrototype
    }
    
    func gimmeTheBestEmitterICanGet(withPointsReceiver pointsReceiver: PointsReceiverComponent) -> (price: Double, node: SKLabelNode, entity: GKEntity)? {
        return previewTheBestEmitterICanGet(withPointsReceiver: pointsReceiver, withIncrement: true)
    }
    
    func previewTheBestEmitterICanGet(withPointsReceiver pointsReceiver: PointsReceiverComponent, withIncrement: Bool = false) -> (price: Double, node: SKLabelNode, entity: GKEntity)? {
        let labelNode = self.emitterIconPrototype.copy() as! SKLabelNode
        
        var biggestFoundOutput: Double?
        var biggestFoundPrice: Double?
        var biggestPosition: Int = 0
        for position in 0..<progression.count {
            let price = self.price(for: position)
            if price <= pointsReceiver.points && output(for: position) > (biggestFoundOutput ?? 0) {
                biggestFoundPrice = price
                biggestPosition = position
                biggestFoundOutput = output(for: position)
            }
        }
        
        guard let biggestPrice = biggestFoundPrice else { return nil }
        guard let biggestOutput = biggestFoundOutput else { return nil }
        
        labelNode.fontSize = fontSize(for: biggestPosition)
        labelNode.text = progression[biggestPosition]
        
        labelNode.physicsBody = SKPhysicsBody(circleOfRadius: labelNode.frame.width * 0.40)
        labelNode.physicsBody?.restitution = 0.1
        labelNode.physicsBody?.friction = 0.15
        
        let entity = GKEntity()
        let pointsEmitterComponent = PointsEmitterComponent(receiver: pointsReceiver, pointsPerSecond: biggestOutput)
        entity.addComponent(pointsEmitterComponent)
        entity.addComponent(GeometricComponent(node: labelNode, pointsEmitter: pointsEmitterComponent))
        
        if withIncrement {
            increment(position: biggestPosition)
        }
        
        return (biggestPrice, labelNode, entity)
    }
    
    private var emitterIconPrototype: SKLabelNode
    
    private func output(for position: Int) -> Double {
        if position == 0 { return 1 }
        return output(for: position - 1) * 2
    }
    
    private func basePrice(for position: Int) -> Double {
        if position == 0 { return 1 }
        return basePrice(for: position - 1) * 2.5
    }
    
    private func price(for position: Int) -> Double {
        return basePrice(for: position) * Double(amounts[position, default: 1])
    }
    
    private var amounts = [Int: Int]()
    private func increment(position: Int) {
        let currentAmount = amounts[position, default: 1]
        amounts[position] = currentAmount + 1
    }
    
    private func fontSize(for position: Int) -> CGFloat {
        let result = pow(CGFloat(position + 1), 2) / 2.0
        return max(result, 8)
    }
}
