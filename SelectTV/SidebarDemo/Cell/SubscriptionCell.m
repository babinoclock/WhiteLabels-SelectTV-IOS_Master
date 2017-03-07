//
//  SubscriptionCell.m
//  SidebarDemo
//
//  Created by Panda on 7/5/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "SubscriptionCell.h"

@implementation SubscriptionCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize thumbnail;
@synthesize label;


- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 80, 80);
        
        //[[NSBundle mainBundle] loadNibNamed:@"SubscriptionCell" owner:self options:nil];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [[NSBundle mainBundle] loadNibNamed:@"SubscriptionCell_IPad" owner:self options:nil];
        }
        else{
            [[NSBundle mainBundle] loadNibNamed:@"SubscriptionCell" owner:self options:nil];
        }
        
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
//        self.thumbnail.layer.cornerRadius = 4.0;
//        self.thumbnail.layer.masksToBounds = YES;
//        self.thumbnail.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.thumbnail.layer.borderWidth = 1.0;
    }
    
    return self;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
}


@end
