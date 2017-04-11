//
//  RabbitTVManager.m
//  SidebarDemo
//
//  Created by Panda on 6/15/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RabbitTVManager.h"
#import "AppConfig.h"


@implementation RabbitTVManager
@synthesize client;

static RabbitTVManager* gSharedManager;

#pragma mark - JSON_URL

//static NSString* JSON_URL = @"http://mdev.rabbittvgo.com/RPC2/";
//static NSString* JSON_URL = @"http://rtv2.rabbittvgo.com/RPC2/";
//static NSString* JSON_URL = @"http://developer1.rabbittvgo.com/RPC2/";

//static NSString* JSON_URL = @"http://selecttv.freecast.com/RPC2/";  //----->PREV  URL LIVE

//static NSString* JSON_URL = @"http://stv.freecast.com/RPC2/";    //------>CURRENT DEV

//static NSString* JSON_URL = @"http://stagingstv.freecast.com/RPC2/"; //--->STAGING URL


static NSString* JSON_URL = @"https://mobile.freecast.com/";//----->CURRENT LIVE URL

//TESING LOAD SUBCRIPTION_LIST

//static NSString* JSON_URL =  @"http://stv5.neatsoft.info/RPC2/"; //testing



+(RabbitTVManager *) sharedManager
{
    
    if(gSharedManager == nil){
        gSharedManager = [[RabbitTVManager alloc] init];
        
    }
    
    return gSharedManager;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        gSharedManager = self;
       client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:JSON_URL]];
    }
    return self;
}

#pragma mark - MAIN CATEGORIES API
-(void) getCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    
//    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:JSON_URL]];
    [client invokeMethod:@"youlive.categories" success:successBlock
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){NSLog(@"ERROR-->%@",error);}];

}

-(void)getAllCategories:(void(^)(AFHTTPRequestOperation *, id))successBlock
{
    [client invokeMethod:@"youlive.categories" withParameters:@[@"1"] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){ NSLog(@"getAllCategoriesERROR-->%@",error);}];
}
- (void)getHomeDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    
    [client invokeMethod:@"carousel.getHomeScreen" success:successBlock
       failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}

//- (void)getHomeDetailsParam:(void (^)(AFHTTPRequestOperation *, id))successBlock
//{
//    [client invokeMethod:@"carousel.getHomeScreen" withParameters:@[@"1"] success:successBlock
//                 failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//}


- (void)getChannels:(void (^)(AFHTTPRequestOperation *, id))successBlock catID:(int)nCategoryId
{
//    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:JSON_URL]];
    [client invokeMethod:@"youlive.channels" withParameters:@[@(nCategoryId)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
    
    NSLog(@"GetChannelsERROR-->%@",error);
    }];
  
}


