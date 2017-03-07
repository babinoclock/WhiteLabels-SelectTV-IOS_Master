//
//  NKContainerCellTableViewCell.m
//  ImageGrid
//
//  Created by Nikunj Modi on 9/21/15.
//  Copyright (c) 2015 Nikunj Modi. All rights reserved.
//

#import "NKContainerCellTableViewCell.h"
#import "NkContainerCellView.h"
#import "AppCommon.h"
@interface NKContainerCellTableViewCell ()
@property (strong, nonatomic) NkContainerCellView *collectionView;
@end
@implementation NKContainerCellTableViewCell//NKContainerCellView_Subscription

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appManagerStr:(NSString * )isAppManager {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [COMMON isAppManager:isAppManager];
        if([isAppManager isEqualToString:@"YES"])
            _collectionView = [[NSBundle mainBundle] loadNibNamed:@"NKContainerCellView_AppManager" owner:self options:nil][0];//NKContainerCellView_AppManager
        else if([isAppManager isEqualToString:@"NO"]){
            _collectionView = [[NSBundle mainBundle] loadNibNamed:@"NKContainerCellView" owner:self options:nil][0];
        } else {
            _collectionView = [[NSBundle mainBundle] loadNibNamed:@"NKContainerCellView_Subscription" owner:self options:nil][0];
        }
        _collectionView.frame = self.bounds;
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCollectionData:(NSArray *)collectionData {
    [_collectionView setCollectionData:collectionData];
}
- (void)setCollectionImageData:(NSArray *)collectionData currentViewStr:(NSString *)currentViewStr {
    [_collectionView setCollectionImageData: collectionData currentViewStr:currentViewStr];
}


@end
