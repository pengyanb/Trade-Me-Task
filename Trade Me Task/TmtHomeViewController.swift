//
//  ViewController.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 18/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtHomeViewController: UIViewController, UITextFieldDelegate,  UIScrollViewDelegate {

    // MARK: - Constants
    private let CONST_CANCEL_BUTTON_EDIT_MODE_SIZE : CGFloat = 60
    private let CONST_CANCEL_BUTTON_NORMAL_MODE_SIZE : CGFloat = 0
    
    private let CONST_SEARCH_SECTION_EDIT_MODE_HEIGHT_PROPORTION : CGFloat = 0.1
    private let CONST_SEARCH_SECTION_NORMAL_MODE_HEIGHT_PROPORTION : CGFloat = 1 / 3
    
    private let CONST_SEARCH_SECTION_EDIT_MODE_WIDTH_PROPORTION : CGFloat = 0.9
    private let CONST_SEARCH_SECTION_NORMAL_MODE_WIDTH_PROPORTION : CGFloat = 0.7
    
    private let CONST_SECTION_CHANGE_ANIMATION_PERIOD = 0.5
    
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
    
    
    // MARK: - Target Actions
    @IBAction func cancelButtonPressed(sender: UIButton) {
        searchTextField.resignFirstResponder()
        displayNormalModeSearchSection()
    }
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        scrollView.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scrollViewLastContentOffset = 0
        displayNormalModeSearchSection()
        
        let oauthHelper = TradeMeOauthHelper()
        oauthHelper.handleUserAuthentication(Constants.CREDENTIAL_TRADEME_CONSUMER_KEY, consumerSecret: Constants.CREDENTIAL_TRADEME_CONSUMER_SECRET)
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
        return true
    }
    
    // MARK: - delegate methods [UIScrollView]
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //print("[Offset]: \(scrollView.contentOffset.y)")
        //print("[View Height]: \(self.view.bounds.size.height)")
        //print("[Multiplier]: \(newHeightMultiplier)")
        if scrollViewLastContentOffset > scrollView.contentOffset.y {   //scrolled down
             let newHeightMultiplier = searchSectionHeightLayoutConstraint.multiplier + scrollView.contentOffset.y / self.view.bounds.size.height
            if searchSectionHeightLayoutConstraint.multiplier < CONST_SEARCH_SECTION_NORMAL_MODE_HEIGHT_PROPORTION{
                searchSectionHeightLayoutConstraint = searchSectionHeightLayoutConstraint.setMultiplier(min(CONST_SEARCH_SECTION_NORMAL_MODE_HEIGHT_PROPORTION, newHeightMultiplier))
                self.view.setNeedsLayout()
            }
        }
        else if scrollViewLastContentOffset < scrollView.contentOffset.y { //scrolled up
            //print("[Scrolled up]")
             let newHeightMultiplier = searchSectionHeightLayoutConstraint.multiplier - scrollView.contentOffset.y / self.view.bounds.size.height
            if searchSectionHeightLayoutConstraint.multiplier > CONST_SEARCH_SECTION_EDIT_MODE_HEIGHT_PROPORTION{
                searchSectionHeightLayoutConstraint =  searchSectionHeightLayoutConstraint.setMultiplier(max(CONST_SEARCH_SECTION_EDIT_MODE_HEIGHT_PROPORTION, newHeightMultiplier))
                self.view.setNeedsLayout()
            }
        }
        scrollViewLastContentOffset = scrollView.contentOffset.y
 
    }
    
    // MARK: - private func
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

