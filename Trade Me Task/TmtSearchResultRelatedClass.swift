//
//  TmtSearchResult.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 21/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import Foundation

class TmtSearchResult: NSObject {
    var srTotalCount : Int?
    var srPage : Int?
    var srPageSize : Int?
    var srList = [TmtSearchResultListing]()
    var srDidYouMean : String?
    var srFoundCategories = [TmtSearchResultFoundCategory]()
    var srFavouriteId : Int?
    var srFavouriteType : EnumSearchResultFavouriteType?
    var srParameters = [TmtSearchResultParameter]()
    var srSortOrders = [TmtSearchResultParameterOption]()
    var srMemberProfile = TmtSearchResultMemberProfile()
    
    override var description: String{
        get {
            var content : String = ""
            content += ((srTotalCount != nil) ? "TotalCount: \(srTotalCount!)\n" : "")
            content += ((srPage != nil) ? "Page: \(srPage!)\n" : "")
            content += ((srPageSize != nil) ? "PageSize: \(srPageSize!)\n" : "")
            for listing in srList{
                content += "\(listing)"
            }
            content += ((srDidYouMean != nil) ? "DidYouMean: \(srDidYouMean!)\n" : "")
            for foundCategory in srFoundCategories{
                content += "\(foundCategory)"
            }
            content += ((srFavouriteId != nil) ? "FavouriteId: \(srFavouriteId!)\n" : "")
            content += ((srFavouriteType != nil) ? "FavouriteType: \(srFavouriteType!.associatedString())\n" : "")
            for parameter in srParameters{
                content += "\(parameter)"
            }
            for sortOrder in srSortOrders{
                content += "\(sortOrder)"
            }
            content += "\(srMemberProfile)"
            
            return content
        }
    }
}

// MARK: - Listing related classes
class TmtSearchResultListing : NSObject{
    var liListingId : Int?
    var liTitle : String?
    var liCategory : String?
    var liStartPrice : Double?
    var liBuyNowPrice : Double?
    var liStartDate : NSDate?
    var liEndDate : NSDate?
    var liIsFeatured : Bool?
    var liHasGallery : Bool?
    var liIsBold : Bool?
    var liIsHighlighted : Bool?
    var liHasHomePageFeature : Bool?
    var liMaxBidAmount : Double?
    var liAsAt : NSDate?
    var liCategoryPath : String?
    var liPictureHref : String?
    var liHasPayNow : Bool?
    var liIsNew : Bool?
    var liRegion : String?
    var liSuburb : String?
    var liBidCount : Int?
    var liIsReserveMet : Bool?
    var liHasReserve : Bool?
    var liHasBuyNow : Bool?
    var liNoteDate : NSDate?
    var liReserveState : EnumSearchResultReserveState?
    var liIsClassified : Bool?
    var liSubtitle : String?
    var liIsBuyNowOnly : Bool?
    var liRemainingGalleryPlusRelists : Int?
    var liIsOnWatchList : Bool?
    var liGeographicLocation = TmtSearchResultListingGeographicLocation()
    var liPriceDisplay : String?
    var liTotalReviewCount : Int?
    var liPositiveReviewCount : Int?
    var liHasFreeShipping : Bool?
    var liIsClearance : Bool?
    var liWasPrice : Double?
    var liPercentageOff : Int?
    var liBranding = TmtSearchResultListingBranding()
    var liIsSuperFeatured : Bool?
    
