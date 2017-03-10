                                      //
//  AppCommon.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 28/01/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "AppCommon.h"
#import "AppConfig.h"
#import <sys/xattr.h>


@implementation AppCommon

AppCommon *sharedCommon = nil;

+ (AppCommon *)common {
    
    if (!sharedCommon) {
        
        sharedCommon = [[self alloc] init];
    }
    return sharedCommon;
}

- (id)init {
    
    return self;
}

#pragma mark - loadProgressHUD
-(void)loadProgressHud{
    progressHUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:progressHUD];
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    progressHUD.userInteractionEnabled = YES;
    progressHUD.dimBackground = YES;
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
    }
    else{
        progressHUD.labelText = NSLocalizedString(@"Please Wait...", @"Please Wait...");
   
    }
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.delegate = self;
    [progressHUD show:YES];
}
-(void) removeProgressHud{
     [progressHUD hide:YES afterDelay:0.1];
}
#pragma mark User Interaction Loading :
- (void)addLoadingIcon:(UIViewController *)controller
{
    progressHUD = [[MBProgressHUD alloc] init];
    progressHUD = [[MBProgressHUD alloc] initWithView:controller.view];
    progressHUD.userInteractionEnabled=YES;
    [controller.view addSubview:progressHUD];
    [progressHUD show:YES];
}
-(void)removeLoadingIcon
{
    [progressHUD hide:YES];
    [progressHUD removeFromSuperview];
}


-(void)LoadIcon:(UIView *)view
{
    [self removeLoading];
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width-37)/2, (view.frame.size.height-37)/2, 67,67)];
    [loadingView.layer setCornerRadius:5.0];
    [loadingView setBackgroundColor:[UIColor blackColor]];
    
    [loadingView.layer setMasksToBounds:YES];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView setFrame:CGRectMake(1, 1, 67, 67)];
    [activityView setHidesWhenStopped:YES];
    [activityView startAnimating];
    [loadingView addSubview:activityView];
    [view addSubview:loadingView];
}

-(void)removeLoading{
    [loadingView removeFromSuperview];
}


-(UIView*)setBackGroundColor:(UIView*)view{
    
    view.backgroundColor = GRAY_BG_COLOR;
    
    return view;
    
}

- (UIColor *)Common_Gray_BG_Color
{
    return [UIColor colorWithRed:59.0f/255.0f green:60.0f/255.0f blue:64.0f/255.0f alpha:1.0f];
}

- (UIColor *)Common_Light_BG_Color
{
    return [UIColor colorWithRed:139.0f/255.0f green:143.0f/255.0f blue:144.0f/255.0f alpha:1.0f];
}

