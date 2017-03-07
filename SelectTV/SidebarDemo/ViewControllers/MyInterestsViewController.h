//
//  MyInterestsViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 23/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RabbitTVManager.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "AppCommon.h"
#import "AppConfig.h"
#import "myInterestsCell.h"
#import "CustomIOS7AlertView.h"
#import "UIImageView+AFNetworking.h"
#import "FavTableViewCell.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HMSegmentedControl.h"

@interface MyInterestsViewController : UIViewController<UIGridViewDelegate,CustomIOS7AlertViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *personalizeBtnImage;
@property (strong, nonatomic) IBOutlet UIButton *personalizeButton;
@property (strong, nonatomic) IBOutlet UIButton *addRemoveBtnImage;
@property (strong, nonatomic) IBOutlet UIButton *addRemoveButton;
@property (strong, nonatomic) IBOutlet UILabel *personlizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addRemoveLabel;

@property (strong, nonatomic) IBOutlet UITableView *myInterestsTable;
@property (strong, nonatomic) IBOutlet UIGridView* popUpTable;
@property(retain,nonatomic) NSMutableArray* movieGenreArray;
@property(retain,nonatomic) NSMutableArray* networkGenreArray;
@property (strong, nonatomic) HMSegmentedControl *headerScroll;

-(void)UserFavListAPI;
@end
