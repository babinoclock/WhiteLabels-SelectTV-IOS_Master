//
//  AppConfig.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 28/01/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

//Common Files

//#import "BroadView-Header.h"
//#import "SidebarDemo-Header.h"
//#import "SidebarDemo-Prefix.pch"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <NewRelicAgent/NewRelic.h>


//#define SplashScreenImageName               @"SplashScreenImage"
//
//#define homeLogoImageName                   @"homeLogo"
//
//#define splashLogoImageName                 @"splash_logo"



#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]

#define SCREEN_WIDTH                   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                    [[UIScreen mainScreen] bounds].size.height
//#define  IS_IPAD_DEVICE (([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone)?NO:YES)

#define IS_IPHONE_DEVICE                (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?NO:YES)

#define IS_IPHONE4                      (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)

#define IS_IPHONE5                      (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IPHONE6                      (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IPHONE6_Plus                 (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

#define IS_IPAD                         (([[UIScreen mainScreen] bounds].size.height-768)?NO:YES)

// OS Versions
#define IS_GREATER_IOS7                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)

#define IS_GREATER_IOS8                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO)

#define IS_GREATER_IOS9                 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)?YES:NO)



//Default keys
#define IOS_OLDER_THAN_6                ([[[UIDevice currentDevice] systemVersion]  floatValue] < 6.0 )
#define IS_GREATER_THAN_OR_EQUAL_IOS7   (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)
#define IS_LESSER_THAN_OR_EQUAL_IOS7    (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?YES:NO)
#define IS_GREATER_THAN_OR_EQUAL_IOS8   (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)?YES:NO)
#define IS_LESS_THAN_IOS8               (([[[UIDevice currentDevice] systemVersion] floatValue] < 8)?YES:NO)


//APP HEADER FILES


#define GOOLGE_APIS_TRANSLATE_KEY           @"AIzaSyCOYvrqzWGA5U-T0Zn_Sj1rw0lMkwbVg8U"

//#define APP_TITLE                           @"Arvig"


//FONTS
#pragma mark Fonts

#define FontAwesome(_size)                  [UIFont fontWithName:@"fontawesome-webfont.ttf" size:_size]

#define Arial_Bold(FontSize)                [UIFont fontWithName:@"Arial-BoldMT" size:FontSize]

#define Arial(FontSize)                     [UIFont fontWithName:@"ArialMT" size:FontSize]

#define Montserrat_Bold(FontSize)           [UIFont fontWithName:@"Montserrat-Bold" size:FontSize]

#define Montserrat_Regular(FontSize)        [UIFont fontWithName:@"Montserrat-Regular" size:FontSize]

#define OpenSans_Regular(FontSize)          [UIFont fontWithName:@"OpenSans" size:FontSize]

#define OpenSans_Bold(FontSize)             [UIFont fontWithName:@"OpenSans-Bold" size:FontSize]

#define OpenSans_SemiBold(FontSize)         [UIFont fontWithName:@"OpenSans-Semibold" size:FontSize]


#define Roboto_Bold(FontSize)               [UIFont fontWithName:@"Roboto-Bold" size:FontSize]

#define Roboto_Light(FontSize)              [UIFont fontWithName:@"Roboto-Light" size:FontSize]

#define Roboto_Medium(FontSize)             [UIFont fontWithName:@"Roboto-Medium" size:FontSize]

#define Roboto_Regular(FontSize)            [UIFont fontWithName:@"Roboto-Regular" size:FontSize]

#define HelveticaNeue(FontSize)             [UIFont fontWithName:@"HelveticaNeue" size:FontSize]

//TITLE Font Size

#define TITLE_FONT_SIZE                      15

// COLOR
#define BORDER_BLUE             [UIColor colorWithRed:2.0f/255.0f green:147.0f/255.0f blue:255.0f/255.0f alpha:1];

