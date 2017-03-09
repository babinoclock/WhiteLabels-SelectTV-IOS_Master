//
//  MyAccountViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 22/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountCustomCell.h"

@interface MyAccountViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    //Scrolltitle
    //Scrolltitle
    MyAccountCustomCell *cell;
    
    NSArray *jsonArray;
    NSArray * genderpickerArray;
    NSMutableDictionary *userDetailsDictionary;
    NSMutableArray *userInitialArray;

    NSMutableDictionary *profileDetailsDict;
    
    UITextField *accountField;
    UITextField *currentTextfield;
    UILabel *accountLabel;
    
    UIView *leftBorder;
    UIView *rightBorder;
    UIView *topBorder;
    
    UIDatePicker *datePicker;
    
    UIButton *genderButton;
    id dropDownSender;
    
    NSString *firstName;
    NSString *lastName;
    NSString *email;
    NSString *gender;
    NSString *date_Of_BirthStr;
    NSString *postalCode;
    NSString *address1;
    NSString *address2;
    NSString *city;
    NSString *state;
    NSString *phoneNumber;
    NSString *userOldPassword;
    NSString *userNewPassword;
    NSString *userConfirmPassword;
    BOOL isFirstLoad;
    
    UIPickerView *genderPickerView;
    
    BOOL isOldPasswordTyped;
    NSString * currentApplanguage;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@end

@implementation MyAccountViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[_myAccountTable class]];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [_myAccountTable setBackgroundColor:[UIColor clearColor]];
    userDetailsDictionary = [[NSMutableDictionary alloc]init];
    userInitialArray       = [[NSMutableArray alloc]initWithCapacity:1];
    [_myAccountTable registerNib:[UINib nibWithNibName:@"MyAccountCustomCell" bundle:nil] forCellReuseIdentifier:@"MyAccountCustomCell"];
    //to get the Profile Details
    isFirstLoad =YES;
    [self getUserProfileDetails];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    genderpickerArray = [[NSArray alloc] init];
    genderpickerArray = [NSArray arrayWithObjects:@"Male",@"Female",nil];
    [_saveAction addTarget:self
                    action:@selector(saveClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dropDownHideAction:)];
    singleFingerTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleFingerTap];
    
    [self loadNavigation];
    [self setOrientation];
    
    
    
}

-(void) viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.tableHeight.constant = self.myAccountTable.contentSize.height;
    
    [self.view layoutIfNeeded];
    
}

-(void) loadNavigation{
    
    currentApplanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *titleStr = @"My Account";
    if([COMMON isSpanishLanguage]==YES){
        titleStr = [COMMON stringTranslatingIntoSpanish:titleStr];
    }
    self.title = titleStr;
    [self.navigationController.navigationBar setHidden:NO];
    UIFont *titleFont = [COMMON getResizeableFont:Roboto_Bold(TITLE_FONT_SIZE)];
    ///[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:titleFont}];
    
    self.navigationController.navigationBar.backgroundColor= GRAY_BG_COLOR;
    self.navigationController.navigationBar.tintColor = GRAY_BG_COLOR;
    self.navigationController.navigationBar.barTintColor = GRAY_BG_COLOR;
    
}
-(void)setOrientation{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myAccountOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    UIDevice* device = [UIDevice currentDevice];
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        [self rotateViews:false];
    }else{
        [self rotateViews:true];
    }
    
}
- (void)dropDownHideAction:(UITapGestureRecognizer *)recognizer {
    
    [dropDown hideDropDown:dropDownSender];
    [self rel];
    
}
#pragma mark - initialArrayValue
-(void)initialArrayValue{
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
    userDict = [COMMON getUserProfileDetails];
    
    firstName=@"";
    lastName =@"";
    email=@"";
    postalCode=@"";
    gender=@"";
    date_Of_BirthStr=@"";
    address1=@"";
    address2=@"";
    city=@"";
    state=@"";
    phoneNumber=@"";
    userOldPassword = @"";
    userNewPassword = @"";
    userConfirmPassword = @"";

    if ([userDict valueForKey:@"first_name"] != NULL) {
       firstName = [userDict valueForKey:@"first_name"];
    }
    if ([userDict valueForKey:@"first_name"] != NULL) {
        lastName = [userDict valueForKey:@"last_name"];
    }
    if ([userDict valueForKey:@"email"] != NULL) {
        email = [userDict valueForKey:@"email"];
    }
    if ([userDict valueForKey:@"postal_code"] != NULL) {
        postalCode = [userDict valueForKey:@"postal_code"];
    }
    if ([userDict valueForKey:@"gender"] != NULL) {
        gender = [userDict valueForKey:@"gender"];
        if([gender isEqualToString:@"M"]){
            gender = @"Male";
        }
        else{
            gender = @"Female";
        }
        
    }
    if ([userDict valueForKey:@"date_of_birth"] != NULL) {
        date_Of_BirthStr = [userDict valueForKey:@"date_of_birth"];
    }
    if ([userDict valueForKey:@"address_1"] != NULL) {
        address1 = [userDict valueForKey:@"address_1"];
    }
    if ([userDict valueForKey:@"address_2"] != NULL) {
        address2 = [userDict valueForKey:@"address_2"];
    }
    if ([userDict valueForKey:@"city"] != NULL) {
        city = [userDict valueForKey:@"city"];
    }
    if ([userDict valueForKey:@"state"] != NULL) {
        state = [userDict valueForKey:@"state"];
    }
    if ([userDict valueForKey:@"phone_number"] != NULL) {
       phoneNumber = [userDict valueForKey:@"phone_number"];
    }
    
}