    override var description: String{
        get {
            var content : String = "\tListing: [\n"
            content += ((liListingId != nil) ? "\tListingId: \(liListingId!)\n" : "")
            content += ((liTitle != nil) ? "\tTitle: \(liTitle!)\n" : "")
            content += ((liCategory != nil) ? "\tCategory: \(liCategory!)\n" : "")
            content += ((liStartPrice != nil) ? "\tStartPrice: \(liStartPrice!)\n" : "")
            content += ((liBuyNowPrice != nil) ? "\tBuyNowPrice: \(liBuyNowPrice!)\n" : "")
            content += ((liStartDate != nil) ? "\tStartDate: \(liStartDate!.generateDateTimeString())\n" : "")
            content += ((liEndDate != nil) ? "\tEndDate: \(liEndDate!.generateDateTimeString())\n" : "")
            content += ((liIsFeatured != nil) ? "\tIsFeatured: \(liIsFeatured!)\n" : "")
            content += ((liHasGallery != nil) ? "\tHasGallery: \(liHasGallery!)\n" : "")
            content += ((liIsBold != nil) ? "\tIsBold: \(liIsBold!)\n" : "")
            content += ((liIsHighlighted != nil) ? "\tIsHighlighted: \(liIsHighlighted!)\n" : "")
            content += ((liHasHomePageFeature != nil) ? "\tHasHomePageFeature: \(liHasHomePageFeature!)\n" : "")
            content += ((liMaxBidAmount != nil) ? "\tMaxBidAmount: \(liMaxBidAmount!)\n" : "")
            content += ((liAsAt != nil) ? "\tAsAt: \(liAsAt!.generateDateTimeString())\n" : "")
            content += ((liCategoryPath != nil) ? "\tCategoryPath: \(liCategoryPath!)\n" : "")
            content += ((liPictureHref != nil) ? "\tPictureHref: \(liPictureHref!)\n" : "")
            content += ((liHasPayNow != nil) ? "\tHasPayNow: \(liHasPayNow!)\n" : "")
            content += ((liIsNew != nil) ? "\tIsNew: \(liIsNew!)\n" : "")
            content += ((liRegion != nil) ? "\tRegion: \(liRegion!)\n" : "")
            content += ((liSuburb != nil) ? "\tSuburb: \(liSuburb!)\n" : "")
            content += ((liBidCount != nil) ? "\tBidCount: \(liBidCount!)\n" : "")
            content += ((liIsReserveMet != nil) ? "\tIsReserveMet: \(liIsReserveMet!)\n" : "")
            content += ((liHasReserve != nil) ? "\tHasReserve: \(liHasReserve!)\n" : "")
            content += ((liHasBuyNow != nil) ? "\tHasBuyNow: \(liHasBuyNow!)\n" : "")
            content += ((liNoteDate != nil) ? "\tNoteDate: \(liNoteDate!.generateDateTimeString())\n" : "")
            content += ((liReserveState != nil) ? "\tReserveState: \(liReserveState!.associatedString())\n" : "")
            content += ((liIsClassified != nil) ? "\tIsClassified: \(liIsClassified!)\n" : "")
            content += ((liSubtitle != nil) ? "\tSubtitle: \(liSubtitle!)\n" : "")
            content += ((liIsBuyNowOnly != nil) ? "\tBuyNowOnly: \(liIsBuyNowOnly!)\n" : "")
            content += ((liRemainingGalleryPlusRelists != nil) ? "\tRemainingGalleryPlusRelists: \(liRemainingGalleryPlusRelists!)\n" : "")
            content += ((liIsOnWatchList != nil) ? "\tIsOnWatchList: \(liIsOnWatchList!)\n" : "")
            content += "\(liGeographicLocation)"
            content += ((liPriceDisplay != nil) ? "\tPriceDisplay: \(liPriceDisplay!)\n" : "")
            content += ((liTotalReviewCount != nil) ? "\tTotalReviewCount: \(liTotalReviewCount!)\n" : "")
            content += ((liPositiveReviewCount != nil) ? "\tPositiveReviewCount: \(liPositiveReviewCount!)\n" : "")
            content += ((liHasFreeShipping != nil) ? "\tHasFreeShipping: \(liHasFreeShipping!)\n" : "")
            content += ((liIsClearance != nil) ? "\tIsClearance: \(liIsClearance!)\n" : "")
            content += ((liWasPrice != nil) ? "\tWasPrice: \(liWasPrice!)\n" : "")
            content += ((liPercentageOff != nil) ? "\tPercentageOff: \(liPercentageOff!)\n" : "")
            content += "\(liBranding)"
            content += ((liIsSuperFeatured != nil) ? "\tIsSuperFeatured: \(liIsSuperFeatured!)\n" : "")
            content += "\t]\n"
            return content
        }
    }
}

class TmtSearchResultListingGeographicLocation : NSObject{
    var glLatitude : Double?
    var glLongitude : Double?
    var glNorthing : Int?
    var glEasting : Int?
    var glAccuracy : EnumSearchResultGeographicLocationAccuracy?
    
    override var description: String{
        get {
            var content : String = "\t\tGeographicLocation: [\n"
            content += ((glLatitude != nil) ? "\t\tLatitude: \(glLatitude!)\n" : "")
            content += ((glLongitude != nil) ? "\t\tLongitude: \(glLongitude!)\n" : "")
            content += ((glNorthing != nil) ? "\t\tNorthing: \(glNorthing!)\n" : "")
            content += ((glEasting != nil) ? "\t\tEasting: \(glEasting!)\n" : "")
            content += ((glAccuracy != nil) ? "\t\tAccuracy: \(glAccuracy!.associatedString())\n" : "")
            content += "\t\t]\n"
            return content
        }
    }
}

