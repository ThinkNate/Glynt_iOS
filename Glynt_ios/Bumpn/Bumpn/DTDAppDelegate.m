//
//  DTDAppDelegate.m
//  Bumpn
//
//  Created by Nate Berman on 7/19/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "DTDAppDelegate.h"
#import "Constants.h"
#import "MainView.h"
#import "DTDViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

@implementation DTDAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UIApplication sharedApplication] setStatusBarHidden:true];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UITextView appearance] setTintColor:[UIColor whiteColor]];
    

    // Parse
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"S6mdqHrkfPeNFiyDjlr6QM2skbyRC2wBX3RPrUWI" clientKey:@"9R7eknVGjMBpY3abJeHHB1iAfnsc8UC7W3gs0uGD"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // If Location Services are disabled, restricted or denied.
    if ((![CLLocationManager locationServicesEnabled])
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        NSLog(@"location authorization denied");
        // Send the user to the location settings preferences
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
        
    } else {
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [[self locationManager] startUpdatingLocation];
        _currentLocation = _locationManager.location;
    }
    
    // range
    [[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:kFilterDistanceKey];
    [[NSUserDefaults standardUserDefaults] setDouble:0.5 forKey:kRangeSliderKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
    
    // nav bar
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    [navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.barTintColor = PRIMARY_ORANGE_COLOR;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[self locationManager] stopUpdatingLocation];
    [self removeOldBumpd];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground user: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"user"]);
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive user: %@", [PFUser currentUser].username);//[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]);

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
    
    [[self locationManager] startUpdatingLocation];
    _currentLocation = _locationManager.location;
        
    NSLog(@"currentUser: %@", [PFUser currentUser] ? @"YES" : @"NO");
    
        if ([PFUser currentUser]) {
            if (_currentLocation) {
            // A user was cached, so skip straight to the main view
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                [navigationController setNavigationBarHidden:false];
            }
        } else {
            // No cached user so just present the welcome screen
            //UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            //navigationController.navigationBarHidden = YES;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
            UINavigationController *navigationVC = (UINavigationController*)self.window.rootViewController;
            MainView *mainVC = navigationVC.viewControllers[0];
            [mainVC presentViewController:loginViewController animated:true completion:^{
                //
            }];
        }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    if (newStatusBarFrame.size.height > 20) {
        @try {
            //[[[UIApplication sharedApplication] keyWindow] viewWithTag:200].frame = CGRectMake(0, newStatusBarFrame.size.height, 70, 60);
            //[[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame.size.width, newStatusBarFrame.size.height, [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame.size.width, [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame.size.height);
        }
        @catch (NSException *exception) {
            //
        }
        @finally {
            //
        }
    }
    else{
        @try {
            //[[[UIApplication sharedApplication] keyWindow] viewWithTag:200].frame = CGRectMake(0, 0, 70, 60);
            //[[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame.size.width, 0, [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame.size.width, [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].frame.size.height);
        }
        @catch (NSException *exception) {
            //
        }
        @finally {
            //
        }
    }
}

#pragma mark - CLLocationManagerDelegate
// lazy loading CLLocationManager
- (CLLocationManager*)locationManager {
    
    if (_locationManager != nil) {
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:10 * kMetersPerYard]; // 30yards (measured as meters)
    [_locationManager setActivityType:CLActivityTypeFitness];
    [_locationManager setDelegate:self];

    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ((![CLLocationManager locationServicesEnabled])
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        [_locationManager stopUpdatingLocation];
        NSLog(@"didFailWithError: %@", error);
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Are Disabled"
                                                             message:@"Please enable location services in your phone's settings"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    _currentLocation = location;
    if (fabs(howRecent) < 15.0) {
        _currentLocation = location;
        NSLog(@"locationManager didUpdateLocation, latitude %+.6f, longitude %+.6f\n",
              _currentLocation.coordinate.latitude,
              _currentLocation.coordinate.longitude);
    }
}

/*
// method to be called when the location changes.
- (void)setCurrentLocation:(CLLocation *)aCurrentLocation {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject: aCurrentLocation forKey:@"location"];
    [[NSNotificationCenter defaultCenter] postNotificationName: kLocationChangeNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (CLLocationCoordinate2D*)getLocation {
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _currentLocation = [_locationManager location];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    return (__bridge CLLocationCoordinate2D *)(_currentLocation);
}
*/
#pragma mark CoreData Stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Data.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Core_Data" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL*)applicationDocumentsDirectory {
    //return [NSURL URLWithString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)removeOldBumpd {
    NSMutableArray *newbumpdPosts = [[NSMutableArray alloc]init];
    NSArray *bumpdPosts = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
    //NSLog(@"bumpdPosts: %@", bumpdPosts);
    
    for (NSDictionary *dict in bumpdPosts) {
        for (id key in dict)
        {
            id value = [dict objectForKey:key];
            NSLog(@"value: %@", value);
            
            if ([[NSDate date] timeIntervalSinceDate:value] < 60*60*24) {
                [newbumpdPosts addObject:dict];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newbumpdPosts forKey:@"bumpdPosts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"cleaned bumpdPosts: %@", bumpdPosts);
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        //Cancel
    }
}

@end
