//
//  StreamTableViewCell.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 27/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "FavTableViewCell.h"

@implementation FavTableViewCell
@synthesize showImageView,showTitle,showDesp,showRating,showRunTime,removeBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        CGRect frame = self.contentView.frame;
         frame.size.width= SCREEN_WIDTH;
        [self.contentView setFrame:frame];
        
        showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 75, 70)];
        [self.contentView addSubview:showImageView];
        
        CGFloat showTitleXPos = showImageView.frame.origin.x+showImageView.frame.size.width+2;
        showTitle = [[UILabel alloc]initWithFrame:CGRectMake(showTitleXPos, 0, (SCREEN_WIDTH-(showTitleXPos*2)-20), 40)];
        [self.contentView addSubview:showTitle];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            showDespWidth = 20;
            showWidth = 10;
            removeBtnWidth = 20;
            XPos = 2;
            RXPos = 2;
            runtimeFont = 7;
            ratingFont = 8;
        } else {
            showDespWidth = 50;
            showWidth = 20;
            removeBtnWidth = 20;
            XPos = -40;
            RXPos = -20;

            runtimeFont = 9;
            ratingFont = 10;
        }

        
        
        
         CGFloat showDespXPos =showImageView.frame.origin.x+showImageView.frame.size.width+2;
        showDesp = [[UILabel alloc]initWithFrame:CGRectMake(showDespXPos, showTitle.frame.origin.y+showTitle.frame.size.height, ((SCREEN_WIDTH-(showDespXPos*2))-showDespWidth), 40)];
        [self.contentView addSubview:showDesp];
        
        CGFloat showRatingXPos = showTitle.frame.origin.x+showTitle.frame.size.width+XPos;
        CGFloat showRatingYPos = 15;
        showRating = [[UILabel alloc]initWithFrame:CGRectMake(showRatingXPos, showRatingYPos, (SCREEN_WIDTH-(showRatingXPos)-showWidth), 15)];
        [self.contentView addSubview:showRating];
        
        
        CGFloat showRunTimeXPos = showTitle.frame.origin.x+showTitle.frame.size.width+XPos;
        CGFloat showRunTimeYPos = showRating.frame.origin.y+showRating.frame.size.height+5;
        showRunTime = [[UILabel alloc]initWithFrame:CGRectMake(showRunTimeXPos,showRunTimeYPos, (SCREEN_WIDTH-(showRunTimeXPos)-showWidth+10), 15)];
        [self.contentView addSubview:showRunTime];
        
        CGFloat removeBtnXPos = showDesp.frame.origin.x+showDesp.frame.size.width+2;
        removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(removeBtnXPos,showRunTime.frame.origin.y+showRunTime.frame.size.height+5, (SCREEN_WIDTH-(removeBtnXPos)-removeBtnWidth), 20)];
        [self.contentView addSubview:removeBtn];
        showDesp.lineBreakMode = NSLineBreakByWordWrapping;
        showTitle.numberOfLines= 0;
        showDesp.numberOfLines= 0;
        showRating.numberOfLines= 0;
        showRunTime.numberOfLines= 0;
        
        showTitle.textColor = [UIColor whiteColor];
        showDesp.textColor = [UIColor whiteColor];
        showRating.textColor = [UIColor whiteColor];
        showRunTime.textColor = [UIColor whiteColor];
        removeBtn.titleLabel.textColor = [UIColor whiteColor];
        
        showRating.textAlignment = NSTextAlignmentCenter;
        showRunTime.textAlignment = NSTextAlignmentCenter;
        
        [showTitle setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
        [showDesp setFont:[COMMON getResizeableFont:Roboto_Regular(10)]];
        [showRating setFont:[COMMON getResizeableFont:Roboto_Regular(ratingFont)]];
        [showRunTime setFont:[COMMON getResizeableFont:Roboto_Regular(runtimeFont)]];
        [removeBtn.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(11)]];
        [removeBtn setBackgroundColor:[UIColor redColor]];
        [removeBtn setTitle:@"REMOVE" forState:UIControlStateNormal];
        
//        [showImageView setBackgroundColor:[UIColor redColor]];
//        [showTitle setBackgroundColor:[UIColor grayColor]];
//        [showDesp setBackgroundColor:[UIColor lightGrayColor]];
//        [showRating setBackgroundColor:[UIColor darkGrayColor]];
//        [showRunTime setBackgroundColor:[UIColor lightGrayColor]];
       
   

    }
    return self;
    
}
-(void)addBorderToCell{
    UIView *leftBorder;
    UIView *rightBorder;
    UIView *topBorder;
    UIView *bottomBorder;
    leftBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0, 1.5, self.contentView.frame.size.height)];
    rightBorder = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-2.0f, 0, 1.0, self.contentView.frame.size.height)];
    topBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,self.contentView.frame.size.width,1.5)];
    bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-2.0f, self.contentView.frame.size.width, 1.5)];
    [self.contentView addSubview:leftBorder];
    [self.contentView addSubview:topBorder];
    [self.contentView addSubview:rightBorder];
    [self.contentView addSubview:bottomBorder];
    [leftBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [rightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    [topBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [bottomBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    leftBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                 green:151.0f/255.0f
                                                  blue:151.0f/255.0f
                                                 alpha:1.0f];
    rightBorder.backgroundColor = [UIColor redColor];
    topBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                green:151.0f/255.0f
                                                 blue:151.0f/255.0f
                                                alpha:1.0f];
    bottomBorder.backgroundColor = [UIColor colorWithRed:151.0f/255.0f
                                                   green:151.0f/255.0f
                                                    blue:151.0f/255.0f
                                                   alpha:1.0f];
}


@end
