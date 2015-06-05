//
//  MainView.m
//  Bumpn
//
//  Created by Nate Berman on 8/16/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "MainView.h"
#import "DTDAppDelegate.h"
#import "Constants.h"
#import "PostDetailViewController.h"
#import "NewPostViewController.h"
#import "ProfileViewController.h"

@interface MainView ()

@property (nonatomic) CLLocationAccuracy accuracy;

@property (nonatomic) UIView *leftRangeCover;
@property (nonatomic) UILabel *leftRangeLabel;
@property (nonatomic) UIView *rightRangeCover;
@property (nonatomic) UILabel *rightRangeLabel;

@end

@implementation MainView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToMain) name:@"pushToMainView" object:nil];
    [((DTDAppDelegate*)[UIApplication sharedApplication].delegate) addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = PRIMARY_ORANGE_COLOR;
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:kJustLaunched] && [userDefaults doubleForKey:kRangeSliderKey] != 0.5) {
        self.rangeSlider.value = [userDefaults doubleForKey:kRangeSliderKey];
    } else {
        //NSLog(@"no rangeslider.value in defaults");
        self.rangeSlider.value = 0.5;
        [userDefaults setDouble:0.5 forKey:kRangeSliderKey];
        [userDefaults setValue:[NSNumber numberWithDouble:1.0] forKey:kFilterDistanceKey];
    }
    
    self.topHorizontal.backgroundColor = [UIColor whiteColor];
    self.topHorizontal.tag = 1;
    [self.view addSubview:self.topHorizontal];
    [self.view bringSubviewToFront:self.topHorizontal];

    self.tableContainer.tag = 4;
    
    [self.view addSubview:self.botHorizontal];
    self.botHorizontal.tag = 3;
    self.botHorizontal.backgroundColor = [UIColor whiteColor];

    self.botBar = [[UIView alloc]init];
    [self.view insertSubview:self.botBar belowSubview:self.botHorizontal];
    self.botBar.backgroundColor = PRIMARY_ORANGE_COLOR;
    
    self.refreshBtn.tag = 2;
    [self.view addSubview:self.refreshBtn];
    [self.view insertSubview:self.refreshBtn aboveSubview:self.botBar];
    
    self.activityCover = [[UIView alloc]init];
    self.activityCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.activityCover.layer.cornerRadius = 5;
    self.activityCover.hidden = true;
    [self.view addSubview:self.activityCover];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityCover addSubview:self.activityIndicator];

    self.leftRangeCover = [[UIView alloc]init];
    self.leftRangeCover.backgroundColor = PRIMARY_ORANGE_COLOR;
    self.leftRangeCover.tag = 200;
    self.leftRangeCover.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.leftRangeCover];
    self.leftRangeLabel = [UILabel new];
    self.leftRangeLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    self.leftRangeLabel.textAlignment = NSTextAlignmentCenter;
    self.leftRangeLabel.textColor = [UIColor whiteColor];
    self.leftRangeLabel.tag = 1;
    self.leftRangeLabel.adjustsFontSizeToFitWidth = true;
    self.leftRangeLabel.numberOfLines = 1;
    self.leftRangeLabel.alpha = 0;
    [self.leftRangeCover addSubview:self.leftRangeLabel];
    
    self.rightRangeCover = [[UIView alloc]init];
    self.rightRangeCover.backgroundColor = PRIMARY_ORANGE_COLOR;
    self.rightRangeCover.tag = 220;
    self.rightRangeCover.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.rightRangeCover];
    self.rightRangeLabel = [UILabel new];
    self.rightRangeLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    self.rightRangeLabel.textAlignment = NSTextAlignmentCenter;
    self.rightRangeLabel.textColor = [UIColor whiteColor];
    self.rightRangeLabel.tag = 1;
    self.rightRangeLabel.adjustsFontSizeToFitWidth = true;
    self.rightRangeLabel.alpha = 0;
    [self.rightRangeCover addSubview:self.rightRangeLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    NSLog(@"MainView viewDidAppear");
    NSLog(@"Nav Stack: %@", [self.navigationController viewControllers]);
    
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    [self.view viewWithTag:2].alpha = 1;
    
    // add a gradient around the edges of the tableview
    // makes it look like cells fall into and emerge from shadows
    /*
     CAGradientLayer *gradient = [CAGradientLayer layer];
     gradient.frame = self.tableContainer.bounds;
     gradient.colors = @[(id)[UIColor whiteColor].CGColor,
     (id)[UIColor whiteColor].CGColor,
     (id)[UIColor whiteColor].CGColor,
     (id)[UIColor clearColor].CGColor];
     //gradient.locations = @[@0.0, @0.07, @0.9, @1.0];
     gradient.locations = @[@0.0, @0.07, @.9, @1];
     self.tableContainer.layer.mask = gradient;
     */
    
    // refresh current post list
    [(MainViewTableViewController*)self.childViewControllers[0] getPosts];
}

