//
//  TmtIpadBrowseCategoriesViewController.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 23/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtIpadBrowseCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Variables
    var tmtModel : TradeMeTaskApiAccessModel?
    
    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()
    
    // MARK: - Outlets
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoriesTableView.dataSource = self
        self.categoriesTableView.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingScreen()
        registerNotifications()
        tmtModel?.tmtGategoryBrowsing("0", depth: 1, withCount: false)
        self.categoriesTableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterNotifications()
    }
    
    // MARK: - Private Fucntions
    private func showLoadingScreen(){
        loadingView.hidden = false
        spinner.startAnimating()
    }
    private func hideLoadingScreen(){
        loadingView.hidden = true
        spinner.stopAnimating()
    }
    private func setLoadingScreen(){
        let width : CGFloat = 150
        let height: CGFloat = 30
        let x = (self.view.bounds.width / 2) - (width / 2)
        let y = (self.view.bounds.height / 2) - (height / 2)
        loadingView.frame = CGRectMake(x, y, width, height)
        
        let loadingLabel = UILabel()
        loadingLabel.textColor = UIColor.grayColor()
        loadingLabel.textAlignment = .Center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRectMake(0, 0, 150, 30)
        
        spinner.activityIndicatorViewStyle = .Gray
        spinner.color = UIColor.darkGrayColor()
        spinner.frame = CGRectMake(0, 0, 30, 30)
        spinner.hidesWhenStopped = true
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        self.view.addSubview(loadingView)
    }
    
    // MARK: - Notification
    private func registerNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleModelChangeNotification(_:)), name: Constants.NOTI_IDENTIFIER_TMT_MODEL_CHANGED, object: nil)
    }
    private func deregisterNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleModelChangeNotification(notification:NSNotification){
        if let userInfo = notification.userInfo{
            if let statusInfo = userInfo["update"] as? String{
                switch statusInfo {
                case Constants.NOTI_UPDATE_CATEGORIES_LOADED:
                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                        if self != nil{
                            self!.hideLoadingScreen()
                            self!.categoriesTableView.reloadData()
                        }
                        })
                default:
                    break
                }
            }
            if let errorInfo = userInfo["error"] as? String{
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.hideLoadingScreen()
                    UIAlertView.init(title: "Error", message: errorInfo, delegate: nil, cancelButtonTitle: "OK").show()
                    })
                
            }
        }
        
    }
    
    // MARK: -Table view data source and delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tmtCategories = tmtModel?.getTmtRootCategories{
            return tmtCategories.cateSubCategories.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CELL_IDENTIFIER_BROWSE_CATEGORIES, forIndexPath: indexPath)
        
        if let tmtCategories = tmtModel?.getTmtRootCategories{
            if tmtCategories.cateSubCategories.count > indexPath.row{
                cell.textLabel?.text = tmtCategories.cateSubCategories[indexPath.row].cateName ?? ""
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < tmtModel?.getTmtRootCategories?.cateSubCategories.count{
            //self.performSegueWithIdentifier(Constants.SEGUE_SHOW_SUB_CATEGORIES, sender: self)
            if indexPath.row < tmtModel?.getTmtRootCategories?.cateSubCategories.count{
                if let cateNumber = tmtModel!.getTmtRootCategories!.cateSubCategories[indexPath.row].cateNumber{
                    let userObject: [String:AnyObject] = ["segueIdentifier":Constants.SEGUE_SHOW_SUB_CATEGORIES, "cateNumber" : cateNumber]
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.NOTI_NEED_SWITCH_IPAD_DETAILED_CONTENT, object: self, userInfo: userObject)
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
