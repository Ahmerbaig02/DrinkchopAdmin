
//
//  Helper.swift
//  Momentum
//
//  Created by Mac on 22/05/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit


let NoImageURL = "http://newhorizonindia.edu/college_edu/wp-content/uploads/2016/07/member_default_img-200x200.png"
let DrinkChopBaseURL:String = "http://kokotuicom.fatcow.com/drinkchop/"

//Colors

let appTintColor = UIColor(red: 37/255, green: 128/255, blue: 232/255, alpha: 1)


let DrinkChopNotificationID = "DrinkChopNotification"

//URLs
let SigninURL = "sign_in_admin.php"
let SignupURL = "create_account.php"
let BarsURL = "getbars.php"
let getAllEventsHappyHoursURL = "geteventssimple.php"
let EventsURL = "getevents.php"
let CardsURL = "get_cards.php"
let CoversURL = "get_covers.php"
let CardStatusURL = "add_card_status.php"
let AddCardURL = "save_card.php"
let DeleteCardURL = "delete_card.php"
let GetExtrasURL = "get_super_extras.php"
let GetSettingsURL = "get_settings.php"
let ChangePasswordURL = "change_user_password.php"
let BarEventsURL = "get_event.php"
let BarHoursURL = "get_hour.php"
let ForgotPasswordURL = "forgotpassword_admin.php"
let SaveSettingsURL = "save_settings.php"
let SaveAllergyURL = "save_allergies.php"
let SalesURL = "get_sales.php"
let AdminUsersURL = "get_users_for_admin.php"
let ChangeBarStatusURL = "change_bar_status.php"
let UpdateTokenURL = "update_token_admin.php"
let GetDrinksURL = "get_drinks_from_admin.php"
let GetOrdersURL = "get_Orders.php"
let InsertDrinksURL = "insert_drinks.php"
let CheckInURL = "confirmation_checkin.php"
let AddUserURL = "add_user_by_admin.php"
let SocialSitesURL = "get_bar_social_sites.php"
let AddSocialSitesURL = "add_social_sites.php"
let OrderAcceptURL = "order_accept_confirmation.php"
let DoctorMessageURL = "sendMessageForDoctor.php"
let PatientMessageURL = "sendMessageForPatient.php"
let AddHappyHourURL = "savehappyhour.php"
let AddEventURL = "saveevent.php"

// MARK: - collection&table ViewResuableID
let notificationCellID = "notificationCell"
let AddCardCellID = "AddCardCell"
let CardCellID = "CardCell"
let CoverCellID = "CoverCell"
let PeopleDoorCellID = "PeopleCell"
let AccountCellID = "AccountCell"
let messageCellID = "messageCell"
let chatCellID = "chatCell"
let drinkCellID = "drinkCell"
let FavouritesHeaderID = "FavouritesHeader"
let FavouritesFooterID = "FavouritesFooter"
let HyveDrinkCellID = "HyveDrinkCell"
let SearchDrinkCellID = "SearchDrinkCell"
let EventCellID = "EventCell"
let OrderCellID = "OrderCell"

// MARK: - SegueID
let VerifyFirstSegueID = "verifyFirst"
let loginSegueID = "Login"
let forgotSegueID = "Forgot"
let ServingSegueID = "ServingSegue"
let LoggedInSegueID = "LoggedIn"
let signupSegueID = "Signup"
let LogoutSegueID = "Logout"
let SelectedCardSegueID = "SelectedCard"
let DrinksSegueID = "Drinks"
let SelectedDrinkSegueID = "SelectedDrink"
let SelectedBarSegueID = "SelectedBar"
let SelectedEventSegueID = "SelectedEvent"
let showEventSegueID = "showEvent"
let addCardSegueID = "AddCard"
let mapUnwindSegueID = "gotoMapView"
let LocationSegueID = "LocationSegue"
let MessageDetailsSegueID = "MessageDetails"
let newDrinkSegueID = "newDrink"


// MARK: - Defaults ID
let rideDataDefaultsID = "rideData"
let UserProfileDefaultsID = "UserProfileDefaults"
let isLoggedInDefaultID = "isLoggedIn"
let fcmTokenDefaultsID = "FCM Token"
let messagesDefaultID = "MessagesDefault"