- (void)viewWillLayoutSubviews {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configureNav];
    
    // top horizontal
    if (self.view.bounds.size.height < [UIScreen mainScreen].bounds.size.height) {
        self.topHorizontal.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2);
    } else {
        self.topHorizontal.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 2);
    }
    
    self.botHorizontal.frame = CGRectMake(0, self.view.bounds.size.height - 64, [UIScreen mainScreen].bounds.size.width, 2);
    self.botBar.frame = CGRectMake(0, self.botHorizontal.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - self.botHorizontal.frame.origin.y);
    self.refreshBtn.frame = CGRectMake(self.view.frame.size.width/2 - 16, self.view.frame.size.height - 36 - 10, 33, 36);
    self.refreshBtn.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 32);
    
    // table container
    if (self.view.bounds.size.height < [UIScreen mainScreen].bounds.size.height) {
        self.tableContainer.frame = CGRectMake(0, self.topHorizontal.frame.origin.y + self.topHorizontal.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.botHorizontal.frame.origin.y - self.topHorizontal.frame.origin.y - self.topHorizontal.frame.size.height);
    }
    else {
        self.tableContainer.frame = CGRectMake(0, 66, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - 140);
    }
    self.tableContainer.frame = CGRectMake(0, self.topHorizontal.frame.origin.y + self.topHorizontal.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.botHorizontal.frame.origin.y - self.topHorizontal.frame.origin.y - self.topHorizontal.frame.size.height);
    
    self.activityCover.frame = CGRectMake(0, 0, 50, 50);
    self.activityCover.center = self.tableContainer.center;
    self.activityIndicator.frame = self.activityCover.bounds;
    [self.view bringSubviewToFront:self.activityCover];
    
    // adjust placement of left and right range views based on incoming call bar
    if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
        self.leftRangeCover.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height - 20, 70, 60);
        self.rightRangeCover.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, [UIApplication sharedApplication].statusBarFrame.size.height - 20, 70, 60);
    }
    else {
        self.leftRangeCover.frame = CGRectMake(0, 0, 70, 60);
        self.rightRangeCover.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 0, 70, 60);
    }
}

- (void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)configureNav {
    //self.navigationController.navigationBar.tintColor = PRIMARY_ORANGE_COLOR;
    //[self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"currentLocation"]) {
        // do some stuff
        [(MainViewTableViewController*)self.childViewControllers[0] getPosts];
        [((DTDAppDelegate*)[UIApplication sharedApplication].delegate) removeObserver:self forKeyPath:@"currentLocation"];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedMainTableViewSegue"]) {
        MainViewTableViewController *vc = [segue destinationViewController];
        NSLog(@"MainView.newPostCreated: %@", (self.newPostCreated) ? @"YES" : @"NO");
        vc.host = self;
    }
    
    if ([segueName isEqualToString:@"viewPostSegue"]) {
        PostDetailViewController *vc = [segue destinationViewController];
        vc.postObject = self.postObject;
    }
    
    if ([segueName isEqualToString: @"createPostSegue"]) {
        NewPostViewController *vc = [segue destinationViewController];
        vc.host = self;
    }
    
    //if ([segueName isEqualToString: @"profileSegue"]) {
    //    ProfileViewController *vc = [segue destinationViewController];
    //}
}