- (void)getStreams:(void (^)(AFHTTPRequestOperation *, id))successBlock chanID:(int)nChannelId
{
    NSString *strID = [NSString stringWithFormat:@"%d", nChannelId];
    [client invokeMethod:@"youlive.scheduller" withParameters:@[strID, @(100)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}
- (void)getStreamsLimit:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock chanID:(int)nChannelId
{
    NSString *strID = [NSString stringWithFormat:@"%d", nChannelId];
   
    [client invokeMethod:@"youlive.scheduller" withParameters:@[strID, @(100)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}

- (void)getStreams:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock chanID:(int)nChannelId
{
    NSString *strID = [NSString stringWithFormat:@"%d", nChannelId];
    

    [client invokeMethod:@"youlive.scheduller" withParameters:@[strID, @(100)] success:successBlock failure:failureBlock];
    
}
#pragma mark - APPMENU API
- (void)getAppMenu:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{

    [client invokeMethod:@"app.menu"
                 success:successBlock
                 failure:failureBlock];
     NSLog(@"client=%@",client);
}
#pragma mark - APPS LIST API
- (void)getAppsByName:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAppName:(NSString *) StrAppName nDeviceId:(int)nDeviceID
{
    [client invokeMethod:@"apps.getByName" withParameters:@[StrAppName,@(nDeviceID)] success:successBlock failure:failureBlock];
}
- (void)getAppsList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock DeviceId:(int)nDeviceID Category:(int)nCategory
{
    
    [client invokeMethod:@"apps.list" withParameters:@[@(nDeviceID),@(nCategory)] success:successBlock failure:failureBlock];
    
    //[client invokeMethod:@"selecttvbox.getShowsCarouselsByCategory" withParameters:@[@(nDeviceID),@(nCategory)] success:successBlock failure:failureBlock];
    
}
- (void)getAppsCategory:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nDeviceId:(int)nDeviceID
{
    
    [client invokeMethod:@"apps.categories" withParameters:@[@(nDeviceID)] success:successBlock failure:failureBlock];
    //[client invokeMethod:@"selecttvbox.categories" success:successBlock failure:failureBlock];
    
}

//NEW
- (void)getAppsListCarouselsByCategory:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock DeviceId:(int)nDeviceID Category:(int)nCategory
{
    
   // [client invokeMethod:@"apps.list" withParameters:@[@(nDeviceID),@(nCategory)] success:successBlock failure:failureBlock];
   // NSString *nCategoryStr = [NSString stringWithFormat:@"%d", nCategory];
   // NSString *nDeviceStr = [NSString stringWithFormat:@"%d", nDeviceID]; //@"i";[NSString stringWithFormat:@"%d", nDeviceID];
    
    [client invokeMethod:@"apps.list" withParameters:@[@(nDeviceID),@(nCategory)] success:successBlock failure:failureBlock];
    
//    [client invokeMethod:@"selecttvbox.getShowsCarouselsByCategory" withParameters:@[nCategoryStr,nDeviceStr] success:successBlock failure:failureBlock];
    
}

- (void)getAppsListCarouselsViewAll:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock  Category:(int)nCategory
{
    
    NSString *nCategoryStr = [NSString stringWithFormat:@"%d", nCategory];
    [client invokeMethod:@"selecttvbox.viewAll" withParameters:@[nCategoryStr,@(100),@(0),@(PAY_MODE_ALL)] success:successBlock failure:failureBlock];
    
}


#pragma mark - MOVIES API
- (void)getMovieListbyGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID nStatus:(int)nStatus nPPV:(int)nPPV
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];

//    [client invokeMethod:@"movies.listByGenre" withParameters:@[strID, @(100), @(0), @(nStatus),@(PAY_MODE_ALL),DEVICES] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    [client invokeMethod:@"movies.listByGenre" withParameters:@[strID, @(100), @(0),@(nPPV),DEVICES] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

- (void)getMovieDetail:(void (^)(AFHTTPRequestOperation *, id))successBlock  failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nMovieID:(int)nID nPPV:(int)nPPV
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];

    [client invokeMethod:@"movie.details" withParameters:@[strID,@(nPPV),DEVICES] success:successBlock failure:failureBlock];
}


#pragma mark - NETWORK API
- (void)getAllNetworks:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{

    [client invokeMethod:@"networks.list" withParameters:@[@"", @(100), @(0)] success:successBlock failure:failureBlock];

}

- (void)getNetworkList:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID nPPV:(int)nPPV
{
    //NSString *strID = [NSString stringWithFormat:@"%d", nID];
   // [client invokeMethod:@"shows.listByNetwork" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    [client invokeMethod:@"selecttvbox.showsByNetwork" withParameters:@[@(nID), @(100), @(0),@(nPPV)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
}

- (void)getNetworkDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
    [client invokeMethod:@"networks.details" withParameters:@[strID] success:successBlock failure:failureBlock];
}


#pragma mark - SHOW API
- (void)getShowListByGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID nPPV:(int)nPPV
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
    
    //[client invokeMethod:@"shows.listByGenre" withParameters:@[strID, @(100), @(0)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    [client invokeMethod:@"selecttvbox.showsByGenre" withParameters:@[strID, @(100), @(0),@(nPPV)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

    
    
}

