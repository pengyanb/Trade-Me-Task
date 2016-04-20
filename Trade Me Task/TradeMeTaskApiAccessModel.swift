//
//  TradeMeApiAccessModel.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 19/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import Foundation

class TradeMeTaskApiAccessModel: NSObject {
    
    // MARK: - variables
    private var tmtCategories : TmtCategory? = TmtCategory()
    var getTmtCategories : TmtCategory?{
        get {
            return tmtCategories
        }
    }
    
        
    // MARK: - Public API
    func tmtGategoryBrowsing(categoryNumber:String, depth:Int, withCount:Bool){
        tmtCategories = TmtCategory()
        
        let categoryBrowsingUrl = Constants.TRADEME_CATEGORY_BROWSING_URL + categoryNumber + ".json?depth=\(depth)&with_counts=\(withCount ? "true" : "false")"
        
        //print("[Request URL]: \(categoryBrowsingUrl)")
        if let requestUrl = NSURL.init(string: categoryBrowsingUrl){
            let getRequest = NSMutableURLRequest(URL: requestUrl)
            getRequest.HTTPMethod = "GET"
            getRequest.timeoutInterval = Constants.TIMING_SESSION_REQUEST_TIMEOUT
            let task = NSURLSession.sharedSession().dataTaskWithRequest(getRequest, completionHandler: { [weak self] (data, response, error) in
                if self != nil{
                    guard error == nil && data != nil else{
                        self!.postModelChangedNotification("Error occured while requesting Gategory Browsing", type: "error")
                        return
                    }
                    
                    do{
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        //print("[JSON Response]: \(jsonResponse)")
                        if let parsedCategories = self!.processTmtBrowseCategoriesJsonResponse(jsonResponse){
                            print("[TmtCategories]:\n\(parsedCategories)")
                            self!.tmtCategories = parsedCategories
                            if let cateName = parsedCategories.cateName{
                                if cateName == "Root"{
                                    self!.postModelChangedNotification(Constants.NOTI_UPDATE_CATEGORIES_LOADED, type: "update")
                                }
                                else{
                                    self!.postModelChangedNotification(Constants.NOTI_UPDATE_SUB_CATEGORIES_LOADED, type: "update")
                                }
                            }
                        }
                        
                    }
                    catch{
                        //print("Error serializing JSON : \(error)")
                        self!.postModelChangedNotification("Error serializing Json Response : \(error)", type: "error")
                    }
                    
                }
            })
            task.resume()
        }
    }
    