- (IBAction)profileBtn:(id)sender {
    [self performSegueWithIdentifier:@"profileSegue" sender:self];
}

- (IBAction)newPostBtn:(id)sender {
    [self performSegueWithIdentifier:@"createPostSegue" sender:self];
}

- (IBAction)refreshBtn:(id)sender {
    if ([(MainViewTableViewController*)self.childViewControllers[0] shouldGetPosts]) {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"scrollToTop"];
        [(MainViewTableViewController*)self.childViewControllers[0] getPosts];
    }
}

- (void)viewPostDetailView:(PFObject *)postObject {
    self.postObject = postObject;
    [self performSegueWithIdentifier:@"viewPostSegue" sender:self];
}

- (void)distanceFilterDidChange:(NSNotification *)note {
}

// Finally, when the view controller no longer needs to observe the
// notification, it removes itself
/*
- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFilterDistanceChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPostCreatedNotification object:nil];
}
*/

#pragma mark Range Slider Methods

- (IBAction)rangeSliderValueChanged:(UISlider*)sender {
     NSArray *convertedValue = [self convertRangeSliderToDistance:sender.value];
    ((UILabel*)[[[[UIApplication sharedApplication] keyWindow] viewWithTag:200] viewWithTag:1]).text = convertedValue[0];
    ((UILabel*)[[[[UIApplication sharedApplication] keyWindow] viewWithTag:220] viewWithTag:1]).text= convertedValue[0];
    
    if ([convertedValue count] > 1) {
        ((UILabel*)[[[[UIApplication sharedApplication] keyWindow] viewWithTag:200] viewWithTag:2]).text = convertedValue[1];
        ((UILabel*)[[[[UIApplication sharedApplication] keyWindow] viewWithTag:220] viewWithTag:2]).text= convertedValue[1];
    } else {
        ((UILabel*)[[[[UIApplication sharedApplication] keyWindow] viewWithTag:200] viewWithTag:2]).text = @"";
        ((UILabel*)[[[[UIApplication sharedApplication] keyWindow] viewWithTag:220] viewWithTag:2]).text= @"";
    }
}

- (IBAction)rangeSliderTouchStart:(UISlider*)sender {
    sender.userInteractionEnabled = NO;
    [self.refreshBtn setUserInteractionEnabled:NO];
    [self.tableContainer setUserInteractionEnabled:NO];
    
    NSArray *convertedValue = [self convertRangeSliderToDistance:sender.value];

    if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
        self.leftRangeCover.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height - 20, 70, 60);
        self.rightRangeCover.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, [UIApplication sharedApplication].statusBarFrame.size.height - 20, 70, 60);
    }
    else {
        self.leftRangeCover.frame = CGRectMake(0, 0, 70, 60);
        self.rightRangeCover.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 0, 70, 60);
    }
    
    self.leftRangeLabel.text = convertedValue[0];
    self.rightRangeLabel.text = convertedValue[0];
    self.leftRangeLabel.frame = CGRectMake(0, 5, 70, 70);
    self.rightRangeLabel.frame = CGRectMake(0, 5, 70, 70);

    [UIView animateWithDuration:0.2
                     animations:^{
                         [[[UIApplication sharedApplication] keyWindow] viewWithTag:200].alpha = 1;
                         [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              [[[[UIApplication sharedApplication] keyWindow] viewWithTag:200] viewWithTag:1].alpha = 1;
                                              [[[[UIApplication sharedApplication] keyWindow] viewWithTag:220] viewWithTag:1].alpha = 1;
                                          } completion:^(BOOL finished) {
                                              //
                                              sender.userInteractionEnabled = YES;
                                          }];
                         
                     }];
}

