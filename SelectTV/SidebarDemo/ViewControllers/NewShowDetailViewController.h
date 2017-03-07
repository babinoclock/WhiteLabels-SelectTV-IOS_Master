//
//  NewShowDetailViewController.h
//  SidebarDemo
//
//  Created by Panda on 7/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailerMovieView.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "CustomIOS7AlertView.h"
#import "TTTAttributedLabel.h"
#import "UIImage+WebP.h"

@interface NewShowDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray  * watchTrailerArray;
    NSMutableArray  * arrayCast;
    NSMutableArray  * EpisodeArray;
    NSDictionary    * showLinkDictionary;
    NSDictionary    * showDetailDictionary,*movieDetailDictionary;
    NSDictionary    * episodeDetailDictionary;
    NSMutableArray  * showFullFreeArray;
    NSMutableArray  * showFirstFullFreeArray;
    //NSMutableArray  * showFullSeasonsArray;
    NSMutableArray  * showFullEpisodesArray;
    NSMutableArray * seasonParticularEpisodesArray;
    BOOL isFreeClicked;
    BOOL isAllEpisodesClicked;
    bool isAllSeasonsClicked;
    BOOL isOverViewClicked;
    BOOL isCastClicked;
    bool isGenreClicked;
    //HiddenBorderBool
    BOOL isHiddenBorder;
    
    //UIVIEW BOTTOMBORDER
    UIView *leftBorder;
    UIView *rightBorder;
    UIView *topBorder;
    UIView *bottomBorder1;
    UIView *bottomBorder2;
    //UIVIEW LEFTBORDER
    UIView *upperLeftBorder;
    UIView *upperRightBorder;
    UIView *upperTopBorder;
    UIView *upperBottomBorder1;
    UIView *upperBottomBorder2;
    NSString *didSelectSeasonId;
    NSString *currentSelectedEpisodeId;
    NSString *currentSelectedSeasonId;
    NSString *didSelectName;
    NSString *didPosterStr;
    
}
@property(retain,nonatomic) NSMutableArray* showFullSeasonsArray;
@property(retain,nonatomic) NSMutableArray* linksTrailer;
@property(retain,nonatomic) NSMutableArray* linksWatchVideo;
@property(retain,nonatomic) NSMutableArray* currentShowGridArray;
@property(retain,nonatomic) NSMutableArray* showDetailArray;
@property(retain,nonatomic) NSMutableArray* showEpisodeArray;
@property(retain,nonatomic) NSMutableArray* youTubeArray;
@property(retain,nonatomic) NSString* posterUrlStr;
@property(retain,nonatomic) NSMutableArray* showNameArray;
@property(retain,nonatomic) NSString *headerLabelStr;
@property(retain,nonatomic) NSString *episodeTitle;
@property (assign, nonatomic) BOOL  isEpisode;
@property(retain,nonatomic)   TrailerMovieView *mainView;
@property (strong, nonatomic) NSString* nID;
@property (strong, nonatomic) NSString* episodeId;
@property (strong, nonatomic) NSString *genreName;

//
//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *newShowDetailActivityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *showTitle;
@property (strong, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *runtimeDataLabel;
@property (strong, nonatomic) IBOutlet UILabel *networkLabel;
@property (strong, nonatomic) IBOutlet UIImageView *showImageView;
@property (strong, nonatomic) IBOutlet UIImageView *portraitMovieImageView;
@property (strong, nonatomic) IBOutlet UILabel *watchLatestLabel;
@property (strong, nonatomic) IBOutlet UIButton *overViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *castBtn;
@property (strong, nonatomic) IBOutlet UIButton *genreBtn;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *watchNowBtn;
@property (strong, nonatomic) IBOutlet UIButton *freeBtn;
@property (strong, nonatomic) IBOutlet UIButton *allEpisodesBtn;
@property (strong, nonatomic) IBOutlet UIButton *AllSeasonBtn;
@property (strong, nonatomic) IBOutlet UIButton *watchTrailerBtn;
@property (strong, nonatomic) IBOutlet UIButton *addToFavBtn;
@property (strong, nonatomic) IBOutlet UIGridView *showDetailGridView;
@property (strong, nonatomic) IBOutlet UIView *bottomBtnsView;
@property (strong, nonatomic) IBOutlet UIView *leftBtnsView;
@property (strong, nonatomic) IBOutlet UIView *addedExtraView;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;

- (IBAction) goBack:(id)sender;
- (void) setIfMovies:(BOOL)bMovies;
@property (strong, nonatomic) IBOutlet UIView *TopFullView;
@property (strong, nonatomic) IBOutlet UIView *BottomFullView;

@property (strong, nonatomic) IBOutlet UICollectionView *castCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCast;
//- (void)getEpisodeData:(int)nShowID seasonId:(int)nSeasonId episodeId:(int)nEpisodeId;
@property (strong, nonatomic) IBOutlet UIScrollView *iPhoneScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *showDetailHeightConstraint;
//ADDED MIDDLE VIEW

@property (strong, nonatomic) IBOutlet UIView *MiddleView;
@property (strong, nonatomic) IBOutlet UIGridView *showLatestGridView;
@property (strong, nonatomic) IBOutlet UIScrollView *middleScrollView;
@property (strong, nonatomic) IBOutlet UILabel *LatestEpisodesLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *middleViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomFullViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topFullViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *castTableHeight;

//IPAD
@property (strong, nonatomic) IBOutlet UIView *TopFullLeftView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *despLabelHeight;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *despLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TopFullLeftViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *ipadSubView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ipadSubViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *showDetailAddFavBtn;

//PAID
@property (assign, nonatomic) BOOL  isPushedFromPayPerView;

//Free and All Toggle
@property (assign, nonatomic) BOOL  isToggledFree;
@property (assign, nonatomic) BOOL  isToggledAll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gridHeight;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ratingLabelWidthConstraint;


@end
