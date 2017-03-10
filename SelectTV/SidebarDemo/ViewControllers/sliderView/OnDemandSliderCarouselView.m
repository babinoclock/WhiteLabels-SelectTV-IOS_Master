  //
//  SliderViewController.m
//  SidebarDemo
//
//  Created by OCS iOS Developer Raji on 16/08/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "OnDemandSliderCarouselView.h"
#import "AppConfig.h"
#import "RabbitTVManager.h"

@interface OnDemandSliderCarouselView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    UIImageView            *infoImage;
    UIView                 *pgDtView;
    UIImageView            *pageImageView;
    UIScrollView            *slideScroll;
    IBOutlet UIView        *divideViewOne;
    IBOutlet UIPageControl *infoPageControl;
    UIImageView            *blkdot;
    UIView                 *pageControlView;
   
    NSString               *pull;
    NSUInteger   j;
    NSUInteger   filterTableHt;
    NSTimer      *timer ,*timerHide;
        
    float xslider;
    NSInteger jslider;
    
    BOOL isTapping;
    NSString *scrolldragging;
    NSMutableArray *appListArrayItems;
    
    UITableView *onDemandSliderTableView;
    UIScrollView  *fullSlideScrollView;
    
    NSMutableArray *bannerImageArr;
    NSMutableArray *sliderImageArray;
    
    NSString *currentViewString;
    NSMutableArray * textSavingArray;
    NSString *currentTopicStr;
    
    NSString *currentApplanguage;
}

@end

@implementation OnDemandSliderCarouselView

+(OnDemandSliderCarouselView *)loadView{
    
    return [[NSBundle mainBundle]loadNibNamed:@"OnDemandSliderCarouselView" owner:self options:nil][0];
}

