//
//  RadioListByGenreGridCell.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 15/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface RadioListByGenreGridCell : UIGridViewCell

@property (weak, nonatomic) IBOutlet UIImageView *radioListImageView;
@property (weak, nonatomic) IBOutlet UILabel *radioListTitle;
@property (weak, nonatomic) IBOutlet UILabel *radioListMainTitle;

@end
