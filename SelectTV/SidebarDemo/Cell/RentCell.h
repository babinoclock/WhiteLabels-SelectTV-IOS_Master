//
//  RentCell.h
//  SidebarDemo
//
//  Created by Panda on 6/17/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *imageBackground;
@property (nonatomic, strong) IBOutlet UIImageView *imageThumbnail;
@property (nonatomic, strong) IBOutlet UILabel *labelStreamName;

- (void) loadImageThumbnail:(NSURL*) strUrl;

@end
