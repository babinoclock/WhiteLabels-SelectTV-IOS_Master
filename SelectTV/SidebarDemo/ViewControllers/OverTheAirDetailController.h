//
//  OverTheAirDetailController.h
//  SidebarDemo
//
//  Created by ocsdeveloper9 on 9/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverTheAirCustomCell.h"

@interface OverTheAirDetailController : UIViewController {
    NSArray *collectionArray;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *overTheAirCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *trialButton;
@property (nonatomic) BOOL isSling;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *watchVideoButton;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descHeight;
@property (strong, nonatomic) IBOutlet UIView *ipadView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (strong, nonatomic) IBOutlet UILabel *descLabel1;
@property (strong, nonatomic) IBOutlet UICollectionView *overTheAirCollectionView1;
@property (strong, nonatomic) IBOutlet UIButton *trialButton1;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel1;
@property (strong, nonatomic) IBOutlet UIButton *watchVideoButton1;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descHeight1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight1;

@property (strong, nonatomic) IBOutlet UIButton *backActionDetail;
@property ( nonatomic)  NSString *urlString;
- (IBAction)backBtnAction:(id)sender;


@end
