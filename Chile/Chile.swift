//
//  Chile.swift
//  Chile
//
//  Created by naoyashiga on 2015/01/10.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import SpriteKit

class Chile: SKSpriteNode {
    convenience override init(){
        let num:CGFloat = 10
        let texture = SKTexture(imageNamed: "chile.png")
        let size = CGSizeMake(275 / num, 183 / num)
        
        self.init(texture: texture, size: size)
        
    }
    
    init(texture: SKTexture!, size: CGSize){
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
