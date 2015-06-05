//
//  PostObject.h
//  Bumpn
//
//  Created by Nate Berman on 8/24/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface PostObject : PFObject

//@protocol MKAnnotation <NSObject>

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

// Other properties:
@property (nonatomic, readonly) PFObject *object;
@property (nonatomic, strong, readonly) PFGeoPoint *geopoint;
@property (nonatomic, strong, readonly) PFUser *user;
@property (nonatomic, assign) BOOL animatesDrop;
@property (nonatomic, readonly) MKPinAnnotationColor pinColor;

@property (nonatomic) BOOL expanded;

// Designated initializer.
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubtitle:(NSString *)subtitle;
- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToPost:(PostObject *)aPost;

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside;

@end