#define FREE_GREEN             [UIColor colorWithRed:19.0f/255.0f green:127.0f/255.0f blue:23.0f/255.0f alpha:1];

#define SKY_BLUE            [UIColor colorWithRed:0.2f green:0.71f blue:0.9f alpha:1.0f];


#define GRAY_BG_COLOR            [UIColor colorWithRed:59.0f/255.0f green:60.0f/255.0f blue:64.0f/255.0f alpha:1.0f];

#define LIGHT_GRAY_BG_COLOR            [UIColor colorWithRed:139.0f/255.0f green:143.0f/255.0f blue:144.0f/255.0f alpha:1.0f];

#define LIGHT_GRAY_TOP_NAVIGATION_COLOR            [UIColor colorWithRed:44.0f/255.0f green:45.0f/255.0f blue:49.0f/255.0f alpha:1.0f];

//USER DEFAULTS

#define USERDETAILS                            @"UserDetails"

#define STARTSCREEN                            @"StartScreenDetails"

#define LOGINSCREEN                            @"LoginScreenDetails"

#define MOBILE_DASHBOARD                       @"MobileDashboard"

#define LOGGEDIN                               @"loggedIn"

#define USERACCESSTOKEN                        @"accessToken"

#define STARTPAGE                              @"startPage"

#define APPLIST                                @"AppListDetails"

#define FAVLIST                                @"FavListDetails"

#define USER_PROFILEDETAILS                    @"UserProfileDetails"

#define DEMO_VIDEO_PLAYED                      @"isDemoVideoPlayed"

//SAVE CONTENT FILE NAME

#define APP_MENU                                @"app.menu"

#define ALL_NETWORK_LIST                        @"networks.list"

#define KIDS_CATEGORIES                         @"kids.categories"

#define KIDS_SUB_CATEGORIES                     @"kids.subcategories_%d"

#define SUBSCRIPTIONS_CATEGORIES                @"subscriptions.categories"

#define SUBSCRIPTIONS_SUB_CATEGORIES            @"subscriptions.subcategories_%d"

#define CAROUSEL_HOME_PAGE                      @"carousel.getHomeScreen"

#define LIVE_CATEGORIES                         @"youlive.categories"

#define APP_CATEGORY                            @"selecttvbox.categories"//@"apps.categories"

#define SELECTTVBOX_SUBSCRIPTIONS               @"selecttvbox.subscriptions"

#define RADIO_GENRES                            @"radio.getGenres"

#define RADIO_LANGUAGES                         @"radio.getLanguages"

#define RADIO_CONTINENTS                        @"radio.getContinents"

#define YOULIVE_CHANNELS                        @"youlive.channels_%@"

#define YOULIVE_CHANNELS_SUB_CATEGORIES         @"latestnews.subcategories_%@"

#define USER_FAVOURITE_LIST                     @"favorites.userList%@"

#define CAROUSEL_WEB_ORIGINAL                   @"selecttvbox.getWebCarousels"

//NEW CHANGES
#define ON_DEMAND_TOP_MENU                      @"selecttvbox.ondemandLeftMenu"

#define GAMES_CAROUSEL                          @"games.carousels"

//NEW DEVICES & PAY_MODE

#define CURRENT_DEVICE_ID                       8

#define DEVICES                                 @"I"

#define PAY_MODE_ALL                            0

#define PAY_MODE_FREE                           1

#define PAY_MODE_PAID                           2

#define PPV_MOVIES_SLUG                         @"pay-per-view-movies"

#define PPV_SHOWS_SLUG                          @"pay-per-view-shows"

#define KIDS_SLUG                               @"kids"

#define WEB_ORIGINALS_SLUG                      @"tv-shows-web-originals"

//TRANSLATION

#define ENGLIST_TEXT                            @"englishTest"

#define SPANISH_TEXT                            @"spainshText"

#define HOME_TRANSLATED_WORDS                   @"homeTranslatedWords"

