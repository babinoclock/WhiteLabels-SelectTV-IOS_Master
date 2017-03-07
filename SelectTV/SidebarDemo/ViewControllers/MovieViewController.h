//
//  MapViewController.h
//  SidebarDemo
//
//  Created by Simon on 30/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "MenuView.h"
#import "AppConfig.h"
#import "YTPlayerView.h"
#import "HMSegmentedControl.h"
@interface MovieViewController : UIViewController <UIGridViewDelegate,YTPlayerViewDelegate>
{
    BOOL isOnTvShowClick;
    BOOL isOnNetworksClick;
    BOOL isOnGenreClick;
    BOOL isOnCategoryClick;
    BOOL isOnDecadeClick;
    
    BOOL isOnMoivesClick;
    BOOL isOnMoivesGenreClick;
    BOOL isOnMoivesRatingClick;
    
    
    BOOL isClickedTv;
    BOOL isClickedMovie;
    BOOL isClickedPrime;
    BOOL isClickedNetwork , isClickedNetworkBackOptions;
    BOOL isClickedNews;
    BOOL isClickedSports;
    BOOL isClickedWebOriginal;
    BOOL isClickedKids;
    BOOL isClickedCollectionSlider;
    BOOL isClickedSliderWatch;
    BOOL isClickedSliderViewAll;
    
    BOOL isNetworkViewAll;
    BOOL isNetworkViewAllSelection;
    
    BOOL isClickedTvShowGenre;
    BOOL isClickedTvShowCategory;
    BOOL isClickedTvShowDecade;
    BOOL isClickedTvShowNetwork;
    
    BOOL isClickedMoviesGenre;
    BOOL isClickedMoviesRating;
    
    
    BOOL isClickedPrimeLeftMenu;
    BOOL isClickedPrimeRightMenu;
    BOOL isPrimeCarouselImage;
    BOOL isWebOriginalImage;
    
    BOOL isThumbnailImage;
    BOOL isCarouselImage;
    BOOL isPosterImage;
    
    BOOL isSliderCarouselImageExists;
    
    
    BOOL isDownloadAppViewHidden;
    //UIView *downloadView;
    IBOutlet UIView *downloadView;
    
    HMSegmentedControl  *appHeaderScrollView;
    UILabel *appHeaderLabel;
    
    UIView *installTitleView;
    UILabel *installedLabel;
    UILabel *notIntalledLabel;
    UIButton *doLaterButton;
    UISwitch *installSwitch;
    NSMutableArray *appTitleArray;
    NSMutableArray *appInstalledArray;
    NSInteger indexPathValue;
    NSMutableArray *appTitleFullArray;
    NSMutableArray *installedArray;
    NSMutableArray *notInstalledArray;
    BOOL isInstalledClicked;
    BOOL isMovieListData;
    BOOL isSeasonArray;
    NSString *genreName;
    NSString *currentScrollTitle;
    
    
    //EXTRA ADDED
    
    NSString *primeWeekStr;
    NSString *primeNetworkStr;
    NSMutableArray * titleArray;
    NSMutableArray * topTitleArray;
    NSMutableArray * topTitleCarouselArray;
    NSMutableArray * onDemandTvShowsCategory;
    NSMutableArray * onDemandTvShowsDecades;
    NSMutableArray * onDemandMoviesRating;
    //WEB ORIGINAL
    UITableView *carouselTableView;
    NSMutableArray* webCarouselArray;
    NSMutableArray* webCarouselNameArray;
    NSMutableArray* webCarouselTitleArray;
    
    UIView *onDemandPlayerView;
    
    NSString *kidsType;
    //NEW
    UILabel *allLabel,*freeLabel;
    
    UISwitch *freeSwitch;
    
    //new change
    UIView *iPhoneView;
    
    BOOL isVideoClosed;
    BOOL isiPhoneViewPage;
    
    
    //new change
    UIView *subScriptionView;
    UICollectionView *_collectionView;
    NSMutableArray *loginSubscriptionArray;
    NSMutableArray *currentSubscriptionArray;
    NSMutableArray *currentSubscriptionCodeArray;
    NSMutableArray *currentCableArray;
    BOOL isSelectedItem;
    
    UIView * collectionHeader;
    UIView * collectionFooter;
    
    
    NSArray *appStaticArray;

    
}


@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *playerBgView;
@property (strong, nonatomic) IBOutlet UIButton *playerViewContinueBtn;

@property(retain,nonatomic) NSMutableArray* dropDownTvShowArray;
@property(retain,nonatomic) NSMutableArray* dropDownTvNetworkArray;
@property(retain,nonatomic) NSMutableArray* dropDownNSArray;
@property(retain,nonatomic) NSMutableArray* dropDownTvShowStaticArray;
@property(retain,nonatomic) NSMutableArray* dropDownMoviesStaticArray;
@property(retain,nonatomic) NSMutableArray* primeWeekDayArray;
@property(retain,nonatomic) NSMutableArray* primeRightViewAllArray;
@property(retain,nonatomic) NSMutableArray* sportsDataArray;

@property(retain,nonatomic) NSString* tvShowStr;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
@property (assign, nonatomic) BOOL  isPayPerView;
@property (assign, nonatomic) BOOL  isNetworksView;

@property (assign, nonatomic) BOOL  isLoadIcon;

@property (assign, nonatomic) BOOL  isAppManagerMenu;

@property(retain,nonatomic) NSString* isPayPerViewStr;



@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *tvShowLabel;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property(retain,nonatomic) NSString* headerLabelStr;

@property (strong, nonatomic) IBOutlet UILabel *tvListLabel;
@property (strong, nonatomic) IBOutlet UILabel *tvNetworkListLabel;
@property (strong, nonatomic) IBOutlet UIView *tvMovieView;
@property (strong, nonatomic) IBOutlet UIButton *tvButton;

@property (strong, nonatomic) IBOutlet UIButton *movieButton;
//NEW
@property (strong, nonatomic) IBOutlet UILabel *allFreeListLabel;
@property (strong, nonatomic) IBOutlet UIView *allFreeView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *movieActivityIndicator;

- (void)updateData:(int)nChannelID status:(int)nStatus;
- (void)updateShowData:(int)nChannelID;
- (void)updateNetworkData:(NSMutableArray*) networks;

- (void)updateNetworkDetailData:(int)nNetworkID;


-(void)loadSliderCarouselScreen;

@property (strong, nonatomic) IBOutlet UIButton *mainLeftBarButton;
@property(strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UICollectionView *appDownloadCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *appDownloadTableView;
@property (strong, nonatomic) IBOutlet UIButton *okDoneBtn;

@property (strong, nonatomic) HMSegmentedControl *headerScroll;
-(IBAction) searchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *onDemandSliderView;
@property (strong, nonatomic) IBOutlet UITableView *onDemandSliderTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *onDemandSliderScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *innerSliderScroll;
@property (strong, nonatomic) IBOutlet UIImageView *scrollImageView;
@property (strong, nonatomic) IBOutlet UIPageControl *imagePagecontrol;

@end
