//
//  SearchViewController.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 30/03/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "AsyncImage.h"
#import "HMSegmentedControl.h"
@interface SearchViewController : UIViewController<UIGridViewDelegate>{
    AsyncImage *asyncImage;
    NSString *scrollButtonTitle;
    BOOL isSeasonArrayExist;
    
}

@property(retain,nonatomic) NSString* searchTitle;
@property (strong, nonatomic)  UIScrollView   *showHeaderView;
@property(retain,nonatomic) NSMutableArray* titleTextArray;
@property(retain,nonatomic) NSMutableArray* FullSearchArray;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (assign, nonatomic) BOOL  isFromChannel;
@property (strong, nonatomic) HMSegmentedControl *headerScroll;

@end