#define SIDE_MENU_TRANSLATED_WORDS              @"sideMenuTranslatedWords"

#define ONDEMAND_CAROUSEL_WORDS                 @"demandTranslatedCarouselWords123"

#define PAYPERVIEW_CAROUSEL_WORDS               @"payPayViewTranslatedCarouselWords1"

#define APP_MANAGER_TOP_MENU                    @"appManagerTopMenu"

#define ON_DEMAND_TOP_MENU_WORDS                @"onDemandTopMenuWords"

#define ON_TV_SHOWS_STATIC_WORDS                @"onTVMenuWords"

#define ON_MOVIES_STATIC_WORDS                  @"onMoviesMenuWords"

#define ON_PRIME_WEEKDAYS_STATIC_WORDS          @"onPrimeWeekDayMenuWords"

#define ON_PAY_PER_VIEW_STATIC_WORDS            @"onPayPerViewMenuWords"

#define ON_DEMAND_CATEGORY_WORDS                @"onDemandCategoryMenuWords"

#define ON_DEMAND_DECADE_WORDS                  @"onDemandDecadeMenuWords"

#define ON_DEMAND_RATING_WORDS                  @"onDemandRatingMenuWords"

#define COMMON_SPANISH_TV_GENRE_WORDS           @"commonTVGenreMenuWords"

#define COMMON_SPANISH_MOVIE_GENRE_WORDS        @"commonMovieGenreMenuWords"

#define ON_PAY_PER_VIEW_RATING_WORDS            @"payPerViewRatingMenuWords"

#define SEARCH_VIEW_WORDS                       @"searchViewMenuWords"

#define GAMES_TOP_MENU_WORDS                    @"gamesMenuWords"



//INTRODUCTION COMMON WORDS

#define LOADING                                 @"loading"
#define LOADING_APP_MENU                        @"loading application menu..."
#define LOADING_NETWORK_LIST                    @"loading networks list..."
#define LOADING_GAMES_CAROUSEL                  @"loading games carousel..."
#define LOADING_HOME                            @"loading home..."
#define LOADING_ON_DEMAND_LIST                  @"loading ondemand menu list..."
#define LOADING_APP_CATEGORY                    @"loading app category..."
#define LOADING_SUBCRIPTION_LIST                @"loading subscriptions list..."
#define LOADING_LIVE_CATEGORIES                 @"loading live categories..."
#define LOADING_RADIO_GENRES                    @"loading radio genres..."
#define LOADING_RADIO_LANGUAGES                 @"loading radio languages..."
#define LOADING_RADIO_CONTINENTS                @"loading radio continents..."


//SINGLE WORKS
#define TERMS_CONDITIONS                        @"terms&Conditions"
#define SUPPORT                                 @"support"
#define ALL                                     @"all"
#define FREE                                    @"free"
#define TV_SHOWS                                @"tvshows"
#define MOVIES                                  @"movies"
#define GENRE                                   @"genre"
#define VIEW_ALL                                @"viewAll"
#define APP_MANAGER                             @"appManager"
#define APP_MANAGER_TOP_TITLE                   @"appTopTitle"
#define GAMES_TITLE                             @"Games"
#define MORE_TITLE                              @"More"

//TRANSLATION KEY WORDS
#define API_URL_GET_LANGUAGES                   @"https://www.googleapis.com/language/translate/v2"
#define PARM_KEY_APIKEY                         @"key"
#define PARM_KEY_DETECTION_TEXT                 @"q"
#define PARM_KEY_SOURCE_LANGUAGE                @"source"
#define PARM_KEY_DESTINATION_LANGUAGE_TARGET    @"target"


//NEW CHANGE

#define APP_MANAGER_MANUAL_NOTIFICATION        @"APP_MANAGER_MANUAL_NOTIFICATION"

#define ENTER_FOREGROUND                       @"ENTER_FOREGROUND"


#endif /* AppConfig_h */