- (IBAction)rangeSliderTouchEnd:(UISlider*)sender {
    //DTDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [sender setUserInteractionEnabled:NO];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithFloat:self.rangeSlider.value] forKey:kRangeSliderKey];
    [userDefaults setValue:[NSNumber numberWithDouble:self.range] forKey:kFilterDistanceKey];
    [userDefaults synchronize];
    NSLog(@"kFilterDistanceKey: %f", [userDefaults floatForKey:kFilterDistanceKey]);
    [UIView animateWithDuration:.02
                          delay:.5
                        options:0
                     animations:^{
                         [[[[UIApplication sharedApplication] keyWindow] viewWithTag:200] viewWithTag:1].alpha = 0;
                         [[[[UIApplication sharedApplication] keyWindow] viewWithTag:220] viewWithTag:1].alpha = 0;
                     } completion:^(BOOL finished) {
                         if (([[[[UIApplication sharedApplication] keyWindow] viewWithTag:200] viewWithTag:1].alpha == 0)) {
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  [[[UIApplication sharedApplication] keyWindow] viewWithTag:200].alpha = 0;
                                                  [[[UIApplication sharedApplication] keyWindow] viewWithTag:220].alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  [sender setUserInteractionEnabled:YES];
                                                  [self.refreshBtn setUserInteractionEnabled:YES];
                                                  [self.tableContainer setUserInteractionEnabled:YES];
                                                  [(MainViewTableViewController*)self.childViewControllers[0] filterAllPostsToRange];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      //[self performSelector:@selector(setFilterDistance:) withObject:self.accuracy afterDelay:1.5];
                                                  });
                                              }];
                         }
                     }];
}

