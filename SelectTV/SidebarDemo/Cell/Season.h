//
//  Season.h
//  SidebarDemo
//
//  Created by OCS iOS Developer on 27/01/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface Season : UIGridViewCell


@property (nonatomic, retain) IBOutlet UIImageView *thumbnail;
@property (nonatomic, retain) IBOutlet UILabel *seasonName;
@property (nonatomic, retain) IBOutlet UILabel *episodeCount;
@end
