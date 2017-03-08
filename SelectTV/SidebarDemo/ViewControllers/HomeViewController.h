//
//  HomeViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 01/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"

@interface HomeViewController : UIViewController < UITableViewDataSource,UITableViewDelegate>{
    BOOL isLoadedHome;
    BOOL isSeasonArrayExist;
    NSMutableArray *arraySeasons;
    UIDevice* homeDevice;
}

//@property (strong, nonatomic) IBOutlet UIImageView *bannerView;
//
//@property (strong, nonatomic) IBOutlet UICollectionView *collection;
//
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *homeActivityIndicator;

@property (weak, nonatomic) UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UIButton *mainLeftBarButton;
@property(nonatomic, strong) IBOutlet UIButton *searchButton;
-(IBAction) searchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *homeSplash_Logo;

@property (assign, nonatomic) BOOL isHomeScreen;

@end
