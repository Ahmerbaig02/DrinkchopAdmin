//
//  Manager.swift
//  Momentum
//
//  Created by Mac on 19/07/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import JHSpinner
import Alamofire


class Manager {
    
    typealias barsAlias = ([DrinkBar]?) -> ()
    typealias barAlias = (DrinkBar?) -> ()
    typealias eventsAlias = ([DrinkEvent]?) -> ()
    typealias eventAlias = (DrinkEvent?) -> ()
    typealias extrasAlias = ([DrinkExtras]?) -> ()
    typealias extraAlias = (DrinkExtras?) -> ()
    typealias settingsAlias = ([Settings]?) -> ()
    typealias settingAlias = (Settings?) -> ()
    typealias cardsAlias = ([DrinkCard]?) -> ()
    typealias cardAlias = (DrinkCard?) -> ()
    typealias usersAlias = ([DrinkUser]?) -> ()
    typealias userAlias = (DrinkUser?) -> ()
    typealias coversAlias = ([DrinkCover]?) -> ()
    typealias coverAlias = (DrinkCover?) -> ()
    typealias drinksAlias = ([Drink]?) -> ()
    typealias drinkAlias = (Drink?) -> ()
    typealias ordersAlias = ([DrinkOrder]?) -> ()
    typealias orderAlias = (DrinkOrder?) -> ()
    typealias happyHoursAlias = ([DrinkHappyHour]?) -> ()
    typealias happyHourAlias = (DrinkHappyHour?) -> ()
    typealias socialAlias = (SocialSites?) -> ()
    
    typealias bartendersAlias = ([BartenderUser]?) -> ()
    typealias bartenderAlias = (BartenderUser?) -> ()
    typealias entryUsersAlias = ([EntryUser]?) -> ()
    typealias entryUserAlias = (EntryUser?) -> ()
    
    typealias barDrinksAlias = ([Drink]?, [String]?) -> ()
    
    typealias eventsHappyHrsAlias = ([DrinkEvent]?, [DrinkHappyHour]?) -> ()
    typealias favoritesAlias = ([DrinkEvent]?, [Drink]?) -> ()
    
    typealias salesAlias = ([BartenderUser]?,[EntryUser]?, [BarTenderTotals]?, [EntryTotals]?, [DrinkBar]?, [DrinkUser]?) -> ()
    
    static var getData:AlamofireRequestFetch = AlamofireRequestFetch(baseUrl: DrinkChopBaseURL)
    
    static var textLabel:UILabel!
    
    static var spinner:JHSpinnerView!
    
    static var access_token:String!
    
    class func getaccess_token() {
        self.access_token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    class func saveaccess_token(token: String?) {
        self.access_token = token ?? ""
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    class func showLoader(text: String, view: UIView) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        spinner = JHSpinnerView.showOnView(view, spinnerColor: appTintColor, overlay:.custom(CGSize(width: 150, height: 150), 20), overlayColor:UIColor.black.withAlphaComponent(0.6), fullCycleTime:4.0, text: text)
    }
    
    class func hideLoader() {
        UIApplication.shared.endIgnoringInteractionEvents()
        spinner.dismiss()
    }
    
    // MARK: - Parser
    