#pragma mark - setInitial
- (void)setInitial {
    
    [self initialArrayValue];
    
    jsonArray = @[
                  
                  @{@"headertitle":@"BASIC INFO",
                    @"fields"     :@[@{@"title" :@"First Name",
                                       @"Value" :firstName
                                       },
                                     @{@"title" :@"Last Name",
                                       @"Value" :lastName
                                       },
                                     @{@"title" :@"Email",
                                       @"Value" :email
                                       },
                                     @{@"title" :@"Zip/Postal Code",
                                       @"Value" :postalCode
                                       }]
                    },
                  @{@"headertitle":@"OPTIONAL",
                    @"fields"     :@[@{@"title" :@"I Am",
                                       @"Value" :gender
                                       },
                                     @{@"title" :@"Birth Date",
                                       @"Value" :date_Of_BirthStr
                                       },
                                     @{@"title" :@"Street Address",
                                       @"Value" :address1
                                       },
                                     @{@"title" :@"Suite/Apt",
                                       @"Value" :address2
                                       },
                                     @{@"title" :@"City",
                                       @"Value" :city
                                       },
                                     @{@"title" :@"State",
                                       @"Value" :state
                                       },
                                     @{@"title" :@"Phone",
                                       @"Value" :phoneNumber
                                       }]
                    
                    },
                  @{@"headertitle":@"CHANGE PASSWORD",
                    @"fields"     :@[@{@"title" :@"Old Password",
                                       @"Value" :userOldPassword
                                       },
                                     @{@"title" :@"New Password",
                                       @"Value" :userNewPassword
                                       },
                                     @{@"title" :@"New Password Confirmation",
                                       @"Value" :userConfirmPassword
                                       }]
                    
                    },
                  
                  
                  ];
    NSLog(@"jsonArray-->%@",jsonArray);
    
    //[userInitialArray valueForKey:@"old_password"],[userInitialArray valueForKey:@"new_password"],[userInitialArray valueForKey:@"confirm_password"]
    
}
#pragma mark - getUserProfileDetails
-(void)getUserProfileDetails{
    [COMMON LoadIcon:self.view];
    NSMutableDictionary *tempDict = [COMMON getUserProfileDetails];
    
    if([tempDict count]!=0){
        [self loadTableData];
    }
    else{
        [[RabbitTVManager sharedManager]getUserProfileDetails:^(AFHTTPRequestOperation *request, id responseObject) {
            [COMMON storeUserProfileDetails:responseObject];
            [self loadTableData];
            
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [COMMON removeLoading];
        } strAccessToken: [COMMON getUserAccessToken]];
    }
}