- (NSArray*)convertRangeSliderToDistance:(float)sliderValue {
    NSArray *resultArray = [NSArray new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (sliderValue == 0) {
        self.range = 30/kYardsPerMile;
        [userDefaults setValue:[NSNumber numberWithDouble:30/kYardsPerMile] forKey:kFilterDistanceKey];
        resultArray = @[@"30 yd"];
        //return [NSString stringWithFormat:@"30 yd"];
    } else if (sliderValue >= 0 && sliderValue < .05) {
        self.range = 50/kYardsPerMile;
        [userDefaults setValue:[NSNumber numberWithDouble:50/kYardsPerMile] forKey:kFilterDistanceKey];
        resultArray = @[@"50 yd"];
        //return [NSString stringWithFormat:@"50 yd"];
    } else if (sliderValue >= .05 && sliderValue < .15) {
        self.range = 100/kYardsPerMile;
        [userDefaults setValue:[NSNumber numberWithDouble:100/kYardsPerMile] forKey:kFilterDistanceKey];
        //resultArray = @[@"100", @"yd"];
        resultArray = @[@"100 yd"];
        //return [NSString stringWithFormat:@"100 yd"];
    } else if (sliderValue >= .15 && sliderValue < .25) {
        self.range = 200/kYardsPerMile;
        [userDefaults setValue:[NSNumber numberWithDouble:200/kYardsPerMile] forKey:kFilterDistanceKey];
        //resultArray = @[@"200", @"yd"];
        resultArray = @[@"200 yd"];
        //return [NSString stringWithFormat:@"200 yd"];
    } else if (sliderValue >= .25 && sliderValue < .35) {
        self.range = 300/kYardsPerMile;
        [userDefaults setValue:[NSNumber numberWithDouble:300/kYardsPerMile] forKey:kFilterDistanceKey];
        //resultArray = @[@"300", @"yd"];
        resultArray = @[@"300 yd"];
        //return [NSString stringWithFormat:@"300 yards"];
    } else if (sliderValue >= .35 && sliderValue < .45) {
        self.range = .25;
        [userDefaults setValue:[NSNumber numberWithDouble:.25] forKey:kFilterDistanceKey];
        resultArray = @[@"1/4 mi"];
        //return [NSString stringWithFormat:@"1/4 mi"];
    } else if (sliderValue >= .45 && sliderValue < .5) {
        self.range = .5;
        [userDefaults setValue:[NSNumber numberWithDouble:.5] forKey:kFilterDistanceKey];
        resultArray = @[@"1/2 mi"];
        //return [NSString stringWithFormat:@"1/2 mi"];
    } else if (sliderValue >= .5 && sliderValue < .55) {
        self.range = 1.0;
        [userDefaults setValue:[NSNumber numberWithDouble:1.0] forKey:kFilterDistanceKey];
        resultArray = @[@"1 mi"];
        //return [NSString stringWithFormat:@"1 mi"];
    } else if (sliderValue >= .55 && sliderValue < .6) {
        self.range = 1.5;
        [userDefaults setValue:[NSNumber numberWithDouble:1.5] forKey:kFilterDistanceKey];
        resultArray = @[@"1.5 mi"];
        //return [NSString stringWithFormat:@"1.5 mi"];
    } else if (sliderValue >= .6 && sliderValue < .65) {
        self.range = 2.0;
        [userDefaults setValue:[NSNumber numberWithDouble:2.] forKey:kFilterDistanceKey];
        resultArray = @[@"2 mi"];
        //return [NSString stringWithFormat:@"2 mi"];
    } else if (sliderValue >= .65 && sliderValue < .7) {
        self.range = 3.0;
        [userDefaults setValue:[NSNumber numberWithDouble:3.] forKey:kFilterDistanceKey];
        resultArray = @[@"3 mi"];
        //return [NSString stringWithFormat:@"3 mi"];
    } else if (sliderValue >= .7 && sliderValue < .75) {
        self.range = 4.0;
        [userDefaults setValue:[NSNumber numberWithDouble:4.] forKey:kFilterDistanceKey];
        resultArray = @[@"4 mi"];
        //return [NSString stringWithFormat:@"4 mi"];
    } else if (sliderValue >= .75 && sliderValue < .8) {
        self.range = 5.0;
        [userDefaults setValue:[NSNumber numberWithDouble:5.] forKey:kFilterDistanceKey];
        resultArray = @[@"5 mi"];
        //return [NSString stringWithFormat:@"5 mi"];
    } else if (sliderValue >= .8 && sliderValue < .85) {
        self.range = 6.0;
        [userDefaults setValue:[NSNumber numberWithDouble:6.] forKey:kFilterDistanceKey];
        resultArray = @[@"6 mi"];
        //return [NSString stringWithFormat:@"6 mi"];
    } else if (sliderValue >= .85 && sliderValue < .9) {
        self.range = 7.0;
        [userDefaults setValue:[NSNumber numberWithDouble:7.] forKey:kFilterDistanceKey];
        resultArray = @[@"7 mi"];
        //return [NSString stringWithFormat:@"7 mi"];
    } else if (sliderValue >= .9 && sliderValue < .95) {
        self.range = 8.0;
        [userDefaults setValue:[NSNumber numberWithDouble:8.] forKey:kFilterDistanceKey];
        resultArray = @[@"8 mi"];
        //return [NSString stringWithFormat:@"8 mi"];
    } else if (sliderValue >= .95 && sliderValue < .99) {
        self.range = 9.0;
        [userDefaults setValue:[NSNumber numberWithDouble:9.] forKey:kFilterDistanceKey];
        resultArray = @[@"9 mi"];
        //return [NSString stringWithFormat:@"9 mi"];
    } else {
        self.range = 10.0;
        [userDefaults setValue:[NSNumber numberWithDouble:10.] forKey:kFilterDistanceKey];
        resultArray = @[@"10 mi"];
        //return [NSString stringWithFormat:@"10 mi"];
    }
    return resultArray;
}

- (void)showActivityIndicator {
    NSLog(@"MainView showActivityIndicator");
    [self.view bringSubviewToFront:self.activityCover];
    [self.refreshBtn setUserInteractionEnabled:false];
    [self.activityIndicator startAnimating];
    self.activityCover.hidden = false;
}

- (void)hideActivityIndicator {
    NSLog(@"hiding activity indicatory");
    self.activityCover.hidden = true;
    [self.activityIndicator stopAnimating];
    [self.refreshBtn setUserInteractionEnabled:YES];
}

- (void)returnToMain {
    [self.navigationController popToViewController:self animated:false];
}

@end
