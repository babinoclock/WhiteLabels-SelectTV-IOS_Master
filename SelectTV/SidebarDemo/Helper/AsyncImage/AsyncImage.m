//
//  AsyncImage.m
//  Causette
//
//  Created by ocsdeveloper12 on 29/09/14.
//  Copyright (c) 2014 OclockSoftware. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AsyncImage.h"

#import <CommonCrypto/CommonCrypto.h>

#include <sys/xattr.h>

#define AsyncImageResizeTypeIsCrop(type)    (type==AsyncImageResizeTypeCrop)

#define AsyncImageResizeTypeIsRatio(type)   (type==AsyncImageResizeTypeRatio)

@implementation AsyncImage

// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time.

@synthesize activityIndicator,asyncdelegate,folderName;

+ (NSString *) getMainFolderPath {
    
    NSArray *paths                  =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory    =   [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"ImageCacheFolder"];
}

+ (NSString *)getImagePathForURL:(NSURL *)imgURL {
    
    NSString *imagePathStr          =   @"";
    
    imagePathStr    =   [self getMainFolderPath];
    
//    imagePathStr    =   [imagePathStr stringByAppendingPathComponent:OTHER_IMAGES];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePathStr])
        [[NSFileManager defaultManager] createDirectoryAtPath :imagePathStr withIntermediateDirectories:YES attributes:nil error:nil];
    
    imagePathStr    =   [imagePathStr stringByAppendingPathComponent:[[imgURL absoluteString] lastPathComponent]];
    
    return imagePathStr;
}

