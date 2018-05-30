////
//  SigninVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var emailTF: TextFieldValidator!
    @IBOutlet weak var passwordTF: TextFieldValidator!
    
    var notificationData:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.validateFields(self.emailTF)
        self.addValidatesTextFields()
        setPaddingInset(emailTF, image: #imageLiteral(resourceName: "ic_email"))
        setPaddingInset(passwordTF, image: #imageLiteral(resourceName: "ic_lock"))
        self.emailTF.addTarget(self, action: #selector(self.validateFields(_:)), for: .editingChanged)
        self.passwordTF.addTarget(self, action: #selector(self.validateFields(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        checkIsUserLoggedIn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MyAccountVC {
            controller.notificationData = notificationData
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.passwordTF.underline(UIColor.white)
        self.emailTF.underline(UIColor.white)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.logoImgView.getRounded(cornerRaius: self.logoImgView.frame.height/2)
        self.signinBtn.getRounded(cornerRaius: self.signinBtn.frame.height/2)
    }
    
    @objc func validateFields(_ sender: UITextField) {
        self.signinBtn.isEnabled = self.emailTF.validate() && self.passwordTF.validate()
    }
    
    func addValidatesTextFields() {
        emailTF.addRegx("[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", withMsg:"Enter valid email.")
        passwordTF.addRegx("^.{4,20}$",withMsg:"Password should be 4-20 characters long")
        passwordTF.addRegx("[A-Za-z0-9]{4,20}",withMsg:"Only alpha numeric characters are allowed.")
    }
    
    func setPaddingInset(_ sender : UITextField, image: UIImage) {
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.tintColor = UIColor.white
        imgView.frame = CGRect(x: 0, y: 0, width: sender.frame.height, height: sender.frame.height)
        sender.leftView = imgView
        sender.leftViewMode = UITextFieldViewMode.always
    }
    
    
    func checkIsUserLoggedIn() {
        let loggedIn = UserDefaults.standard.bool(forKey: isLoggedInDefaultID)
        if loggedIn {
            if let data = UserDefaults.standard.data(forKey: UserProfileDefaultsID) {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let userData = try? decoder.decode(DrinkUser.self, from: data) else {
                    return
                }
                DrinkUser.iUser = userData
                if notificationData != nil {
                    ID = "Messages"
                }
                self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
            }
        }
    }
    
    func saveUserDataAndLogin() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(DrinkUser.iUser) else {return}
        
        UserDefaults.standard.set(data, forKey: UserProfileDefaultsID)
        UserDefaults.standard.set(true, forKey: isLoggedInDefaultID)
        self.performSegue(withIdentifier: LoggedInSegueID, sender: nil)
    }
    
    func signinUserFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.signinUserOnServer(email: self.emailTF.text!, password: self.passwordTF.text!) { [weak self] (usersData) in
            Manager.hideLoader()
            if let usersData = usersData {
                DrinkUser.iUser = usersData[0]
                self!.emailTF.text = ""
                self!.passwordTF.text = ""
                self!.saveUserDataAndLogin()
            } else {
                self!.showToast(message: "Username/Password invalid. Please try again...")
                //err
            }
        }
    }

    @IBAction func signInAction(_ sender: Any) {
        self.signinUserFromManager()
    }
    
    deinit {
        print("sign in vc deinit")
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

