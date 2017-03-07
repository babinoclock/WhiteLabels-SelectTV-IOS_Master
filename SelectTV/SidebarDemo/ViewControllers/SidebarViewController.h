//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChanelManager.h"
#import "Category.h"
#import "MenuView.h"
#import "CustomIOS7AlertView.h"

@interface SidebarViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate,MenuViewDelegate,CustomIOS7AlertViewDelegate>{

}


@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic,retain) MenuView* menuVeiw;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *freeCastlabel;
@property (strong, nonatomic) IBOutlet UIView *LeftBgView;

@property (strong, nonatomic) IBOutlet UIImageView *freeCastLogo;
@property (nonatomic) NSString* isSibarAppManager;
@end
