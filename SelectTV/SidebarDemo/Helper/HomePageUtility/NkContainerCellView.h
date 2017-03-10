//
//  NkContainerCellView.h
//  ImageGrid
//
//  Created by Nikunj Modi on 9/21/15.
//  Copyright (c) 2015 Nikunj Modi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NkContainerCellView : UIView{
    NSInteger count;
    NSMutableDictionary *selectedIdx;
    NSInteger pageNumber;
    UICollectionViewFlowLayout *flowLayout;
}
@property (strong, nonatomic) IBOutlet UIImageView *tickImage;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *appNameButton;
@property (strong, nonatomic) IBOutlet UIImageView *appHeaderImage;
- (void)setCollectionData:(NSArray *)collectionData;
@property (strong, nonatomic) IBOutlet UIButton *headerImageButton;
@property (strong, nonatomic) IBOutlet UIButton *viewAllBtn;
@property ( nonatomic)  NSArray *imagesArray;
@property (strong, nonatomic) IBOutlet UIButton *leftBtnArrow;
@property (strong, nonatomic) IBOutlet UIButton *rightBtnArrow;
- (void)setCollectionImageData:(NSArray *)collectionData currentViewStr:(NSString *)currentViewStr;
@end
