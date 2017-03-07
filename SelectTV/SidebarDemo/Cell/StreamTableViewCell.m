//
//  StreamTableViewCell.m
//  SidebarDemo
//
//  Created by Panda on 6/17/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "StreamTableViewCell.h"

@implementation StreamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadImageThumbnail:(NSURL*) strUrl
{
    [self.imageThumbnail setImage:[UIImage imageNamed:@"noVideoBgIcon"]];
    //[self.imagePlay setImage:[UIImage imageNamed:@"playIcon"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData* imageData = [NSData dataWithContentsOfURL:strUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * image = [UIImage imageWithData:imageData];
            [self.imageThumbnail setImage:image];
            
        });
        
    });

}
@end
