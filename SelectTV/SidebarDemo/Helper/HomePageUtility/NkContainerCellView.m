//
//  NkContainerCellView.m
//  ImageGrid
//
//  Created by Nikunj Modi on 9/21/15.
//  Copyright (c) 2015 Nikunj Modi. All rights reserved.
//

#import "NkContainerCellView.h"
#import "NKArticleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "AppCommon.h"
#import "UIImage+WebP.h"
#import "AsyncImage.h"
#import "AppConfig.h"


@interface NkContainerCellView () <UICollectionViewDataSource, UICollectionViewDelegate>{
    NKArticleCollectionViewCell *cell;
    AsyncImage *asyncImage;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *collectionData;
@property (strong, nonatomic) NSString *currentViewStr;
@property (strong, nonatomic) NSString *appIdStr;
@end
@implementation NkContainerCellView

- (void)awakeFromNib {
   flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(101,122);//101,122
    //121.0, 145.0
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    // Register the colleciton cell
   
    [_collectionView registerNib:[UINib nibWithNibName:@"NKArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NKArticleCollectionViewCell"];
    

    self.collectionView.pagingEnabled=YES;
    NkContainerCellView *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf _edgeInsetsToFit];
    });
    
    //nextImage
    //previousImage
    
    //[_leftBtnArrow setImage:@"" forState:UIControlStateNormal];
   // [_rightBtnArrow setImage:@"" forState:UIControlStateNormal];
    
    [_leftBtnArrow setImage:[[UIImage imageNamed:@"previousImage"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_rightBtnArrow setImage:[[UIImage imageNamed:@"nextImage"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [_leftBtnArrow setTintColor:[UIColor whiteColor]];
    [_rightBtnArrow setTintColor:[UIColor whiteColor]];
    
}

- (void)_edgeInsetsToFit {
    UIEdgeInsets edgeInsets = self.collectionView.contentInset;
    CGSize contentSize = self.collectionView.contentSize;
    CGSize size = self.collectionView.bounds.size;
    CGFloat heightOffset = (contentSize.height + edgeInsets.top) - size.height;
    if (heightOffset < 0) {
        edgeInsets.bottom = size.height - (contentSize.height + edgeInsets.top) + 1;
        self.collectionView.contentInset = edgeInsets;
    } else {
        edgeInsets.bottom = 0;
        self.collectionView.contentInset = edgeInsets;
    }
}

#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    NSLog(@"count-->%lu",(unsigned long)[_collectionData count]);
    [_collectionView setContentOffset:CGPointZero animated:NO];
    if(collectionData.count!=0)
        [_collectionView reloadData];
}
- (void)setCollectionImageData:(NSArray *)collectionData currentViewStr:(NSString *)currentViewStr{

    _collectionData = collectionData;
    NSLog(@"count-->%lu",(unsigned long)[_collectionData count]);
    _currentViewStr =currentViewStr;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    if(collectionData.count!=0)
        [_collectionView reloadData];
  //  [_collectionView reloadData];
  //  [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    NSDictionary *cellData1 = [self.collectionData objectAtIndex:section];
//    NSString *typeString = cellData1[@"type"];
//   if([typeString isEqualToString:@"G"]||[typeString isEqualToString:@"M"]||[typeString isEqualToString:@"N"])
//      return 0.0f;
//    
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    NSDictionary *cellData1 = [self.collectionData objectAtIndex:section];
    NSString *typeString = cellData1[@"type"];
    if([typeString isEqualToString:@"M"])
        return 0.0f;//0
    else if([typeString isEqualToString:@"G"]||[typeString isEqualToString:@"N"])
        return 10.0f;
    return 10.0f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_collectionData count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData1 = [self.collectionData objectAtIndex:[indexPath row]];
    NSString *typeString = cellData1[@"type"];
    if([typeString isEqualToString:@"G"]||[typeString isEqualToString:@"M"]||[typeString isEqualToString:@"N"])
        return CGSizeMake(120, 190);
    
    return CGSizeMake(200, 160);//170, 158 //(150, 130);//(150, 112)
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NKArticleCollectionViewCell" forIndexPath:indexPath];
    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0, 0, cell.blockPotraitImage.frame.size.width, cell.blockPotraitImage.frame.size.height-20)];
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    cell.blockTitle.text = @"";
    NSString* strPosterUrl;
    NSString *appImageUrl ;
    NSString *str = [COMMON getAppManagerDetail];
    if([_currentViewStr  isEqualToString:@"SubscriptionView"]) {
        _headerLabel.text = [cellData[@"code"] capitalizedString];
        [_headerLabel setHidden:NO];
        [_headerLabel setTextColor:[UIColor whiteColor]];
        NSString * isSubscribed = cellData[@"subscribed"];
        
        if([isSubscribed  isEqualToString:@"YES"])
        {
            [_tickImage setHidden:NO];
            appImageUrl = cellData[@"image_url"];
        }
        else {
            [_tickImage setHidden:YES];
            appImageUrl = cellData[@"gray_url"];
        }
        strPosterUrl = [cellData  valueForKey:@"image"];
        if ((NSString *)[NSNull null] == appImageUrl||appImageUrl == nil) {
            appImageUrl=@"";
        }
        if([appImageUrl containsString:@".png" ]|| [appImageUrl containsString: @".jpeg"]|| [appImageUrl containsString: @".jpg" ]){
            NSURL *imageNSURL = [NSURL URLWithString:appImageUrl];
            [_appHeaderImage setImageWithURL:imageNSURL placeholderImage:[UIImage imageNamed:@"landscape_Loader"]];//white_Bg
        }
        else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *imageWebp = [NSString stringWithFormat:@"%@image.webp",_appIdStr];
            NSString *webPPath = [paths[0] stringByAppendingPathComponent:imageWebp];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:webPPath]) {
                [_appHeaderImage setImage:[UIImage imageWithWebP:webPPath]];
                
            } else {
                
                NSURL *imageURL = [NSURL URLWithString:appImageUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                if ([imageData writeToFile:webPPath atomically:YES]) {
                    uint64_t fileSize;
                    fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:webPPath error:nil] fileSize];
                    [UIImage imageWithWebP:webPPath completionBlock:^(UIImage *result) {
                        [_appHeaderImage setImage:result];
                    }failureBlock:^(NSError *error) {
                        NSLog(@"error%@", error.localizedDescription);
                        [_appHeaderImage setImage:[UIImage imageWithWebP:webPPath]];
                    }];
                }
            }
        }
        _headerImageButton.tag = indexPath.row;
        
        
        _viewAllBtn.tag = indexPath.row;
        [_viewAllBtn  addTarget:self
                         action:@selector(indexAction:)
               forControlEvents:UIControlEventTouchUpInside];
        
        if([_currentViewStr  isEqualToString:@"SubscriptionView"]) {
            
            NSString * isSubscribed = cellData[@"subscribed"];
            
            NSLog(@"isSubscribed -->%@",isSubscribed);
            
            if([isSubscribed  isEqualToString:@"YES"])
            {
                [_appNameButton setTitle:@"Subscribed" forState:UIControlStateNormal];
                [_appNameButton setBackgroundColor:[UIColor orangeColor]];
            }
            else{
                [_appNameButton setTitle:@"UnSubscribed" forState:UIControlStateNormal];
                [_appNameButton setBackgroundColor:[UIColor grayColor]];
            }
            
            _appNameButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(8)];
            
            _appNameButton.tag = indexPath.row;
            
            _appNameButton.layer.cornerRadius    = 10.0;
            _appNameButton.clipsToBounds         = YES;
            
            [_appNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_appNameButton  addTarget:self
                                action:@selector(subscribeActionMethod:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            [_appNameButton setUserInteractionEnabled:YES];
            [_headerImageButton  addTarget:self
                                    action:@selector(subscribeIndexAction:)
                          forControlEvents:UIControlEventTouchUpInside];

        
    }
}

    if([str isEqualToString:@"YES"]){
        
        //gray_image_url
//        if([_currentViewStr  isEqualToString:@"SubscriptionView"]) {
//            _headerLabel.text = [cellData[@"code"] capitalizedString];
//            [_headerLabel setHidden:NO];
//            [_headerLabel setTextColor:[UIColor whiteColor]];
//            NSString * isSubscribed = cellData[@"subscribed"];
//            
//            if([isSubscribed  isEqualToString:@"YES"])
//            {
//                appImageUrl = cellData[@"image_url"]; 
//            }
//            else{
//                appImageUrl = cellData[@"gray_url"];
//            }
//            strPosterUrl = [cellData  valueForKey:@"image"];
//           
//        }else {
            [_headerLabel setHidden:YES];

        strPosterUrl = cellData[@"carousel_image"];
       appImageUrl = cellData[@"app_image"];
//        }
        //NSString *appSlug = cellData[@"slug"];
        NSString *isInstalled = cellData[@"isInstalled"];
        _appIdStr = cellData[@"app_id"];
        if ((NSString *)[NSNull null] == appImageUrl||appImageUrl == nil) {
            appImageUrl=@"";
        }
        if([appImageUrl containsString:@".png" ]|| [appImageUrl containsString: @".jpeg"]|| [appImageUrl containsString: @".jpg" ]){
            NSURL *imageNSURL = [NSURL URLWithString:appImageUrl];
            [_appHeaderImage setImageWithURL:imageNSURL placeholderImage:[UIImage imageNamed:@"white_Bg"]];//white_Bg
        }
        else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *imageWebp = [NSString stringWithFormat:@"%@image.webp",_appIdStr];
            NSString *webPPath = [paths[0] stringByAppendingPathComponent:imageWebp];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:webPPath]){
                [_appHeaderImage setImage:[UIImage imageWithWebP:webPPath]];
                
            } else {
                
                NSURL *imageURL = [NSURL URLWithString:appImageUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                if ([imageData writeToFile:webPPath atomically:YES]) {
                    uint64_t fileSize;
                    fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:webPPath error:nil] fileSize];
                    [UIImage imageWithWebP:webPPath completionBlock:^(UIImage *result) {
                        [_appHeaderImage setImage:result];
                    }failureBlock:^(NSError *error) {
                        NSLog(@"error%@", error.localizedDescription);
                        [_appHeaderImage setImage:[UIImage imageWithWebP:webPPath]];
                    }];
                }
            }
        }
        _headerImageButton.tag = indexPath.row;
    
        
        _viewAllBtn.tag = indexPath.row;
        [_viewAllBtn  addTarget:self
                         action:@selector(indexAction:)
               forControlEvents:UIControlEventTouchUpInside];
        
         if([_currentViewStr  isEqualToString:@"SubscriptionView"]) {
             
             NSString * isSubscribed = cellData[@"subscribed"];
             
             NSLog(@"isSubscribed -->%@",isSubscribed);
             
             if([isSubscribed  isEqualToString:@"YES"])
             {
                 [_appNameButton setTitle:@"Subscribed" forState:UIControlStateNormal];
                 [_appNameButton setBackgroundColor:[UIColor orangeColor]];
             }
             else{
                 [_appNameButton setTitle:@"UnSubscribed" forState:UIControlStateNormal];
                 [_appNameButton setBackgroundColor:[UIColor grayColor]];
             }
             
            _appNameButton.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(8)];
             
             _appNameButton.tag = indexPath.row;
             
             _appNameButton.layer.cornerRadius    = 10.0;
             _appNameButton.clipsToBounds         = YES;
             
             [_appNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             [_appNameButton  addTarget:self
                                 action:@selector(subscribeActionMethod:)
                       forControlEvents:UIControlEventTouchUpInside];
             
             [_appNameButton setUserInteractionEnabled:YES];
             [_headerImageButton  addTarget:self
                                     action:@selector(subscribeIndexAction:)
                           forControlEvents:UIControlEventTouchUpInside];
             
             
         }

        
        else{
            
            if([isInstalled isEqualToString:@"YES"]){
                [_headerLabel setHidden:YES];

                [_appNameButton setTitle:@"Installed" forState:UIControlStateNormal];
                //_appNameButton.titleLabel.shadowOffset = CGSizeMake( 0.0f, -1.0f);
                _appNameButton.titleEdgeInsets = UIEdgeInsetsMake( 0.0f, 3.0f, 0.0f, 0.0f);
                UIImage *tickImage = [[UIImage imageNamed:@"installTickIcon"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [_appNameButton setImage:tickImage
                                forState:UIControlStateNormal];
                [_appNameButton setTintColor:[UIColor greenColor]];
                //_appNameButton.titleLabel.shadowOffset = CGSizeMake( 0.0f, -1.0f);
            }
            else{
                [_headerLabel setHidden:YES];

                [_appNameButton setTitle:@"Add" forState:UIControlStateNormal];
                [_appNameButton setBackgroundImage:[UIImage imageNamed:@"AddButton.png"] forState:UIControlStateNormal];
            }
            _appNameButton.tag = indexPath.row;
            
            [_appNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_appNameButton  addTarget:self
                                action:@selector(addButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            [_appNameButton setUserInteractionEnabled:YES];
            [_headerImageButton  addTarget:self
                                    action:@selector(indexAction:)
                          forControlEvents:UIControlEventTouchUpInside];

        }
        
        
    }
    else if([_currentViewStr isEqualToString:@"OnDemandView"]){
        [_headerLabel setHidden:YES];
        strPosterUrl = cellData[@"carousel_image"];
        if ((NSString *)[NSNull null] == strPosterUrl) {
            strPosterUrl=@"";
        } else {
            if (strPosterUrl == nil) {
                strPosterUrl=@"";
            }
        }
    }
    else if([_currentViewStr isEqualToString:@"PayPerView"]){
        [_headerLabel setHidden:YES];

        strPosterUrl = cellData[@"carousel_image"];
        if ((NSString *)[NSNull null] == strPosterUrl) {
            strPosterUrl=@"";
        } else {
            if (strPosterUrl == nil) {
                strPosterUrl=@"";
            }
        }
        
    }
    else if([_currentViewStr isEqualToString:@"GamesView"]){
        [_headerLabel setHidden:YES];

        strPosterUrl = cellData[@"carousel_image"];
        if ((NSString *)[NSNull null] == strPosterUrl) {
            strPosterUrl=@"";
        } else {
            if (strPosterUrl == nil) {
                strPosterUrl=@"";
            }
        }
        
    }
    else
        strPosterUrl = cellData[@"image"];
    if ((NSString *)[NSNull null] == strPosterUrl) {
        strPosterUrl=@"";
    } else {
        if (strPosterUrl == nil) {
            strPosterUrl=@"";
        }
    }
    [cell.spinner setHidden:YES];
    //[cell.spinner startAnimating];
    
    NSString *typeString = cellData[@"type"];
    NSURL* imageUrl = [NSURL URLWithString:strPosterUrl];
//    asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0, 0, cell.blockPotraitImage.frame.size.width, cell.blockPotraitImage.frame.size.height-20)];
//    [asyncImage setLoadingImage];
//    [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
//                            type:AsyncImageResizeTypeAspectRatio//AsyncImageResizeTypeCrop//
//                         isCache:YES];
    if([typeString isEqualToString:@"M"]) {
        [cell.blockPotraitImage setHidden:NO];
        [cell.blockSquareImage setHidden:YES];
        [cell.blockImage setHidden:YES];
        [cell.blockPotraitImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];//landscapePlace.jpg//landscapeLoader_show.jpg//landscape_Loader

    }
    else if([typeString isEqualToString:@"N"]) {
        [cell.blockPotraitImage setHidden:YES];
        [cell.blockSquareImage setHidden:NO];
        [cell.blockImage setHidden:YES];
        [cell setNeedsLayout];
        [cell.blockSquareImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];//potraitPlace.jpg//potraitLoader_network.jpg

    }
    else if([typeString isEqualToString:@"G"]){
        [cell.blockPotraitImage setHidden:YES];
        [cell.blockSquareImage setHidden:NO];
        [cell.blockImage setHidden:YES];
        [cell.blockSquareImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"movie_Loader"]];//potraitLoader_network.jpg
    }
    else {
        [cell.blockPotraitImage setHidden:YES];
        [cell.blockSquareImage setHidden:YES];
        [cell.blockImage setHidden:NO];
        [cell.blockImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"show_Loader"]];//potraitLoader_network.jpg//portrait_Loader
    }
    //[self performSelector:@selector(stopSpinner) withObject:nil afterDelay:0.1];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellData = [self.collectionData objectAtIndex:[indexPath row]];
    
    if([_currentViewStr isEqualToString:@"MovieViewAppManager"]){
        ///[[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionViewForMovie" object:cellData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemInCellAppManager" object:cellData];
    }
    else if([_currentViewStr isEqualToString:@"OnDemandView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionViewForOnDemand" object:cellData];
    }
    else if([_currentViewStr isEqualToString:@"PayPerView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionViewForPayPerView" object:cellData];
    }
    else if([_currentViewStr isEqualToString:@"GamesView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionViewForGamesView" object:cellData];
    }
    else if([_currentViewStr isEqualToString:@"SubscriptionView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromSubscriptionView" object:cellData];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:cellData];
    }
}

