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
    
    private var isInIPadViewContainer = false
    
    private var ipadViewContainerPreviousVC : UIViewController? = nil
        
    // MARK: - Variables
    private var scrollViewLastContentOffset : CGFloat = 0
    
    var tmtModel = TradeMeTaskApiAccessModel()
    
    // MARK: - Outlets
    @IBOutlet weak var searchSectionHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var searchSectionWidthLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var cancelButtonWidthLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var searchTextField: UITextField?
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    @IBOutlet weak var scrollableContentView: UIView?
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var menuContainerWidthLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var ipadDetailVcContainer: UIView?
    
    @IBOutlet weak var ipadSearchTextField: UITextField?
    
    
    // MARK: - Target Actions
    @IBAction func cancelButtonPressed(sender: UIButton) {
        searchTextField?.resignFirstResponder()
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
    
    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
        if menuContainerWidthLayoutConstraint?.constant == 0{
            menuContainerWidthLayoutConstraint?.constant = 300
        }
        else{
            menuContainerWidthLayoutConstraint?.constant = 0
        }
        UIView.animateWithDuration(0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField?.delegate = self
        ipadSearchTextField?.delegate = self
        hideMenuButton()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("[viewWillAppear]")
        scrollViewLastContentOffset = 0
        displayNormalModeSearchSection()
        registerNotifications()
        handleUserAuthentication()
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        if isInIPadViewContainer{
            showMenuButton()
        }
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleDetailedContentSwithNotification(_:)), name: Constants.NOTI_NEED_SWITCH_IPAD_DETAILED_CONTENT, object: nil)
    }
    
    private func deregisterNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleDetailedContentSwithNotification(notification:NSNotification){
        print("[handleDetailedContentSwithNotification]")
        if let userInfo = notification.userInfo{
            if let segueIdentifier = userInfo["segueIdentifier"] as? String{
                switch segueIdentifier {
                case Constants.SEGUE_SHOW_SUB_CATEGORIES:
                    if let cateNumber = userInfo["cateNumber"] as? String{
                        if let subCategoriesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TmtSubCategoriesTableViewController") as? TmtSubCategoriesTableViewController{
                            subCategoriesViewController.tmtModel = tmtModel
                            subCategoriesViewController.subCategoryNumber = cateNumber
                            subCategoriesViewController.isInIPadViewContainer = true
                            swithToContentViewController(subCategoriesViewController)
                        }
                    }
                case Constants.SEGUE_SHOW_LISTINGS:
                    if let cateNumber = userInfo["selectedCategoryNumber"] as? String{
                        if let listingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TmtListingsTableViewController") as? TmtListingsTableViewController{
                            listingTableViewController.tmtModel = tmtModel
                            listingTableViewController.tmtSelectedCategoryNumber = cateNumber
                            listingTableViewController.isInIPadViewContainer = true
                            swithToContentViewController(listingTableViewController)
                        }
                    }
                case Constants.SEGUE_SHOW_LISTING_DETAILS:
                    if let listingId = userInfo["listingId"] as? Int{
                        if let listingDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TmtListingDetailsViewController") as?  TmtListingDetailsViewController{
                            listingDetailViewController.tmtModel = tmtModel
                            listingDetailViewController.ldListingId = listingId
                            listingDetailViewController.isInIPadViewContainer = true
                            swithToContentViewController(listingDetailViewController)
                        }
                    }
                default:
                    break
                }
            }
        }
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
                    destVc.tmtModel = tmtModel
                    destVc.searchString = searchTextField?.text
                }
            }
            else if identifier == Constants.SEGUE_SHOW_IPAD_BROWSE_CATEGORIES_MENU{
                //showMenuButton()
                isInIPadViewContainer = true
                if let destVc = segue.destinationViewController as? TmtIpadBrowseCategoriesViewController{
                    destVc.tmtModel = tmtModel
                }
            }
        }
    }
    
    // MARK: - delegate methods [UITextField]
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        displayEditModeSearchSection()
        ipadSearchTextField?.textAlignment = NSTextAlignment.Left
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        displayNormalModeSearchSection()
        if textField == searchTextField{
            self.performSegueWithIdentifier(Constants.SEGUE_SEARCH_LISTINGS, sender: self)
        }
        if textField == ipadSearchTextField{
            ipadSearchTextField?.textAlignment = NSTextAlignment.Center
            if let listingTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TmtListingsTableViewController") as? TmtListingsTableViewController{
                listingTableViewController.tmtModel = tmtModel
                listingTableViewController.searchString = ipadSearchTextField?.text
                listingTableViewController.isInIPadViewContainer = true
                swithToContentViewController(listingTableViewController)
            }
        }
        
        return true
    }
    
    // MARK: - private func
    private func swithToContentViewController(content:UIViewController){
        print("[swithToContentViewController]")
        self.addChildViewController(content)
        content.view.frame = self.ipadDetailVcContainer!.bounds
        if ipadViewContainerPreviousVC != nil{
            ipadViewContainerPreviousVC?.removeFromParentViewController()
            ipadViewContainerPreviousVC = content
        }
        ipadDetailVcContainer!.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    private func moveToViewController(viewController: UIViewController){
        
    }
    private func handleUserAuthentication(){
        oauthHelper.handleUserAuthentication(Constants.CREDENTIAL_TRADEME_CONSUMER_KEY, consumerSecret: Constants.CREDENTIAL_TRADEME_CONSUMER_SECRET)
    }
    
    private func displayNormalModeSearchSection(){
        if searchTextField == nil || cancelButtonWidthLayoutConstraint == nil || searchSectionWidthLayoutConstraint == nil || searchSectionHeightLayoutConstraint == nil{
            return
        }
        searchTextField?.textAlignment = NSTextAlignment.Center
        cancelButtonWidthLayoutConstraint?.constant = CONST_CANCEL_BUTTON_NORMAL_MODE_SIZE
        searchSectionWidthLayoutConstraint = searchSectionWidthLayoutConstraint?.setMultiplier(CONST_SEARCH_SECTION_NORMAL_MODE_WIDTH_PROPORTION)
        searchSectionHeightLayoutConstraint = searchSectionHeightLayoutConstraint?.setMultiplier(CONST_SEARCH_SECTION_NORMAL_MODE_HEIGHT_PROPORTION)
        UIView.animateWithDuration(CONST_SECTION_CHANGE_ANIMATION_PERIOD) { [weak self] in
            if self != nil{
                self!.view.layoutIfNeeded()
            }
        }
    }
    private func displayEditModeSearchSection(){
        if searchTextField == nil || cancelButtonWidthLayoutConstraint == nil || searchSectionWidthLayoutConstraint == nil || searchSectionHeightLayoutConstraint == nil{
            return
        }
        searchTextField?.textAlignment = NSTextAlignment.Left
        cancelButtonWidthLayoutConstraint?.constant = CONST_CANCEL_BUTTON_EDIT_MODE_SIZE
        searchSectionWidthLayoutConstraint = searchSectionWidthLayoutConstraint?.setMultiplier(CONST_SEARCH_SECTION_EDIT_MODE_WIDTH_PROPORTION)
        searchSectionHeightLayoutConstraint = searchSectionHeightLayoutConstraint?.setMultiplier(CONST_SEARCH_SECTION_EDIT_MODE_HEIGHT_PROPORTION)
        UIView.animateWithDuration(CONST_SECTION_CHANGE_ANIMATION_PERIOD) { [weak self] in
            if self != nil{
                self!.view.layoutIfNeeded()
            }
        }
    }
    private func hideMenuButton(){
        menuButton.enabled = false
        menuButton.tintColor = UIColor.clearColor()
    }
    private func showMenuButton(){
        print("[ShowMenuButton]")
        menuButton.enabled = true
        menuButton.tintColor = nil
    }
}

