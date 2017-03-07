//
//  GamesViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 23/09/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "HMSegmentedControl.h"
#import "RabbitTVManager.h"
#import "NKContainerCellTableViewCell.h"
@interface GamesViewController : UIViewController{
    NSMutableArray * titleArray;
    NSMutableArray * topTitleArray;
    NSMutableArray * topTitleCarouselArray;
    NSMutableArray * gamesGridItemsArray;
    NSInteger visibleSection;
}
@property (strong, nonatomic) IBOutlet UIView *topSegmentView;
@property (strong, nonatomic) IBOutlet UITableView *carouselTableView;
@property (strong, nonatomic) IBOutlet UIGridView *gamesGirdTable;
@property (strong, nonatomic) HMSegmentedControl *gamesHeaderScroll;
@property (assign, nonatomic) BOOL isMoreView;
@property (assign, nonatomic) BOOL isLogout;
-(void)getMoreDataList;


@end
