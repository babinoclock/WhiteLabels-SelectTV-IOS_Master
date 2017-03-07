//
//  RabbitTVManager.h
//  SidebarDemo
//
//  Created by Panda on 6/15/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#ifndef SidebarDemo_RabbitTVManager_h
#define SidebarDemo_RabbitTVManager_h

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

#import "AFJSONRPCClient.h"

typedef void (^WebserviceRequestSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);

typedef void (^WebserviceRequestFailureHandler)(AFHTTPRequestOperation  *operation, id error);

typedef void (^WebserviceRequestXMLSuccessHandler)(AFHTTPRequestOperation  *operation);
typedef void (^WebserviceRequestXMLFailureHandler)(AFHTTPRequestOperation  *operation, NSError *error);

@interface RabbitTVManager : NSObject
{
    
}

@property(nonatomic,retain) AFJSONRPCClient *client;

+(RabbitTVManager *) sharedManager;

//-(void )getCategories;
#pragma mark - MAIN CATEGORIES API
- (void)getCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getAllCategories:(void(^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getHomeDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock;
//- (void)getHomeDetailsParam:(void (^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getChannels:(void (^)(AFHTTPRequestOperation *, id))successBlock catID:(int)nCategoryId;

- (void)getStreams:(void (^)(AFHTTPRequestOperation *, id))successBlock chanID:(int)nChannelId;
- (void)getStreamsLimit:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock chanID:(int)nChannelId;

#pragma mark - APPMENU API
- (void)getAppMenu:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

//To get rent now(image,link)
#pragma mark - APPS LIST API
- (void)getAppsByName:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAppName:(NSString *) StrAppName nDeviceId:(int)nDeviceID;

- (void)getAppsList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock DeviceId:(int)nDeviceID Category:(int)nCategory;
- (void)getAppsCategory:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nDeviceId:(int)nDeviceID;

//NEW
- (void)getAppsListCarouselsByCategory:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock DeviceId:(int)nDeviceID Category:(int)nCategory;

- (void)getAppsListCarouselsViewAll:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock  Category:(int)nCategory;

#pragma mark - MOVIES API
- (void)getMovieListbyGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID nStatus:(int)nStatus nPPV:(int)nPPV;
- (void)getMovieDetail:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nMovieID:(int)nID nPPV:(int)nPPV;
- (void)getShowListByGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID nPPV:(int)nPPV;
- (void)getShowDetail:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID;

#pragma mark - NETWORK API
- (void)getAllNetworks:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;
- (void)getNetworkList:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID nPPV:(int)nPPV;
- (void)getNetworkDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nID:(int)nID;

#pragma mark - SHOW API
- (void)getShowSeasons:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;
- (void)getShowEpisodes:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nSeasonId:(int)nSeasonID nPPV:(int)nPPV;
- (void)getShowEpisodesWithShowId:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nPPV:(int)nPPV;
- (void)getShowFreeDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nPPV:(int)nPPV;- (void)getShowLinkList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nShowID:(int)nID nSeasonId:(int)nSeasonID nEpisodeId:(int)nEpisodeID;
- (void)getEpisodeDetail:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

#pragma mark - KIDS API
- (void)getKidsCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;
- (void)getKidSubCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;
- (void)getKidItems:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

#pragma mark - SUBSCRIPTION API
- (void)getSubscriptionCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getSubscriptionSubCategories:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;
- (void)getSubScriptionItems:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

- (void)getSelectTvScriptionItems:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;


//RADIO
#pragma mark - RADIO API
- (void)getRadioGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getRadioLanguage:(void (^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getRadioContinent:(void (^)(AFHTTPRequestOperation *, id))successBlock;

//RADIO BY LIST
- (void)getRadioListByGenre:(void (^)(AFHTTPRequestOperation *, id))successBlock nGenreID:(int)nID;
- (void)getRadioListByLanguage:(void (^)(AFHTTPRequestOperation *, id))successBlock nLanguageID:(int)nID;
- (void)getRadioListByLocation:(void (^)(AFHTTPRequestOperation *, id))successBlock nLocationID:(int)nID;
- (void)getRadioCountries:(void (^)(AFHTTPRequestOperation *, id))successBlock nContinentID:(int)nID;
//- (void)getRadioCities:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID nRegionID:(int)nRegionId;
- (void)getRadioCities:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID;
- (void)getRadioRegions:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID;
//byRegionID
- (void)getRadioCitiesRegion:(void (^)(AFHTTPRequestOperation *, id))successBlock nRegionID:(int)nID;
- (void)getListByLocationCountryCity:(void (^)(AFHTTPRequestOperation *, id))successBlock nCountryID:(int)nID nCityID:(int)nCityId;
//By RadioWithId
- (void)getRadioWithId:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nRadioID:(int)nID;

- (void)getStreams:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock chanID:(int)nChannelId;


//SEARCH
#pragma mark - SEARCH API
- (void)getSearch:(void (^)(AFHTTPRequestOperation *, id))successBlock searchString:(NSString *)strSearchQuery;

- (void)getSearchFindByType:(void (^)(AFHTTPRequestOperation *, id))successBlock searchString:(NSString *)strSearchQuery searchTypeStr:(NSString *)strSearchType;

- (void)getActorDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

//LIVE DETAILS
#pragma mark - SEARCH LIVE DETAILS API
- (void)getLiveDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

- (void)getStationDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

- (void)getTvStationDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock nID:(int)nID;

//ON DEMAND
#pragma mark - ON DEMAND API
- (void)getPrimeTimeData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nWeekday:(NSString *)strWeekDay nPPV:(int)nPPV;;

- (void)getWholeViewAll:(void (^)(AFHTTPRequestOperation *, id))successBlock  failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nID:(int)nID nPPV:(int)nPPV;

- (void)getSportsData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;

- (void)getWebOriginalSliderData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;
- (void)getWebOriginalCarouselData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;

- (void)getKidsSliderData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;
- (void)getKidsCarouselsData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;


//LOGIN
#pragma mark - LOGIN API
//- (void)getLoginDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock email:(NSString *)email password:(NSString *)password;
- (void)getLoginDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock email:(NSString *)email password:(NSString *)password;
- (void)getForgotPassword:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock email:(NSString *)email;
- (void)getRegisterDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock email:(NSString *)email password:(NSString *)password  data:(NSDictionary *)data;


//USER PROFILE UPDATE API

#pragma mark - USER PROFILE UPDATE API
- (void)changeUserPassword:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken oldPassword:(NSString *)OldPassword newPassword:(NSString *)NewPassword;

- (void)getUserProfileDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken;

- (void)updateUserProfileDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken data:(NSDictionary *)Data;


//FAVOURITE
#pragma mark - FAVOURITE API
- (void)getFavoritesAdd:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken strEntity:(NSString *) StrEntity nEntityId:(int)nEntityId;


- (void)getFavoritesRemove:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken strEntity:(NSString *) StrEntity nEntityId:(int)nEntityId;

- (void)getFavoritesUserList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken;

//ADDITIONAL CHANGES IN ONDEMAND PAGE
#pragma mark - ON DEMAND PAGE ADDITIONAL API

- (void)getOnDemandSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

- (void)getOnDemandCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;

- (void)getOnDemandTopMenu:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

- (void)getOnDemandTvShowsCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;

- (void)getOnDemandTvShowsSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

- (void)getOnDemandTvShowsCategory:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

- (void)getOnDemandTvShowsCarouselsByCategoryID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock categoryID:(int)categoryID nPPV:(int)nPPV;

- (void)getOnDemandTvShowsSliderByCategoryID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock categoryID:(int)categoryID;

- (void)getOnDemandTvShowsDecades:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

- (void)getOnDemandTvShowsByDecadeID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock decadeID:(int)decadeID nPPV:(int)nPPV;

- (void)getOnDemandPrimeTimeSliderImageByWeek:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock Weekday:(NSString *)strWeekDay;

- (void)getOnDemandMoviesCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;

- (void)getOnDemandMoviesSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;
     
- (void)getOnDemandMoviesRating:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

#pragma mark - getOnDemandSliderEntityDetails
- (void)getOnDemandSliderEntityDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock slideID:(int)slideID;

- (void)getOnDemandMoviesRatingDetails:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strRating:(NSString *)strRating nPPV:(int)nPPV;

#pragma mark - PayPerView

- (void)getPayPerViewMoviesCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;
- (void)getPayPerViewMoviesSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

- (void)getPayPerViewShowsCarousels:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;
- (void)getPayPerViewShowsSlider:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;

#pragma mark - GAMES
- (void)getGamesCarouselData:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nPPV:(int)nPPV;
- (void)getGamesDetailWithID:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock nID:(int)nID;
- (void)getGamesMoreList:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock;


#pragma mark - SUBSCRIPTIONS GET AND SET METHOD

- (void)setUserSubscriptions:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken subscriptionCode:(NSString *)subscriptionCode;\

- (void)getUserSubscriptions:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock strAccessToken:(NSString *) StrAccessToken;

- (void)getUserCaurosalSubsc:(void (^)(AFHTTPRequestOperation *, id))successBlock;
- (void)getUserSubscriptionsWithCodeValue:(void (^)(AFHTTPRequestOperation *, id))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *, id))failureBlock codeValue:(NSString *) code;
#pragma mark - googleTranslateMessage METHOD

+ (AFHTTPRequestOperation *)googleTranslateMessage:(NSString *)message
                                        withSource:(NSString *)source
                                            target:(NSString *)target
                                               key:(NSString *)key
                                        completion:(void (^)(NSString *translatedMessage, NSString *detectedSource, NSError *error))completion;

- (void)getGoogleTranslateText:(NSString *)key
                    withSource:(NSString *)source
                        target:(NSString *)target
                          text:(NSString *)text
                       success:(WebserviceRequestSuccessHandler)success
                       failure:(WebserviceRequestFailureHandler)failure;

#pragma mark - CANCELREQUEST
- (void) cancelRequest;
@end

#endif
