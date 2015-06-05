//
//  PostObject.m
//  Bumpn
//
//  Created by Nate Berman on 8/24/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "PostObject.h"
#import "DTDAppDelegate.h"

@interface PostObject ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation PostObject

@synthesize coordinate;
@synthesize animatesDrop;
@synthesize object;
@synthesize user;
@synthesize subtitle;
@synthesize pinColor;
@synthesize geopoint;
@synthesize title;
@synthesize expanded;


- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
		self.animatesDrop = NO;
	}
	return self;
}

- (id)initWithPFObject:(PFObject *)anObject {
	self.object = anObject;
	self.geopoint = [anObject objectForKey:kParseLocationKey];
	self.user = [anObject objectForKey:kParseUserKey];
    
	[anObject fetchIfNeeded];
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
	NSString *aTitle = [anObject objectForKey:kParseTitleKey];
	NSString *aUser = [[anObject objectForKey:kParseUserKey] objectForKey:kParseUsernameKey];
    
	return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aUser];
}

- (BOOL)equalToPost:(PostObject *)aPost {
	if (aPost == nil) {
		return NO;
	}
    
	if (aPost.object && self.object) {
		// We have a PFObject inside the PAWPost, use that instead.
		if ([aPost.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
		// Fallback code:
        
		if ([aPost.title compare:self.title] != NSOrderedSame ||
			[aPost.subtitle compare:self.subtitle] != NSOrderedSame ||
			aPost.coordinate.latitude != self.coordinate.latitude ||
			aPost.coordinate.longitude != self.coordinate.longitude ) {
			return NO;
		}
        
		return YES;
	}
}

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
	if (outside) {
		self.subtitle = nil;
		self.title = kCantViewPost;
		self.pinColor = MKPinAnnotationColorRed;
	} else {
		self.title = [self.object objectForKey:kParseTitleKey];
		self.subtitle = [[self.object objectForKey:kParseUserKey] objectForKey:kParseUsernameKey];
		self.pinColor = MKPinAnnotationColorGreen;
	}
}


@end
