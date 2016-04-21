//
//  ViewController.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 18/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtHomeViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Constants
    private let CONST_CANCEL_BUTTON_EDIT_MODE_SIZE : CGFloat = 60
    private let CONST_CANCEL_BUTTON_NORMAL_MODE_SIZE : CGFloat = 0
    
    private let CONST_SEARCH_SECTION_EDIT_MODE_HEIGHT_PROPORTION : CGFloat = 0.1
    private let CONST_SEARCH_SECTION_NORMAL_MODE_HEIGHT_PROPORTION : CGFloat = 1 / 3
    
    private let CONST_SEARCH_SECTION_EDIT_MODE_WIDTH_PROPORTION : CGFloat = 0.9
    private let CONST_SEARCH_SECTION_NORMAL_MODE_WIDTH_PROPORTION : CGFloat = 0.7
    
    private let CONST_SECTION_CHANGE_ANIMATION_PERIOD = 0.5
    
    private let oauthHelper = TradeMeOauthHelper()
    
    // MARK: - Variables
    private var scrollViewLastContentOffset : CGFloat = 0
    
    var tmtModel = TradeMeTaskApiAccessModel()
    
    // MARK: - Outlets
    @IBOutlet weak var searchSectionHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchSectionWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonWidthLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollableContentView: UIView!
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    // MARK: - Target Actions
    @IBAction func cancelButtonPressed(sender: UIButton) {
        searchTextField.resignFirstResponder()
        displayNormalModeSearchSection()
    }
    
    @IBAction func loginButtonPressed(sender: UIBarButtonItem) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let finalTokenDictionary = userDefault.objectForKey(Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY) as? [String:String]{
            if let _ = finalTokenDictionary["oauth_token"], _ = finalTokenDictionary["oauth_token_secret"]{
                loginButton.title = "Login"
                
                userDefault.removeObjectForKey(Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY)
                userDefault.removeObjectForKey(Constants.NSUSER_DEFAULT_TEMP_TOKEN_KEY)
                userDefault.synchronize()
            }
            else{
                handleUserAuthentication()
            }
        }
        else{
            handleUserAuthentication()
        }

    }
    
    @IBAction func scrollViewTapped(sender: UITapGestureRecognizer) {
        displayNormalModeSearchSection()
        self.view.endEditing(true)
    }
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("[viewWillAppear]")
        scrollViewLastContentOffset = 0
        displayNormalModeSearchSection()
        registerNotifications()
        handleUserAuthentication()
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let finalTokenDictionary = userDefault.objectForKey(Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY) as? [String:String]{
            if let _ = finalTokenDictionary["oauth_token"], _ = finalTokenDictionary["oauth_token_secret"]{
                //print("[Final Token]: \(token) [Final TokenSecret]: \(tokenSecret)")
                loginButton.title = "Logout"
            }
            else{
                loginButton.title = "Login"
            }
        }
        else{
            loginButton.title = "Login"
        }
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterNotifications()
    }
    
    // MARK: - Notification related
    private func registerNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleOauthNotification(_:)), name: Constants.NOTI_IDENTIFIER_OAUTH_UPDATE, object: nil)
    }
    
    private func deregisterNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func appDidBecomeActive(notification:NSNotification){
        //print("[appDidBecomeActive]")
        handleUserAuthentication()
    }
    
    func handleOauthNotification(notification:NSNotification){
        //print("[Received Oauth Notification]")
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if self != nil{
                let userDefault = NSUserDefaults.standardUserDefaults()
                if let finalTokenDictionary = userDefault.objectForKey(Constants.NSUSER_DEFAULT_FINAL_TOKEN_KEY) as? [String:String]{
                    if let _ = finalTokenDictionary["oauth_token"], _ = finalTokenDictionary["oauth_token_secret"]{
                        //print("[Final Token]: \(token) [Final TokenSecret]: \(tokenSecret)")
                        self!.loginButton.title = "Logout"
                    }
                    else{
                        self!.loginButton.title = "Login"
                    }
                }
                else{
                    self!.loginButton.title = "Login"
                }
            }
        }
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == Constants.SEGUE_SHOW_BROWSE_CATEGORIES{
                var destVc = segue.destinationViewController
                if let naviVc = destVc as? UINavigationController{
                    if let tableVc = naviVc.viewControllers.first as? TmtBrowseCategoriesTableViewController{
                        destVc = tableVc
                    }
                }
                
                if let tableVc = destVc as? TmtBrowseCategoriesTableViewController{
                    tableVc.tmtModel = tmtModel
                }
            }
            else if identifier == Constants.SEGUE_SEARCH_LISTINGS{
                if let destVc = segue.destinationViewController as? TmtListingsTableViewController{
                    print("[Search]")
                    destVc.tmtModel = tmtModel
                    destVc.searchString = searchTextField.text
                }
            }
        }
    }
    
    // MARK: - delegate methods [UITextField]
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        displayEditModeSearchSection()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        displayNormalModeSearchSection()
        self.performSegueWithIdentifier(Constants.SEGUE_SEARCH_LISTINGS, sender: self)
        return true
    }
    
    // MARK: - private func
    private func handleUserAuthentication(){
        oauthHelper.handleUserAuthentication(Constants.CREDENTIAL_TRADEME_CONSUMER_KEY, consumerSecret: Constants.CREDENTIAL_TRADEME_CONSUMER_SECRET)
    }
    
    private func displayNormalModeSearchSection(){
        searchTextField.textAlignment = NSTextAlignment.Center
        cancelButtonWidthLayoutConstraint.constant = CONST_CANCEL_BUTTON_NORMAL_MODE_SIZE
        searchSectionWidthLayoutConstraint = searchSectionWidthLayoutConstraint.setMultiplier(CONST_SEARCH_SECTION_NORMAL_MODE_WIDTH_PROPORTION)
        searchSectionHeightLayoutConstraint = searchSectionHeightLayoutConstraint.setMultiplier(CONST_SEARCH_SECTION_NORMAL_MODE_HEIGHT_PROPORTION)
        UIView.animateWithDuration(CONST_SECTION_CHANGE_ANIMATION_PERIOD) { [weak self] in
            if self != nil{
                self!.view.layoutIfNeeded()
            }
        }
    }
    private func displayEditModeSearchSection(){
        searchTextField.textAlignment = NSTextAlignment.Left
        cancelButtonWidthLayoutConstraint.constant = CONST_CANCEL_BUTTON_EDIT_MODE_SIZE
        searchSectionWidthLayoutConstraint = searchSectionWidthLayoutConstraint.setMultiplier(CONST_SEARCH_SECTION_EDIT_MODE_WIDTH_PROPORTION)
        searchSectionHeightLayoutConstraint = searchSectionHeightLayoutConstraint.setMultiplier(CONST_SEARCH_SECTION_EDIT_MODE_HEIGHT_PROPORTION)
        UIView.animateWithDuration(CONST_SECTION_CHANGE_ANIMATION_PERIOD) { [weak self] in
            if self != nil{
                self!.view.layoutIfNeeded()
            }
        }
    }
}