    class func parseUsersData(response: [String:Any], key: String) -> [DrinkUser]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([DrinkUser].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    class func parseBartendersData(response: [String:Any], key: String) -> [BartenderUser]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([BartenderUser].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    
    class func parseBartenderTotalsData(response: [String:Any], key: String) -> [BarTenderTotals]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([BarTenderTotals].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
//    class func parseUsersData(response: Any?, isSignin: Bool = false) -> [DrinkUser]? {
//        if let res = response as? [String:Any] {
//            if let success = res["success"] as? Int {
//                if(isSignin && success == 1) || (!isSignin && success == 3) {
//                    if let dictArr = res["user"] as? [[String:Any]] {
//                        do {
//                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
//                            let decoder = JSONDecoder()
//                            return try decoder.decode([DrinkUser].self, from: data)
//                        } catch let error as Error {
//                            print(error.localizedDescription)
//                            return nil
//                        }
//                    } else {
//                        return nil
//                    }
//                } else {
//                    return nil
//                }
//            } else {
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }
    
    class func parseEntryUsersData(response: [String:Any], key: String) -> [EntryUser]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([EntryUser].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseEntriesTotalData(response: [String:Any], key: String) -> [EntryTotals]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([EntryTotals].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseBarsData(response: [String:Any], key: String) -> [DrinkBar]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([DrinkBar].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseCoversData(response: [String:Any], key: String) -> [DrinkCover]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([DrinkCover].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    class func parseBarDrinksData(response: [String:Any], key: String) -> ([Drink]?, [String]?) {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return (nil,nil)}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return (try decoder.decode([Drink].self, from: data), response["types"] as? [String] ?? [])
            } catch let error as Error {
                print(error.localizedDescription)
                return (nil,nil)
            }
        } else {
            return (nil,nil)
        }
    }
    
    
    class func parseOrdersData(response: Any?) -> [DrinkOrder]? {
        if let res = response as? [String:Any] {
            let key = "status"
            if let success = res[key] as? Bool {
                if success {
                    let key1 = "users"
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkOrder].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseExtrasData(response: [String:Any], key: String) -> [DrinkExtras]? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([DrinkExtras].self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
 
    class func parseSocialSitesData(response: [String:Any], key: String) -> SocialSites? {
        if let dictArr = response[key] as? [String:Any] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(SocialSites.self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseCardStatusData(response: Any?) -> Bool? {
        if let res = response as? [String:Any] {
            if let success = res["status"] as? Bool {
                if success {
                    return true
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseChangePassData(response: Any?) -> Bool? {
        if let res = response as? [String:Any] {
            if let success = res["success"] as? Bool {
                if success {
                    return true
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // MARK: - API Calls
    
    class func signinUserOnServer(email: String, password: String, completionHandler: @escaping usersAlias) {
        getData.getDataFromServer(subUrl: "\(SigninURL)?email=\(email)&password=\(password)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(parseUsersData(response: res, key: "user"))
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    class func getSalesFromServer(barId: String, completionHandler: @escaping salesAlias) {
        getData.getDataFromServer(subUrl: "\(SalesURL)?bar_id=\(barId)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        let usersData = parseUsersData(response: res, key: "users")
                        let bartendersData = parseBartendersData(response: res, key: "bartender_users")
                        let bartenderTotals = parseBartenderTotalsData(response: res, key: "bartender_totals")
                        let entryUsers = parseEntryUsersData(response: res, key: "entries_users")
                        let entriesTotal = parseEntriesTotalData(response: res, key: "entries_totals")
                        let barData = parseBarsData(response: res, key: "data")
                        
                        completionHandler(bartendersData, entryUsers, bartenderTotals, entriesTotal, barData, usersData)
                        
                    } else {
                        completionHandler(nil,nil,nil,nil,nil,nil)
                    }
                } else {
                    completionHandler(nil,nil,nil,nil,nil,nil)
                }
            } else {
                completionHandler(nil,nil,nil,nil,nil,nil)
            }
        }
    }
    
    
    class func getAdminUsersFromServer(barId: String, completionHandler: @escaping usersAlias) {
        getData.getDataFromServer(subUrl: "\(AdminUsersURL)?bar_id=\(barId)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        let usersData = parseUsersData(response: res, key: "users")
                        completionHandler(usersData)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    class func updateBarStatusOnServer(barId: String, status: Int, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(ChangeBarStatusURL)?bar_id=\(barId)&status=\(status)") { (response) in
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    class func getDrinksFromServer(id:Int, completionHandler: @escaping barDrinksAlias) {
        getData.getDataFromServer(subUrl: "\(GetDrinksURL)?bar_id=\(id)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        let res = parseBarDrinksData(response: res, key: "users")
                        completionHandler(res.0, res.1)
                    } else {
                        completionHandler(nil,nil)
                    }
                } else {
                    completionHandler(nil,nil)
                }
            } else {
                completionHandler(nil,nil)
            }
        }
    }
    
    class func getCoversFromServer(id: String, completionHandler: @escaping coversAlias) {
        getData.getDataFromServer(subUrl: "\(CoversURL)?bar_id=\(id)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(parseCoversData(response: res, key: "users"))
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    class func getSuperExtrasFromServer(completionHandler: @escaping extrasAlias) {
        getData.getDataFromServer(subUrl: GetExtrasURL) { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(parseExtrasData(response: res, key: "users"))
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func getOrdersFromServer(id: String, completionHandler: @escaping ordersAlias) {
        getData.getDataFromServer(subUrl: "\(GetOrdersURL)?bar_id=\(id)") { (response) in
            print(response)
            completionHandler(parseOrdersData(response: response))
        }
    }
    
    class func updateTokenOnServer(completionHandler: @escaping (Bool?) -> ()) {
        let token = UserDefaults.standard.string(forKey: fcmTokenDefaultsID) ?? ""
        getData.getDataFromServer(subUrl: "\(UpdateTokenURL)?token=\(token)&email=\(DrinkUser.iUser.userEmail!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func checkinUserOnServer(barId: String, bar_entry_id: String, status: String, people: String, completionHandler: @escaping (Bool?) -> ()) {
        let userId = DrinkUser.iUser.userId ?? ""
        getData.getDataFromServer(subUrl: "\(CheckInURL)?user_id=\(userId)&bar_id=\(barId)&bar_entry_id=\(bar_entry_id)&staus=\(status)&people=\(people)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func acceptOrderOnServer(userId: String, order_id: String,bartender_id: String, status: String, completionHandler: @escaping (Bool?) -> ()) {
        let params:[String:Any] = ["bartender_name": DrinkUser.iUser.userName ?? ""]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(OrderAcceptURL)?user_id=\(userId)&bartender_name=\(DrinkUser.iUser.userName ?? "")&bartender_id=\(bartender_id)&status=\(status)&order_id=\(order_id)", method: .post, parameters: params) { (response) in
            print(response)
            if let res = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else if success == 2 {
                        print("accepted by other bartender")
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func sendDocMessageFromServer(params: [String:Any], completionHandler: @escaping (Bool?) -> ()) {
        getData.UpdateRequestWithRequestStringToServer(subUrl: DoctorMessageURL, method: .post, parameters: params) { (response) in
            print(response)
            if let res = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let success = res["success"] as? Bool {
                    if success {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func sendPatientMessageFromServer(params: [String:Any], completionHandler: @escaping (Bool?) -> ()) {
        getData.UpdateRequestWithRequestStringToServer(subUrl: PatientMessageURL, method: .post, parameters: params) { (response) in
            print(response)
            if let res = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let success = res["success"] as? Bool {
                    if success {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func insertDrinksOnServer(json: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(InsertDrinksURL)?json=\(json)&bar_id=\(DrinkUser.iUser.barId!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else if success == 2 {
                        completionHandler(false)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func forgotPasswordOnServer(email: String, type: String, completionHandler: @escaping (Bool?) -> ()) {
        let params:[String:Any] = ["email": email]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(ForgotPasswordURL)", method: .post, parameters: params) { (response) in
            print(response)
            if response.value!.contains("yes") {
                completionHandler(true)
            } else {
                completionHandler(nil)
            }
//            if let res = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
//                if let success = res["success"] as? Int {
//                    if success == 1 {
//                        completionHandler(true)
//                    } else {
//                        completionHandler(nil)
//                    }
//                } else {
//                    completionHandler(nil)
//                }
//            } else {
//                completionHandler(nil)
//            }
        }
    }
    
    class func uploadUserImageOnServer(imgData: Data, fileURL: URL, completionHandler: @escaping (String?) -> ()) {
        let fileName = fileURL.path
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imgData, withName: "FILE", fileName: fileName ,mimeType: "image/jpeg")
            formData.append("\(DrinkUser.iUser.userName!)".data(using: .utf8)!, withName: "name")
            formData.append(DrinkUser.iUser.userId!.data(using: .utf8)!, withName: "user_id")
        }, to: "\(DrinkChopBaseURL)add_admin_user_picture.php") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    if let res = response.result.value as? [String:Any] {
                        if let success = res["success"] as? Int {
                            if success == 1 {
                                completionHandler(res["img"] as? String ?? "")
                            } else {
                                completionHandler(nil)
                            }
                        } else {
                            completionHandler(nil)
                        }
                    } else {
                        completionHandler(nil)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(nil)
            }
        }
    }
    
    class func addNewDrinkOnServer(imgData: Data, fileURL: URL, params: [String:Data], completionHandler: @escaping (String?) -> ()) {
        let fileName = fileURL.path
        Alamofire.upload(multipartFormData: { (formData) in
            for (key,val) in params {
                formData.append(val, withName: key)
            }
            formData.append(imgData, withName: "FILE", fileName: fileName ,mimeType: "image/jpeg")
        }, to: "\(DrinkChopBaseURL)add_new_bar_drink.php") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    if let res = response.result.value as? [String:Any] {
                        if let success = res["success"] as? Int {
                            if success == 1 {
                                completionHandler(res["img"] as? String ?? "")
                            } else {
                                completionHandler(nil)
                            }
                        } else {
                            completionHandler(nil)
                        }
                    } else {
                        completionHandler(nil)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(nil)
            }
        }
    }
    
    class func addUserOnServer(name: String, barId: String, email: String, password: String, phone: String, Type: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(AddUserURL)?name=\(name)&bar_id=\(barId)&email=\(email)&password=\(password)&phone=\(phone)&type=\(Type)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
  
    class func getSocialSitesFromServer(barId: String, completionHandler: @escaping socialAlias) {
        getData.getDataFromServer(subUrl: "\(SocialSitesURL)?bar_id=\(barId)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(parseSocialSitesData(response: res, key: "result"))
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }

    class func updateSocialSitesOnServer(fb: String, tw: String, insta: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(AddSocialSitesURL)?fb=\(fb)&bar_id=\(barId)&tw=\(tw)&inst=\(insta)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func addHappyHourOnServer(name: String, about: String, stime: String, etime: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(AddHappyHourURL)?happy_hour_name=\(name)&happy_hour_start_time=\(stime)&happy_hour_end_time=\(etime)&happy_hour_about=\(about)&bar_id=\(barId)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func addEventOnServer(name: String, about: String, stime: String, etime: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(AddEventURL)?event_name=\(name)&event_start_time=\(stime)&event_end_time=\(etime)&event_about=\(about)&bar_id=\(barId)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
}
