//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "AppDelegate.h"
#import "MenuView.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "HMSegmentedControl.h"
#import "SWRevealViewController.h"

@interface MainViewController : UIViewController<SWRevealViewControllerDelegate>{
    
    
    float whichHeight;
    BOOL isCurVideo;
    IBOutlet UIView *onCastView;
    BOOL isLoaded;
    IBOutlet UIView *newScrollGridView;
    // the Gride Table View
    
    
    UIToolbar               *keyboardToolbar;
    UIBarButtonItem         *spaceBarItem;
    UIBarButtonItem         *doneBarItem;
    
    int checkChannelCount;
    NSMutableArray *videoCountArray;
    NSInteger popUpIndex;
    NSString *popUpSelectionId;
    BOOL isLocal;
    NSString *onWatchChannelId;
    NSMutableArray *onWatchChannelArray;
    NSString *TvActorId;
    NSString *MovieActorId;
    NSString *MusicArtistId;
    
    
    
    
}

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property (strong, nonatomic) HMSegmentedControl *headerScroll;


@property(retain,nonatomic) NSString* youtubeID;
@property(retain,nonatomic) NSString* youtubeTitle;
@property (assign, nonatomic) BOOL  * isLoadAgain;


@property (weak, nonatomic) UIBarButtonItem *sidebarButton;
//Streams
@property (weak, nonatomic) IBOutlet UITableView *tableStreams;

// Content SETTING
@property (weak, nonatomic) IBOutlet UITableView *tableContent;
@property (strong, nonatomic) IBOutlet UIButton *showViewButton;
@property (strong, nonatomic) IBOutlet UIButton *contentViewButton;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UITableView *contentScrollTableView;

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;


@property (weak, nonatomic) IBOutlet UIView *playerContainer;

@property (weak, nonatomic) IBOutlet UIView *containerVideoView;

@property (weak, nonatomic) IBOutlet UIView *nowView;

@property (weak, nonatomic) IBOutlet UILabel *textStreamTitle;
@property (weak, nonatomic) IBOutlet UILabel *textStreamTime;

@property (strong, nonatomic) IBOutlet UILabel *nowPlayLabel;

-(IBAction) fullScreenTouched:(id)sender;
-(IBAction) searchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *mainLeftBarButton;



- (void) updateStreams:(int)nChannelID;
- (void) updateTitle:(NSString *)strTitle;
- (void) updateChannelData:(NSDictionary *)dictItem;

@property (strong, nonatomic)  UIScrollView   *showHeaderView;
@property (strong, nonatomic)  UIView   *showTopView;
@property(nonatomic,retain) MenuView* menuView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *onCastTopConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *mainBackgroundImage;

@end
