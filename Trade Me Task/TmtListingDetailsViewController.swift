//
//  TmtListingDetailsViewController.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 21/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import UIKit

class TmtListingDetailsViewController: UIViewController {

    // MARK: - Variables
    var tmtModel : TradeMeTaskApiAccessModel?
    
    var ldListingId : Int?
    var ldIncrementViewCount : Bool?
    var ldQuestionLimit : Int?
    var ldReturnMemberProfile : Bool?
    
    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()
    
    private var currentImageIndex  = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageGalleryIndexLabel: UILabel!
    @IBOutlet weak var listingTitleLabel: UILabel!
    @IBOutlet weak var listingEndDateLabel: UILabel!
    @IBOutlet weak var listingBodyTextview: UITextView!
    
    @IBOutlet weak var listingGalleryImageView: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen()
        
        let leftSwipeGestureRecognizer  = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeToLeftOnImageView(_:)))
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.listingGalleryImageView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeToRightOnImageView(_:)))
        self.listingGalleryImageView.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //print("[ListingId]: \(ldListingId)")
        currentImageIndex = 0
        showLoadingScreen()
        registerNotifications()
        if let listingId = ldListingId{
            tmtModel?.tmtRetrieveListingDetails(listingId, incrementViewCount: ldIncrementViewCount, questionLimit: ldQuestionLimit, returnMemberProfile: ldReturnMemberProfile)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterNotifications()
    }
    
    // MARK: - Swipe Gesture handlers
    func swipeToLeftOnImageView(sender: UISwipeGestureRecognizer) {
        if let tmtListingDetail = tmtModel?.getTmtListingDetail{
            let ldPhotos = tmtListingDetail.ldPhotos
            if (currentImageIndex - 1 >= 0) && (currentImageIndex - 1 < ldPhotos.count){
                let ldPhoto = ldPhotos[currentImageIndex - 1]
                if let ldpValue = ldPhoto.ldpValue{
                    if let ldpuGallery = ldpValue.ldpuGallery{
                        if let url = NSURL.init(string: ldpuGallery){
                            tmtModel?.downloadDataFromUrl(url, completion: { (data, response, error) in
                                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                                    if self != nil{
                                        guard let data = data where error == nil else {return}
                                        self!.listingGalleryImageView.image = UIImage(data: data)
                                        var indexLabelText = ""
                                        self!.currentImageIndex =  self!.currentImageIndex - 1
                                        for index in 0 ..< ldPhotos.count{
                                            if index == self!.currentImageIndex{
                                                indexLabelText += "⚪️"
                                            }
                                            else{
                                                indexLabelText += "⚫️"
                                            }
                                        }
                                        self!.imageGalleryIndexLabel.text = indexLabelText
                                    }
                                    })
                            })
                        }
                    }
                }
                
            }
        }
    }
    
    func swipeToRightOnImageView(sender: UISwipeGestureRecognizer) {
        if let tmtListingDetail = tmtModel?.getTmtListingDetail{
            let ldPhotos = tmtListingDetail.ldPhotos
            if currentImageIndex + 1 < ldPhotos.count{
                let ldPhoto = ldPhotos[currentImageIndex + 1]
                if let ldpValue = ldPhoto.ldpValue{
                    if let ldpuGallery = ldpValue.ldpuGallery{
                        if let url = NSURL.init(string: ldpuGallery){
                            tmtModel?.downloadDataFromUrl(url, completion: { (data, response, error) in
                                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                                    if self != nil{
                                        guard let data = data where error == nil else {return}
                                        self!.listingGalleryImageView.image = UIImage(data: data)
                                        var indexLabelText = ""
                                        self!.currentImageIndex =  self!.currentImageIndex + 1
                                        for index in 0 ..< ldPhotos.count{
                                            if index == self!.currentImageIndex{
                                                indexLabelText += "⚪️"
                                            }
                                            else{
                                                indexLabelText += "⚫️"
                                            }
                                        }
                                        self!.imageGalleryIndexLabel.text = indexLabelText
                                    }
                                    })
                            })
                        }
                    }
                }
                
            }
        }
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
                case Constants.NOTI_UPDATE_LISTING_DETAILS_LOADED:
                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                        if self != nil{
                            self!.hideLoadingScreen()
                            //print(Constants.NOTI_UPDATE_LISTING_DETAILS_LOADED)
                            if let tmtListingDetail = self!.tmtModel?.getTmtListingDetail{
                                if let ldTitle = tmtListingDetail.ldTitle{
                                    self!.listingTitleLabel.text = ldTitle
                                    self!.title = ldTitle
                                }
                                if let ldEndDate = tmtListingDetail.ldEndDate{
                                    self!.listingEndDateLabel.text = "End Date: \(ldEndDate.generateDateTimeString())"
                                }
                                if let ldBody = tmtListingDetail.ldBody{
                                    self!.listingBodyTextview.text = ldBody
                                }
                                let ldPhotos = tmtListingDetail.ldPhotos
                                if let ldPhoto = ldPhotos.first{
                                    if let ldpValue = ldPhoto.ldpValue{
                                        if let ldpuGallery = ldpValue.ldpuGallery{
                                            if let url = NSURL.init(string: ldpuGallery){
                                                self!.tmtModel?.downloadDataFromUrl(url, completion: { (data, response, error) in
                                                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                                                        if self != nil{
                                                            guard let data = data where error == nil else {return}
                                                            self!.listingGalleryImageView.image = UIImage(data: data)
                                                            var indexLabelText = ""
                                                            self!.currentImageIndex = 0
                                                            for index in 0 ..< ldPhotos.count{
                                                                if index == self!.currentImageIndex{
                                                                    indexLabelText += "⚪️"
                                                                }
                                                                else{
                                                                    indexLabelText += "⚫️"
                                                                }
                                                            }
                                                            self!.imageGalleryIndexLabel.text = indexLabelText
                                                        }
                                                    })
                                                })
                                            }
                                        }
                                    }
                                }
                                
                            }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
