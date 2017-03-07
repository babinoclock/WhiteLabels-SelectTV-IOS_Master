//
//  SubScriptionsViewController.h
//  SidebarDemo
//
//  Created by Panda on 7/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "subscriptionCustomCollectionCell.h"
#import "SubscriptTableViewCell.h"
@interface SubScriptionsViewController : UIViewController {
    UIView *subScriptionView;
    UISwitch *freeSwitch;
    BOOL isCableSelected;
    UIView *subscriptionBottomView;
    UIDevice* homeDevice;
    UITableView *_collectionView;
    NSMutableArray *currentSubscriptionArray;
    NSMutableArray *loginSubscriptionArray;
    NSMutableArray *currentCableArray;
    BOOL isSelectedItem;
    NSMutableArray * tempArray;
    NSMutableArray *caurosalArray;
    NSMutableArray *selectedSubscriptArray;
    UIScrollView *collectionScroll;
    NSString *subscriptionCode;
    UIButton* setBtn;
}

@property (weak, nonatomic) IBOutlet UIGridView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *subScriptionIndicator;
@property(retain,nonatomic) NSString* isKid;
- (void)updateData:(NSString *)strID bKid:(BOOL)bKid :(NSInteger)currentIndex;

@property (strong, nonatomic) IBOutlet UIButton *mainLeftBarButton;
@property(nonatomic, strong) IBOutlet UIButton *searchButton;
-(IBAction) searchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *subscriptionTable;
@property (strong, nonatomic) IBOutlet UIScrollView *subscriptionScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subscriptionTableHeight;
@property (assign, nonatomic) BOOL  isKidsMenu;
@property (assign, nonatomic) BOOL  isKidsMenuMovie;
@property (assign, nonatomic) BOOL  isSide;
@property (assign, nonatomic) BOOL  isPushedFromSubscriptView;

@end
