//
//  UIImage+ImageResize.m
//  Causette
//
//  Created by OCS Developer 1 on 31/01/14.
//  Copyright (c) 2014 Appsolute. All rights reserved.
//

#import "UIImage+ImageResize.h"

@implementation UIImage (ImageResize)

-(UIImage *)resizeImageWithSize:(CGSize)size
{
	int w = self.size.width;
    int h = self.size.height;
	
	CGImageRef imageRef = [self CGImage];
	
	int width, height;
	
    //	int destWidth   = 640;
    //	int destHeight  = 480;
    
    int destWidth   = size.width;
	int destHeight  = size.height;
    
	if(w > h){
		width = destWidth;
		height = h*destWidth/w;
	} else {
		height = destHeight;
		width = w*destHeight/h;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGContextRef bitmap;
	bitmap = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedFirst);

	
	if (self.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, M_PI/2);
		CGContextTranslateCTM (bitmap, 0, -height);
		
	} else if (self.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, -M_PI/2);
		CGContextTranslateCTM (bitmap, -width, 0);
		
	} else if (self.imageOrientation == UIImageOrientationUp) {
		
	} else if (self.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, -M_PI);
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
}

@end
