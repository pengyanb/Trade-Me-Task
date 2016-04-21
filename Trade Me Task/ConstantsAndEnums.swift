//
//  Constants.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 19/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import Foundation

class Constants{
    // MARK: - keys and secret
    static let CREDENTIAL_TRADEME_CONSUMER_KEY = "86FA7A59450DC5F9EB823D1B43BC5179"
    static let CREDENTIAL_TRADEME_CONSUMER_SECRET = "08B6466E6AFB48032AA2CA1AF731B1F6"
    
    //static let CREDENTIAL_TRADEME_CONSUMER_KEY = "A1AC63F0332A131A78FAC304D007E7D1"
    //static let CREDENTIAL_TRADEME_CONSUMER_SECRET = "EC7F18B17A062962C6930A8AE88B16C7"
    
    // MARK: - URLs
    static let TRADEME_API_URL = "https://api.tmsandbox.co.nz/v1/"  //sandbox url
    
    static let TRADEME_CATEGORY_BROWSING_URL = Constants.TRADEME_API_URL + "Categories/"
    static let TRADEME_SEARCH_URL = Constants.TRADEME_API_URL + "Search/General.json"
    static let TRADEME_LISTING_DETAILS_URL = Constants.TRADEME_API_URL + "Listings/"
    
    static let TRADEME_OAUTH_REQUEST_TOKEN_URL = "https://secure.tmsandbox.co.nz/Oauth/RequestToken"
    static let TRADEME_OAUTH_ACCESS_TOKEN_URL = "https://secure.tmsandbox.co.nz/Oauth/AccessToken"
    
    static let TRADEME_OAUTH_AUTHORISING_URL = "https://secure.tmsandbox.co.nz/Oauth/Authorize"
    
    // TradeMe seems not accepting custom URL schema as backback
    // so app set callback to Foauthswift.herokuapp.com to get redirected to oauth-swift:// to resume the app after OAuth authorization
    static let TRADEME_OAUTH_CALLBACK_URL = "http%3A%2F%2Foauthswift.herokuapp.com%2Fcallback%2Ftmtcallback"
    
    // MARK: - Const Numbers
    static let TIMING_SESSION_REQUEST_TIMEOUT:Double = 5
    static let COUNT_LISTINGS_LOAD_QUOTA : Int = 20
    
    // MARK: - Notifications
    static let NOTI_IDENTIFIER_TMT_MODEL_CHANGED = "TradeMeTaskApiAccessModelChangedNotification"
    
    static let NOTI_UPDATE_CATEGORIES_LOADED = "categoriesLoaded"
    static let NOTI_UPDATE_SUB_CATEGORIES_LOADED = "subCategoriesLoaded"
    static let NOTI_UPDATE_SEARCH_RESULT_LOADED = "searchResultLoaded"
    static let NOTI_UPDATE_LISTING_DETAILS_LOADED = "listingDetailsLoaded"
    
    // MARK: - Segue
    static let SEGUE_SHOW_BROWSE_CATEGORIES = "showBrowseCategoriesSegueIdentifier"
    static let SEGUE_SHOW_SUB_CATEGORIES = "showSubCategoriesSegueIdentifier"
    static let SEGUE_SHOW_LISTINGS = "showListingsSegueIdentifier"
    static let SEGUE_SHOW_LISTING_DETAILS = "showListingDetailsSegueIdentifier"
    
    // MARK: - Table View Cell
    static let CELL_IDENTIFIER_BROWSE_CATEGORIES = "browseCategoriesTableViewCellIdentifier"
    static let CELL_IDENTIFIER_SUB_CATEGORIES = "subCategoriesTableViewCellIdentifier"
    static let CELL_IDENTIFIER_LISTING = "listingTableViewCellIdentifier"
    
    // MARK: - NSUserfaults    
    static let NSUSER_DEFAULT_TEMP_TOKEN_KEY = "TradeMeTaskUserDefaultTempTokenKey"
    static let NSUSER_DEFAULT_FINAL_TOKEN_KEY = "TradeMeTaskUserDefaultFinalTokenKey"
}