#pragma mark - loadTableData
-(void)loadTableData{
    if(isFirstLoad==YES){
        [self setInitial];
        isFirstLoad=NO;
    }
    [self.myAccountTable reloadData];
    [COMMON removeLoading];
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation
//{
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    [_myAccountTable reloadRowsAtIndexPaths:[_myAccountTable indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
//}

#pragma mark - UITableviewDatasource & DelegateMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [jsonArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[jsonArray objectAtIndex:section] valueForKey:@"fields"] count];
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0,5, 200, 40)];
    [titleButton setTitle:[[jsonArray objectAtIndex:section] valueForKey:@"headertitle"] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[COMMON getResizeableFont:Roboto_Bold(14)]];
    [headerView addSubview:titleButton];
    rightBorder = [[UIView alloc] initWithFrame:CGRectMake(titleButton.frame.size.width-1.0f, 1, 1.5, titleButton.frame.size.height)];
    topBorder = [[UIView alloc] initWithFrame:CGRectMake(1, 0,titleButton.frame.size.width,1.0)];
    [self autoMaskingForBottomButtonBorder];
    [titleButton addSubview:topBorder];
    [titleButton addSubview:rightBorder];
    UILabel *bottomBorderLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleButton.frame.size.width, titleButton.frame.size.height+5, SCREEN_WIDTH-titleButton.frame.size.width, 1)];
    bottomBorderLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5];
    [headerView addSubview:bottomBorderLabel];
    headerView.backgroundColor = [UIColor clearColor];
    rightBorder.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5];
    topBorder.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5];
    return headerView;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyAccountCustomCell";//Cell
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[MyAccountCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.accountLabel setFont:[COMMON getResizeableFont:Roboto_Regular(10)]];
    cell.accountLabel.textAlignment = NSTextAlignmentRight;
    [cell.accountField setFont:[COMMON getResizeableFont:Roboto_Regular(12)]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    cell.accountField.leftView = paddingView;
    cell.accountField.leftViewMode = UITextFieldViewModeAlways;
    [cell.accountField setBackgroundColor:[UIColor whiteColor]];
    cell.accountField.delegate = self;

    NSString *fieldString = [[[[jsonArray objectAtIndex:indexPath.section] valueForKey:@"fields"]objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.accountLabel.text = fieldString;
    NSString *valueString = [[[[jsonArray objectAtIndex:indexPath.section] valueForKey:@"fields"]objectAtIndex:indexPath.row] valueForKey:@"Value"];
    
    [cell.accountLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5]];
    if (indexPath.section == 1 && indexPath.row == 0 ) {
        cell.accountField.tag = 200;
    }

   else if (indexPath.section == 1 && indexPath.row == 1 ) {
        cell.accountField.tag = 201;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.accountField.tag = 300;
        
    }
    if ([fieldString isEqualToString:@"Email"]) {
        
        [cell.accountField setKeyboardType:UIKeyboardTypeEmailAddress];
        
    } else if ([fieldString isEqualToString:@"Zip/Postal Code"] || [fieldString isEqualToString:@"Phone"]) {
        
        [cell.accountField setKeyboardType:UIKeyboardTypeNumberPad];
    }else {
        
    }
    
    if  ((NSString *)[NSNull null] != valueString ||valueString != nil) {
        
        cell.accountField.text = valueString ;
    }
   
    [cell setBackgroundColor:[UIColor clearColor]];
    
         return cell;
    
    
}
-(void)genderPickerView :(NSInteger)_tag{
    
    currentTextfield=(UITextField *)[self.view viewWithTag:_tag];
    genderPickerView = [[UIPickerView alloc]init];
    genderPickerView.dataSource = self;
    genderPickerView.delegate = self;
    genderPickerView.showsSelectionIndicator = YES;
    [genderPickerView setHidden:NO];
    currentTextfield.inputView = genderPickerView;

}

#pragma mark - Picker View Data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    return [genderpickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
   
   // [cell.accountField setText:[genderpickerArray objectAtIndex:row]];
    
    [currentTextfield setText:[genderpickerArray objectAtIndex:row]];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    
    return [genderpickerArray objectAtIndex:row];
}