- (UIColor *)Common_Top_Navigation_Color
{
    return [UIColor colorWithRed:44.0f/255.0f green:45.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
}

- (UIColor *)Common_Screen_BG_Color
{
    return [UIColor colorWithRed:44.0f/255.0f green:45.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
}


+(void)showSimpleAlertWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: APP_TITLE
                                                   message: message
                                                  delegate: nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
}


#pragma mark - Get Current Device Info

- (currentDevice)getCurrentDevice
{
    if (([[UIScreen mainScreen] bounds].size.height == 480 && [[UIScreen mainScreen] bounds].size.width == 320) || ([[UIScreen mainScreen] bounds].size.width == 480 && [[UIScreen mainScreen] bounds].size.height == 320)) {
        return iPhone4;
    }
    else if (([[UIScreen mainScreen] bounds].size.height == 568 && [[UIScreen mainScreen] bounds].size.width == 320) || ([[UIScreen mainScreen] bounds].size.width == 568 && [[UIScreen mainScreen] bounds].size.height == 320))
        return iPhone5;
    else if (([[UIScreen mainScreen] bounds].size.height == 667 && [[UIScreen mainScreen] bounds].size.width == 375) || ([[UIScreen mainScreen] bounds].size.width == 667 && [[UIScreen mainScreen] bounds].size.height == 375))
        return iPhone6;
    else if (([[UIScreen mainScreen] bounds].size.height == 736 && [[UIScreen mainScreen] bounds].size.width == 414) || ([[UIScreen mainScreen] bounds].size.width == 736 && [[UIScreen mainScreen] bounds].size.height == 414))
        return iPhone6Plus;
    else if (([[UIScreen mainScreen] bounds].size.height == 768 && [[UIScreen mainScreen] bounds].size.width == 1024) || ([[UIScreen mainScreen] bounds].size.width == 1024 && [[UIScreen mainScreen] bounds].size.height == 768))
        return iPad;
    
    return 0;
}


#pragma mark - Resizeable Font

- (UIFont *)getResizeableFont:(UIFont *)currentFont {
    
    CGFloat sizeScale = 1;
    
    if (IS_IPHONE_DEVICE)
    {
        
        if ([COMMON getCurrentDevice]==iPhone6Plus )
        {
            sizeScale = 1.3;
        }
        else if ([COMMON getCurrentDevice]== iPhone6)
        {
            sizeScale = 1.2;
        }
    }
    else
    {
        sizeScale = 1.4;
    }
    return [currentFont fontWithSize:(currentFont.pointSize * sizeScale)];
}

#pragma mark - Get Height of Control

- (CGSize)getControlHeight:(NSString *)string withFontName:(NSString *)fontName ofSize:(NSInteger)size withSize:(CGSize)LabelWidth {
    CGSize maxSize = LabelWidth;
    CGSize dataHeight;
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.paragraphSpacing = 50 * font.lineHeight;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if ([version floatValue]>=7.0) {
        CGRect textRect = [string boundingRectWithSize:maxSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
        
        
        dataHeight = CGSizeMake(textRect.size.width , textRect.size.height);
        
    }
    
    return CGSizeMake(dataHeight.width, dataHeight.height+10);
}



#pragma mark - Userdetails
-(void)setDetails:(NSMutableDictionary *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableDictionary class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:STARTSCREEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:STARTSCREEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary *)getDetails
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:STARTSCREEN];
    
    return dic;
    
}
#pragma mark - LoginDetails
-(void)setLoginDetails:(NSMutableDictionary *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableDictionary class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:LOGINSCREEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeLoginDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINSCREEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary *)getLoginDetails
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:LOGINSCREEN];
    
    return dic;
    
}
//TRANSLATED WORDS