// MARK: - Enum General Search
enum EnumGeneralSearchBuy {
    case All
    case BuyNow
    func associatedString()->String{
        switch self {
        case .All:
            return "All"
        case .BuyNow:
            return "BuyNow"
        }
    }
}
enum EnumGeneralSearchClearance{
    case All
    case Clearance
    case OnSale
    func associatedString()->String{
        switch self {
        case .All:
            return "All"
        case .Clearance:
            return "Clearance"
        case .OnSale:
            return "OnSale"
        }
    }
}
enum EnumGeneralSearchCondition{
    case All
    case New
    case Used
    func associatedString()->String{
        switch self {
        case .All:
            return "All"
        case .New:
            return "New"
        case .Used:
            return "Used"
        }
    }
}
enum EnumGeneralSearchPay{
    case All
    case PayNow
    func associatedString()->String{
        switch self {
        case .All:
            return "All"
        case .PayNow:
            return "PayNow"
        }
    }
}
enum EnumGeneralSearchPhotoSize{
    case Thumbnail
    case List
    case Medium
    case Gallery
    case Large
    case FullSize
    func associatedString()->String{
        switch self {
        case .Thumbnail:
            return "Thumbnail"
        case .List:
            return "List"
        case .Medium:
            return "Medium"
        case .Gallery:
            return "Gallery"
        case .Large:
            return "Large"
        case .FullSize:
            return "FullSize"
        }
    }
}
enum EnumGeneralSearchShippingMethod{
    case All
    case Free
    case Pickup
    func associatedString()->String{
        switch self {
        case .All:
            return "All"
        case .Free:
            return "Free"
        case .Pickup:
            return "Pickup"
        }
    }
}
enum EnumGeneralSearchSortOrder{
    case Default
    case FeaturedFirst
    case SuperGridFeaturedFirst
    case TitleAsc
    case ExpiryAsc
    case ExpiryDesc
    case PriceAsc
    case PriceDesc
    case BidsMost
    case BuyNowAsc
    case BuyNowDesc
    case ReviewsDesc
    case HighestSalary
    case LowestSalary
    case LowestKilometres
    case HighestKilometres
    case NewestVechile
    case OldestVechile
    func associatedString()->String{
        switch self {
        case .Default:
            return "Default"
        case .FeaturedFirst:
            return "FeaturedFirst"
        case .SuperGridFeaturedFirst:
            return "SuperGridFeaturedFirst"
        case .TitleAsc:
            return "TitleAsc"
        case .ExpiryAsc:
            return "ExpiryAsc"
        case .ExpiryDesc:
            return "ExpiryDesc"
        case .PriceAsc:
            return "PriceAsc"
        case .PriceDesc:
            return "PriceDesc"
        case .BidsMost:
            return "BidsMost"
        case .BuyNowAsc:
            return "BuyNowAsc"
        case .BuyNowDesc:
            return "BuyNowDesc"
        case .ReviewsDesc:
            return "ReviewsDesc"
        case .HighestSalary:
            return "HighestSalary"
        case .LowestSalary:
            return "LowestSalary"
        case .LowestKilometres:
            return "LowestKilometres"
        case .HighestKilometres:
            return "HighestKilometres"
        case .NewestVechile:
            return "NewestVehicle"
        case .OldestVechile:
            return "OldestVechile"
        }
    }
}

// MARK: - Enum Search Result
enum EnumSearchResultReserveState : Int{
    case None = 0
    case Met = 1
    case NotMet = 2
    case NotApplicable = 3
    func associatedString()->String{
        switch  self {
        case .None:
            return "None"
        case .Met:
            return "Met"
        case .NotMet:
            return "NotMet"
        case .NotApplicable:
            return "NotApplicable"
        }
    }
}

enum EnumSearchResultGeographicLocationAccuracy : Int{
    case None = 0
    case Address = 1
    case Suburb = 2
    case Street = 3
    func associatedString()->String{
        switch self {
        case .None:
            return "None"
        case .Address:
            return "Address"
        case .Suburb:
            return "Suburb"
        case .Street:
            return "Street"
        }
    }
}

enum EnumSearchResultFavouriteType : Int{
    case None = 0
    case Category = 1
    case Search = 3
    case AttributeSearch = 4
    case Seller = 6
    func associatedString()->String{
        switch self {
        case .None:
            return "None"
        case .Category:
            return "Category"
        case .Search:
            return "Search"
        case .AttributeSearch:
            return "AttributeSearch"
        case .Seller:
            return "Seller"
        }
    }
}

enum EnumSearchResultParameterType : Int{
    case IsBoolean  = 0
    case IsNumeric = 1
    case IsString = 2
    case IsPropertyRegionId = 3
    case IsPropertyDistrictId = 4
    case IsPropertySuburbId = 5
    case IsLocation = 6
    func associatedString()->String{
        switch self {
        case .IsBoolean:
            return "Boolean"
        case .IsNumeric:
            return "Numeric"
        case .IsString:
            return "String"
        case .IsPropertyRegionId:
            return "PropertyRegionId"
        case .IsPropertyDistrictId:
            return "PropertyDistrictId"
        case .IsPropertySuburbId:
            return "PropertySuburbId"
        case .IsLocation:
            return "Location"
        }
    }
}



// MARK: - Enum Listing Details
enum EnumListingDetailReserveState : Int{
    case None = 0
    case Met = 1
    case NotMet = 2
    case NotApplicable = 3
    func associatedString()->String{
        switch  self {
        case .None:
            return "None"
        case .Met:
            return "Met"
        case .NotMet:
            return "NotMet"
        case .NotApplicable:
            return "NotApplicable"
        }
    }
}

enum EnumListingDetailAttributeType : Int{
    case None = 0
    case Boolean = 1
    case Integer = 2
    case Decimal = 3
    case String = 4
    case DateTime = 5
    
}












