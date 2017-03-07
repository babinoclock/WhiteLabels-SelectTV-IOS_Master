//
//  RadioGenreTableViewCell.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 12/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "RadioGenreTableViewCell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation RadioGenreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 70, 70); //old
        self.backgroundColor = [UIColor clearColor];
        [[NSBundle mainBundle] loadNibNamed:@"RadioGenreTableViewCell" owner:self options:nil];
        [self addSubview:self.view];
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)dealloc {
}


@end
