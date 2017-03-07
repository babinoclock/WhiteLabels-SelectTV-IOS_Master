//
//  StreamTableViewCell.h
//  SidebarDemo
//
//  Created by Panda on 6/17/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imageBackground;
@property (nonatomic, weak) IBOutlet UIImageView *imageThumbnail;
@property (nonatomic, weak) IBOutlet UILabel *labelStreamName;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imagePlay;

- (void) loadImageThumbnail:(NSURL*) strUrl;

@end
