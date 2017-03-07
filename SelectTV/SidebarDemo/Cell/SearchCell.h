//
//  RadioGenreTableViewCell.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 12/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface SearchCell : UIGridViewCell

@property (strong, nonatomic) IBOutlet UIImageView *searchImage;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@end
