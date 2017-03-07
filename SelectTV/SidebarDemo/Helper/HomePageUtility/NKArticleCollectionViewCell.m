//
//  NKArticleCollectionViewCell.m
//  ImageGrid
//
//  Created by Nikunj Modi on 9/21/15.
//  Copyright (c) 2015 Nikunj Modi. All rights reserved.
//

#import "NKArticleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppCommon.h"
@implementation NKArticleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *str = [COMMON getAppManagerDetail];
        if([str isEqualToString:@"YES"]) {
            [self setBackgroundColor:[UIColor clearColor]];
        } else {
            [self setBackgroundColor:[UIColor blackColor]];

        }
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [[NSBundle mainBundle] loadNibNamed:@"NKArticleCollectionViewCell_iPad" owner:self options:nil];
        }
        else{
            [[NSBundle mainBundle] loadNibNamed:@"NKArticleCollectionViewCell" owner:self options:nil];
        }

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //self.layer.borderColor = [[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0] CGColor];
    //self.layer.borderWidth = 1.0;
}
@end