- (void)setLoadingImage
{
    activityIndicator  =   [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    CGFloat xPos,yPos;
    
    xPos = 70;
    
    yPos = 70;
    
    if(self.frame.size.width > 0) {
        
        xPos = (self.frame.size.width - 20.0) / 2;
        
        yPos = (self.frame.size.height - 20.0) / 2;
    }
    
    activityIndicator.frame             =   CGRectMake(xPos, yPos, 20.0, 20.0);
    
    activityIndicator.hidesWhenStopped  =   YES;
    
    [self addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    [activityIndicator setNeedsLayout];
    
    [self setNeedsLayout];
}

- (void)loadImageFromURL:(NSURL *)url type:(AsyncImageResizeType)_type isCache:(BOOL)iscache {
    
    isimgCached         =   iscache;
    
    resizeType          =   _type;
    
    imagePath           =   [AsyncImage getImagePathForURL:url];
    
    BOOL isFileExist    =   NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        
        isFileExist     =   YES;
        
    }
    
    if (isFileExist) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
            localImage  =   [UIImage imageWithContentsOfFile:imagePath];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self resizeImageFromPath : NO];
                
            });
            
        });
    }
    else {
        
        if ([self animationType] != AsyncImageViewAnimationTypeRotation)
            [self setLoadingImage];
        
        if (connection != nil)
            
            if (data != nil){ }
        
        NSURLRequest * request  =   [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        connection              =   [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
    }
}

#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    
	if (data == nil)
        data    =   [[NSMutableData alloc] initWithCapacity:2048];
    
	[data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    statusCode = (int)[(NSHTTPURLResponse*)response statusCode];
    
    //CPLog(@"%d",statusCode);
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    responseString  =   [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
	connection      =   nil;
    
    if(statusCode == 200){
        
        if(![imagePath isEqualToString:@""])
        {
            if(isimgCached){
                
                [data writeToFile:imagePath atomically:YES];
                
                [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:imagePath]];
            }
        }
        
        [self resizeImageFromPath : YES];
    }
    else{
        
        [activityIndicator stopAnimating];
    }
}

-(void)resizeImageFromPath : (BOOL) isImageDownloadedFromOnline {
    
    UIImage * thisImage;
    
    if (localImage == nil) {
        thisImage = [UIImage imageWithData:data];
    }else {
        thisImage = localImage;
    }

    //make an image view for the image
    
    if ([[self subviews] count] > 0) {
        
        //then this must be another image, the old one is still in subviews
        
        [[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
    }
    
    if(!thisImage) {
        return;
    }
    
    UIImage     * resizedImage;
    
    UIImageView * imageView;
    
    if (AsyncImageResizeTypeIsCrop(resizeType)) {
        
        resizedImage            =   [self  resizeImage:thisImage targetSize:self.frame.size];
        
        //make an image view for the image
        imageView               =   [[UIImageView alloc] initWithImage:resizedImage];
        
        imageView.contentMode   =   UIViewContentModeScaleAspectFit;
    }
    else if (AsyncImageResizeTypeIsRatio(resizeType)) {
        
        int _newImageWidth      =   self.frame.size.width;
        
        int _newImageHeight;
        
        if (thisImage.size.width <= self.frame.size.width) {
            
            _newImageWidth      =   thisImage.size.width;
            
            _newImageHeight     =   thisImage.size.height;
        }
        else {
            
            if (thisImage.size.height <= thisImage.size.width || thisImage.size.width > self.frame.size.width) {
                
                _newImageWidth  =   self.frame.size.width;
                
                _newImageHeight =   (thisImage.size.height / thisImage.size.width)*_newImageWidth;
            }
            else {
                
                if (thisImage.size.height < 480)
                    _newImageHeight     =   thisImage.size.height;
                else
                    _newImageHeight     =   480;
                
                _newImageWidth  = (thisImage.size.width/thisImage.size.height) * _newImageHeight;
            }
        }
        
        int intX                =   (self.frame.size.width - _newImageWidth) / 2;
        
        imageView               =   [[UIImageView alloc] initWithFrame:CGRectMake(intX, 0, _newImageWidth, _newImageHeight)];
        
        //imageView.contentMode   =   UIViewContentModeScaleAspectFill;
        
        //imageView.clipsToBounds =   YES;
        
        resizedImage            =   [self  resizeImage:thisImage targetSize:imageView.frame.size];
        
        imageView.image         =   resizedImage;
        
        if([self.asyncdelegate respondsToSelector:@selector(refreshContents:withHeight:)])
              [self.asyncdelegate refreshContents:_newImageWidth withHeight:_newImageHeight];
    }
    else {
        resizedImage            =   [self resizeimageScaled:thisImage targetSize:self.frame.size ];
        
        imageView               =   [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        imageView.image         =   resizedImage;
        
        imageView.contentMode   =   UIViewContentModeScaleAspectFit;
    }
    
    [imageView setBackgroundColor:[UIColor clearColor]];
	
	CGRect goodBounds = [self bounds];
	
	CGPoint viewCenterPoint = CGPointMake(CGRectGetWidth([self bounds]) / 2, CGRectGetHeight([self bounds]) / 2);
	
	CAShapeLayer *circleMaskLayer = [CAShapeLayer layer];
	
	[circleMaskLayer setFrame: [self frame]];
	
	UIBezierPath *initialCircleBezier;
	
	if ([self animationType] == AsyncImageViewAnimationTypeFade)
		[imageView setAlpha: 0];
	else if ([self animationType] == AsyncImageViewAnimationTypeSlide)
	{
		CGRect hiddenBounds = [self bounds];
		
		hiddenBounds.origin.y = -CGRectGetHeight(hiddenBounds);
		
		[self setBounds: hiddenBounds];
	}
	else if ([self animationType] == AsyncImageViewAnimationTypeCircle)
	{
		initialCircleBezier = [UIBezierPath bezierPathWithArcCenter: viewCenterPoint
															  radius: 0
														   startAngle: 0
															endAngle: 2 * M_PI
														    clockwise: NO];
		
		[circleMaskLayer setPath: [initialCircleBezier CGPath]];
		
		[[self layer] setMask: circleMaskLayer];
	}
	
    [self addSubview:imageView];
    
    [activityIndicator stopAnimating];
    
    thisImage   =   nil;
    
    data        =   nil;
	
	if ([self animationType] == AsyncImageViewAnimationTypeFade)
	{
		[UIView animateWithDuration: .2
						  delay: .2
						options: 0
					  animations: ^{
						  [imageView setAlpha: 1];
					  }
					  completion: NULL];
	}
	else if ([self animationType] == AsyncImageViewAnimationTypeSlide)
	{
		[UIView animateWithDuration: .2
						  delay: .2
			usingSpringWithDamping: .6
			 initialSpringVelocity: .5
						options: 0
					  animations: ^{
						  [self setBounds: goodBounds];
					  }
					  completion: NULL];		
	}
	else if ([self animationType] == AsyncImageViewAnimationTypeCircle)
	{
		UIBezierPath *largerCircleBezier = [UIBezierPath bezierPathWithArcCenter: viewCenterPoint
															 radius: [self cirlcleAnimationRadius]
														  startAngle: 0
														    endAngle: 2 * M_PI
														   clockwise: NO];
		
		CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
		
		[basicAnimation setFromValue: (id) [initialCircleBezier CGPath]];
		
		[basicAnimation setToValue: (id) [largerCircleBezier CGPath]];
		
		[basicAnimation setDuration: .2];
		
		[basicAnimation setTimeOffset: .2];
		
		[circleMaskLayer setPath: [largerCircleBezier CGPath]];
		
		[circleMaskLayer addAnimation: basicAnimation forKey: @"Radius Animation"];
	}
    else if ([self animationType] == AsyncImageViewAnimationTypeRotation)
    {
        if(isImageDownloadedFromOnline)
            [self avatarImageDidStartAnimating:imageView];
    }
}

- (void)avatarImageDidStartAnimating:(UIImageView *)imageView
{
    // rotation animation
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    
    [anim setFromValue:[NSNumber numberWithDouble:M_PI_2]]; // rotation angle
    
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [anim setDuration:.4];
    
    [anim setRepeatCount:1];
    
    //    [anim setAutoreverses:YES];
    
    [anim setRemovedOnCompletion:YES];
    
    [imageView.layer addAnimation:anim forKey:@"iconShake"];
    
    
    // zoom effect animation
    
    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            imageView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma Mark - ImageResize

- (UIImage *)resizeImage:(UIImage *)imageToCrop  targetSize:(CGSize)_targetSize{
    return [imageToCrop imageCroppedToFitSize:_targetSize];
}

- (UIImage *)resizeimageScaled:(UIImage *)imageToCrop  targetSize:(CGSize)_targetSize{
    return [imageToCrop imageScaledToFitSize:_targetSize];
}

- (NSData *) imageData{
    return data;
}

//just in case you want to get the image directly, here it is in subviews

- (UIImage*) image{
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

#pragma mark- iCloud do not back up

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    // iOS >= 5.1
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

@end