-(void)setHomeStaticArrayList:(NSMutableArray *)_arrayInfo
{    NSLog(@"setHomeStaticDetails = %@",_arrayInfo);
    
    if([_arrayInfo isKindOfClass:[NSMutableArray class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_arrayInfo forKey:HOME_TRANSLATED_WORDS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeHomeStaticArrayList
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HOME_TRANSLATED_WORDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getHomeStaticArrayList
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    array =[[NSUserDefaults standardUserDefaults] valueForKey:HOME_TRANSLATED_WORDS];
    return array;
}

#pragma mark - setSideBarStaticArrayList

-(void)setSideBarStaticArrayList:(NSMutableArray *)_arrayInfo
{    NSLog(@"setHomeStaticDetails = %@",_arrayInfo);
    
    if([_arrayInfo isKindOfClass:[NSMutableArray class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_arrayInfo forKey:SIDE_MENU_TRANSLATED_WORDS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeSideBarStaticArrayList
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SIDE_MENU_TRANSLATED_WORDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getSideBarStaticArrayList
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    array =[[NSUserDefaults standardUserDefaults] valueForKey:SIDE_MENU_TRANSLATED_WORDS];
    return array;
}


//APP LIST DETAILS
-(void)setAppListDetails:(NSMutableArray *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableArray class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:APPLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeAppListDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APPLIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)getAppListDetails
{
    NSMutableArray *dic=[[NSMutableArray alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:APPLIST];
    
    return dic;
    
}
//FAV LIST DETAILS
-(void)setFavListDetails:(NSMutableDictionary *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableDictionary class]]){
        
        _dicInfo = [self getCleanDictData:_dicInfo];
        
        NSLog(@"setUserDetails = %@",_dicInfo);
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:FAVLIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(id) getCleanDictData:(id)_dicInfo {
    id currentDictionary;
    
    for (NSString *keyValue in [_dicInfo allKeys]) {
        NSLog(@"_dicInfo%@",[_dicInfo objectForKey:keyValue]);
        currentDictionary = [[_dicInfo objectForKey:keyValue] mutableCopy];
        for (NSString *key in [currentDictionary allKeys]) {
            NSLog(@"key%@",key);
             NSLog(@"_dicInfo%@",[currentDictionary valueForKey:key]);
            if ([[currentDictionary valueForKey:key] isEqual:[NSNull null]] ||
                [[currentDictionary valueForKey:key] isKindOfClass:[NSNull class]] ||
                [currentDictionary valueForKey:key] == nil) {
                [currentDictionary setValue:@"" forKey:key];
            }
        }
        [_dicInfo setObject:[currentDictionary copy] forKey:keyValue];
    }
    return _dicInfo;
}

-(void)removeFavListDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FAVLIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary *)getFavListDetails
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:FAVLIST];
    
    return dic;
    
}


- (BOOL) isUserFirstTimeLoggedIn {
    NSDictionary *userDetails = [self getDetails];
    if (userDetails != NULL) {
        return YES;
    }
    return NO;
}

- (BOOL) isUserLoggedIn {
    NSDictionary *userDetails = [self getLoginDetails];
    if (userDetails != NULL) {
        return YES;
    }
    return NO;
}
//APP DEMO VIDEO
#pragma mark - Userdetails
-(void)setAppDemoVideoDetails:(NSMutableDictionary *)_dicInfo
{    NSLog(@"setUserDetails = %@",_dicInfo);
    
    if([_dicInfo isKindOfClass:[NSMutableDictionary class]]){
        [[NSUserDefaults standardUserDefaults] setObject:_dicInfo forKey:DEMO_VIDEO_PLAYED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(void)removeAppDemoVideoDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableDictionary *)getAppDemoVideoDetails
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic =[[NSUserDefaults standardUserDefaults] valueForKey:DEMO_VIDEO_PLAYED];
    
    return dic;
    
}

#pragma mark - Remove Nulls

- (NSMutableDictionary *) removeNullValuesFromDictionary:(NSMutableDictionary *) currentDictionary {
    for (NSString * key in [currentDictionary allKeys])
    {
        if ([[currentDictionary objectForKey:key] isKindOfClass:[NSNull class]])
            [currentDictionary setObject:@"" forKey:key];
    }
    return currentDictionary;
}
#pragma mark - USER_PROFILEDETAILS

- (void) storeUserProfileDetails:(NSMutableDictionary *) userDetails {
   userDetails = [self removeNullValuesFromDictionary:[userDetails mutableCopy]];
    [[NSUserDefaults standardUserDefaults] setObject:userDetails forKey:USER_PROFILEDETAILS];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *) getUserProfileDetails{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILEDETAILS];
}

-(void)removeUserProfileDetails
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_PROFILEDETAILS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - getUserAccessToken
-(NSString *)getUserAccessToken
{
    NSString *getUserAccessToken =[[NSUserDefaults standardUserDefaults]valueForKey:USERACCESSTOKEN];
    return getUserAccessToken;
}



#pragma mark - getDemoVideoPlayed
-(NSString *)getDemoVideoPlayed
{
    NSString *getDemoVideoPlayed =[[NSUserDefaults standardUserDefaults]valueForKey:DEMO_VIDEO_PLAYED];
    return getDemoVideoPlayed;
   
}
-(void)isSideBarAppManager:(NSString *)valid {
    [[NSUserDefaults standardUserDefaults] setObject:valid forKey:@"APPMANAGER"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)isAppManager:(NSString *)valid {
    
    [[NSUserDefaults standardUserDefaults] setObject:valid forKey:@"NEWAPPMANAGER"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *) getAppManagerDetail{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWAPPMANAGER"];
}
#pragma mark - checkFormattedPrice
-(NSString*)checkFormattedPrice:(NSMutableArray*)formats stringToFind:(NSString*)stringToFind{
    NSString *strRate;  NSString *strType;
    for(NSDictionary * anEntry in formats)
    {
        NSString * url = [anEntry objectForKey:@"format"];
        if([url containsString: stringToFind]){
            strRate = [NSString stringWithFormat:@"$%@",[anEntry objectForKey:@"price"]];
            strType = [NSString stringWithFormat:@"%@",[anEntry objectForKey:@"type"]];
            if(strType==nil){
                strType = @"FREE";
            }
            
            else{
                if([strType isEqualToString:@"purchase"]){
                    strType = @"BUY";
                }
                
                else{
                    strType = @"RENT";

                }
                
            }
            strType = [NSString stringWithFormat:@"%@ %@",strType,strRate];
            break;
        }
        else{
            strType = @"FREE";
        }
        
    }
    return strType;
}
#pragma mark - checkSubscriptionCode
-(NSString *)checkSubscriptionCode:(NSMutableArray*)subcriptionArray stringToFind:(NSString*)appSubcriptionCode{
    NSString *strRate;
    for(NSDictionary *tempDict in subcriptionArray){
        NSString *subCode = [tempDict valueForKey:@"code"];
        if([subCode isEqualToString:appSubcriptionCode]){
            strRate=@"Subscribed";
            break;
        }
        else{
            strRate=@"Free Trial";
        }
    }
     return strRate;
}

#pragma mark - SPANISH WORDS

-(NSString *)getloadingStr
{
    NSString *getloadingStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING];
    return getloadingStr;
}
-(NSString *)getloadingAppMenuStr
{
    NSString *getloadingAppMenuStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_APP_MENU];
    return getloadingAppMenuStr;
}
-(NSString *)getloadingNetworkListStr
{
    NSString *getloadingNetworkListStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_NETWORK_LIST];
    return getloadingNetworkListStr;
}
-(NSString *)getloadingGamesCarouselStr
{
    NSString *getloadingGamesCarouselStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_GAMES_CAROUSEL];
    return getloadingGamesCarouselStr;
}
-(NSString *)getloadingHomeStr
{
    NSString *getloadingHomeStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_HOME];
    return getloadingHomeStr;
}
-(NSString *)getloadingOnDemandStr
{
    NSString *getloadingOnDemandStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_ON_DEMAND_LIST];
    return getloadingOnDemandStr;
}
-(NSString *)getloadingAppCategoryStr
{
    NSString *getloadingAppCategoryStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_APP_CATEGORY];
    return getloadingAppCategoryStr;
}
-(NSString *)getloadingSubscriptionListStr
{
    NSString *getloadingSubscriptionListStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_SUBCRIPTION_LIST];
    return getloadingSubscriptionListStr;
}
-(NSString *)getloadingLiveCategoriesStr
{
    NSString *getloadingLiveCategoriesStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_LIVE_CATEGORIES];
    return getloadingLiveCategoriesStr;
}
-(NSString *)getloadingRadioGenreStr
{
    NSString *getloadingRadioGenreStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_RADIO_GENRES];
    return getloadingRadioGenreStr;
}
-(NSString *)getloadingRadioLanguageStr
{
    NSString *getloadingRadioLanguageStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_RADIO_LANGUAGES];
    return getloadingRadioLanguageStr;
}
-(NSString *)getloadingRadioContinentsStr
{
    NSString *getloadingRadioContinentsStr =[[NSUserDefaults standardUserDefaults]valueForKey:LOADING_RADIO_CONTINENTS];
    return getloadingRadioContinentsStr;
}