-(void) autoMaskingForBottomButtonBorder{
    
    [topBorder setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [rightBorder setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
}

#pragma mark - UITextFieldDelegateMethood

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSInteger tag = [textField tag];
    
    if(textField.tag == 200){
        
        [self genderPickerView:tag];
        
    } else if(textField.tag == 201) {
        
        [self loadDatePicker:tag];
        
    } else if(textField.tag == 300){
        
        isOldPasswordTyped =YES;
    } else {
        
    }
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    
    id textFieldSuper = textField;
    
    while (![textFieldSuper isKindOfClass:[UITableViewCell class]]) {
        
        textFieldSuper = [textFieldSuper superview];
        
    }
    
    NSIndexPath *indexPath ;
    
    indexPath = [self.myAccountTable indexPathForCell:(UITableViewCell *)textFieldSuper];
    cell = (MyAccountCustomCell *) [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    if(cell.accountField.text==nil){
        cell.accountField.text =@"";
    }
    NSMutableDictionary *tempDict= [[NSMutableDictionary new]mutableCopy];
    [tempDict setValue:cell.accountLabel.text forKey:@"title"];
    [tempDict setValue:cell.accountField.text forKey:@"Value"];
    
    NSLog(@"jsonArray-->%@",[[[jsonArray objectAtIndex:indexPath.section] valueForKey:@"fields"] objectAtIndex:indexPath.row]);
    
    NSMutableArray *currentJsonArray =[(NSMutableArray*) jsonArray mutableCopy];
    NSMutableArray *currentArray =[(NSMutableArray*) [[jsonArray objectAtIndex:indexPath.section] valueForKey:@"fields"] mutableCopy];
    NSString *currentTitle =[(NSMutableArray*) [[jsonArray objectAtIndex:indexPath.section] valueForKey:@"headertitle"] mutableCopy];
    
    [currentArray  removeObjectAtIndex:indexPath.row];
    [currentArray insertObject:tempDict atIndex:indexPath.row];
    
    NSMutableDictionary *tempDict1= [[NSMutableDictionary new]mutableCopy];
    [tempDict1 setObject:currentArray forKey:@"fields"];
    [tempDict1 setObject:currentTitle forKey:@"headertitle"];
    
    [currentJsonArray  removeObjectAtIndex:indexPath.section];
    [currentJsonArray insertObject:tempDict1 atIndex:indexPath.section];
    
    jsonArray = [(NSArray*)currentJsonArray mutableCopy];
    
}


#pragma mark - ButtonAction Method

- (IBAction)genderClicked:(id)sender {
    
    dropDownSender = sender;
    if(dropDown == nil) {
        CGFloat f = 80;
        [dropDown setUserInteractionEnabled:YES];
        dropDown = [[NIDropDown alloc] showDropDown:sender :&f :genderpickerArray :nil :@"down"];
        //[[NIDropDown alloc]showDropDown:sender :&f :genderpickerArray  :@"down"];
        dropDown.delegate = self;
//        [_myAccountTable bringSubviewToFront:dropDown];
//        [_myAccountTable setUserInteractionEnabled:NO];
        [[_myAccountTable superview] bringSubviewToFront:dropDown];


    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
        [_myAccountTable setUserInteractionEnabled:YES];

    }
   
    
}



#pragma mark - niDropDownDelegateMethod

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    
    NSString *selectedLetter = genderButton.titleLabel.text;
    
    NSString * string = [NSString stringWithFormat:@"  %@",selectedLetter];
    [genderButton setTitle:string forState:UIControlStateNormal];
    genderButton.titleLabel.font =[COMMON getResizeableFont:Roboto_Bold(12)];
    [genderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    genderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
}

-(void)rel{
    
    dropDown = nil;
}

#pragma mark - LoadDatePickerMethod

-(void)loadDatePicker:(NSInteger)_tag{
    
    currentTextfield=(UITextField *)[self.view viewWithTag:_tag];
    
    datePicker   = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 320, 150)];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    // NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear: -100];
    NSDate * minDate = [calendar dateByAddingComponents: comps toDate: currentDate options: 0];
    
    [datePicker setMinimumDate:minDate];
    [datePicker setMaximumDate:maxDate];
    
    datePicker.backgroundColor = [UIColor whiteColor];
    
    [datePicker addTarget:self action:@selector(DateSelectionAction:) forControlEvents:UIControlEventValueChanged];
    
    datePicker.tag =_tag;
    
    //if([currentTextfield.text length] > 0  && ![currentTextfield.text isEqualToString:@"MM / DD / YYYY"]){
    if([currentTextfield.text length] > 0  && ![currentTextfield.text isEqualToString:@"yyyy-MM-dd"]){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //[dateFormatter setDateFormat:@"MM / dd / yyyy"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        
        dateFromString = [dateFormatter dateFromString:currentTextfield.text];
        
        [datePicker setDate:dateFromString animated:NO];
        
    }
    
    [currentTextfield setInputView:datePicker];
    
    currentTextfield.tintColor=[UIColor clearColor];
}


