//
//  RentCell.m
//  SidebarDemo
//
//  Created by Panda on 6/17/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "RentCell.h"

@implementation RentCell
@synthesize imageThumbnail = _imageThumbnail;
@synthesize labelStreamName = _labelStreamName;
- (void)awakeFromNib {
    // Initialization code
}
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    //self = [super initWithStyle:<#style#> reuseIdentifier:<#reuseIdentifier#>];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    if( self) {
        self.imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(30,0, 50, 30)];
        self.labelStreamName = [[UILabel alloc] initWithFrame:CGRectMake(100,0,100,30)];
        self.labelStreamName.textColor = [UIColor whiteColor];
        [self addSubview:self.imageThumbnail];
        [self addSubview:self.labelStreamName];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadImageThumbnail:(NSURL*) strUrl
{
    [self.imageThumbnail setImage:[UIImage imageNamed:@"noVideoBgIcon"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData* imageData = [NSData dataWithContentsOfURL:strUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * image = [UIImage imageWithData:imageData];
            [self.imageThumbnail setImage:image];
        });
        
    });

}
@end
