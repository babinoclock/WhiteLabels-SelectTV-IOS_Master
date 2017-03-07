//
//  NKArticleCollectionViewCell.h
//  ImageGrid
//
//  Created by Nikunj Modi on 9/21/15.
//  Copyright (c) 2015 Nikunj Modi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKArticleCollectionViewCell : UICollectionViewCell
@property (weak) IBOutlet UIImageView *blockImage;
@property (strong, nonatomic) IBOutlet UIImageView *blockPotraitImage;
@property (strong, nonatomic) IBOutlet UIImageView *blockSquareImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak) IBOutlet UILabel *blockTitle;
@end