class TmtSearchResultListingBranding : NSObject{
    var brLargeSquareLogo : String?
    var brLargeWideLogo : String?
    override var description: String{
        get{
            var content : String = "\t\tBranding: [\n"
            content += ((brLargeSquareLogo != nil) ? "\t\tLargeSquareLogo: \(brLargeSquareLogo!)\n" : "")
            content += ((brLargeWideLogo != nil) ? "\t\tLargeWideLogo: \(brLargeWideLogo!)\n" : "")
            content += "\t\t]\n"
            return content
        }
    }
}


//MARK: - Found Categories Related Classes
class TmtSearchResultFoundCategory : NSObject{
    var fcCount : Int?
    var fcCategory : String?
    var fcName : String?
    var fcIsRestricted : Bool?
    
    override var description: String{
        get{
            var content : String = "\tFoundCategory: [\n"
            content += ((fcCount != nil) ? "\tCount: \(fcCount!)\n" : "")
            content += ((fcCategory != nil) ? "\tCategory: \(fcCategory!)\n" : "")
            content += ((fcName != nil) ? "\tName: \(fcName!)\n" : "")
            content += ((fcIsRestricted != nil) ? "\tIsRestricted: \(fcIsRestricted!)\n" : "")
            content += "\t]\n"
            return content
        }
    }
}

// MARK: - Parameters Related Classes
class TmtSearchResultParameter : NSObject{
    var paDisplayName : String?
    var paName : String?
    var paLowerBoundName : String?
    var paUpperBoundName : String?
    var paType : EnumSearchResultParameterType?
    var paAllowsMultipleValues : Bool?
    var paMutualExclusionGroup : String?
    var paDependentOn : String?
    var paExternalOptionKey : String?
    var paOptions = [TmtSearchResultParameterOption]()
    
    override var description: String{
        get{
            var content : String = "\tSearchParameters : [\n"
            content += ((paDisplayName != nil) ? "\tDisplayName: \(paDisplayName!)\n" : "")
            content += ((paName != nil) ? "\tName: \(paName!)\n" : "")
            content += ((paLowerBoundName != nil) ? "\tLowerBoundName: \(paLowerBoundName!)\n" : "")
            content += ((paUpperBoundName != nil) ? "\tUpperBoundName: \(paUpperBoundName!)\n" : "")
            content += ((paType != nil) ? "\tType: \(paType!.associatedString())\n" : "")
            content += ((paAllowsMultipleValues != nil) ? "\tAllowsMultipleValues: \(paAllowsMultipleValues!)\n" : "")
            content += ((paMutualExclusionGroup != nil) ? "\tMutualExlusionGroup: \(paMutualExclusionGroup!)\n" : "")
            content += ((paDependentOn != nil) ? "\tDependentOn: \(paDependentOn!)\n" : "")
            content += ((paExternalOptionKey != nil) ? "\tExternalOptionKey: \(paExternalOptionKey)\n" : "")
            for option in paOptions{
                content += "\(option)"
            }
            content += "\t]\n"
            return content
        }
    }
}

class TmtSearchResultParameterOption : NSObject{
    var poValue : String?
    var poDisplay : String?
    
    override var description: String{
        get{
            var content : String = "\t\tAttributeOption: [\n"
            content += ((poValue != nil) ? "\t\tValue: \(poValue!)\n" : "")
            content += ((poDisplay != nil) ? "\t\tDisplay: \(poDisplay!)\n" : "")
            content += "\t\t]\n"
            return content
        }
    }
}

// MARK: - Member Profile
class TmtSearchResultMemberProfile : NSObject{
    var mpFirstName : String?
    var mpOccuption : String?
    var mpBiography : String?
    var mpQuote : String?
    var mpPhoto : String?
    var mpIsEnabled : Bool?
    var mpDateRemoved : NSDate?
    var mpMember = TmtSearchResultMemberProfileMember()
    var mpFavouritedId : Int?
    var mpStore = TmtSearchResultMemberProfileStore()
    