- (void)DateSelectionAction:(UIDatePicker *)sender
{
    currentTextfield=(UITextField *)[self.view viewWithTag:[sender tag]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    //[dateFormat setDateFormat:@"MM / dd / YYYY"];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString =  [dateFormat stringFromDate:sender.date];
    
    currentTextfield.text = dateString;
    
}


- (IBAction)saveClicked:(id)sender {
    
    NSLog(@"SAVED");
    
        if ([self isValidEntry]) {
             [self updateUserProfileDetails:userDetailsDictionary];
            if(isOldPasswordTyped==YES){
                [self changeUserPassword];
            }
        }
    //    NSLog(@"userDetailsDictionary--->%@",userDetailsDictionary);
    //
    //    [userInitialArray insertObject:userDetailsDictionary atIndex:0];
    //
    //    [COMMON storeUserProfileDetails:[userInitialArray copy]];
    //
    //
    
}

-(void)updateUserProfileDetails:(NSMutableDictionary *)UpdataDataDict{
    [COMMON LoadIcon:self.view];
    [[RabbitTVManager sharedManager]updateUserProfileDetails:^(AFHTTPRequestOperation *request, id responseObject)
     {  [COMMON removeLoading];
         [AppCommon showSimpleAlertWithMessage:@"Successfully Completed"];
         NSLog(@"ProfileUpdate-->%@",responseObject);
        //to save user profile details in nsuserdefaults
         [self getuserProfileDetails];
         [COMMON removeLoading];
     }failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"ProfileError-->%@",error);
         NSString *errorStr = @"Invalide or expired token, Please Login to Continue";
         [self alertView:errorStr];
         [COMMON removeLoading];

     } strAccessToken:[COMMON getUserAccessToken] data:UpdataDataDict];
    
}

-(void)getuserProfileDetails{
    [[RabbitTVManager sharedManager]getUserProfileDetails:^(AFHTTPRequestOperation *request, id responseObject) {
        [COMMON storeUserProfileDetails:responseObject];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [COMMON removeLoading];
    } strAccessToken: [COMMON getUserAccessToken]];
}

#pragma mark - alertView
-(void)alertView:(NSString *)errorStr{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE
                                                    message:errorStr
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok",nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //Cancel
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        //Ok
        [self logoutForTokenExpired];
        
    }
}

#pragma mark - logoutForTokenExpired
-(void)logoutForTokenExpired{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DEMO_VIDEO_PLAYED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [COMMON removeLoginDetails];
    [COMMON removeLoading];
    [self pushToLoginScreen];
}

#pragma mark - pushToLoginScreen
-(void)pushToLoginScreen{
    [[AppDelegate sharedAppDelegate] setVcCurrentID:@"mainNavController"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController * LoginVC = nil;
    LoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:LoginVC animated:YES];
}

-(void)changeUserPassword{
    [COMMON LoadIcon:self.view];
    if(![userOldPassword isEqualToString:@""] && ![userNewPassword isEqualToString:@""]){
        [[RabbitTVManager sharedManager]changeUserPassword:^(AFHTTPRequestOperation *request, id responseObject) {
            NSLog(@"Password-->%@",responseObject);
            [COMMON removeLoading];
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }strAccessToken:[COMMON getUserAccessToken] oldPassword:userOldPassword newPassword:userNewPassword];

    }
}

#pragma mark - Validation Functionalities

