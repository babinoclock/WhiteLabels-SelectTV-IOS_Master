//
//  MyAccountCustomCell.m
//  SidebarDemo
//
//  Created by ocsdeveloper9 on 6/29/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "MyAccountCustomCell.h"

@implementation MyAccountCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self)
//    {
////        [self cellDesign];
//        [_accountLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//
//        
//        self.backgroundColor = [UIColor blackColor];
//        _accountLabel.textAlignment = NSTextAlignmentRight;
//        [_accountField setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
//        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
//        _accountField.leftView = paddingView;
//        _accountField.leftViewMode = UITextFieldViewModeAlways;
//        [_accountField setBackgroundColor:[UIColor whiteColor]];
//        _accountField.delegate = self;
//
//        
//    }
//    return self;
//    
//}

-(void)cellDesign {
    
    CGFloat labelWidth = (SCREEN_WIDTH/2.5);
    
    _accountLabel
    = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, labelWidth, 30)];
    _accountLabel.backgroundColor = [UIColor clearColor];
    _accountLabel.textAlignment = NSTextAlignmentRight;
    _accountLabel.numberOfLines = 0;
    [_accountLabel setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    _accountLabel.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_accountLabel];
    
    CGFloat FieldWidth =  (SCREEN_WIDTH-labelWidth)-20  ;//(SCREEN_WIDTH/1.5)-40
    
    _accountField = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+10, 10, FieldWidth, 30)];
    _accountField.backgroundColor = [UIColor whiteColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
     [_accountField setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    _accountField.leftView = paddingView;
    _accountField.leftViewMode = UITextFieldViewModeAlways;
    _accountField.delegate = self;
    [self.contentView addSubview:_accountField];
    
//     CGFloat buttonWidth = (SCREEN_WIDTH/2)-60;
//    _genderButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2)+10, 10, buttonWidth, 30)];
//    [_genderButton setBackgroundColor:[UIColor whiteColor]];
////    [genderButton addTarget:self
////                     action:@selector(genderClicked:)
////           forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_genderButton];

    
    
    
    
}

@end
