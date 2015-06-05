//
//  MainView.h
//  Bumpn
//
//  Created by Nate Berman on 8/16/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MainViewTableViewController.h"

@interface MainView : UIViewController <CLLocationManagerDelegate, UINavigationControllerDelegate>

@property (nonatomic) IBOutlet UIView *topHorizontal;
@property (nonatomic) IBOutlet UIView *botHorizontal;
@property (nonatomic) UIView *botBar;
@property (nonatomic) UIView *activityCover;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIView *tableContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileBtn;
- (IBAction)profileBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postBtn;
- (IBAction)newPostBtn:(id)sender;

@property double range; // in miles
@property (weak, nonatomic) IBOutlet UISlider *rangeSlider;
- (IBAction)rangeSliderValueChanged:(id)sender;
- (IBAction)rangeSliderTouchStart:(id)sender;
- (IBAction)rangeSliderTouchEnd:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
- (IBAction)refreshBtn:(id)sender;

@property (strong, nonatomic) PFObject *postObject;
- (void)viewPostDetailView:(PFObject *)postObject;

@property BOOL newPostCreated;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end
