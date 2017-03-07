//
//  NewMovieDetailViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 30/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailerMovieView.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "TTTAttributedLabel.h"

@interface NewMovieDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGridViewDelegate>{
   
    NSMutableArray  * EpisodeArray;
    NSDictionary    * showLinkDictionary;
    NSDictionary    * showDetailDictionary,*movieDetailDictionary;
     NSMutableArray *rentNowArray;
    NSDictionary    * episodeDetailDictionary;
    NSMutableArray  * watchTrailerArray;
    NSMutableArray  * arrayCast;
    
    //UIVIEW LEFTBORDER
    UIView *upperLeftBorder;
    UIView *upperRightBorder;
    UIView *upperTopBorder;
    UIView *upperBottomBorder1;
    UIView *upperBottomBorder2;
    
    //DESP LABEL
    NSString* strDescriptionText;
    CGFloat DespHeight;
    CGFloat freeLabelWidth,rentLabelWidth,commonSDBtnWidth,commonSDBtnHeight;
    NSString* previousEpisodeID;


}
@property(retain,nonatomic) NSMutableArray* linksTrailer;
@property(retain,nonatomic) NSMutableArray* linksWatchVideo;
@property (strong, nonatomic) NSString* nID;
@property (strong, nonatomic) NSString* episodeId;
@property (strong, nonatomic) NSString* seasonId;
@property (strong, nonatomic) NSString *genreName;
@property(retain,nonatomic) NSString *headerLabelStr;
@property (assign, nonatomic) BOOL  isEpisode;
@property (assign, nonatomic) BOOL  isMovie;
@property(retain,nonatomic) NSString* posterUrlStr;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *despLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *despLabelHeight;

@property (strong, nonatomic) IBOutlet UIView *detailFullView;
@property (strong, nonatomic) IBOutlet UIView *leftTopHalfView;//IPAD
@property (strong, nonatomic) IBOutlet UIView *rightTopHalfView;//IPAD and IPHONE
@property (strong, nonatomic) IBOutlet UIImageView *landScapeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *networkLabel;
@property (strong, nonatomic) IBOutlet UIButton *watchNowButton;
@property (strong, nonatomic) IBOutlet UIButton *watchTrailerButton;
@property (strong, nonatomic) IBOutlet UIButton *overViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *castBtn;
@property (strong, nonatomic) IBOutlet UIButton *genreBtn;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITableView *castTableView;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;

@property(retain,nonatomic)   TrailerMovieView *mainView;
- (IBAction) goBack:(id)sender;
- (void) setIfMovies:(BOOL)bMovies;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *appListHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *watchBtnHeightConstraint;

//iphone
@property (strong, nonatomic) IBOutlet UIScrollView *iPhoneScrollView;
@property (strong, nonatomic) IBOutlet UIGridView   *appListGridView;
@property (strong, nonatomic) IBOutlet UITextView   *episodeTextView;

//SHOW DETAILS ARE PASSING HERE

@property(retain,nonatomic) NSMutableArray  * fourLatestArray;
@property(retain,nonatomic) NSMutableArray  * allFreeEpisodeArray;
@property(retain,nonatomic) NSMutableArray  * allEpisodeArray;
@property(retain,nonatomic) NSMutableArray  * allSeasonsArray;


//Added for centre scroll
@property (strong, nonatomic) IBOutlet UIView *appListView;
@property (strong, nonatomic) IBOutlet UIScrollView *appListScrollView;

@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIScrollView *middleScrollView;

@property (strong, nonatomic) IBOutlet UIView *lastBottomView;
@property (strong, nonatomic) IBOutlet UIView *lastBottomInnerView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *middleScrollHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightViewIphoneHeightConstraint;
//IPAD CHECKED
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *appListViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *middleViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomFullViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomInnerViewHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topFullViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightViewIpadHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *latestEpisodeLabel;

@property (strong, nonatomic) IBOutlet UILabel *watchLatestLabel;

//PAID
@property (assign, nonatomic) BOOL  isPushedFromPayPerView;
//Free and All Toggle
@property (assign, nonatomic) BOOL  isToggledFree;
@property (assign, nonatomic) BOOL  isToggledAll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gridViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ratingLabelWidthConstraint;

@end
