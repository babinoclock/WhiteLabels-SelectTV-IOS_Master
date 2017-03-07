//
//  NKContainerCellTableViewCell.h
//  ImageGrid
//
//  Created by Nikunj Modi on 9/21/15.
//  Copyright (c) 2015 Nikunj Modi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NKContainerCellTableViewCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier appManagerStr:(NSString * )isAppManager;
- (void)setCollectionData:(NSArray *)collectionData;
- (void)setCollectionImageData:(NSArray *)collectionData currentViewStr:(NSString *)currentViewStr;
@end
