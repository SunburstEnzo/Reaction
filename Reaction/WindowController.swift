//
//  WindowController.swift
//  Reaction
//
//  Created by Aled Samuel on 12/12/2016.
//  Copyright © 2016 Aled Samuel. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, NSTouchBarDelegate {
	
	
	fileprivate var score = 0 {
		
		didSet {
			
			scoreButton.title = "\(score)"
		}
	}
	
	fileprivate let scoreButton: NSButton = {
		
		let button = NSButton()
		button.title = "0"
		return button
	}()
	
//	fileprivate let activeButton: NSButton = {
//		
//		let button = NSButton()
//		
//		return button
//	}()
//	
//	fileprivate let inactiveButton: NSButton = {
//		
//		let button = NSButton()
//		
//		return button
//	}()
	
	
	// MARK: Window lifecycle
	
    override func windowDidLoad() {
        super.windowDidLoad()
		
		
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
	
	
	// MARK: Handlers
	
	@objc fileprivate func handleButtonPress(_ sender: NSButton) {
		
		score += 1
		
		/// All ⚫️⚫️⚫️⚫️⚫️⚫️⚫️⚫️
		touchBar?.defaultItemIdentifiers = [.inactive, .inactive, .inactive, .inactive, .inactive, .inactive, .inactive, .inactive, .score]
		
		/// Shuffle and set with delay ⚫️⚫️⚫️🔴⚫️⚫️⚫️⚫️
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
			
			let random = Int(arc4random_uniform(8))
			
			self?.touchBar?.defaultItemIdentifiers[random] = .active
		}
	}
	
	
	// MARK: NSTouchBarDelegate
	
	override func makeTouchBar() -> NSTouchBar? {
		
		let touchBar = NSTouchBar()
		touchBar.delegate = self
		touchBar.customizationIdentifier = .touchBar
		touchBar.defaultItemIdentifiers = [.inactive, .inactive, .inactive, .active, .inactive, .inactive, .inactive, .inactive, .score]
		
		return touchBar
	}
	
	
	func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
		
		let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
		
		switch identifier {
			
		case NSTouchBarItemIdentifier.score:
			
			touchBarItem.view = scoreButton
			return touchBarItem
			
		case NSTouchBarItemIdentifier.active:
			
			let button = NSButton(title: "🔴", target: self, action: #selector(handleButtonPress(_:)))
			touchBarItem.view = button
			return touchBarItem
			
		case NSTouchBarItemIdentifier.inactive:
			fallthrough
		default:
			
			let button = NSButton(title: "⚫️", target: self, action: nil)
			touchBarItem.view = button
			return touchBarItem
		}
	}
}


fileprivate extension NSTouchBarCustomizationIdentifier {
	
	static let touchBar = NSTouchBarCustomizationIdentifier("com.aledsamuel.Reaction")
}

fileprivate extension NSTouchBarItemIdentifier {
	
	static let active = NSTouchBarItemIdentifier("active")
	static let inactive = NSTouchBarItemIdentifier("inactive")
	
	static let score = NSTouchBarItemIdentifier("score")
}
