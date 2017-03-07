//
//  AsyncImage.h
//  Causette
//
//  Created by ocsdeveloper12 on 29/09/14.
//  Copyright (c) 2014 OclockSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ProportionalFill.h"
#import "UIImage+Tint.h"

typedef NS_ENUM(NSUInteger, AsyncImageViewAnimationType)
{
	AsyncImageViewAnimationTypeNone = 0,
	AsyncImageViewAnimationTypeFade,
	AsyncImageViewAnimationTypeSlide,
	AsyncImageViewAnimationTypeCircle,
    AsyncImageViewAnimationTypeRotation
};

typedef enum {
    AsyncImageResizeTypeCrop,
    AsyncImageResizeTypeRatio,
    AsyncImageResizeTypeAspectRatio,
}AsyncImageResizeType;

@protocol AsyncImageDelegate <NSObject>

-(void)refreshContents:(float)originalwidth withHeight:(float)originalheight;

@end

@interface AsyncImage:   UIView {
    
    //could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to
	// to build into this class?
    
	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
	
    UIImage     *localImage;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSString *responseString;
    
    NSString *imagePath;
    
    AsyncImageResizeType resizeType;
    
    int statusCode;
    
    BOOL isimgCached;
}

@property(nonatomic,retain) UIActivityIndicatorView *activityIndicator;

@property(nonatomic,retain) id<AsyncImageDelegate> asyncdelegate;

@property(nonatomic,retain) NSString *folderName;

@property (nonatomic, assign) AsyncImageViewAnimationType animationType;

@property (nonatomic, assign) CGFloat cirlcleAnimationRadius;

+ (NSString *) getMainFolderPath;

+ (NSString *)getImagePathForURL:(NSURL *)imgURL;

- (void)setLoadingImage;

- (void)loadImageFromURL:(NSURL *)url type:(AsyncImageResizeType)_type isCache:(BOOL)iscache;

- (UIImage*) image;

- (NSData *) imageData;

@end
