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
    
    private var tmtSearchResults : [TmtSearchResult] = [TmtSearchResult]()
    var getTmtSearchResults : [TmtSearchResult]{
        get{
            return tmtSearchResults
        }
    }
    
    private var tmtListingDetail : TmtListingDetail? = TmtListingDetail()
    var getTmtListingDetail : TmtListingDetail?{
        get{
            return tmtListingDetail
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
    
    func tmtGeneralSearch(buy:EnumGeneralSearchBuy?, category:String?, clearance:EnumGeneralSearchClearance?, condition:EnumGeneralSearchCondition?, dataFrom:NSDate?, expired:Bool?, memberListing:Int?, page:Int?, pay:EnumGeneralSearchPay?, photoSize:EnumGeneralSearchPhotoSize?, returnMetadata:Bool?, rows:Int?, searchString:String?, shippingMethod:EnumGeneralSearchShippingMethod?, sortOrder:EnumGeneralSearchSortOrder?, userDistrict:Int?, userRegion:Int?, clearExistingResult:Bool = true){
        if clearExistingResult{
            tmtSearchResults = [TmtSearchResult]()
        }
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
            let oauthHelper = TradeMeOauthHelper()
            let getRequest = NSMutableURLRequest(URL: requestUrl)
            getRequest.HTTPMethod = "GET"
            getRequest.timeoutInterval = Constants.TIMING_SESSION_REQUEST_TIMEOUT
            if let  authHeader = oauthHelper.generateAuthorizationHeader(Constants.CREDENTIAL_TRADEME_CONSUMER_KEY, consumerSecret: Constants.CREDENTIAL_TRADEME_CONSUMER_SECRET){
                getRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
            }
            let task = NSURLSession.sharedSession().dataTaskWithRequest(getRequest, completionHandler: { [weak self] (data, response, error) in
                if self != nil{
                    guard error == nil && data != nil else{
                        print("Error occured while searching for items")
                        self!.postModelChangedNotification("Error occured while searching for items", type: "error")
                        return
                    }
                    
                    do{
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        //print("[JSON Response]: \(jsonResponse)")
                        if let parsedSearchResult = self!.processTmtGeneralSearchJsonResponse(jsonResponse){
                            print("[TmtSearchResult]:\n\(parsedSearchResult)")
                            self!.tmtSearchResults.append(parsedSearchResult)
                            self!.postModelChangedNotification(Constants.NOTI_UPDATE_SEARCH_RESULT_LOADED, type: "update")
                        }
                        
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
    
    func tmtRetrieveListingDetails(listingId:Int, incrementViewCount:Bool?, questionLimit:Int?, returnMemberProfile:Bool?){
        tmtListingDetail = TmtListingDetail()
        var listingDetailsUrl = Constants.TRADEME_LISTING_DETAILS_URL + "\(listingId).json?"
        if let _incrementViewCount = incrementViewCount{
            listingDetailsUrl += "increment_view_count=\(_incrementViewCount)&"
        }
        if let _questionLimit = questionLimit{
            listingDetailsUrl += "question_limit=\(_questionLimit)&"
        }
        if let _returnMemberProfile = returnMemberProfile{
            listingDetailsUrl += "return_member_profile=\(_returnMemberProfile)&"
        }
        listingDetailsUrl = listingDetailsUrl.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "?&"))
        print("[ListingDetails URL]: \(listingDetailsUrl)")
        
        if let requestUrl = NSURL.init(string: listingDetailsUrl){
            let oauthHelper = TradeMeOauthHelper()
            let getRequest = NSMutableURLRequest(URL: requestUrl)
            getRequest.HTTPMethod = "GET"
            getRequest.timeoutInterval = Constants.TIMING_SESSION_REQUEST_TIMEOUT
            if let authHeader = oauthHelper.generateAuthorizationHeader(Constants.CREDENTIAL_TRADEME_CONSUMER_KEY, consumerSecret: Constants.CREDENTIAL_TRADEME_CONSUMER_SECRET){
                getRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
            }
            let task = NSURLSession.sharedSession().dataTaskWithRequest(getRequest, completionHandler: { [weak self] (data, response, error) in
                guard error == nil && data != nil else{
                    print("Error occured while retrieving listing details")
                    self!.postModelChangedNotification("Error occured while retrieving listing details", type: "error")
                    return
                }
                
                do{
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    //print("[JSON Response]: \(jsonResponse)")
                    if let parsedListingDetail = self!.processTmtListingDetailsJsonResponse(jsonResponse){
                        self!.tmtListingDetail = parsedListingDetail
                        self!.postModelChangedNotification(Constants.NOTI_UPDATE_LISTING_DETAILS_LOADED, type: "update")
                    }
                    
                }
                catch{
                    print("Error serializing Json Response : \(error)")
                    self!.postModelChangedNotification("Error serializing Json Response : \(error)", type: "error")
                }
            })
            task.resume()
        }
    }
    
    func downloadDataFromUrl(url: NSURL, completion: ((data:NSData?, response : NSURLResponse?, error: NSError?)->Void)){
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
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
    
    private func processTmtGeneralSearchJsonResponse(jsonObj:AnyObject)->TmtSearchResult?{
        if let jsonObject = jsonObj as? [String:AnyObject]{
            let searchResult = TmtSearchResult()
            if let srTotalCount =  jsonObject["TotalCount"] as? Int{
                searchResult.srTotalCount = srTotalCount
            }
            if let srPage = jsonObject["Page"] as? Int{
                searchResult.srPage = srPage
            }
            if let srPageSize = jsonObject["PageSize"] as? Int{
                searchResult.srPageSize = srPageSize
            }
            if let srListElements = jsonObject["List"] as? [[String:AnyObject]]{
                for listElement in srListElements{
                    let list = TmtSearchResultListing()
                    if let liListingId = listElement["ListingId"] as? Int{
                        list.liListingId = liListingId
                    }
                    if let liTitle = listElement["Title"] as? String{
                        list.liTitle = liTitle
                    }
                    if let liCategory = listElement["Category"] as? String{
                        list.liCategory = liCategory
                    }
                    if let liStartPrice = listElement["StartPrice"] as? Double{
                        list.liStartPrice = liStartPrice
                    }
                    if let liBuyNowPrice = listElement["BuyNowPrice"] as? Double{
                        list.liBuyNowPrice = liBuyNowPrice
                    }
                    if let liStartDate = listElement["StartDate"] as? String{
                        if let startDate = parseNSDateFromString(liStartDate){
                            list.liStartDate = startDate
                        }
                    }
                    if let liEndDate = listElement["EndDate"] as? String{
                        if let endDate = parseNSDateFromString(liEndDate){
                            list.liEndDate = endDate
                        }
                    }
                    if let liIsFeatured = listElement["IsFeatured"] as? Bool{
                        list.liIsFeatured = liIsFeatured
                    }
                    if let liHasGallery = listElement["HasGallery"] as? Bool{
                        list.liHasGallery = liHasGallery
                    }
                    if let liIsBold = listElement["IsBold"] as? Bool{
                        list.liIsBold = liIsBold
                    }
                    if let liIsHighLighted = listElement["IsHighlighted"] as? Bool{
                        list.liIsHighlighted = liIsHighLighted
                    }
                    if let liHasHomePageFeature = listElement["HasHomePageFeature"] as? Bool{
                        list.liHasHomePageFeature = liHasHomePageFeature
                    }
                    if let liMaxBidAmount = listElement["MaxBidAmount"] as? Double{
                        list.liMaxBidAmount = liMaxBidAmount
                    }
                    if let liAsAt = listElement["AsAt"] as? String{
                        if let asAt = parseNSDateFromString(liAsAt){
                            list.liAsAt = asAt
                        }
                    }
                    if let liCategoryPath = listElement["CategoryPath"] as? String{
                        list.liCategoryPath = liCategoryPath
                    }
                    if let liPictureHref = listElement["PictureHref"] as? String{
                        list.liPictureHref = liPictureHref
                    }
                    if let liHasPayNow = listElement["HasPayNow"] as? Bool{
                        list.liHasPayNow = liHasPayNow
                    }
                    if let liIsNew = listElement["IsNew"] as? Bool{
                        list.liIsNew = liIsNew
                    }
                    if let liRegion = listElement["Region"] as? String{
                        list.liRegion = liRegion
                    }
                    if let liSuburb = listElement["Suburb"] as? String{
                        list.liSuburb = liSuburb
                    }
                    if let liBidCount = listElement["BidCount"] as? Int{
                        list.liBidCount = liBidCount
                    }
                    if let liIsReserveMet = listElement["IsReserveMet"] as? Bool{
                        list.liIsReserveMet = liIsReserveMet
                    }
                    if let liHasReserve = listElement["HasReserve"] as? Bool{
                        list.liHasReserve = liHasReserve
                    }
                    if let liHasBuyNow = listElement["HasBuyNow"] as? Bool{
                        list.liHasBuyNow = liHasBuyNow
                    }
                    if let liNoteDate = listElement["NoteDate"] as? String{
                        if let noteDate = parseNSDateFromString(liNoteDate){
                            list.liNoteDate = noteDate
                        }
                    }
                    if let liReserveState = listElement["ReserveState"] as? Int{
                        if let reserveState = EnumSearchResultReserveState(rawValue: liReserveState){
                            list.liReserveState = reserveState
                        }
                    }
                    if let liIsClassified = listElement["IsClassified"] as? Bool{
                        list.liIsClassified = liIsClassified
                    }
                    if let liSubtitle = listElement["Subtitle"] as? String{
                        list.liSubtitle = liSubtitle
                    }
                    if let liIsBuyNowOnly = listElement["IsBuyNowOnly"] as? Bool{
                        list.liIsBuyNowOnly = liIsBuyNowOnly
                    }
                    if let liRemainingGalleryPlusRelists = listElement["RemainingGalleryPlusRelists"] as? Int{
                        list.liRemainingGalleryPlusRelists = liRemainingGalleryPlusRelists
                    }
                    if let liIsOnWatchList = listElement["IsOnWatchList"] as? Bool{
                        list.liIsOnWatchList = liIsOnWatchList
                    }
                    if let liGeographicLocationElement = listElement["GeographicLocation"] as? [String:AnyObject]{
                        if let glLatitude = liGeographicLocationElement["Latitude"] as? Double{
                            list.liGeographicLocation.glLatitude = glLatitude
                        }
                        if let glLongitude = liGeographicLocationElement["Longitude"] as? Double{
                            list.liGeographicLocation.glLongitude = glLongitude
                        }
                        if let glNorthing = liGeographicLocationElement["Northing"] as? Int{
                            list.liGeographicLocation.glNorthing = glNorthing
                        }
                        if let glEasting  = liGeographicLocationElement["Easting"] as? Int{
                            list.liGeographicLocation.glEasting = glEasting
                        }
                        if let glAccuracy = liGeographicLocationElement["Accuracy"] as? Int{
                            if let accuracy = EnumSearchResultGeographicLocationAccuracy(rawValue: glAccuracy){
                                list.liGeographicLocation.glAccuracy = accuracy
                            }
                        }
                    }
                    if let liPriceDisplay = listElement["PriceDisplay"] as? String{
                        list.liPriceDisplay = liPriceDisplay
                    }
                    if let liTotalReviewCount = listElement["TotalReviewCount"] as? Int{
                        list.liTotalReviewCount = liTotalReviewCount
                    }
                    if let liPositiveReviewCount = listElement["PositiveReviewCount"] as? Int{
                        list.liPositiveReviewCount = liPositiveReviewCount
                    }
                    if let liHasFreeShipping = listElement["HasFreeShipping"] as? Bool{
                        list.liHasFreeShipping = liHasFreeShipping
                    }
                    if let liIsClearance  = listElement["IsClearance"] as? Bool{
                        list.liIsClearance = liIsClearance
                    }
                    if let liWasPrice = listElement["WasPrice"] as? Double{
                        list.liWasPrice = liWasPrice
                    }
                    if let liPercentageOff = listElement["PercentageOff"] as? Int{
                        list.liPercentageOff = liPercentageOff
                    }
                    if let liBrandingElement = listElement["Branding"] as? [String:String]{
                        if let brLargeSquareLogo = liBrandingElement["LargeSquareLogo"] {
                            list.liBranding.brLargeSquareLogo = brLargeSquareLogo
                        }
                        if let brLargeWideLogo = liBrandingElement["LargeWideLogo"]{
                            list.liBranding.brLargeWideLogo = brLargeWideLogo
                        }
                    }
                    if let liIsSuperFeatured = listElement["IsSuperFeatured"] as? Bool{
                        list.liIsSuperFeatured = liIsSuperFeatured
                    }
                    searchResult.srList.append(list)
                }
                if let srDidYouMean = jsonObject["DidYouMean"] as? String{
                    searchResult.srDidYouMean = srDidYouMean
                }
                if let foundCategoryElements = jsonObject["FoundCategories"] as? [[String:AnyObject]]{
                    for foundCategoryElement in foundCategoryElements{
                        let foundCategory = TmtSearchResultFoundCategory()
                        if let fcCount = foundCategoryElement["Count"] as? Int{
                            foundCategory.fcCount = fcCount
                        }
                        if let fcCategory = foundCategoryElement["Category"] as? String{
                            foundCategory.fcCategory = fcCategory
                        }
                        if let fcName = foundCategoryElement["Name"] as? String{
                            foundCategory.fcName = fcName
                        }
                        if let fcIsRestricted = foundCategoryElement["IsRestricted"] as? Bool{
                            foundCategory.fcIsRestricted = fcIsRestricted
                        }
                        searchResult.srFoundCategories.append(foundCategory)
                    }
                }
                if let srFavouriteId = jsonObject["FavouriteId"] as? Int{
                    searchResult.srFavouriteId = srFavouriteId
                }
                if let srFavouriteType = jsonObject["FavouriteType"] as? Int{
                    if let favouriteType = EnumSearchResultFavouriteType(rawValue: srFavouriteType){
                        searchResult.srFavouriteType = favouriteType
                    }
                }
                if let srParameterElements = jsonObject["Parameters"] as? [[String:AnyObject]]{
                    for parameterElement in srParameterElements{
                        let parameter = TmtSearchResultParameter()
                        if let paDisplayName = parameterElement["DisplayName"] as? String{
                            parameter.paDisplayName = paDisplayName
                        }
                        if let paName = parameterElement["Name"] as? String{
                            parameter.paName = paName
                        }
                        if let paLowerBoundName = parameterElement["LowerBoundName"] as? String{
                            parameter.paLowerBoundName = paLowerBoundName
                        }
                        if let paUpperBoundName = parameterElement["UpperBoundName"] as? String{
                            parameter.paUpperBoundName = paUpperBoundName
                        }
                        if let paType = parameterElement["Type"] as? Int{
                            if let type = EnumSearchResultParameterType(rawValue: paType){
                                parameter.paType = type
                            }
                        }
                        if let paAllowsMultipleValues = parameterElement["AllowsMultipleValues"] as? Bool{
                            parameter.paAllowsMultipleValues = paAllowsMultipleValues
                        }
                        if let paMutualExclusionGroup = parameterElement["MutualExclusionGroup"] as? String{
                            parameter.paMutualExclusionGroup = paMutualExclusionGroup
                        }
                        if let paDependentOn = parameterElement["DependentOn"] as? String{
                            parameter.paDependentOn = paDependentOn
                        }
                        if let paExternalOptionsKey = parameterElement["ExternalOptionsKey"] as? String{
                            parameter.paExternalOptionKey = paExternalOptionsKey
                        }
                        if let paOptionElements = parameterElement["Options"] as? [[String:String]]{
                            for optionElement in paOptionElements{
                                let paOption = TmtSearchResultParameterOption()
                                if let poValue = optionElement["Value"]{
                                    paOption.poValue = poValue
                                }
                                if let poDisplay = optionElement["Display"]{
                                    paOption.poDisplay = poDisplay
                                }
                                parameter.paOptions.append(paOption)
                            }
                        }
                        searchResult.srParameters.append(parameter)
                    }
                }
                
                if let srSortOrderElements = jsonObject["SortOrders"] as? [[String:String]]{
                    for sortOrderElement in srSortOrderElements{
                        let sortOrder = TmtSearchResultParameterOption()
                        if let poValue = sortOrderElement["Value"] {
                            sortOrder.poValue = poValue
                        }
                        if let poDisplay = sortOrderElement["Display"]{
                            sortOrder.poDisplay = poDisplay
                        }
                        searchResult.srSortOrders.append(sortOrder)
                    }
                }
                if let srMemberProfileElement = jsonObject["MemberProfile"] as? [String:AnyObject]{
                    if let mpFirstName = srMemberProfileElement["FirstName"] as? String{
                        searchResult.srMemberProfile.mpFirstName = mpFirstName
                    }
                    if let mpOccupation = srMemberProfileElement["Occupation"] as? String{
                        searchResult.srMemberProfile.mpOccuption = mpOccupation
                    }
                    if let mpBiography = srMemberProfileElement["Biography"] as? String{
                        searchResult.srMemberProfile.mpBiography = mpBiography
                    }
                    if let mpQuote = srMemberProfileElement["Quote"] as? String{
                        searchResult.srMemberProfile.mpQuote = mpQuote
                    }
                    if let mpPhoto = srMemberProfileElement["Photo"] as? String{
                        searchResult.srMemberProfile.mpPhoto = mpPhoto
                    }
                    if let mpIsEnabled = srMemberProfileElement["IsEnabled"] as? Bool{
                        searchResult.srMemberProfile.mpIsEnabled = mpIsEnabled
                    }
                    if let mpDateRemoved = srMemberProfileElement["DateRemoved"] as? String{
                        if let dateRemoved = parseNSDateFromString(mpDateRemoved){
                            searchResult.srMemberProfile.mpDateRemoved = dateRemoved
                        }
                    }
                    if let memberElement = srMemberProfileElement["Member"] as? [String:AnyObject]{
                        if let mpmMemberId = memberElement["MemberId"] as? Int{
                            searchResult.srMemberProfile.mpMember.mpmMemberId = mpmMemberId
                        }
                        if let mpmNickname = memberElement["Nickname"] as? String{
                            searchResult.srMemberProfile.mpMember.mpmNickname = mpmNickname
                        }
                        if let mpmDateAddressVerified = memberElement["DateAddressVerified"] as? String{
                            if let dateAddressVerified = parseNSDateFromString(mpmDateAddressVerified){
                                searchResult.srMemberProfile.mpMember.mpmDateAddressVerified = dateAddressVerified
                            }
                        }
                        if let mpmDateJoined = memberElement["DateJoined"] as? String{
                            if let dateJoined  = parseNSDateFromString(mpmDateJoined){
                                searchResult.srMemberProfile.mpMember.mpmDateJoined = dateJoined
                            }
                        }
                        if let mpmUniqueNegative = memberElement["UniqueNegative"] as? Int{
                            searchResult.srMemberProfile.mpMember.mpmUniqueNegative = mpmUniqueNegative
                        }
                        if let mpmUniquePositive = memberElement["UniquePositive"] as? Int{
                            searchResult.srMemberProfile.mpMember.mpmUniquePositive = mpmUniquePositive
                        }
                        if let mpmFeedbackCount = memberElement["FeedbackCount"] as? Int{
                            searchResult.srMemberProfile.mpMember.mpmFeedbackCount = mpmFeedbackCount
                        }
                        if let mpmIsAddressVerified = memberElement["IsAddressVerified"] as? Bool{
                            searchResult.srMemberProfile.mpMember.mpmIsAddressVerified = mpmIsAddressVerified
                        }
                        if let mpmSuburb = memberElement["Suburb"] as? String{
                            searchResult.srMemberProfile.mpMember.mpmSuburb = mpmSuburb
                        }
                        if let mpmIsDealer = memberElement["IsDealer"] as? Bool{
                            searchResult.srMemberProfile.mpMember.mpmIsDealer = mpmIsDealer
                        }
                        if let mpmIsAuthenticated = memberElement["IsAuthenticated"] as? Bool{
                            searchResult.srMemberProfile.mpMember.mpmIsAuthenticated = mpmIsAuthenticated
                        }
                        if let mpmIsInTrade = memberElement["IsInTrade"] as? Bool{
                            searchResult.srMemberProfile.mpMember.mpmIsInTrade = mpmIsInTrade
                        }
                        if let mpmImportChargesMayApply = memberElement["ImportChargesMayApply"] as? Bool{
                            searchResult.srMemberProfile.mpMember.mpmImportChargesMayApply = mpmImportChargesMayApply
                        }
                    }
                    if let mpFavouritedId = srMemberProfileElement["FavouriteId"] as? Int{
                        searchResult.srMemberProfile.mpFavouritedId = mpFavouritedId
                    }
                    if let storeElement = srMemberProfileElement["Store"] as? [String:AnyObject]{
                        if let mpsName = storeElement["Name"] as? String{
                            searchResult.srMemberProfile.mpStore.mpsName = mpsName
                        }
                        if let mpsLogoImageUri = storeElement["LogoImageUri"] as? String{
                            searchResult.srMemberProfile.mpStore.mpsLogoImageUri = mpsLogoImageUri
                        }
                        if let mpsBannerImageUri = storeElement["BannerImageUri"] as? String{
                            searchResult.srMemberProfile.mpStore.mpsBannerImageUri = mpsBannerImageUri
                        }
                        if let promotionElements = storeElement["Promotions"] as? [[String:String]]{
                            for promotionElement in promotionElements{
                                let promotion = TmtSearchResultMemberProfileStorePromotion()
                                if let imageUri = promotionElement["ImageUri"]{
                                    promotion.mpspImageUri = imageUri
                                }
                                searchResult.srMemberProfile.mpStore.mpsPromotions.append(promotion)
                            }
                        }
                    }
                }
            }
            return searchResult
        }
        
        return nil
    }
    
    private func processTmtListingDetailsJsonResponse(jsonObj:AnyObject)->TmtListingDetail?{
        if let jsonObject = jsonObj as? [String:AnyObject]{
            let listingDetail = TmtListingDetail()
            if let ldTitle = jsonObject["Title"] as? String{
                listingDetail.ldTitle = ldTitle
            }
            if let ldEndDate = jsonObject["EndDate"] as? String{
                if let endDate = parseNSDateFromString(ldEndDate){
                    listingDetail.ldEndDate = endDate
                }
            }
            if let ldSuburb = jsonObject["Suburb"] as? String{
                listingDetail.ldSuburb = ldSuburb
            }
            if let ldPriceDisplay = jsonObject["PriceDisplay"] as? String{
                listingDetail.ldPriceDisplay = ldPriceDisplay
            }
            if let ldBody = jsonObject["Body"] as? String{
                listingDetail.ldBody = ldBody
            }
            if let ldPhotos = jsonObject["Photos"] as? [[String:AnyObject]]{
                for ldPhoto in ldPhotos{
                    let photo = TmtListingDetailPhoto()
                    if let photoId = ldPhoto["PhotoId"] as? Int{
                        photo.ldpPhotoId = photoId
                    }
                    if let value = ldPhoto["Value"] as? [String:AnyObject]{
                        photo.ldpValue = TmtListingDetailPhotoUrl()
                        if let thumbnail = value["Thumbnail"] as? String{
                            photo.ldpValue?.ldpuThumbnail = thumbnail
                        }
                        if let list = value["List"] as? String{
                            photo.ldpValue?.ldpuList = list
                        }
                        if let medium = value["Medium"] as? String{
                            photo.ldpValue?.ldpuMedium = medium
                        }
                        if let gallery = value["Gallery"] as? String{
                            photo.ldpValue?.ldpuGallery = gallery
                        }
                        if let large = value["Large"] as? String{
                            photo.ldpValue?.ldpuLarge = large
                        }
                        if let fullSize = value["FullSize"] as? String{
                            photo.ldpValue?.ldpuFullSize = fullSize
                        }
                        if let plusSize = value["PlusSize"] as? String{
                            photo.ldpValue?.ldpuPlusSize = plusSize
                        }
                        if let phId = value["PhotoId"] as? Int{
                            photo.ldpValue?.ldpuPhotoId = phId
                        }
                        if let originalWidth  = value["OriginalWidth"] as? Int{
                            photo.ldpValue?.ldpuOriginalWidth = originalWidth
                        }
                        if let originalHeight = value["OriginalHeight"] as? Int{
                            photo.ldpValue?.ldpuOriginalHeight = originalHeight
                        }
                        
                    }
                    listingDetail.ldPhotos.append(photo)
                }
            }
            return listingDetail
        }
        return nil
    }
    
    private func parseNSDateFromString(dateString:String)->NSDate?{
        var dateStringFiltered = dateString.stringByReplacingOccurrencesOfString("/Date(", withString: "")
        dateStringFiltered = dateStringFiltered.stringByReplacingOccurrencesOfString(")/", withString: "")
        if let milliSecondsSince1970 = Double.init(dateStringFiltered){
            if milliSecondsSince1970 > 0{
                return NSDate.init(timeIntervalSince1970: milliSecondsSince1970 / 1000.0)
            }
        }
        return nil
    }
    
    private func postModelChangedNotification(message:String, type:String){
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NOTI_IDENTIFIER_TMT_MODEL_CHANGED, object: self, userInfo: [type:message])
    }
}

















