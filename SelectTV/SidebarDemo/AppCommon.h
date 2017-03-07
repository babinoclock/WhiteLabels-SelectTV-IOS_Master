//
//  AppCommon.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 28/01/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#pragma mark - Device model checking

#define IS_IPHONE UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone
#define IS_HEIGHT_GTE_480 ([[UIScreen mainScreen ] bounds].size.height >= 480.0f) && ([[UIScreen mainScreen ] bounds].size.height < 568.0f)
#define IS_HEIGHT_GTE_568 ([[UIScreen mainScreen ] bounds].size.height >= 568.0f) && ([[UIScreen mainScreen ] bounds].size.height < 667.0f)
#define IS_IPHONE_4 ( IS_IPHONE && IS_HEIGHT_GTE_480 )
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#define IS_IPHONE_6 ( IS_IPHONE && IS_HEIGHT_GTE_667 )


typedef enum {
    
    iPhone4,
    iPhone5,
    iPhone6,
    iPhone6Plus,
    iPad
}currentDevice;

typedef enum {
    DataTypeArray,
    DataTypeDic,
    DataTypeImage
}DataType;




@interface AppCommon : NSObject<MBProgressHUDDelegate>{
    UIView  *loadingView;
    UIActivityIndicatorView *activityView;
    MBProgressHUD   *progressHUD;
}

+(AppCommon *) common;
//progres hud with name
-(void)loadProgressHud;
-(void) removeProgressHud;

- (void)addLoadingIcon:(UIViewController *)controller;
- (void)removeLoadingIcon;

- (void)LoadIcon:(UIView *)view;
- (void)removeLoading;

- (currentDevice)getCurrentDevice;
- (UIFont *)getResizeableFont:(UIFont *)currentFont;
+(void)showSimpleAlertWithMessage:(NSString *)message;


//TRANSLATED WORDS

-(void)setHomeStaticArrayList:(NSMutableArray *)_arrayInfo;
-(void)removeHomeStaticArrayList;
-(NSMutableArray *)getHomeStaticArrayList;

-(void)setSideBarStaticArrayList:(NSMutableArray *)_arrayInfo;
-(void)removeSideBarStaticArrayList;
-(NSMutableArray *)getSideBarStaticArrayList;

    
//User Defaults
- (void)setDetails:(NSMutableDictionary *)_dicInfo;
- (void)removeDetails;
- (NSMutableDictionary *)getDetails;

//Login Defaults
- (void)setLoginDetails:(NSMutableDictionary *)_dicInfo;
- (void)removeLoginDetails;
- (NSMutableDictionary *)getLoginDetails;
-(void)isSideBarAppManager:(NSString *)valid;
//APP LIST DETAILS
-(void)setAppListDetails:(NSMutableArray *)_dicInfo;
-(void)removeAppListDetails;
-(NSMutableArray *)getAppListDetails;

//FAV LIST DETAILS
-(void)setFavListDetails:(NSMutableDictionary *)_dicInfo;
-(void)removeFavListDetails;
-(NSMutableDictionary *)getFavListDetails;

//USER PROFILE DETAILS
- (void) storeUserProfileDetails:(NSMutableDictionary *) userDetails;
-(void)isAppManager:(NSString *)valid;
- (NSString *) getAppManagerDetail;
- (NSMutableDictionary *) getUserProfileDetails;
- (void) removeUserProfileDetails;

- (BOOL) isUserFirstTimeLoggedIn;
- (BOOL) isUserLoggedIn;
-(NSString *)getUserAccessToken;

-(BOOL)isSpanishLanguage;

//APPLIST CHECK

-(BOOL)checkInstalledApplicationInApp:(NSString*)urlStr;

#pragma mark - SPANISH WORDS
//INTRO

-(NSString *)getloadingStr;
-(NSString *)getloadingAppMenuStr;
-(NSString *)getloadingNetworkListStr;
-(NSString *)getloadingGamesCarouselStr;
-(NSString *)getloadingHomeStr;
-(NSString *)getloadingOnDemandStr;
-(NSString *)getloadingAppCategoryStr;
-(NSString *)getloadingSubscriptionListStr;
-(NSString *)getloadingLiveCategoriesStr;
-(NSString *)getloadingRadioGenreStr;
-(NSString *)getloadingRadioLanguageStr;
-(NSString *)getloadingRadioContinentsStr;


//INSIDE
-(NSString *)getTermsAndConditionsStr;
-(NSString *)getSupportStr;
-(NSString *)getAllStr;
-(NSString *)getFreeStr;
-(NSString *)getTvShowsStr;
-(NSString *)getMoviesStr;
-(NSString *)getGenreStr;
-(NSString *)getViewAllStr;
-(NSString *)getAppManagerStr;
-(NSString *)getAppManagetTopTitleStr;
-(NSString *)getGamesNavTitleStr;
-(NSString *)getMoreNavTitleStr;


//NEW
-(NSString *)getAppManagerManualNotification;
-(void)setAppManagerManualNotification:(NSString *)valid;
-(void)removeAppManagerManualNotification;

//USER DEMO VIDEO DETAILS
-(void)setAppDemoVideoDetails:(NSMutableDictionary *)_dicInfo;
-(void)removeAppDemoVideoDetails;
-(NSMutableDictionary *)getAppDemoVideoDetails;
-(NSString *)getDemoVideoPlayed;

-(NSString*)checkFormattedPrice:(NSMutableArray*)formats stringToFind:(NSString*)stringToFind;
-(NSString *)stringTranslatingIntoSpanish:(NSString *)currentEnglishText;
-(NSString *)urlEncodedStringFromString:(NSString *)original;
-(NSString *)checkSubscriptionCode:(NSMutableArray*)subcriptionArray stringToFind:(NSString*)appSubcriptionCode;

-(id)getCleanData:(id)responseObject;
- (BOOL) isFileExists:(NSString *) filename;
-(id)retrieveContentsFromFile:(NSString *)filename dataType:(DataType)datatype;
void saveContentsToFile (id data, NSString* filename);
- (CGSize)getControlHeight:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth;


#pragma  mark Remove Cache from Local
-(void)removeFileFromLocalCache;

    

@end

extern AppCommon *sharedCommon;
extern void downloadImageFromUrl(NSString* urlString, UIImageView * imageview);
#define COMMON (sharedCommon? sharedCommon:[AppCommon common])

