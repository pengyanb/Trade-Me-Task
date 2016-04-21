//
//  TmtListingDetailsRelatedClass.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 21/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import Foundation

class TmtListingDetail : NSObject{
    var ldListingId : Int?
    var ldTitle : String?
    var ldCategory : String?
    var ldStartPrice : Double?
    var ldBuyNowPrice : Double?
    var ldStartDate : NSDate?
    var ldEndDate : NSDate?
    var ldIsFeatured : Bool?
    var ldHasGallery : Bool?
    var ldIsBold : Bool?
    var ldIsHightlighted : Bool?
    var ldHasHomePageFeature : Bool?
    var ldBidderAndWatchers : Int?
    var ldMaxBidAmount : Double?
    var ldAsAt : NSDate?
    var ldCategoryPath : NSString?
    var ldPhotoId : Int?
    var ldHasPayNow : Bool?
    var ldIsNew : Bool?
    var ldRegionId : Int?
    var ldRegion : String?
    var ldSuburbId : Int?
    var ldSuburb : String?
    var ldBidCount : Int?
    var ldViewCount : Int?
    var ldIsReserveMet : Bool?
    var ldHasReserve : Bool?
    var ldHasBuyNow : Bool?
    var ldNoteDate : NSDate?
    var ldCategoryName: String?
    var ldReserveState : EnumListingDetailReserveState?
    var ldAttributes = [TmtListingDetailAttribute]()
    var ldIsClassified : Bool?
    
    var ldPriceDisplay : String?
    var ldBody : String?
    var ldPhotos = [TmtListingDetailPhoto]()
    var ldContactDetails : TmtListingDetailContactDetail?
}

class TmtListingDetailAttribute : NSObject{
    var ldaName : String?
    var ldaDisplayName : String?
    var ldaValue : String?
    var ldaType : EnumListingDetailAttributeType?
    //var ldaRange : AttributeRange         //!! AttributeRange type undefined in API
    //var ldaOptions = [AttributeOption]()  //!! AttributeOption type undefined in API
    var ldaIsRequiredForSell : Bool?
    
}

class TmtListingDetailPhoto : NSObject{
    var ldpPhotoId : Int?
    var ldpValue : TmtListingDetailPhotoUrl?
}
class TmtListingDetailPhotoUrl : NSObject{
    var ldpuThumbnail : String?
    var ldpuList : String?
    var ldpuMedium : String?
    var ldpuGallery : String?
    var ldpuLarge : String?
    var ldpuFullSize : String?
    var ldpuPlusSize : String?
    var ldpuPhotoId : Int?
    var ldpuOriginalWidth : Int?
    var ldpuOriginalHeight : Int?
}

class TmtListingDetailContactDetail : NSObject{
    var ldcdContactName : String?
    var ldcdPhoneNumber : String?
    var ldcdMobilePhoneNumber : String?
    var ldcdBestContactTime : String?
    var ldcdWebsite : String?
}





