    func tmtGeneralSearch(buy:EnumGeneralSearchBuy?, category:String?, clearance:EnumGeneralSearchClearance?, condition:EnumGeneralSearchCondition?, dataFrom:NSDate?, expired:Bool?, memberListing:Int?, page:Int?, pay:EnumGeneralSearchPay?, photoSize:EnumGeneralSearchPhotoSize?, returnMetadata:Bool?, rows:Int?, searchString:String?, shippingMethod:EnumGeneralSearchShippingMethod?, sortOrder:EnumGeneralSearchSortOrder?, userDistrict:Int?, userRegion:Int?){
        var searchUrl = Constants.TRADEME_SEARCH_URL + "?"
        if let _buy = buy{
            searchUrl += "buy=" + _buy.associatedString() + "&"
        }
        if let _category = category{
            searchUrl += "category=" + _category + "&"
        }
        if let _clearance = clearance{
            searchUrl += "clearance=" + _clearance.associatedString() + "&"
        }
        if let _condition = condition{
            searchUrl += "condition=" + _condition.associatedString() + "&"
        }
        if let _dateFrom = dataFrom{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-ddThh:mm"
            let dateString = formatter.stringFromDate(_dateFrom).stringByReplacingOccurrencesOfString(":", withString: "%3A")
            searchUrl += "date_from=" + dateString + "&"
        }
        if let _expired = expired{
            searchUrl += "expired=" + (_expired ? "true" : "false") + "&"
        }
        if let _memberListing = memberListing{
            searchUrl += "member_listing=\(_memberListing)&"
        }
        if let _page = page{
            searchUrl += "page=\(_page)&"
        }
        if let _pay = pay{
            searchUrl += "pay=" + _pay.associatedString() + "&"
        }
        if let _photoSize = photoSize{
            searchUrl += "photo_size=" + _photoSize.associatedString() + "&"
        }
        if let _returnMetadata = returnMetadata{
            searchUrl += "return_metadata=" + (_returnMetadata ? "true" : "false") + "&"
        }
        if let _rows = rows{
            searchUrl += "rows=\(_rows)&"
        }
        if let _searchString = searchString{
            searchUrl += "search_string=\(_searchString)&"
        }
        if let _shippingMethod = shippingMethod{
            searchUrl += "shipping_method=" + _shippingMethod.associatedString() + "&"
        }
        if let _sortOrder = sortOrder{
            searchUrl += "sort_order=" + _sortOrder.associatedString() + "&"
        }
        if let _userDistrict = userDistrict{
            searchUrl += "user_district=\(_userDistrict)&"
        }
        if let _userRegion = userRegion{
            searchUrl += "user_region=\(_userRegion)&"
        }
        searchUrl = searchUrl.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "?&"))
        print("[Search URL]: \(searchUrl)")
        
        if let requestUrl = NSURL.init(string: searchUrl){
            let getRequest = NSMutableURLRequest(URL: requestUrl)
            getRequest.HTTPMethod = "GET"
            getRequest.timeoutInterval = Constants.TIMING_SESSION_REQUEST_TIMEOUT
            let task = NSURLSession.sharedSession().dataTaskWithRequest(getRequest, completionHandler: { [weak self] (data, response, error) in
                if self != nil{
                    guard error == nil && data != nil else{
                        print("Error occured while searching for items")
                        self!.postModelChangedNotification("Error occured while searching for items", type: "error")
                        return
                    }
                    
                    do{
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        print("[JSON Response]: \(jsonResponse)")
                    }
                    catch{
                        print("Error serializing Json Response : \(error)")
                        self!.postModelChangedNotification("Error serializing Json Response : \(error)", type: "error")
                    }
                }
            })
            task.resume()
        }
    }
    
    // MARK: - Private functions
    private func processTmtBrowseCategoriesJsonResponse(jsonObj:AnyObject)->TmtCategory?{
        if let jsonObject = jsonObj as? [String:AnyObject]{
            let category = TmtCategory()
            if let cateName = jsonObject["Name"] as? String{
                category.cateName = cateName
            }
            if let cateNumber = jsonObject["Number"] as? String{
                category.cateNumber = cateNumber
            }
            if let catePath = jsonObject["Path"] as?  String{
                category.catePath = catePath
            }
            if let cateCount = jsonObject["Count"] as? Int{
                category.cateCount = cateCount
            }
            if let cateIsRestricted = jsonObject["IsRestricted"] as? Bool{
                category.cateIsRestricted = cateIsRestricted
            }
            if let cateHasLegalNotice = jsonObject["HasLegalNotice"] as? Bool{
                category.cateHasLegalNotice = cateHasLegalNotice
            }
            if let cateHasClassifieds = jsonObject["HasClassifieds"] as? Bool{
                category.cateHasClassifieds = cateHasClassifieds
            }
            if let cateSubCategories = jsonObject["Subcategories"] as? [[String:AnyObject]]{
                for subCategoryJson in cateSubCategories{
                    if let subCategory = processTmtBrowseCategoriesJsonResponse(subCategoryJson){
                        category.cateSubCategories.append(subCategory)
                    }
                }
            }
            return category
        }
        
        return nil
    }
    
    private func postModelChangedNotification(message:String, type:String){
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NOTI_IDENTIFIER_TMT_MODEL_CHANGED, object: self, userInfo: [type:message])
    }
}

















