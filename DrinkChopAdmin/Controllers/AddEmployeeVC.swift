//
//  AddEmployeeVC.swift
//  DrinkChopAdmin
//
//  Created by Mahnoor Fatima on 4/30/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class AddEmployeeVC: UIViewController {

    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var types: [String] = ["Doorman", "Bartender"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        typeTF.inputView  = picker
    }

    func addUserFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.addUserOnServer(name: nameTF.text!, barId: DrinkUser.iUser.barId ?? "", email: emailTF.text!, password: passwordTF.text!, phone: phoneTF.text!, Type: typeTF.text!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.emailTF.text = ""
                self!.passwordTF.text = ""
                self!.phoneTF.text = ""
                self!.nameTF.text = ""
                self!.typeTF.text = ""
            } else {
                print("error on adding admin user")
            }
        }
    }
    
    @IBAction func addUserAction(_ sender: Any) {
        addUserFromManager()
    }
    
    deinit {
        print("deinit addEmployeeVC")
    }

}

extension AddEmployeeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTF.text = types[row]
    }
    
}
