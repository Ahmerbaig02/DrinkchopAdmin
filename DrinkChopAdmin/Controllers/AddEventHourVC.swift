////
//  AddEventHourVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class AddEventHourVC: UIViewController {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var endTimeTF: UITextField!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var startTimeTF: UITextField!
    @IBOutlet var aboutTF: UITextField!
    @IBOutlet var nameTF: UITextField!
    
    var isEvent:Bool = true
    
    var datePickers:[UIDatePicker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTimeFields(TF: self.startTimeTF)
        setTimeFields(TF: self.endTimeTF)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setViews()
    }
    
    func resetViews() {
        self.nameTF.text = ""
        self.startTimeTF.text = ""
        self.endTimeTF.text = ""
        self.aboutTF.text = ""
    }
    
    func setTimeFields(TF: UITextField) {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        TF.inputView = picker
        
        self.datePickers.append(picker)
    }
    
    func setViews() {
        self.titleLbl.text = "Add \(isEvent ? "Event" : "Happy Hour")"
        self.nameTF.placeholder = "\(isEvent ? "Event" : "Happy Hour") Name"
        self.aboutTF.placeholder = "\(isEvent ? "Event" : "Happy Hour") About"
        self.startTimeTF.placeholder = "\(isEvent ? "Event" : "Happy Hour") Start Time"
        self.endTimeTF.placeholder = "\(isEvent ? "Event" : "Happy Hour") End Time"
        
        self.createBtn.setTitle("Create \(isEvent ? "Event" : "Happy Hour")", for: .normal)
    }
    
    func creatHourFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.addHappyHourOnServer(name: self.nameTF.text!, about: self.aboutTF.text!, stime: self.startTimeTF.text!, etime: self.endTimeTF.text!, barId: DrinkUser.iUser.barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.resetViews()
                self!.showToast(message: "HappyHour created successfully....")
                print("HappyHour Added", success)
            } else {
                self!.showToast(message: "HappyHour not created. Please try again....")
                print("add HappyHour error")
            }
        }
    }
    
    func CreateEventFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.addEventOnServer(name: self.nameTF.text!, about: self.aboutTF.text!, stime: self.startTimeTF.text!, etime: self.endTimeTF.text!, barId: DrinkUser.iUser.barId!) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.resetViews()
                self!.showToast(message: "Event created successfully....")
                print("event Added", success)
            } else {
                self!.showToast(message: "Event not created. Please try again....")
                print("add event error")
            }
        }
    }
    
    @IBAction func createAction(_ sender: Any) {
        if isEvent {
            CreateEventFromManager()
        } else {
            creatHourFromManager()
        }
    }
    
    deinit {
        print("add event happyHour VC deinit")
    }

}

extension AddEventHourVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == startTimeTF {
            let time = datePickers[0].date.description.components(separatedBy: " ")[1].components(separatedBy: ":")
            self.startTimeTF.text = "\(time[0]):\(time[1])"
            self.datePickers[1].minimumDate = datePickers[0].date
            self.endTimeTF.text = ""
        } else if textField == endTimeTF {
            let time = datePickers[1].date.description.components(separatedBy: " ")[1].components(separatedBy: ":")
            self.endTimeTF.text = "\(time[0]):\(time[1])"
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            aboutTF.becomeFirstResponder()
        } else if textField == aboutTF {
            startTimeTF.becomeFirstResponder()
        } else if textField == startTimeTF {
            endTimeTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
}
