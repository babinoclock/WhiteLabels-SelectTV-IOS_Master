//
//  Season.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 27/01/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "Season.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Season

- (void)awakeFromNib {
    // Initialization code
}
@synthesize thumbnail;
@synthesize seasonName,episodeCount;


- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 80, 80); //old
        
        //self.frame = CGRectMake(0, 0, 90, 90); //new
        
        [[NSBundle mainBundle] loadNibNamed:@"Season" owner:self options:nil];
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
//        self.thumbnail.layer.cornerRadius = 4.0;
//        self.thumbnail.layer.masksToBounds = YES;
//        self.thumbnail.layer.borderColor = [UIColor grayColor].CGColor;
//        self.thumbnail.layer.borderWidth = 1.0;
        seasonName.numberOfLines = 0;
        episodeCount.numberOfLines = 0;
        
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
