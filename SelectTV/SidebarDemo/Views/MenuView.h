//
//  MenuView.h
//  SidebarDemo
//
//  Created by Solafort Yong on 11/3/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@protocol MenuViewDelegate <NSObject>

-(void)onDismissMenuView;
-(void)onWatchChanel:(NSString*)idCategory;

@end

@interface MenuView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) id<MenuViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableViewCats;
@property(nonatomic,retain) NSMutableArray* arrData;

-(void)initWithCategories:(NSMutableArray*) arrCats;
- (IBAction)cancelButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *iphoneCancel;
@property (strong, nonatomic) IBOutlet UIButton *ipadCancel;

@end