#pragma mark - IBAction
-(IBAction)indexAction:(UIButton *)sender{
    if([_currentViewStr  isEqualToString:@"SubscriptionView"]) {
//        NSInteger index = sender.tag;
//        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
//        NSMutableDictionary *cellData = [NSMutableDictionary new];
//        cellData = [self.collectionData objectAtIndex:index];
//        [cellData setObject:indexStr forKey:@"index"];

        NSArray *cellData = self.collectionData;//[self.collectionData objectAtIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectSubscript" object:cellData];

    }else{
    NSLog(@"button tag-->%ld",(long)sender.tag);
    NSLog(@"INDEX");
    NSInteger index = sender.tag;
    NSDictionary *cellData = [self.collectionData objectAtIndex:index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionViewForMovie" object:cellData];
    }
}

#pragma mark - IBAction
- (void)stopSpinner {
    [cell.spinner stopAnimating];
    [cell.spinner setHidden:YES];

}
-(IBAction)addButtonAction:(UIButton *)sender {
    NSLog(@"button tag-->%ld",(long)sender.tag);
    NSLog(@"ADD ACTION");
    NSInteger index = sender.tag;
    NSDictionary *cellData = [self.collectionData objectAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectAddAction" object:cellData];
}

-(void) subscribeActionMethod:(UIButton *)sender{
    NSLog(@"button tag-->%ld",(long)sender.tag);
    NSLog(@"ADD ACTION");
    NSInteger index = sender.tag;
    
    NSDictionary *cellData = [self.collectionData objectAtIndex:index];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary new ];
    
    tempDict = (NSMutableDictionary*)cellData;
    
    NSString * isSubscribed = cellData[@"subscribed"];
    
    if([isSubscribed isEqualToString:@"YES"]){
        [tempDict setObject:@"NO" forKey:@"subscribed"];
    }
    else{
        [tempDict setObject:@"YES"forKey:@"subscribed"];
    }
    
    NSMutableArray *tempArrayCollection = [NSMutableArray new ];
    
    tempArrayCollection = (NSMutableArray*)self.collectionData;
    
    [tempArrayCollection replaceObjectAtIndex:index withObject:tempDict];
    
     [_collectionView reloadData];
    
    NSLog(@"cellData --> %@",cellData);
}
-(IBAction)subscribeIndexAction:(UIButton *)sender{
        //        NSInteger index = sender.tag;
       // NSArray *cellData = self.collectionData;//[self.collectionData objectAtIndex:index];
    
    //NSLog(@"cellData --> %@",cellData);
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectSubscript" object:cellData];
        
    NSInteger index = sender.tag;
    
    NSDictionary *cellData = [self.collectionData objectAtIndex:index];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary new ];
    
    tempDict = (NSMutableDictionary*)cellData;
    
    NSString * isSubscribed = cellData[@"subscribed"];
    NSString *subsSelection ;
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
    if([isSubscribed isEqualToString:@"YES"]){
        [tempDict setObject:@"NO" forKey:@"subscribed"];
        subsSelection=@"NO";
    }
    else{
        [tempDict setObject:@"YES"forKey:@"subscribed"];
         subsSelection=@"YES";
    }
    
    NSMutableArray *tempArrayCollection = [NSMutableArray new ];
    
//    tempArrayCollection = (NSMutableArray*)self.collectionData;
    NSMutableDictionary *tempDict1;
    for(NSDictionary *dict in self.collectionData) {
        tempDict1 = [NSMutableDictionary new];
        tempDict1 = [dict mutableCopy];
        if([subsSelection isEqualToString:@"YES"])
            [tempDict1 setObject:@"YES" forKey:@"subscribed"];
        else
            [tempDict1 setObject:@"NO" forKey:@"subscribed"];
        [tempDict1 setObject:indexStr forKey:@"index"];
        [tempArrayCollection addObject:tempDict];

    }
    
//    [tempArrayCollection replaceObjectAtIndex:index withObject:tempDict];
    
    [_collectionView reloadData];
    
    NSLog(@"cellData --> %@",cellData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectSubscript" object:tempDict1];
}


-(IBAction)actionRight:(UIButton *)sender {
    //    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    [self.collectionView scrollToItemAtIndexPath:visibleIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}
-(IBAction)actionLeft:(UIButton *)sender {
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    
    [self.collectionView scrollToItemAtIndexPath:visibleIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void) snapRightToCellAtIndex:(NSInteger)index section:(int)currentSection withAnimation:(BOOL) animated {
    NSIndexPath *nextItem = [NSIndexPath indexPathForItem:index inSection:currentSection];
    [_collectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionRight animated:animated];
}

- (void) snapLeftToCellAtIndex:(NSInteger)index section:(int)currentSection withAnimation:(BOOL) animated
{
    NSIndexPath *prevItem = [NSIndexPath indexPathForItem:index inSection:currentSection];
    [_collectionView scrollToItemAtIndexPath:prevItem atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}
@end
