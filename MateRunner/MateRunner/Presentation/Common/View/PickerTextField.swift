//
//  PickerTextField.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/14.
//

import UIKit

final class PickerTextField: UITextField {
    lazy var doneButton = UIBarButtonItem(title: "설정", style: .done, target: self, action: nil)
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [self.doneButton]
        toolbar.barTintColor = .systemBackground
        toolbar.tintColor = .mrPurple
        return toolbar
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .systemBackground
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

// MARK: - Private Functions

private extension PickerTextField {
    func configureUI() {
        self.borderStyle = .roundedRect
        self.tintColor = .clear
        self.backgroundColor = .systemGray6
        self.font = .notoSans(size: 16, family: .regular)
        self.inputView = self.pickerView
    }
}
