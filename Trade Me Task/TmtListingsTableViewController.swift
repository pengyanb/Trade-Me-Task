//
//  TmtListingsTableViewController.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 20/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtListingsTableViewController: UITableViewController {

    // MARK: - Variables
    var tmtModel : TradeMeTaskApiAccessModel?
    var tmtSelectedCategoryNumber: String?
    var searchString : String?
    var sortOrder : EnumGeneralSearchSortOrder = EnumGeneralSearchSortOrder.Default
    
    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingScreen()
        tmtModel?.tmtGeneralSearch(nil, category: tmtSelectedCategoryNumber, clearance: nil, condition: nil, dataFrom: nil, expired: nil, memberListing: nil, page: nil, pay: nil, photoSize: EnumGeneralSearchPhotoSize.List, returnMetadata: nil, rows: Constants.COUNT_LISTINGS_LOAD_QUOTA, searchString: searchString, shippingMethod: nil, sortOrder: sortOrder, userDistrict: nil, userRegion: nil)
        self.tableView.reloadData()
    }
    
    // MARK: - Private functions [Loading Spinner]
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

    // MARK: - Notifications
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
                case Constants.NOTI_UPDATE_LISTINGS_LOADED:
                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                        if self != nil{
                            self!.hideLoadingScreen()
                            self!.tableView.reloadData()
                            //!! todo
                        }
                    })
                default:
                    break
                }
            }
        }
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