-(NSString *)getTermsAndConditionsStr
{
    NSString *getTermsAndConditionsStr =[[NSUserDefaults standardUserDefaults]valueForKey:TERMS_CONDITIONS];
    return getTermsAndConditionsStr;
}
-(NSString *)getSupportStr
{
    NSString *getSupportStr =[[NSUserDefaults standardUserDefaults]valueForKey:SUPPORT];
    return getSupportStr;
}

-(NSString *)getAllStr
{
    NSString *getAllStr =[[NSUserDefaults standardUserDefaults]valueForKey:ALL];
    return getAllStr;
}

-(NSString *)getFreeStr
{
    NSString *getFreeStr =[[NSUserDefaults standardUserDefaults]valueForKey:FREE];
    return getFreeStr;
}

-(NSString *)getTvShowsStr
{
    NSString *getTvShowsStr =[[NSUserDefaults standardUserDefaults]valueForKey:TV_SHOWS];
    return getTvShowsStr;
}
-(NSString *)getMoviesStr
{
    NSString *getMoviesStr =[[NSUserDefaults standardUserDefaults]valueForKey:MOVIES];
    return getMoviesStr;
}

-(NSString *)getGenreStr
{
    NSString *getGenreStr =[[NSUserDefaults standardUserDefaults]valueForKey:GENRE];
    return getGenreStr;
}
-(NSString *)getViewAllStr
{
    NSString *getViewAllStr =[[NSUserDefaults standardUserDefaults]valueForKey:VIEW_ALL];
    return getViewAllStr;
}


