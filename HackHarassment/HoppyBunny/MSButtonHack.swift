//
//  MSButtonHack.swift
//  HoppyBunny
//
//  Created by Katie Moreno on 03/09/2017.
//

import SpriteKit

enum MSButtonHackState {
    case active, selected, hidden
}

class MSButtonHack: SKSpriteNode {
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    /* Button state management */
    var state: MSButtonHackState = .active {
        didSet {
            switch state {
            case .active:
                /* Enable touch */
                self.isUserInteractionEnabled = true
                
                /* Visible */
                self.alpha = 1
                break
            case .selected:
                /* Visible */
                self.alpha = 1
                break
            case .hidden:
                /* Disable touch */
                self.isUserInteractionEnabled = false
                
                /* Hide */
                self.alpha = 0
                break
            }
        }
    }
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button hack */
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .active
        selectedHandler()
    }
    
}
