//
//  FilterView.swift
//  BreakingBadApp
//
//  Created by Sasha Belov on 5.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit

class FilterView: UIView {

    @IBOutlet private weak var seasonsTextField: UITextField!
    @IBOutlet private weak var textLabel: UILabel!
    
   /// Should be used to access the actual visible view.
   var contentView: UIView?
   
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       xibSetup()
   }
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       xibSetup()
   }
   
   init?(coder aDecoder: NSCoder, nibName: String) {
       super.init(coder: aDecoder)
       xibSetup(nibName: nibName)
   }
   
   /// Autoresizes the view to constrain the content view loaded from the interface builder
   private func xibSetup(nibName: String? = nil) {
       guard let view = loadViewFromNib(name: nibName) else { return }
       view.frame = bounds
       view.autoresizingMask =
           [.flexibleWidth, .flexibleHeight]
       addSubview(view)
       contentView = view
   }
   
   /// Finds the view (It should be named the same as the class!) and returns it to be set as content view
   ///
   /// - Returns: The actual visible view in the interface builder
   private func loadViewFromNib(name: String? = nil) -> UIView? {
       let bundle = Bundle(for: type(of: self))
       
       let nibName = name ?? String(describing: type(of: self))
       
       let nib = UINib(nibName: nibName, bundle: bundle)
       
       return nib.instantiate(
           withOwner: self,
           options: nil).first as? UIView
   }

    func resignFirstResponderToTextField() {
        seasonsTextField.resignFirstResponder()
    }
    
    func setupView(delegate: UITextFieldDelegate, description: String, inputView: UIView) {
        seasonsTextField.delegate = delegate
        textLabel.text = description
        seasonsTextField.inputView = inputView
    }
    
    func setTextInTextField(text: String) {
        seasonsTextField.text = text == "0" ? "No filter" : text
    }
}
