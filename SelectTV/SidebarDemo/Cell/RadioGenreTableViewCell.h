//
//  RadioGenreTableViewCell.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 12/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface RadioGenreTableViewCell : UIGridViewCell
@property (strong, nonatomic) IBOutlet UIImageView *radioGenreImage;
@property (strong, nonatomic) IBOutlet UILabel *radioGenreLabel;
@property (strong, nonatomic) IBOutlet UILabel *radioLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *radioView;

@end