-(NSString *)getAppManagerStr
{
    NSString *getAppManagerStr =[[NSUserDefaults standardUserDefaults]valueForKey:APP_MANAGER];
    return getAppManagerStr;
}
-(NSString *)getAppManagetTopTitleStr
{
    NSString *getAppManagetTopTitleStr =[[NSUserDefaults standardUserDefaults]valueForKey:APP_MANAGER_TOP_TITLE];
    return getAppManagetTopTitleStr;
}
-(NSString *)getGamesNavTitleStr
{
    NSString *getGamesNavTitleStr =[[NSUserDefaults standardUserDefaults]valueForKey:GAMES_TITLE];
    return getGamesNavTitleStr;
}

-(NSString *)getMoreNavTitleStr
{
    NSString *getMoreNavTitleStr =[[NSUserDefaults standardUserDefaults]valueForKey:MORE_TITLE];
    return getMoreNavTitleStr;
}

-(NSString *)getAppManagerManualNotification
{
    NSString *getAppManagerManualNotification =[[NSUserDefaults standardUserDefaults]valueForKey:APP_MANAGER_MANUAL_NOTIFICATION];
    return getAppManagerManualNotification;
}


-(void)setAppManagerManualNotification:(NSString *)valid{
    
    [[NSUserDefaults standardUserDefaults] setObject:valid forKey:APP_MANAGER_MANUAL_NOTIFICATION];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeAppManagerManualNotification {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APP_MANAGER_MANUAL_NOTIFICATION];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - isSpanishLanguage
-(BOOL)isSpanishLanguage
{
    NSString *currentAppLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([currentAppLanguage containsString:@"es"]||[currentAppLanguage isEqualToString:@"es"]||[currentAppLanguage isEqualToString:@"es-US"]){
        return YES;
    }
    else{
        return NO;
    }
}

#pragma  mark - stringTranslatingIntoSpanish
-(NSString *)stringTranslatingIntoSpanish:(NSString *)currentEnglishText{
    
    __block NSString *translatedText= @"";
    
    if ((NSString *)[NSNull null] == currentEnglishText||currentEnglishText == nil) {
        currentEnglishText=@"";
    }
    NSString * googleTranslatedText = [COMMON urlEncodedStringFromString:currentEnglishText];
    NSString * urlString=@"";
    urlString = [NSString stringWithFormat:@"%@?key=%@&source=%@&target=%@&q=%@",API_URL_GET_LANGUAGES,GOOLGE_APIS_TRANSLATE_KEY,@"en",@"es",googleTranslatedText];
    
    //NSLog(@"urlString = %@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    //NSLog(@"jsonObject is %@",jsonObject);
    
    NSDictionary *translation = [[[jsonObject objectForKey:@"data"] objectForKey:@"translations"] objectAtIndex:0];
    translatedText = [translation objectForKey:@"translatedText"];
    
    if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
        translatedText=@"";
    }
    return translatedText;
}

-(BOOL)checkInstalledApplicationInApp:(NSString*)urlStr{
    
    NSURL* linkUrl = [NSURL URLWithString:urlStr];
    
    if([[UIApplication sharedApplication] canOpenURL:linkUrl] ){
        return YES;
    }
    
    else{
        return NO;
    }
    
}



#pragma mark -  urlEncodedStringFromString

- (NSString *)urlEncodedStringFromString:(NSString *)original
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



-(id) getCleanData:(id)responseObject {
    NSMutableDictionary *currentDictionary;
    for (int i=0; i<[responseObject count]; i++) {
        currentDictionary = [[responseObject objectAtIndex:i] mutableCopy];
        for (NSString *key in [currentDictionary allKeys]) {
            if ([[currentDictionary valueForKey:key] isEqual:[NSNull null]] ||
                [[currentDictionary valueForKey:key] isKindOfClass:[NSNull class]] ||
                [currentDictionary valueForKey:key] == nil) {
                [currentDictionary setValue:@"" forKey:key];
            }
        }
        [responseObject setObject:[currentDictionary copy] atIndex:i];
    }
    return responseObject;
}

