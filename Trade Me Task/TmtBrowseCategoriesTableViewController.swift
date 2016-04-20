//
//  TmtBrowseCategoriesTableViewController.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 19/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtBrowseCategoriesTableViewController: UITableViewController {
    
    // MARK: - variables
    var tmtModel : TradeMeTaskApiAccessModel?
    
    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()
    
    // MARK: - Target Actions
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingScreen()
        registerNotifications()
        tmtModel?.tmtGategoryBrowsing("0", depth: 1, withCount: false)
        self.tableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterNotifications()
    }

    // MARK: - Private functions
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
        let x = (self.tableView.bounds.width / 2) - (width / 2)
        let y = (self.tableView.bounds.height / 2) - (height / 2)
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
        self.tableView.addSubview(loadingView)
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
                            self!.tableView.reloadData()
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
    
    // MARK: - Table view data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tmtCategories = tmtModel?.getTmtCategories{
            return tmtCategories.cateSubCategories.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CELL_IDENTIFIER_BROWSE_CATEGORIES, forIndexPath: indexPath)

        if let tmtCategories = tmtModel?.getTmtCategories{
            if tmtCategories.cateSubCategories.count > indexPath.row{
                cell.textLabel?.text = tmtCategories.cateSubCategories[indexPath.row].cateName ?? ""
            }
        }
        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < tmtModel?.getTmtCategories?.cateSubCategories.count{
            self.performSegueWithIdentifier(Constants.SEGUE_SHOW_SUB_CATEGORIES, sender: self)
        }
    }
    
    
     // MARK: - Navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == Constants.SEGUE_SHOW_SUB_CATEGORIES{
                if let destVc = segue.destinationViewController as? TmtSubCategoriesTableViewController{
                    if let row = self.tableView.indexPathForSelectedRow?.row{
                        destVc.tmtModel = tmtModel
                        destVc.subCategoryNumber = tmtModel?.getTmtCategories?.cateSubCategories[row].cateNumber
                        //print("subCategoryNumber: \(destVc.subCategoryNumber)")
                    }
                }
            }
        }
     }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
