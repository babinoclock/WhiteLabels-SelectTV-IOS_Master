//
//  RadioListByGenreCell.m
//  SidebarDemo
//
//  Created by OCS iOS Developer on 15/02/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "MainContentGridCell.h"

@implementation MainContentGridCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 70, 70); //old
        
        [[NSBundle mainBundle] loadNibNamed:@"MainContentGridCell" owner:self options:nil];
        
        [self addSubview:self.view];
        self.backgroundColor = [UIColor clearColor];
        [self.view setBackgroundColor:[UIColor clearColor]];
        _mainContentLabel.layer.borderWidth = 1.0;
        
    }
    
    return self;
    
}
- (void)dealloc {
}


@end
