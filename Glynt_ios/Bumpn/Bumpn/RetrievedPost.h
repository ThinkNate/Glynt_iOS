//
//  RetrievedPost.h
//  Glynt
//
//  Created by Nate Berman on 4/21/15.
//  Copyright (c) 2015 Dream Team Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface RetrievedPost : NSObject

@property (nonatomic) PFObject *postObject;
@property (nonatomic) BOOL expanded;

@end