- (BOOL)isValidEntry{
    
    MyAccountCustomCell *nameCell            = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MyAccountCustomCell *lastNameCell       = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    MyAccountCustomCell *emailCell           = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    MyAccountCustomCell *postalCell        = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    MyAccountCustomCell *genderCell = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    MyAccountCustomCell *dateCell            = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    MyAccountCustomCell *addressCell       = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    MyAccountCustomCell *suiteCell           = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    MyAccountCustomCell *cityCell        = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    MyAccountCustomCell *stateCell = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
    MyAccountCustomCell *phoneCell = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
    
    MyAccountCustomCell *oldPasswordCell        = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    MyAccountCustomCell *newPasswordCell = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    MyAccountCustomCell *pwdConfirmationCell = [self.myAccountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
    
    [userDetailsDictionary setValue:nameCell.accountField.text forKey:@"first_name"];
    [userDetailsDictionary setValue:lastNameCell.accountField.text forKey:@"last_name"];
    [userDetailsDictionary setValue:emailCell.accountField.text forKey:@"email"];
    [userDetailsDictionary setValue:postalCell.accountField.text forKey:@"postal_code"];
    [userDetailsDictionary setValue:genderCell.accountField.text forKey:@"gender"];
    [userDetailsDictionary setValue:dateCell.accountField.text forKey:@"date_of_birth"];
    [userDetailsDictionary setValue:addressCell.accountField.text forKey:@"address_1"];
    [userDetailsDictionary setValue:suiteCell.accountField.text forKey:@"address_2"];
    [userDetailsDictionary setValue:cityCell.accountField.text forKey:@"city"];
    [userDetailsDictionary setValue:stateCell.accountField.text forKey:@"state"];
    [userDetailsDictionary setValue:phoneCell.accountField.text forKey:@"phone_number"];
    
    userOldPassword = oldPasswordCell.accountField.text;
    userNewPassword = newPasswordCell.accountField.text;
    userConfirmPassword = pwdConfirmationCell.accountField.text;
    
    //[userDetailsDictionary setValue:oldPasswordCell.accountField.text forKey:@"old_password"];
    //[userDetailsDictionary setValue:newPasswordCell.accountField.text forKey:@"new_password"];
    //[userDetailsDictionary setValue:pwdConfirmationCell.accountField.text forKey:@"confirm_password"];
    
    
    if ([NSString isEmpty: nameCell.accountField.text ] ||
        [NSString isEmpty: lastNameCell.accountField.text ] ||
        [NSString isEmpty: emailCell.accountField.text ] ||
        [NSString isEmpty: postalCell.accountField.text ] ||
        [NSString isEmpty: dateCell.accountField.text ]||
        [NSString isEmpty: addressCell.accountField.text ] ||
        [NSString isEmpty: suiteCell.accountField.text ] ||
        [NSString isEmpty: cityCell.accountField.text ]||
        [NSString isEmpty: stateCell.accountField.text ] ||
        [NSString isEmpty: phoneCell.accountField.text ]  ){
        
        [AppCommon showSimpleAlertWithMessage:@"Please Complete All Fields"];
        return NO;
    } else if (![NSString validateEmail:emailCell.accountField.text]) {
        
        [AppCommon showSimpleAlertWithMessage:@"Invalid Email"];
        
        return NO;
    }else if (![newPasswordCell.accountField.text isEqualToString:pwdConfirmationCell.accountField.text])
    {
        [AppCommon showSimpleAlertWithMessage:@"New Password is mismatches with confirmation password"];
        
        return NO;
    } else if (![NSString validatePostalCode:postalCell.accountField.text]){
        [AppCommon showSimpleAlertWithMessage:@"Invalid PostalCode"];
        return NO;
        
    }
    
    //else if (![NSString validatePhone:phoneCell.accountField.text]) {
    //   [AppCommon showSimpleAlertWithMessage:@"Invalid Phone No"];
    //    return NO;
    //}
    
    /*
    if ([NSString isEmpty: oldPasswordCell.accountField.text ] ||[NSString isEmpty: newPasswordCell.accountField.text ]||[NSString isEmpty: pwdConfirmationCell.accountField.text ]){
     */
        
    else if(isOldPasswordTyped==YES){
        
        if(![NSString isEmpty: oldPasswordCell.accountField.text]){
            if ([NSString isEmpty: newPasswordCell.accountField.text ]||[NSString isEmpty: pwdConfirmationCell.accountField.text ]){
                [AppCommon showSimpleAlertWithMessage:@"Please Complete Password Fields"];
                return NO;
            }
            else if (![newPasswordCell.accountField.text isEqualToString:pwdConfirmationCell.accountField.text])
            {
                [AppCommon showSimpleAlertWithMessage:@"New Password is mismatches with confirmation password"];
                return NO;
            }
        }
    }
   
    else {
        return YES;
    }
    return YES;
    
}

#pragma mark - orientationChanged
-(void) myAccountOrientationChanged:(NSNotification *) note
{
    UIDevice * devie = note.object;
    
    switch (devie.orientation) {
        case UIDeviceOrientationPortrait:
            //   case UIDeviceOrientationPortraitUpsideDown:
            [self rotateViews:true];
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self rotateViews:false];
            break;
            
        default:
            break;
    }
    
}

-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        return YES;
    } else {
        return NO;
    }
}



#pragma mark -Rotate View
-(void) rotateViews:(BOOL) bPortrait{
//    cell = nil;
//    for(UIView *views in [_myAccountTable subviews])
//        [views removeFromSuperview];

    if(bPortrait){
        
        
    }else{
        
        
    }
    
    if(isFirstLoad==YES){
        [self setInitial];
    }

    
    [self.myAccountTable reloadData];
    
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
  //    }

    
}

#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}


@end