- (BOOL) isFileExists:(NSString *) filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileNameToSave = [documentsDirectory stringByAppendingPathComponent:filename];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileNameToSave];
    
    return fileExists;
    
}
#pragma mark - Save Content
void saveContentsToFile (id data, NSString* filename) {
    
    NSArray *namesArray = [filename componentsSeparatedByString:@"/"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileNameToSave;
    
    if ([namesArray count]>1) {
        NSString *dirNameToSave=[documentsDirectory stringByAppendingPathComponent:[namesArray objectAtIndex:0]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirNameToSave])
            [[NSFileManager defaultManager] createDirectoryAtPath:dirNameToSave withIntermediateDirectories:YES attributes:nil error:nil];
        for (int i=1; i<[namesArray count]-1; i++) {
            dirNameToSave = [dirNameToSave stringByAppendingPathComponent:[namesArray objectAtIndex:i]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:dirNameToSave])
                [[NSFileManager defaultManager] createDirectoryAtPath:dirNameToSave withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    fileNameToSave = [documentsDirectory stringByAppendingPathComponent:filename];
    
    NSLog(@"fileNameToSave = %@",fileNameToSave);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileNameToSave])
        [[NSFileManager defaultManager] createFileAtPath:fileNameToSave contents:nil attributes:nil];
    
    //[data writeToFile:fileNameToSave atomically:YES];
    
    NSData *convetedData = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    [convetedData writeToFile:fileNameToSave atomically:NO];
    
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:fileNameToSave]);
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    // iOS >= 5.1
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                    
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

-(id)retrieveContentsFromFile:(NSString *)filename dataType:(DataType)datatype {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileNameToSave = [documentsDirectory stringByAppendingPathComponent:filename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileNameToSave])
        return NULL;
    
    id object=nil;
    
    if (datatype==DataTypeDic){
        //object = [[NSDictionary alloc] initWithContentsOfFile:fileNameToSave];
        
        NSData *convertedDATA = [NSData dataWithContentsOfFile:fileNameToSave];
        object = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:convertedDATA];
        
    }
    else if (datatype==DataTypeArray) {
        //object = [[NSArray alloc] initWithContentsOfFile:fileNameToSave];
        
        NSData *convertedDATA = [NSData dataWithContentsOfFile:fileNameToSave];
        object = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:convertedDATA];
        
    }
    else {
        NSData *data = [NSData dataWithContentsOfFile:fileNameToSave];
        object = [UIImage imageWithData:data];
    }
    
    return object;
}

bool addSkipBackupAttributeToItemAtURL (NSURL* URL)
{
    if (& NSURLIsExcludedFromBackupKey == nil)
    {
        // iOS <= 5.0.1
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else
    {
        // iOS >= 5.1
        NSError *error = nil;
        
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                        
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
}


void downloadImageFromUrl(NSString* urlString, UIImageView * imageview)
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake((imageview.frame.size.width-47)/2, (imageview.frame.size.height-47)/2, 37, 37)];
    [loadingView.layer setCornerRadius:5.0];
    
    [loadingView setBackgroundColor:[UIColor clearColor]];//colorWithRed:41.0/255.0f green:41.0/255.0f blue:41.0/255.0f alpha:1]];
    //Enable maskstobound so that corner radius would work.
    [loadingView.layer setMasksToBounds:YES];
    //Set the corner radius
    
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView setFrame:CGRectMake(0, 3, 40, 40)];
    [activityView setBackgroundColor:[UIColor clearColor]];
    [activityView setHidesWhenStopped:YES];
    [activityView startAnimating];
    [loadingView addSubview:activityView];
    [imageview addSubview:loadingView];
    
    
    NSString *imageFile = [[[NSString stringWithFormat:@"%@",urlString] componentsSeparatedByString:@"/"] lastObject];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileNameToSave = [documentsDirectory stringByAppendingPathComponent:imageFile];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileNameToSave]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfFile:fileNameToSave];
            UIImage *img = [UIImage imageWithData:data];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if(img) {
                    imageview.image=img;
                    //imageview.contentMode = UIViewContentModeScaleAspectFit;
                    imageview.contentMode = UIViewContentModeScaleToFill;
                    
                    [activityView stopAnimating];
                }
            });
            
            
        });
        
    }
    else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            UIImage *img = [UIImage imageWithData:data];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(img) {
                    imageview.image=img;
                    imageview.contentMode = UIViewContentModeScaleToFill;
                    saveContentsToFile(data,imageFile);
                }
                [activityView stopAnimating];
            });
            
        });
    }
}

#pragma  mark Remove Cache from Local
-(void)removeFileFromLocalCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    
    NSString *filename;
    
    while ((filename = [e nextObject])) {
        
        if ([filename containsString:@"youlive.channels"]||[filename containsString:@"latestnews.subcategories"]){
           [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
        
    }
}



@end
