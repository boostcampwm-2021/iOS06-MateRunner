//
//  CursorDisabledTextField.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/04.
//

import UIKit

final class CursorDisabledTextField: UITextField {
	override func closestPosition(to point: CGPoint) -> UITextPosition? {
		let beginning = self.beginningOfDocument
		let end = self.position(from: beginning, offset: self.text?.count ?? 0)
		return end
	}
}
