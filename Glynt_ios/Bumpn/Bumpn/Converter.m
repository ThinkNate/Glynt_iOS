//
//  Converter.m
//  Bumpn
//
//  Created by Nate Berman on 8/16/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "Converter.h"

@implementation Converter

// converts an image to a binary of less than 10k
+ (NSData *)convertImageToBinary:(UIImage*) image {
    NSData *imageData = UIImageJPEGRepresentation(image, .0032);
    int iterations = 0;
    // this is where we set total final size to 10k
    while (imageData.length / 1000 >= 10) {
        image = [self convertImageWithImage:image toWidth:image.size.width/2 andHeight:image.size.height/2];
        imageData = UIImageJPEGRepresentation(image, .0032);
        iterations++;
        NSLog(@"iterations: %u",iterations);
    }
    int size = (int)imageData.length;
    NSLog(@"FINAL SIZE OF IMAGE: %i", size);
    return imageData;
}

+(UIImage*)convertImageWithImage:(UIImage*)image toWidth:(CGFloat)width andHeight:(CGFloat)height {
    UIGraphicsBeginImageContext( CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
