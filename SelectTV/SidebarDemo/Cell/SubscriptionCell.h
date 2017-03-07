//
//  SubscriptionCell.h
//  SidebarDemo
//
//  Created by Panda on 7/5/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "UIGridViewCell.h"

@interface SubscriptionCell : UIGridViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel* label;
@property (weak, nonatomic) IBOutlet UIImageView* thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView* kidsThumbnail;

@end