#pragma mark - isDeviceIpad
-(BOOL)isDeviceIpad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}
-(void)loadSliderShowImages:(NSMutableArray *)ImageArray carouselArray:(NSMutableArray *)carouselArray currentViewStr:(NSString *) currentViewStr currentTitleStr:(NSString *) currentTitleStr {
    
    currentApplanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    textSavingArray = [NSMutableArray new];
    currentViewString = currentViewStr;
    sliderImageArray = [NSMutableArray new];
    sliderImageArray = ImageArray;
    currentTopicStr = currentTitleStr;
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
     //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud_BG.png"]];
    
    self.backgroundColor= [COMMON Common_Screen_BG_Color];
    //self.backgroundColor = [UIColor clearColor];
    appListArrayItems =[NSMutableArray new];
    appListArrayItems= carouselArray;
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    fullSlideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fullSlideScrollView.delegate=self;
    fullSlideScrollView.scrollEnabled=YES;
    
    [self addSubview:fullSlideScrollView];
    
    UIDevice* device = [UIDevice currentDevice];
    
    CGFloat slideScrollHeight;
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight){
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            slideScrollHeight = SCREEN_HEIGHT/1.3;
        }
        else{
            slideScrollHeight = SCREEN_HEIGHT;
        }
        
    }
    else{
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            slideScrollHeight = SCREEN_HEIGHT/2.3;
        }
        else{
            slideScrollHeight = SCREEN_HEIGHT/2.5;
        }
        
    }
    slideScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, slideScrollHeight)];
    slideScroll.delegate=self;
    slideScroll.pagingEnabled=YES;
    slideScroll.scrollEnabled=YES;
    
    infoPageControl = [[UIPageControl alloc] init];
    infoPageControl.numberOfPages = 2;
    infoPageControl.currentPage = 0;
    [slideScroll addSubview:infoPageControl];
    [infoPageControl setHidden:YES];
    
    [fullSlideScrollView addSubview:slideScroll];
    [fullSlideScrollView setUserInteractionEnabled:YES];
    
    for(int i = 0; i < [ImageArray count]; i++)
    {
        NSArray *tempArray = [ImageArray objectAtIndex:i];
        
        NSString* strName = [tempArray valueForKey:@"name"];
        NSString* strTitle = [tempArray valueForKey:@"title"];
        NSString* strDesc = [tempArray valueForKey:@"description"];
        NSString* strPosterUrl = [tempArray valueForKey:@"image"];
                
        if ((NSString *)[NSNull null] == strName||strName == nil) {
            strName=@"";
        }
        if ((NSString *)[NSNull null] == strTitle||strTitle == nil) {
            strTitle=@"";
        }
        if ((NSString *)[NSNull null] == strDesc||strDesc == nil) {
            strDesc=@"";
        }
        if ((NSString *)[NSNull null] == strPosterUrl||strPosterUrl == nil) {
            strPosterUrl=@"";
        }
        
        infoImage = [[UIImageView alloc] initWithFrame:CGRectMake(i*(self.frame.size.width)+0, 0, self.frame.size.width, slideScroll.frame.size.height)];
        infoImage.tag = i;//+1;
        
        AsyncImage *asyncImage = [[AsyncImage alloc]initWithFrame:CGRectMake(0, 0, infoImage.frame.size.width, infoImage.frame.size.height)];
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderImageAction:)];
        tapGesture1.delegate=self;
        tapGesture1.numberOfTapsRequired = 1;
        [infoImage addGestureRecognizer:tapGesture1];
        [infoImage setBackgroundColor:[UIColor clearColor]];
        [infoImage setUserInteractionEnabled:YES];
        
        [asyncImage setLoadingImage];
        [asyncImage loadImageFromURL:[NSURL URLWithString:strPosterUrl]
                                type:AsyncImageResizeTypeRatio//AsyncImageResizeTypeAspectRatio
                             isCache:YES];
        
        [infoImage setImageWithURL:[NSURL URLWithString:strPosterUrl]];
       // [infoImage addSubview:asyncImage];
        
        UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoImage.frame.size.width, infoImage.frame.size.height)];
        [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]];
        [infoImage addSubview:overlay];

        [slideScroll addSubview:infoImage];
        
        asyncImage.tag = i;
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderImageAction:)];
        tapGesture2.numberOfTapsRequired = 1;
        tapGesture2.delegate=self;
        [asyncImage addGestureRecognizer:tapGesture2];
        [asyncImage setBackgroundColor:[UIColor clearColor]];
        [asyncImage setUserInteractionEnabled:YES];
        
        CGFloat  sliderNameYPos = 0.0f;
        CGFloat sliderWatchBtnHeight=0.0f;
        int sliderNameSize,sliderTitleSize,sliderWatchBtnSize,sliderDescSize=0.0f;
        CGFloat sliderTitleYPosExtra=0.0f;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            sliderNameYPos=20;
            sliderWatchBtnHeight=50;
            sliderNameSize =20;
            sliderTitleSize = 19;
            sliderWatchBtnSize=17;
            sliderDescSize=15;
            sliderTitleYPosExtra =10;
        }
        else{
            sliderNameYPos=10;
            sliderWatchBtnHeight=40;
            sliderNameSize=15;
            sliderTitleSize= 13;
            sliderWatchBtnSize=14;
            sliderDescSize=12;
            sliderTitleYPosExtra =5;
        }
        
        CGFloat  commonXPosition =10;
        
        UILabel *sliderName = [[UILabel alloc]initWithFrame:CGRectMake(commonXPosition, sliderNameYPos, (infoImage.frame.size.width)-(commonXPosition*2), 30)];
        [sliderName setTextColor:[UIColor whiteColor]];
        [sliderName setText:strName];
        [sliderName setFont:[COMMON getResizeableFont:Roboto_Bold(sliderNameSize)]];
        sliderName.textAlignment=NSTextAlignmentLeft;
        [infoImage addSubview:sliderName];
        
        CGFloat  sliderTitleYPos = sliderName.frame.origin.y+sliderName.frame.size.height+sliderTitleYPosExtra;
        UILabel *sliderTitle = [[UILabel alloc]initWithFrame:CGRectMake(commonXPosition, sliderTitleYPos, (infoImage.frame.size.width)-(commonXPosition*2), 30)];
        [sliderTitle setTextColor:[UIColor whiteColor]];
        [sliderTitle setText:strTitle];
        
        [sliderTitle setFont:[COMMON getResizeableFont:Roboto_Regular(sliderTitleSize)]];
        sliderTitle.textAlignment=NSTextAlignmentLeft;
        [infoImage addSubview:sliderTitle];
        
        CGFloat  sliderDescYPos = sliderTitle.frame.origin.y+sliderTitle.frame.size.height+5;
        UILabel *sliderDesc = [[UILabel alloc]initWithFrame:CGRectMake(commonXPosition, sliderDescYPos, (infoImage.frame.size.width)-commonXPosition, infoImage.frame.size.height/4)];
        [sliderDesc setTextColor:[UIColor whiteColor]];
        [sliderDesc setText:strDesc];
        sliderDesc.numberOfLines= 0;
        [sliderDesc setFont:[COMMON getResizeableFont:Roboto_Regular(sliderDescSize)]];
        sliderDesc.textAlignment=NSTextAlignmentLeft;
        [infoImage addSubview:sliderDesc];
        
        //CGFloat  sliderWatchBtnYPos = sliderDesc.frame.origin.y+sliderDesc.frame.size.height+5;//infoImage.frame.size.height-80;
        NSString *watchButtonTittle = @"WATCH NOW";
        CGSize stringsize = [watchButtonTittle sizeWithAttributes:@{ NSFontAttributeName : [COMMON getResizeableFont:Roboto_Regular(17)] }];
        CGFloat  sliderWatchBtnYPos = sliderDesc.frame.origin.y+sliderDesc.frame.size.height+5;//infoImage.frame.size.height-80;
        UIButton *sliderWatchBtn = [[UIButton alloc]initWithFrame:CGRectMake(commonXPosition, sliderWatchBtnYPos, stringsize.width+20, sliderWatchBtnHeight)];
        [sliderWatchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sliderWatchBtn setTitle:@"WATCH NOW" forState:UIControlStateNormal];
        sliderWatchBtn.titleLabel.font = [COMMON getResizeableFont:Roboto_Regular(sliderWatchBtnSize)];
        sliderWatchBtn.backgroundColor = BORDER_BLUE;
        sliderWatchBtn.tag=i;
        [sliderWatchBtn addTarget:self action:@selector(watchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoImage addSubview:sliderWatchBtn];
        

        
    }
    
    [slideScroll setContentSize:CGSizeMake((ImageArray.count * self.frame.size.width),slideScroll.frame.size.height)];
    slideScroll.delegate=self;
    [slideScroll setUserInteractionEnabled:YES];

    xslider=0;
    pgDtView=[[UIView alloc]init];
    CGFloat width;
    pgDtView.backgroundColor=[UIColor clearColor];
    pageImageView =[[UIImageView alloc]init];
    infoPageControl.numberOfPages=ImageArray.count;
    CGFloat pageControlViewYPos =40.0f,pageControlViewHeight;
     if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
         pageControlViewHeight = 60;
     }
     else{
         pageControlViewHeight = 40;
     }
    pageControlView = [[UIView alloc]initWithFrame:CGRectMake(0, (slideScroll.frame.origin.y+slideScroll.frame.size.height)-(pageControlViewYPos), SCREEN_WIDTH, pageControlViewHeight)];
    [fullSlideScrollView addSubview:pageControlView];
     pageControlView.backgroundColor=[UIColor clearColor];

    int pageControlStartPos=0;
    int pageControlBtnSize=0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        pageControlStartPos =40;
        pageControlBtnSize = 20;
        
        
    }
    else{
        pageControlStartPos =30;
        pageControlBtnSize = 15;
    }
    for(int i=0;i<infoPageControl.numberOfPages;i++)
    {
        blkdot=[[UIImageView alloc]init];
        [blkdot setFrame:CGRectMake(i*pageControlStartPos, 0, pageControlBtnSize, pageControlBtnSize )];
        UIImage *btnImage1 = [[UIImage imageNamed:@"radio_Inactive"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [blkdot setImage:btnImage1];
        [blkdot setTintColor:[UIColor whiteColor]];
        [pgDtView addSubview:blkdot];
        [pageImageView setFrame:CGRectMake(0, 0,pageControlBtnSize,pageControlBtnSize)];
        UIImage *btnImage2 = [[UIImage imageNamed:@"radio_Active"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [pageImageView setImage:btnImage2];
        [pageImageView setTintColor:[UIColor whiteColor]];
        [pgDtView addSubview:pageImageView];
        
        
        width = infoPageControl.numberOfPages * pageControlStartPos;
        
        CGRect pageControlViewFrame = pageControlView.frame;
        pageControlViewFrame.size.width = width;
        pageControlView.frame = pageControlViewFrame;
        
//        CGRect frame = pageControlView.frame;
//        frame.origin.y =  (slideScroll.frame.origin.y+slideScroll.frame.size.height)-70;
//        [pageControlView setFrame:frame];
        
        //CGFloat pgDtViewXPos = (pageControlView.frame.size.width/2)-60;
        //[pgDtView setFrame:CGRectMake(pgDtViewXPos,10,pageControlView.frame.size.width-(pgDtViewXPos),40)];
        
        [pageControlView addSubview:pgDtView];
        
    }
    
    [pgDtView setFrame:CGRectMake(0,pageControlView.frame.size.height - 15,pageControlView.frame.size.width,40)];//10
    pageControlView.center = CGPointMake(fullSlideScrollView.center.x, (slideScroll.frame.origin.y+slideScroll.frame.size.height)-40);
    [pageControlView addSubview:pgDtView];

    
    bannerImageArr =[NSMutableArray new];
    bannerImageArr = ImageArray;
    [self timerFunction];

    [self loadTable];
    
}
-(void)timerFunction{
    j=bannerImageArr.count;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
   
}
-(void)startAgainloadbanner
{
    if (timer==nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    
}
-(void)nextPage
{
    int pageControlStartPos=0;
    int pageControlBtnSize=0;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        pageControlStartPos =40;
        pageControlBtnSize = 20;
    }
    else{
        pageControlStartPos =30;
        pageControlBtnSize = 15;
    }
    
    CGRect newRect;
    if(j < bannerImageArr.count){
        xslider += SCREEN_WIDTH;
        newRect = CGRectMake(xslider,0,SCREEN_WIDTH,140);
        UIImage *btnImage2 = [[UIImage imageNamed:@"radio_Active"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [pageImageView setImage:btnImage2];
        [pageImageView setTintColor:[UIColor whiteColor]];
        [slideScroll scrollRectToVisible:newRect animated:YES];
        [pageImageView setFrame:CGRectMake(j*pageControlStartPos, 0, pageControlBtnSize, pageControlBtnSize)];
        j++;
    }
    else{
        xslider=0-SCREEN_WIDTH;
        j=0;
        [slideScroll setContentOffset:CGPointMake(0, 0)];
        [pageImageView setFrame:CGRectMake(j*pageControlStartPos, 0, pageControlBtnSize, pageControlBtnSize)];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
     if  (scrollView== slideScroll)
    {
        [timer invalidate];
        timer=nil;
        [self performSelector:@selector(startAgainloadbanner) withObject:nil afterDelay:4.0];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageControlStartPos=0;
    int pageControlBtnSize=0;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        pageControlStartPos =40;
        pageControlBtnSize = 20;
    }
    else{
        pageControlStartPos =30;
        pageControlBtnSize = 15;
    }
    
    if(scrollView==slideScroll){
        pull=@"";
        jslider = scrollView.contentOffset.x/self.frame.size.width;
        [slideScroll setNeedsDisplay];
        infoPageControl.currentPage=jslider;
        [pageImageView setFrame:CGRectMake(jslider*pageControlStartPos, 0, pageControlBtnSize, pageControlBtnSize)];
    }
    
    isTapping=NO;
    scrolldragging=@"YES";
}


-(void)loadTable{
    CGFloat onDemandSliderTableViewYPos= 0.0f;
    CGFloat onDemandSliderScrollHeight= 0.0f;
    if([sliderImageArray count]==0){
        onDemandSliderTableViewYPos = 0;
        onDemandSliderScrollHeight = 0;
    }
    else {
        onDemandSliderTableViewYPos = slideScroll.frame.origin.y+slideScroll.frame.size.height+5;
        onDemandSliderScrollHeight  =  slideScroll.frame.size.height;
    }
    
    onDemandSliderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,onDemandSliderTableViewYPos, SCREEN_WIDTH,100 )];//(appListArrayItems.count *240)
    onDemandSliderTableView.delegate = self;
    onDemandSliderTableView.dataSource = self;
    onDemandSliderTableView.backgroundColor = [UIColor clearColor];
    onDemandSliderTableView.opaque = NO;
    onDemandSliderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [onDemandSliderTableView setScrollEnabled:NO];
    onDemandSliderTableView.bounces = NO;
    //onDemandSliderTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [fullSlideScrollView addSubview:onDemandSliderTableView];
    [onDemandSliderTableView reloadData];
    CGRect frame = onDemandSliderTableView.frame;
    frame.size = onDemandSliderTableView.contentSize;
    onDemandSliderTableView.frame = frame;
    [fullSlideScrollView setContentSize:CGSizeMake(0,(onDemandSliderTableView.frame.size.height+onDemandSliderScrollHeight)+150)];//+150

}

-(void)watchBtnAction:(id)sender{
    UIButton *button = (UIButton*)sender;
    
    NSInteger selectedIndex = button.tag;
    NSLog(@"selectedIndex-->%ld",(long)selectedIndex);
    NSMutableDictionary *viewAllData = [NSMutableDictionary new];
    viewAllData = [sliderImageArray objectAtIndex:selectedIndex];
    
    if([currentViewString isEqualToString:@"OnDemandView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sliderViewWatchNowAction" object:viewAllData];
  
    }
    else if([currentViewString isEqualToString:@"PayPerView"]){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"sliderViewWatchNowActionPayPerView" object:viewAllData];
    }
}
-(void)sliderImageAction:(UITapGestureRecognizer *)tap {
    
}
-(void)viewAllAction:(UITapGestureRecognizer *)tap {
    UILabel *currentLabel   = (UILabel *) tap.view;
    NSInteger selectedIndex = currentLabel.tag;
    
    NSMutableDictionary *dictItem =  appListArrayItems[selectedIndex];
    NSString *carouselId = dictItem[@"id"];
    //NSString *strHeaderTitle = dictItem[@"title"];
    NSMutableArray *itemsArray = dictItem[@"items"];
    NSString *type;
    if([itemsArray count]!=0){
        type = [[itemsArray objectAtIndex:0]valueForKey:@"type"];
    }
    if ((NSString *)[NSNull null] == type||type == nil) {
        type=@"";
    }
    
    NSMutableDictionary *viewAllData = [NSMutableDictionary new];
    
   // NSString *carouselId = [NSString stringWithFormat:@"%ld",(long)selectedIndex];
    [viewAllData setValue:carouselId forKey:@"carouselId"];
    [viewAllData setValue:type forKey:@"type"];
    
    if([currentViewString isEqualToString:@"OnDemandView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sliderViewAllOption" object:viewAllData];
  
    }
    else if([currentViewString isEqualToString:@"PayPerView"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sliderViewAllOptionPayPerView" object:viewAllData];
    }
    
}

-(id)loadTranslation:(NSString *)currentEnglishText{
    
    NSString * translatedText=@"";
    NSMutableDictionary *tempDict = [NSMutableDictionary new];
    tempDict = [[COMMON retrieveContentsFromFile:ONDEMAND_CAROUSEL_WORDS dataType:DataTypeDic] mutableCopy];
        
    NSMutableArray *tempArray =[NSMutableArray new];
    tempArray = [tempDict valueForKey:currentTopicStr];
    
    if([tempArray count]!=0){
        for(NSMutableDictionary * anEntry in [tempArray mutableCopy])
        {
            NSString *englishTextInDict = [anEntry valueForKey:ENGLIST_TEXT];
            
            if([englishTextInDict isEqualToString: currentEnglishText]){
                translatedText = [anEntry valueForKey:SPANISH_TEXT];
                
                break;
            }
            else{
                translatedText = [COMMON stringTranslatingIntoSpanish:currentEnglishText];
                //continue;
            }
            
        }

    }
    else{
        translatedText = [COMMON stringTranslatingIntoSpanish:currentEnglishText];
    }
    if ((NSString *)[NSNull null] == currentEnglishText||currentEnglishText == nil) {
        currentEnglishText=@"";
    }
    if ((NSString *)[NSNull null] == translatedText||translatedText == nil) {
        translatedText=@"";
    }
    if([translatedText isEqualToString:@""]){
        translatedText = currentEnglishText;
    }

    
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc]init];
    [myDictionary setValue:currentEnglishText forKey:ENGLIST_TEXT];
    [myDictionary setValue:translatedText forKey:SPANISH_TEXT];
    [textSavingArray addObject:myDictionary];
    
    //NSMutableArray *tempArray1 =[NSMutableArray new];
    //tempArray1 = [[tempDict valueForKey:currentViewString]valueForKey:currentTopicStr];
    
    NSMutableDictionary *currenTitleDict=[[NSMutableDictionary alloc]init];
    
    if([tempDict count]!=0){
        currenTitleDict = [tempDict mutableCopy];
    }
    [currenTitleDict setValue:[textSavingArray mutableCopy] forKey:currentTopicStr];
    
//    NSMutableArray *tempArray1 =[NSMutableArray new];
//    tempArray1 = [[tempDict valueForKey:currentViewString]valueForKey:currentTopicStr];

    NSLog(@"currenTitleDict-->%@-->",currenTitleDict);
    
    //NSMutableDictionary *tempSavingDict = [[NSMutableDictionary alloc]init];
    
    
   NSString *currentViewStr;
   // if([tempDict count]==0){
        if([currentViewString isEqualToString:@"OnDemandView"]){
            currentViewStr = ONDEMAND_CAROUSEL_WORDS;
            //[tempSavingDict  setObject:[currenTitleDict mutableCopy]  forKey:currentViewString];
        }
        else if([currentViewString isEqualToString:@"PayPerView"]){
            currentViewStr = PAYPERVIEW_CAROUSEL_WORDS;
            //[tempSavingDict setObject:[currenTitleDict mutableCopy]  forKey:currentViewString];
        }
    //}
    
    saveContentsToFile(currenTitleDict,currentViewStr);
    return translatedText;;

    

}

#pragma mark - Table view data source

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    [cell setBackgroundColor:[UIColor clearColor]];
//}
#pragma mark UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIView *headerView;
    NSString *strChannelName;
    NSMutableDictionary *dictItem;
    // NSString *carouselId = dictItem[@"id"];
    NSString *strHeaderTitle;
    NSString *strHeaderName;
    
    if([appListArrayItems count]!=0){
        dictItem =  appListArrayItems[section];
        strHeaderTitle = dictItem[@"title"];
        strHeaderName = dictItem[@"name"];
    }
   
    if(strHeaderTitle==nil||(NSString *)[NSNull null]==strHeaderTitle){
        strHeaderTitle = @"";
    }
    if(strHeaderName==nil||(NSString *)[NSNull null]==strHeaderName){
        strHeaderName = @"";
    }
    
    if([strHeaderTitle isEqualToString:@""]){
        strChannelName = strHeaderName;
    }
    else{
        strChannelName = strHeaderTitle;
    }
    
    CGFloat viewLabelWidth =130; 
    if(IS_IPHONE4||IS_IPHONE5){
        viewLabelWidth=100;
    }
    if(strChannelName==nil||(NSString *)[NSNull null]==strChannelName){
        strChannelName = @"";
    }

    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[strChannelName dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    strChannelName = [attr string];
    NSString *viewAllStr = @"VIEW ALL";
   if([COMMON isSpanishLanguage]==YES){
       strChannelName = [self loadTranslation:strChannelName];
       viewAllStr = [COMMON getViewAllStr];
       if ((NSString *)[NSNull null] == viewAllStr||viewAllStr == nil) {
           viewAllStr =@"VIEW ALL";
           viewAllStr =  [COMMON stringTranslatingIntoSpanish:viewAllStr];
           [[NSUserDefaults standardUserDefaults] setObject:viewAllStr forKey:VIEW_ALL];
           [[NSUserDefaults standardUserDefaults] synchronize];
       }
    }
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,headerView.frame.size.width-viewLabelWidth,30)];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = strChannelName;
    
    headerLabel.textColor=[UIColor whiteColor];//BORDER_BLUE;
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
    
    UILabel *viewAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width-(viewLabelWidth),2,viewLabelWidth,30)];
    viewAllLabel.textAlignment = NSTextAlignmentLeft;
    viewAllLabel.text = viewAllStr;
    viewAllLabel.textColor = [UIColor whiteColor];//BORDER_BLUE;
    viewAllLabel.backgroundColor = [UIColor clearColor];
    viewAllLabel.tag = section;//[carouselId intValue];
        
    int headerLabelFontSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        headerLabelFontSize=14;
    }
    else{
        headerLabelFontSize=12;
    }
    
    [headerLabel setFont:[COMMON getResizeableFont:Roboto_Bold(headerLabelFontSize)]];
    [viewAllLabel setFont:[COMMON getResizeableFont:Roboto_Bold(14)]];
      
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAllAction:)];
    tapGesture2.delegate=self;
    tapGesture2.numberOfTapsRequired = 1;
    [viewAllLabel addGestureRecognizer:tapGesture2];
    [viewAllLabel setUserInteractionEnabled:YES];
    [headerView addSubview:viewAllLabel];
    [headerView setUserInteractionEnabled:YES];
    return headerView;
        
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if([appListArrayItems count]!=0){
        NSDictionary *cellData = [appListArrayItems objectAtIndex:section] ;
        NSArray *BlockData = [cellData objectForKey:@"items"];
        if([BlockData count]!=0) {
            NSString *type =[[BlockData objectAtIndex:0]valueForKey:@"type"];
            if([type isEqualToString:@"M"]){
                return 55.0;
            }
        } else{
            return 40.0;
        }
    }
    else{
        return 0.0;
    }
    return 40.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if([appListArrayItems count]!=0){
        return appListArrayItems.count;
    }
    else{
        return 0;
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if([appListArrayItems count]!=0){
        NSMutableDictionary *dictItem =  appListArrayItems[indexPath.section];
        NSLog(@"dictItem%@-->",dictItem);
        NSDictionary *cellData = [appListArrayItems objectAtIndex:[indexPath section]] ;
        NSArray *BlockData = [cellData objectForKey:@"items"];
        if([BlockData count]!=0){
            
            NSString *type =[[BlockData objectAtIndex:0]valueForKey:@"type"];
            if([type isEqualToString:@"M"]){
                return 190.0;
            }
            else if([type isEqualToString:@"N"]||[type isEqualToString:@"G"]){
                return 130.0;
            }
            else {
                return 130.0;
            }
            
        }
        else{
            return 190.0;
        }

    }
    else{
        return 0.0;
    }
       //return 190.0;//170//160
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger nCount = 0;
   
    nCount = 1;
    
    return nCount;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"NKContainerCellTableViewCell%ld",(long)indexPath.section];
    NKContainerCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *BlockData;

    if (nil == cell) {

       // [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];

        cell = [[NKContainerCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier appManagerStr :@"NO"];

        NSDictionary *cellData = [appListArrayItems objectAtIndex:[indexPath section]] ;
        BlockData = [cellData objectForKey:@"items"];
        

        [cell setCollectionImageData:BlockData currentViewStr:currentViewString];

    }

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
    
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];    
}


#pragma mark-Orientation

-(BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
