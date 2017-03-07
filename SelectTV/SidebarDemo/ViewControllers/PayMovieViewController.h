//
//  PayMovieViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 26/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "AppConfig.h"

@interface PayMovieViewController : UIViewController  <UIGridViewDelegate>{
    NSString *didSelectId;
    NSString *didSelectName;
    NSString *genreName;
    BOOL isSeasonExist;
    UIImageView *logoImgView;
    BOOL isSubscription;
    UIScrollView *HeaderScroll ;
     UIImageView *episodeImage;
    NSMutableArray *movieArray;
    NSMutableArray *showArray;
    UIButton *movieButton;
    UIButton *showButton;
    
    //UIVIEW LEFTBORDER
    UIView *upperLeftBorder;
    UIView *upperRightBorder;
    UIView *upperTopBorder;
    UIView *upperBottomBorder1;
    UIView *upperBottomBorder2;
    UIView *manageLabel;
    BOOL isLandscape;
    NSUInteger selectedCaurosalIndex;
    BOOL isShowsClicked;
}

@property (strong, nonatomic) IBOutlet UIView *caurosalView;

@property(retain,nonatomic) NSString* payShowStr;
@property(retain,nonatomic) NSString* payHeaderLabelStr;
@property(retain,nonatomic) NSString* genreName;

@property(retain,nonatomic) NSMutableArray* dropDownNSArray;
@property (strong, nonatomic) IBOutlet UITableView *payTableView;
@property (strong, nonatomic) IBOutlet UILabel *payLabel;
@property (strong, nonatomic) IBOutlet UILabel *payHeaderLabel;

//BOOL
@property (assign, nonatomic) BOOL isPayPerView;
@property (assign, nonatomic) BOOL isNetworksView;

@property (assign, nonatomic) BOOL isSearchNetworksView;

@property (assign, nonatomic) BOOL isSubcriptionView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *payMovieActivityIndicator;


- (void)updateData:(int)nChannelID status:(int)nStatus;
- (void)updateShowData:(int)nChannelID;
- (void)updateNetworkData:(NSArray*) networks;
- (void)updateNetworkDetailData:(int)nNetworkID;

-(void)loadSliderCarouselScreen;
@property (strong, nonatomic) IBOutlet UIButton *mainLeftBarButton;
@property(nonatomic, strong) IBOutlet UIButton *searchButton;
-(IBAction) searchAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *payPerSliderView;
@property (strong, nonatomic) IBOutlet UILabel *payPerRightMenuLabel;

@property (assign, nonatomic) BOOL isPushedFromSubscriptView;

@property(nonatomic, strong)  NSArray *subcsArray;
@end
