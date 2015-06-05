//
//  DTDAppDelegate.h
//  Bumpn
//
//  Created by Nate Berman on 7/19/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreLocation/CoreLocation.h>
#import "DataManager.h"

static NSUInteger const kPostMaximumCharacterCount = 200;

static double const kFeetPerMeter = 0.3048; // this is an exact value.
static double const kFeetPerYard = 3;
static double const kMetersPerYard = 1.09361;
static double const kYardsPerKilometer = 1093.61;
static double const kYardsPerMile = 1760;
static double const kMetersPerMile = 1609.34;
static double const kKilometersPerYard = 0.0009144;
static double const kFeetPerMile = 5280.0; // this is an exact value.
static double const kKilometersPerMile = 1.60934;
static double const kMilesPerKilometer = 0.621371;
static double const kWallPostMaximumSearchDistance = 100.0;
static double const kMetersInAKilometer = 1000.0; // this is an exact value.

static NSUInteger const kWallPostsSearch = 20; // query limit for pins and tableviewcells

// Parse API key constants:
static NSString * const kParsePostsClassKey = @"Posts";
static NSString * const kParseUserKey = @"user";
static NSString * const kParseUsernameKey = @"username";
static NSString * const kParseTitleKey = @"title";
static NSString * const kParseLocationKey = @"location";

// NSNotification userInfo keys:
static NSString * const kJustLaunched = @"justLaunched";
static NSString * const kRefreshTimerKey = @"refreshTimer";
static NSString * const kRangeSliderKey = @"rangeSider";
static NSString * const kFilterDistanceKey = @"filterDistance";
static NSString * const kLocationKey = @"location";

static double const kSecondsBetweenRefresh = 60.0;

// Notification names:
static NSString * const kFilterDistanceChangeNotification = @"kFilterDistanceChangeNotification";
static NSString * const kLocationChangeNotification = @"kLocationChangeNotification";
static NSString * const kPostCreatedNotification = @"kPostCreatedNotification";

// UI strings:
static NSString * const kCantViewPost = @"Can’t view post! Get closer.";

#define LocationAccuracy double

@interface DTDAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIViewController *viewController;

@property (nonatomic, assign) CLLocationAccuracy filterDistance;

@end
