//
//  SearchDetailViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 01/04/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "TrailerMovieView.h"
#import "HMSegmentedControl.h"
@interface SearchDetailViewController : UIViewController<UIGridViewDelegate>{
    BOOL isSeasonExist;
}

@property(retain,nonatomic) NSMutableArray* stationDataArray;
@property (strong, nonatomic) NSString* stationImageUrl;
@property (strong, nonatomic) NSString* stationNameStr;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *searchStationTable;


@property (strong, nonatomic) IBOutlet UILabel *stationName;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;

- (IBAction) goBack:(id)sender;
@property(retain,nonatomic) NSString* titleStr;
//NETWORK
@property(retain,nonatomic) NSString* networkStr;
@property(retain,nonatomic) NSMutableArray* dropDownNSArray;
@property (strong, nonatomic) IBOutlet UITableView *payTableView;
@property(retain,nonatomic)NSMutableArray *liveDetailArray;

//BOOL
@property (nonatomic,assign) BOOL isNetworksView;
@property (nonatomic,assign) BOOL isLiveViewDetails;
@property (nonatomic,assign) BOOL isActorViewDetails;
@property (assign, nonatomic) BOOL  isFromChannel;

//ACTOR
@property (strong, nonatomic)  UIView   *showHeaderView;
@property(retain,nonatomic) NSMutableArray* titleTextArray;
@property(retain,nonatomic) NSMutableArray* FullActorArray;
@property(retain,nonatomic) NSMutableArray* ActorMoviesArray;
@property(retain,nonatomic) NSMutableArray* ActorShowsArray;
@property (strong, nonatomic) NSString* actorPosterUrl;
@property (strong, nonatomic) HMSegmentedControl *headerScroll;

//- (void)updateNetworkData:(NSArray*) networks;
- (void)updateNetworkDetailData:(int)nNetworkID;
@end
