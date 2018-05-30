////
//  SocialSitesVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SocialSitesVC: UIViewController {

    @IBOutlet var facebookTF: UITextField!
    @IBOutlet var twitterTF: UITextField!
    @IBOutlet var instaTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSocialSitesFromManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    func getSocialSitesFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getSocialSitesFromServer(barId: DrinkUser.iUser.barId!) { [weak self] (rawSocials) in
           Manager.hideLoader()
            if let socials = rawSocials {
                self!.facebookTF.text = socials.fb ?? ""
                self!.twitterTF.text = socials.tw ?? ""
                self!.instaTF.text = socials.inst ?? ""
            } else {
                self!.showToast(message: "error fetching socials")
                print("error fetching socials")
            }
        }
    }
    
    func updateSocialSitesFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.updateSocialSitesOnServer(fb: facebookTF.text!, tw: twitterTF.text!, insta: instaTF.text!, barId: DrinkUser.iUser.barId ?? "") { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.showToast(message: "socials updated successfully")
                print("updated successfully")
            } else {
                self!.showToast(message: "error updating socials")
                print("error updating socials")
            }
        }
    }
    
    @IBAction func updateAction(_ sender: Any) {
        updateSocialSitesFromManager()
    }
    
    deinit {
        print("deinit social sites VC")
    }
    
}
