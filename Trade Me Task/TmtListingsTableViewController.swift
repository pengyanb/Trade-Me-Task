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
    
    private var readyToFetchMoreListing  = true
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingScreen()
        registerNotifications()
        tmtModel?.tmtGeneralSearch(nil, category: tmtSelectedCategoryNumber, clearance: nil, condition: nil, dataFrom: nil, expired: nil, memberListing: nil, page: nil, pay: nil, photoSize: EnumGeneralSearchPhotoSize.List, returnMetadata: nil, rows: Constants.COUNT_LISTINGS_LOAD_QUOTA, searchString: searchString, shippingMethod: nil, sortOrder: sortOrder, userDistrict: nil, userRegion: nil, clearExistingResult: true)
        self.tableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterNotifications()
    }
    
    // MARK: - Private functions [Loading Spinner]
    private func showLoadingScreen(){
        loadingView.hidden = false
        readyToFetchMoreListing = false
        spinner.startAnimating()
    }
    private func hideLoadingScreen(){
        loadingView.hidden = true
        readyToFetchMoreListing = true
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
                case Constants.NOTI_UPDATE_SEARCH_RESULT_LOADED:
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
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tmtSearchResults = tmtModel?.getTmtSearchResults{
            if tmtSearchResults.count > 0{
                var rowCount : Int = 0
                for searchResult in tmtSearchResults{
                    if let pageSize = searchResult.srPageSize{
                        rowCount += pageSize
                    }
                }
                return rowCount
            }
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CELL_IDENTIFIER_LISTING, forIndexPath: indexPath)

        if let listingCell = cell as? TmtListingsTableViewCell{
            if let tmtSearchResults = tmtModel?.getTmtSearchResults{
                let pageIndex = Int(indexPath.row / Constants.COUNT_LISTINGS_LOAD_QUOTA)
                let listingIndex = indexPath.row - pageIndex * Constants.COUNT_LISTINGS_LOAD_QUOTA
                //print("[PageIndex]: \(pageIndex) [ListingIndex]: \(listingIndex)")
                if tmtSearchResults.count > pageIndex{
                    let tmtSearchResult = tmtSearchResults[pageIndex]
                    if listingIndex < tmtSearchResult.srList.count{
                        let listing = tmtSearchResult.srList[listingIndex]
                        if let pictureHref = listing.liPictureHref{
                            if let pictureUrl = NSURL.init(string: pictureHref){
                                tmtModel?.downloadDataFromUrl(pictureUrl, completion: {(data, response, error) in
                                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                                        if self != nil{
                                            guard let data = data where error == nil else {return}
                                            listingCell.listingImageView.image = UIImage(data: data)
                                        }
                                    })
                                })
                            }
                        }
                        listingCell.listingCityLabel.text = listing.liRegion ?? ""
                        listingCell.listingNameLabel.text = listing.liTitle ?? ""
                        listingCell.listingPriceLabel.text = (listing.liStartPrice != nil ? "\(listing.liPriceDisplay!)" : "")
                        listingCell.listingTimeLabel.text = (listing.liStartDate != nil ? "\(listing.liStartDate!.generateDateTimeString())" : "")
                    }
                }
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pageIndex = Int(indexPath.row / Constants.COUNT_LISTINGS_LOAD_QUOTA)
        let listingIndex = indexPath.row - pageIndex * Constants.COUNT_LISTINGS_LOAD_QUOTA
        if let tmtSearchResults = tmtModel?.getTmtSearchResults{
            if tmtSearchResults.count > pageIndex{
                let tmtSearchResult = tmtSearchResults[pageIndex]
                if listingIndex < tmtSearchResult.srList.count{
                    self.performSegueWithIdentifier(Constants.SEGUE_SHOW_LISTING_DETAILS, sender: self)
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == Constants.SEGUE_SHOW_LISTING_DETAILS{
                if let destVc = segue.destinationViewController as? TmtListingDetailsViewController{
                    if let indexPath = self.tableView.indexPathForSelectedRow{
                        let pageIndex = Int(indexPath.row / Constants.COUNT_LISTINGS_LOAD_QUOTA)
                        let listingIndex = indexPath.row - pageIndex * Constants.COUNT_LISTINGS_LOAD_QUOTA
                        if let tmtSearchResults = tmtModel?.getTmtSearchResults{
                            if tmtSearchResults.count > pageIndex{
                                let tmtSearchResult = tmtSearchResults[pageIndex]
                                if listingIndex < tmtSearchResult.srList.count{
                                    let listing  = tmtSearchResult.srList[listingIndex]
                                    destVc.ldListingId = listing.liListingId
                                    destVc.tmtModel = tmtModel
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - scrollView Did scroll [Load more listing if reach bottom]
    override func scrollViewDidScroll(scrollView: UIScrollView) {
       
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset <= 20.0){
            if readyToFetchMoreListing{
                if let tmtSearchResults = tmtModel?.getTmtSearchResults
                {
                    if let tmtsearchResult = tmtSearchResults.last{
                        showLoadingScreen()
                        tmtModel?.tmtGeneralSearch(nil, category: tmtSelectedCategoryNumber, clearance: nil, condition: nil, dataFrom: nil, expired: nil, memberListing: nil, page: tmtsearchResult.srPage, pay: nil, photoSize: EnumGeneralSearchPhotoSize.List, returnMetadata: nil, rows: Constants.COUNT_LISTINGS_LOAD_QUOTA, searchString: searchString, shippingMethod: nil, sortOrder: sortOrder, userDistrict: nil, userRegion: nil, clearExistingResult: false)
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
