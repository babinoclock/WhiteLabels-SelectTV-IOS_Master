//
//  RadioViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 12/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrailerMovieView.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "Radio.h"

@interface RadioViewController : UIViewController <UIGridViewDelegate,UITableViewDataSource,UITableViewDelegate,RadioDelegate>{
    
     IBOutlet UIWebView *Webview;
     Radio *radio;
    UIActivityIndicatorView *radioLoadingView;
}

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic)  UIView   *showHeaderView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;

@property (weak, nonatomic) UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITableView *tableRadio;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *radioActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *radioByListView;
@property (weak, nonatomic) IBOutlet UITableView *radioByListTable;

@property (weak, nonatomic) IBOutlet UIView *radioDetailView;
@property (weak, nonatomic) IBOutlet UILabel *radioDetailLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *radioDetailMainLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *emailDataLabel;

@property (strong, nonatomic) IBOutlet UILabel *radioDetailSloganTitle;
@property (strong, nonatomic) IBOutlet UIImageView *radioDetailImageView;
@property (strong, nonatomic) IBOutlet UILabel *radioDetailSloganLabel;
@property (strong, nonatomic) IBOutlet UILabel *radioDetailDesTitle;
@property (strong, nonatomic) IBOutlet UITextView *radioDetailTextView;
@property (strong, nonatomic) IBOutlet UILabel *radioDetailAddTitle;
@property (strong, nonatomic) IBOutlet UILabel *radioDetailAddLabel;
@property (strong, nonatomic) IBOutlet UILabel *radioDetailPhoneTitle;
@property (strong, nonatomic) IBOutlet UILabel *radioDetailPhoneLabel;


@property (weak, nonatomic) IBOutlet UIButton *radioDetailBackBtn;
@property (strong, nonatomic) IBOutlet UIButton *radioDetailPlayBtn;
//SHOW IN LOCATION
@property (weak, nonatomic) IBOutlet UIView *radioHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *radioHeaderBackBtn;
@property (weak, nonatomic) IBOutlet UILabel *radioHeaderLabel;

//@property (strong,nonatomic) MPMoviePlayerController *myPlayer;

@property (weak, nonatomic) IBOutlet UISlider *myslider;

@property (strong, nonatomic) IBOutlet UIButton *mainLeftBarButton;
@property(nonatomic, strong) IBOutlet UIButton *searchButton;
-(IBAction) searchAction:(id)sender;

@end