    override var description: String{
        get{
            var content : String = "\tMemberProfile:[\n"
            content += ((mpFirstName != nil) ? "\tFirstName: \(mpFirstName!)\n" : "")
            content += ((mpOccuption != nil) ? "\tOccupation: \(mpOccuption!)\n" : "")
            content += ((mpBiography != nil) ? "\tBiography: \(mpBiography!)\n" : "")
            content += ((mpQuote != nil) ? "\tQuote: \(mpQuote!)\n" : "")
            content += ((mpPhoto != nil) ? "\tPhoto: \(mpPhoto!)\n" : "")
            content += ((mpIsEnabled != nil) ? "\tIsEnabled: \(mpIsEnabled!)\n" : "")
            content += ((mpDateRemoved != nil) ? "\tDateRemoved: \(mpDateRemoved!.generateDateTimeString())\n" : "")
            content += "\(mpMember)"
            content += ((mpFavouritedId != nil) ? "\tFavouriteId: \(mpFavouritedId!)\n" : "")
            content += "\(mpStore)"
            content += "\t]\n"
            return content
        }
    }
}
class TmtSearchResultMemberProfileMember : NSObject{
    var mpmMemberId : Int?
    var mpmNickname : String?
    var mpmDateAddressVerified : NSDate?
    var mpmDateJoined : NSDate?
    var mpmUniqueNegative : Int?
    var mpmUniquePositive : Int?
    var mpmFeedbackCount : Int?
    var mpmIsAddressVerified : Bool?
    var mpmSuburb : String?
    var mpmIsDealer : Bool?
    var mpmIsAuthenticated : Bool?
    var mpmIsInTrade : Bool?
    var mpmImportChargesMayApply : Bool?
    
    override var description: String{
        get{
            var content : String = "\t\tMember: [\n"
            content += ((mpmMemberId != nil) ? "\t\tMemberId: \(mpmMemberId!)\n" : "")
            content += ((mpmNickname != nil) ? "\t\tNickName: \(mpmNickname!)\n" : "")
            content += ((mpmDateAddressVerified != nil) ? "\t\tDateAddressVerified: \(mpmDateAddressVerified!)\n" : "")
            content += ((mpmDateJoined != nil) ? "\t\tDateJoined: \(mpmDateJoined!)\n" : "")
            content += ((mpmUniqueNegative != nil) ? "\t\tUniqueNegative: \(mpmUniqueNegative!)\n" : "")
            content += ((mpmUniquePositive != nil) ? "\t\tUniquePositive: \(mpmUniquePositive!)\n" : "")
            content += ((mpmFeedbackCount != nil) ? "\t\tFeedbackCount: \(mpmFeedbackCount!)\n" : "")
            content += ((mpmIsAddressVerified != nil) ? "\t\tIsAddressVerified: \(mpmIsAddressVerified!)\n" : "")
            content += ((mpmSuburb != nil) ? "\t\tSuburb: \(mpmSuburb!)\n" : "")
            content += ((mpmIsDealer != nil) ? "\t\tIsDealer: \(mpmIsDealer!)\n" : "")
            content += ((mpmIsAuthenticated != nil) ? "\t\tIsAuthenticated: \(mpmIsAuthenticated!)\n" : "")
            content += ((mpmIsInTrade != nil) ? "\t\tIsInTrade: \(mpmIsInTrade!)\n" : "")
            content += ((mpmImportChargesMayApply != nil) ? "\t\tImportChargesMayApply: \(mpmImportChargesMayApply!)\n" : "")
            content += "\t\t]\n"
            return content
        }
    }
}
class TmtSearchResultMemberProfileStore : NSObject{
    var mpsName : String?
    var mpsLogoImageUri : String?
    var mpsBannerImageUri : String?
    var mpsPromotions = [TmtSearchResultMemberProfileStorePromotion]()
    
    override var description: String{
        get{
            var content : String = "\t\tStore: [\n"
            content += ((mpsName != nil) ? "\t\tName: \(mpsName!)\n" : "")
            content += ((mpsLogoImageUri != nil) ? "\t\tLogoImageUri: \(mpsLogoImageUri!)\n" : "")
            content += ((mpsBannerImageUri != nil) ? "\t\tBannerImageUri: \(mpsBannerImageUri!)\n" : "")
            for promotion in mpsPromotions{
                content += "\(promotion)"
            }
            content += "\t\t]\n"
            return content
        }
    }
}

class TmtSearchResultMemberProfileStorePromotion : NSObject{
    var mpspImageUri : String?
    
    override var description: String{
        get{
            var content : String = "\t\t\tStorePromotion:[\n"
            content += ((mpspImageUri != nil) ? "\t\t\tImageUri: \(mpspImageUri!)\n" : "")
            content += "\t\t\t]\n"
            return content
        }
    }
}


