- (void)getShowDetail:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
   
    [client invokeMethod:@"shows.details" withParameters:@[strID] success:successBlock failure:failureBlock];
    
    // [client invokeMethod:@"youlive.scheduller" withParameters:@[strID, @(100)] success:successBlock failure:failureBlock];
    
    //[client invokeMethod:@"shows.details" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getShowSeasons:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];

    [client invokeMethod:@"shows.seasons" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

- (void)getShowEpisodes:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nSeasonId:(int)nSeasonID nPPV:(int)nPPV;
{
    NSString *strDevice = DEVICES;
    [client invokeMethod:@"shows.episodes" withParameters:@[@(nID), @(nSeasonID),@(nPPV),strDevice] success:successBlock failure:failureBlock];
}
- (void)getShowEpisodesWithShowId:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nPPV:(int)nPPV;//Doubt
{
    NSString *strDevice = DEVICES;
    [client invokeMethod:@"shows.episodes" withParameters:@[@(nID),@(0),@(nPPV),strDevice] success:successBlock failure:failureBlock];
}

- (void)getShowFreeDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nPPV:(int)nPPV;//Doubt
{
    //,@(0), @(1)
    NSString *strDevice = DEVICES;
    [client invokeMethod:@"shows.episodes" withParameters:@[@(nID),@(0),@(nPPV),strDevice] success:successBlock failure:failureBlock];
}

- (void)getShowLinkList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nSeasonId:(int)nSeasonID nEpisodeId:(int)nEpisodeID
{
    //NOT GETTING EPISODE AND SEASON ID HERE
    
    [client invokeMethod:@"shows.linksList" withParameters:@[@(nID),@(nSeasonID),@(nEpisodeID)] success:successBlock failure:failureBlock];
}


- (void)getEpisodeDetail:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{

    [client invokeMethod:@"shows.episodeDetails" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

#pragma mark - KIDS API
- (void)getKidsCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{

    [client invokeMethod:@"kids.categories" success:successBlock failure:failureBlock];

}

- (void)getKidSubCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{

    [client invokeMethod:@"kids.subcategories" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

- (void)getKidItems:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{

    [client invokeMethod:@"kids.items" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

#pragma mark - SUBSCRIPTION API
- (void)getSubscriptionCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    [client invokeMethod:@"subscriptions.categories" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

- (void)getSubscriptionSubCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    [client invokeMethod:@"subscriptions.subcategories" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

- (void)getSubScriptionItems:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    [client invokeMethod:@"subscriptions.items" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}

- (void)getSelectTvScriptionItems:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    
    [client invokeMethod:@"selecttvbox.subscriptions" success:successBlock failure:failureBlock];
    
}
#pragma mark - RADIO API
- (void)getRadioGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    [client invokeMethod:@"radio.getGenres" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//   [client invokeMethod:@"radio.getGenres" withParameters:@[@(1000), @(0)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
    
}
- (void)getRadioLanguage:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    [client invokeMethod:@"radio.getLanguages" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//    [client invokeMethod:@"radio.getLanguages" withParameters:@[@(1000), @(0)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];

}
- (void)getRadioContinent:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    [client invokeMethod:@"radio.getContinents" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
//    [client invokeMethod:@"radio.getContinents" withParameters:@[@(1000), @(0)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getRadioListByGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock nGenreID:(int)nID
{
    [client invokeMethod:@"radio.getListByGenre" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//    [client invokeMethod:@"radio.getListByGenre" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getRadioListByLanguage:(void (^)(AFHTTPRequestOperation *, id))successBlock nLanguageID:(int)nID
{
    [client invokeMethod:@"radio.getListByLanguage" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//    [client invokeMethod:@"radio.getListByLanguage" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getRadioListByLocation:(void (^)(AFHTTPRequestOperation *, id))successBlock nLocationID:(int)nID
{
    [client invokeMethod:@"radio.getListByLocation" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//    [client invokeMethod:@"radio.getListByLocation" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}

- (void)getRadioCountries:(void (^)(AFHTTPRequestOperation *, id))successBlock nContinentID:(int)nID
{
   [client invokeMethod:@"radio.getCountries" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
}

- (void)getRadioCities:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID
{
    
    [client invokeMethod:@"radio.getCities" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getRadioCitiesRegion:(void (^)(AFHTTPRequestOperation *, id))successBlock nRegionID:(int)nID
{
    
    [client invokeMethod:@"radio.getCities" withParameters:@[@(""),@(nID),@(""),@("")] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getRadioRegions:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID
{
   
    [client invokeMethod:@"radio.getRegions" withParameters:@[@(nID)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
    //    [client invokeMethod:@"radio.getCities" withParameters:@[strID, @(1000), @(0) ] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
}

- (void)getListByLocationCountryCity:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID nCityID:(int)nCityId;
{
    //NSString *strID = [NSString stringWithFormat:@"%d", nID];
    [client invokeMethod:@"radio.getListByLocation" withParameters:@[@(""),@(nID),@(""),@(nCityId),@(""), @("")] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
    // "continent_id","country_id","region_id","city_id","limit","offset"
    
}
- (void)getRadioWithId:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nRadioID:(int)nID
{
    [client invokeMethod:@"radio.getRadio" withParameters:@[@(nID)] success:successBlock failure:failureBlock];
    
    
}
#pragma mark - SEARCH API
- (void)getSearch:(void (^)(AFHTTPRequestOperation *, id))successBlock searchString:(NSString *)strSearchQuery
{
    [client invokeMethod:@"search.combined" withParameters:@[strSearchQuery,@(2000)] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getSearchFindByType:(void (^)(AFHTTPRequestOperation *, id))successBlock searchString:(NSString *)strSearchQuery searchTypeStr:(NSString *)strSearchType
{
    [client invokeMethod:@"search.findByType" withParameters:@[strSearchQuery, strSearchType] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}

- (void)getActorDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
    [client invokeMethod:@"actors.details" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
#pragma mark - SEARCH LIVE DETAILS API
- (void)getLiveDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
    [client invokeMethod:@"live.details" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getStationDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
    [client invokeMethod:@"stations.details" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}
- (void)getTvStationDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID
{
    NSString *strID = [NSString stringWithFormat:@"%d", nID];
    [client invokeMethod:@"tvstations.details" withParameters:@[strID] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    
}


#pragma mark - ON DEMAND API
- (void)getPrimeTimeData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nWeekday:(NSString *)strWeekDay nPPV:(int)nPPV;
{
    [client invokeMethod:@"selecttvbox.primetimeAnytimeCarousels" withParameters:@[strWeekDay,@(nPPV)] success:successBlock failure:failureBlock];
}

- (void)getWholeViewAll:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nID:(int)nID  nPPV:(int)nPPV
{
    [client invokeMethod:@"selecttvbox.viewAll" withParameters:@[@(nID),@(100),@(0),@(nPPV),DEVICES] success:successBlock failure:failureBlock];
}
- (void)getSportsData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
//    [client invokeMethod:@"selecttvbox.sportsCarousels" success:successBlock failure:failureBlock];
    [client invokeMethod:@"selecttvbox.sportsCarousels" withParameters:@[@(nPPV),DEVICES] success:successBlock failure:failureBlock];

}
- (void)getWebOriginalSliderData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    NSString *slug =WEB_ORIGINALS_SLUG;
    [client invokeMethod:@"selectvbox.getWebSlider" withParameters:@[slug] success:successBlock failure:failureBlock];
}
- (void)getWebOriginalCarouselData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    NSString *slug =WEB_ORIGINALS_SLUG;
    
    [client invokeMethod:@"selecttvbox.getWebCarousels" withParameters:@[slug,@(nPPV),DEVICES] success:successBlock failure:failureBlock];
    
}


- (void)getKidsSliderData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"selectvbox.getKidsSlider" withParameters:@[] success:successBlock failure:failureBlock];
    
}
- (void)getKidsCarouselsData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    NSString *slug = KIDS_SLUG;
    [client invokeMethod:@"selecttvbox.getKidsCarousels" withParameters:@[slug,@(nPPV),DEVICES] success:successBlock failure:failureBlock];
    
}

//USER LOGIN API
#pragma mark - LOGIN API
- (void)getLoginDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock email:(NSString *)email password:(NSString *)password
{
     //  [client invokeMethod:@"auth.login" withParameters:@[email, password] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
    [client invokeMethod:@"auth.login" withParameters:@[email,password] success:successBlock failure:failureBlock];

}


- (void)getRegisterDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock email:(NSString *)email password:(NSString *)password data:(NSDictionary *)data
{
    
    [client invokeMethod:@"auth.register" withParameters:@[email, password,data] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
}


- (void)getForgotPassword:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock email:(NSString *)email

{
    
    [client invokeMethod:@"auth.forgot_password" withParameters:@[email] success:successBlock failure:failureBlock];
    
}

//USER PROFILE UPDATE API

#pragma mark - USER PROFILE UPDATE API
- (void)changeUserPassword:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken oldPassword:(NSString *)OldPassword newPassword:(NSString *)NewPassword
{
    [client invokeMethod:@"auth.userChangePassword" withParameters:@[StrAccessToken, OldPassword,NewPassword] success:successBlock failure:failureBlock];
}

- (void)getUserProfileDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken
{
    [client invokeMethod:@"auth.userProfile" withParameters:@[StrAccessToken] success:successBlock failure:failureBlock];
}

- (void)updateUserProfileDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken data:(NSDictionary *)Data
{
    [client invokeMethod:@"auth.userUpdate" withParameters:@[StrAccessToken,Data] success:successBlock failure:failureBlock];
}


//FAVOURITE
#pragma mark - FAVOURITE API
- (void)getFavoritesAdd:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken strEntity:(NSString *) StrEntity nEntityId:(int)nEntityId
{
    [client invokeMethod:@"favorites.add" withParameters:@[StrAccessToken,StrEntity,@(nEntityId)] success:successBlock failure:failureBlock];
}

- (void)getFavoritesRemove:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken strEntity:(NSString *) StrEntity nEntityId:(int)nEntityId
{
    [client invokeMethod:@"favorites.remove" withParameters:@[StrAccessToken,StrEntity,@(nEntityId)] success:successBlock failure:failureBlock];
}
- (void)getFavoritesUserList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken
{
    [client invokeMethod:@"favorites.userList" withParameters:@[StrAccessToken] success:successBlock failure:failureBlock];
}


//ADDITIONAL CHANGES IN ONDEMAND PAGE
#pragma mark - ON DEMAND PAGE ADDITIONAL API
- (void)getOnDemandSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"selecttvbox.ondemandSlider" success:successBlock
                 failure:failureBlock];
}
- (void)getOnDemandCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    NSString *device = DEVICES;
   [client invokeMethod:@"selecttvbox.ondemandCarousels" withParameters:@[@(nPPV),device] success:successBlock failure:failureBlock];
}

- (void)getOnDemandTopMenu:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"selecttvbox.ondemandSideMenu" success:successBlock failure:failureBlock];
}

- (void)getOnDemandTvShowsCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    NSString *device =DEVICES;
    [client invokeMethod:@"selecttvbox.showsCarousels" withParameters:@[@(nPPV),device] success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
}
- (void)getOnDemandTvShowsSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
   // NSString *slug = PPV_SHOWS_SLUG;
    [client invokeMethod:@"selecttvbox.showsSlider" withParameters:@[] success:successBlock
                 failure:failureBlock];
}

- (void)getOnDemandTvShowsCategory:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"selecttvbox.categories" success:successBlock
                 failure:failureBlock];
}
- (void)getOnDemandTvShowsCarouselsByCategoryID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock categoryID:(int)categoryID nPPV:(int)nPPV
{
    NSString *device =DEVICES;
    [client invokeMethod:@"selecttvbox.getShowsCarouselsByCategory" withParameters:@[@(categoryID),@(nPPV),device] success:successBlock failure:failureBlock];
    
    //@[@(categoryID),device,@(nPPV)]
}

- (void)getOnDemandTvShowsSliderByCategoryID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock categoryID:(int)categoryID
{
    
    [client invokeMethod:@"selecttvbox.getShowsSliderByCategory" withParameters:@[@(categoryID)] success:successBlock failure:failureBlock];
}

- (void)getOnDemandTvShowsDecades:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"selecttvbox.showsDecades" success:successBlock
                 failure:failureBlock];
}
- (void)getOnDemandTvShowsByDecadeID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock decadeID:(int)decadeID nPPV:(int)nPPV
{
    
    [client invokeMethod:@"selecttvbox.showsByDecade" withParameters:@[@(decadeID),@(100),@(0),@(nPPV)] success:successBlock failure:failureBlock];
}

- (void)getOnDemandPrimeTimeSliderImageByWeek:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock Weekday:(NSString *)strWeekDay
{
    
    [client invokeMethod:@"selecttvbox.primetimeAnytimeSlider" withParameters:@[strWeekDay] success:successBlock failure:failureBlock];
}
- (void)getOnDemandMoviesCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    NSString *device = @"I";
    [client invokeMethod:@"selecttvbox.moviesCarousels" withParameters:@[@(nPPV),device] success:successBlock failure:failureBlock];
}
- (void)getOnDemandMoviesSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"selecttvbox.moviesSlider" success:successBlock
                 failure:failureBlock];
}

- (void)getOnDemandMoviesRating:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    [client invokeMethod:@"movies.getMoviesRatings" success:successBlock
                 failure:failureBlock];
}

#pragma mark - getOnDemandSliderEntityDetails
- (void)getOnDemandSliderEntityDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock slideID:(int)slideID
{
    [client invokeMethod:@"selecttvbox.getSlideEntity" withParameters:@[@(slideID)] success:successBlock failure:failureBlock];
}
- (void)getOnDemandMoviesRatingDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strRating:(NSString *)strRating nPPV:(int)nPPV
{
    
    [client invokeMethod:@"movies.getMoviesByRating" withParameters:@[strRating,@(100),@(0),@(nPPV),DEVICES] success:successBlock failure:failureBlock];
}


- (void)getPayPerViewMoviesCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    NSString *slug = PPV_MOVIES_SLUG;
    NSString *device = DEVICES;
   
    [client invokeMethod:@"selecttvbox.ppvMoviesCarousels" withParameters:@[slug,device] success:successBlock failure:failureBlock];
}
- (void)getPayPerViewMoviesSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    NSString *slug = PPV_MOVIES_SLUG;
    [client invokeMethod:@"selecttvbox.ppvMoviesSlider" withParameters:@[slug] success:successBlock failure:failureBlock];
}

- (void)getPayPerViewShowsCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    NSString *slug = PPV_SHOWS_SLUG;
    NSString *device = DEVICES;
    [client invokeMethod:@"selecttvbox.ppvShowsCarousels" withParameters:@[slug,device] success:successBlock failure:failureBlock];
}
- (void)getPayPerViewShowsSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    NSString *slug = PPV_SHOWS_SLUG;
    [client invokeMethod:@"selecttvbox.ppvShowsSlider" withParameters:@[slug] success:successBlock failure:failureBlock];
}

#pragma mark - GAMES
- (void)getGamesCarouselData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV
{
    
    NSString *device = DEVICES;
    [client invokeMethod:@"games.carousels" withParameters:@[@(nPPV),device] success:successBlock failure:failureBlock];
}
- (void)getGamesDetailWithID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nID:(int)nID
{
    [client invokeMethod:@"games.details" withParameters:@[@(nID)] success:successBlock failure:failureBlock];
}

- (void)getGamesMoreList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock
{
    
    NSString *device = DEVICES;
     NSString *tag = @"more";
    [client invokeMethod:@"games.list" withParameters:@[device,tag,@(100),@(0)] success:successBlock failure:failureBlock];
}

#pragma mark - SUBSCRIPTIONS GET AND SET METHOD

- (void)setUserSubscriptions:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken subscriptionCode:(NSString *)subscriptionCode
{
    [client invokeMethod:@"user.set_user_subscriptions" withParameters:@[StrAccessToken,subscriptionCode] success:successBlock failure:failureBlock];
}
- (void)getUserSubscriptions:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken
{
    [client invokeMethod:@"user.get_user_subscriptions" withParameters:@[StrAccessToken] success:successBlock failure:failureBlock];
}

- (void)getUserCaurosalSubsc:(void (^)(AFHTTPRequestOperation *, id))successBlock
{
    [client invokeMethod:@"user.get_subscriptions" success:successBlock failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
}

- (void)getUserSubscriptionsWithCodeValue:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock codeValue:(NSString *) code
{
//    client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:@"http://stv6.neatsoft.info/RPC2/"]];
    [client invokeMethod:@"user.get_subscriptions" withParameters:@[code] success:successBlock failure:failureBlock];
}




#pragma mark - Tranlation_API

+ (AFHTTPRequestOperation *)googleTranslateMessage:(NSString *)message
                                        withSource:(NSString *)source
                                            target:(NSString *)target
                                               key:(NSString *)key
                                        completion:(void (^)(NSString *translatedMessage, NSString *detectedSource, NSError *error))completion
{
    NSURL *base = [NSURL URLWithString:@"https://www.googleapis.com/language/translate/v2"];
    
    NSMutableString *queryString = [NSMutableString string];
    // API key
    [queryString appendFormat:@"?key=%@", key];
//    // output style
//    [queryString appendString:@"&format=text"];
//    [queryString appendString:@"&prettyprint=false"];
    
    // source language
    if (source)
        [queryString appendFormat:@"&source=%@", source];
    
    // target language
    [queryString appendFormat:@"&target=%@", target];
    
//    // quota
//    if (quotaUser.length > 0)
//        [queryString appendFormat:@"&quotaUser=%@", quotaUser];
    
    // message
    [queryString appendFormat:@"&q=%@", [self urlEncodedStringFromString:message]];
    
    NSURL *requestURL = [NSURL URLWithString:queryString relativeToURL:base];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *translation = [[[responseObject objectForKey:@"data"] objectForKey:@"translations"] objectAtIndex:0];
         NSString *translatedText = [translation objectForKey:@"translatedText"];
         NSString *detectedSource = [translation objectForKey:@"detectedSourceLanguage"];
         if (!detectedSource)
             detectedSource = source;
         
         completion(translatedText, detectedSource, nil);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Translator: failed Google translate: %@", operation.responseObject);
         NSString *const TRANSLATOR_ERROR_DOMAIN = @"TranslatorErrorDomain";
         NSInteger code = error.code == 400 ? 1 : 2;
         NSError *fgError = [NSError errorWithDomain:TRANSLATOR_ERROR_DOMAIN code:code userInfo:nil];
         
         completion(nil, nil, fgError);
     }];
    [operation start];
    
    return operation;
}


//@"https://www.googleapis.com/language/translate/v2?"
    
+ (NSString *)urlEncodedStringFromString:(NSString *)original
{
    NSMutableString *escaped = [NSMutableString stringWithString:[original stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [escaped replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    [escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escaped length])];
    
    return escaped;
}
- (void)getGoogleTranslateText:(NSString *)key
                   withSource:(NSString *)source
                       target:(NSString *)target
                         text:(NSString *)text
                  success:(WebserviceRequestSuccessHandler)success
                  failure:(WebserviceRequestFailureHandler)failure{
    
                NSString *urlString = API_URL_GET_LANGUAGES;
                NSDictionary *parameters = @{
                                             PARM_KEY_APIKEY : key,
                                             PARM_KEY_SOURCE_LANGUAGE: source,
                                             PARM_KEY_DESTINATION_LANGUAGE_TARGET : target,
                                             PARM_KEY_DETECTION_TEXT : text
                                 
                                                };

                        NSLog(@"urlString = %@",urlString);

    [self sendRequestWithUrlPath:urlString parms:parameters successHandler:success failureHandler:failure];
    
}



- (void)sendRequestWithUrlPath:(NSString *)path parms:(NSDictionary *)parms successHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successHandler failureHandler:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [self translateRequestWithPath:path parms:parms];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:successHandler
                                                                         failure:failureHandler];
    
    [manager.operationQueue addOperation:operation];
}
- (NSMutableURLRequest *)translateRequestWithPath:(NSString *)path parms:(NSDictionary *)parms {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                      URLString:path
                                                                     parameters:parms
                                                                          error:nil];
   // [request addValue:[[NSBundle mainBundle] bundleIdentifier] forHTTPHeaderField:@"Referer"];
    
    return request;
}

#pragma mark - CANCELREQUEST
-(void) cancelRequest{
    [client.operationQueue cancelAllOperations];
}



@end
