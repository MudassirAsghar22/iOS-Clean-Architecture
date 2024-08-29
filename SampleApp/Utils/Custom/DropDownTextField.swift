//
//  DropDownTextField.swift
//  Sample App
//
//  Created by Mudassir Asghar on 28/05/2024.
//

import Foundation

import UIKit
import TweeTextField

protocol DropDownTextFieldDelegate : AnyObject {
    func dropdownShouldOpen(textField: DropDownTextField) -> Bool
    func dropdown(textField: DropDownTextField, selectedItem: String, selectedItemID: String)
    func didTapDone()
}

class DropDownTextField: TweeAttributedTextField, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var ddDelegate: DropDownTextFieldDelegate?
    var picker: UIPickerView = UIPickerView()
    var itemsList: [DropDownModel] = []
    var isImageDropDown: Bool = false
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 25)

    override func awakeFromNib() {
        super.awakeFromNib()
        picker.dataSource = self
        picker.delegate = self
        self.delegate = self
        self.addRightView(named: "icon_arrow_down")
        self.inputView = picker
        let toolBar = UIToolbar.init()
        toolBar.barStyle = .black
        toolBar.sizeToFit()
        toolBar.barTintColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

        let btnDone : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender:)))
        btnDone.tintColor = UIColor.darkGray
        let btnFlexible : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([btnFlexible, btnDone], animated: false)
        self.inputAccessoryView = toolBar

    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)

    }

//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)

    }

    //    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    //        let rightBounds = CGRect(x: self.bounds.size.width-22, y: self.center.y/2, width: 24, height: 24)
    //        return rightBounds
    //    }

    @objc func donePressed(sender: UIBarButtonItem) {
        self.endEditing(true)
        if let del = ddDelegate {
            del.didTapDone()
        }
    }

    // MARK: Picker

    func selectRow(index: Int) {
        picker.selectRow(index, inComponent: 0, animated: true)

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsList.count

    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if isImageDropDown == true {
            let imgView = UIImageView.init(image: UIImage.init(named: itemsList[row].itemString ?? ""))
            imgView.frame = CGRect.init(x: 145, y: 5, width: 30, height: 30)
            imgView.contentMode = UIView.ContentMode.scaleAspectFit

            let vew = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 40))
            vew.addSubview(imgView)
            return vew

        } else {

            let label = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: (self.window?.bounds.width)!, height: 30))
            label.text = itemsList[row].itemString
            label.textAlignment = NSTextAlignment.center
            let vew = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (self.window?.bounds.width)!, height: 40))
            vew.addSubview(label)
            return vew
        }

    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return (self.window?.bounds.width)!

    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if itemsList.count > 0 {
            if isImageDropDown == false {
                self.text = itemsList[row].itemString!
            }
            if let del = ddDelegate {
                del.dropdown(textField: self, selectedItem:  itemsList[row].itemString!, selectedItemID: itemsList[row].id!)
            }

        }

    }

    func setItemList(list: [DropDownModel]) {
        self.itemsList = list
        picker.reloadAllComponents()

    }

    func setItemList(list: [String]) {
        self.itemsList.removeAll()
        for item in list {
            self.itemsList.append(DropDownModel.init(id: "", itemString: item))
            picker.reloadAllComponents()
        }

    }

    func setSelectedItem(index: Int) {
        if isImageDropDown == false && self.itemsList.count > 0 {
            self.text = itemsList[index].itemString!
            if let del = ddDelegate {
                del.dropdown(textField: self, selectedItem:  itemsList[index].itemString!, selectedItemID: itemsList[index].id!)
            }
        }

    }

    // MARK: TextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if  let del = ddDelegate {
            return del.dropdownShouldOpen(textField: self)
        } else {
            return true
        }

    }

}

struct DropDownModel {
    var id: String? = nil
    var itemString: String? = nil
    var isSelected: Bool = false

    init(id: String, itemString: String) {
        self.id = id
        self.itemString = itemString
    }
}
