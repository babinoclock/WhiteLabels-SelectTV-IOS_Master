//
//  SubscriptTableViewCell.h
//  SidebarDemo
//
//  Created by Karthikeyan on 19/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *appImage;
@property (strong, nonatomic) IBOutlet UIButton *appNameButton;
@property (strong, nonatomic) IBOutlet UIButton *leftMoveBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIButton *rightMoveBtn;

@end
