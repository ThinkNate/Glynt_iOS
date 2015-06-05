//
//  PostDetailViewController.m
//  Bumpn
//
//  Created by Nate Berman on 9/1/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Constants.h"
#import "DTDAppDelegate.h"

@interface PostDetailViewController ()

//@property (nonatomic) UIView *bumpnB;
@property (nonatomic) CLLocation *currentLocation;

@end

@implementation PostDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:true];
    
    // set Nav Title Font and Size
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"GurmukhiSangamMN" size:40], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBarHidden = YES;
    self.currentLocation = ((DTDAppDelegate*)[UIApplication sharedApplication].delegate).locationManager.location;
    NSLog(@"post: %@", self.postObject);
    
    [self configureDistanceLabel];
    self.title = _distance.text;
}

- (void)viewWillLayoutSubviews {
    [self configureView];
    [self performSelector:@selector(removeObservers) withObject:self afterDelay:.1];
    //[self performSelectorOnMainThread:@selector(removeObservers) withObject:self waitUntilDone:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    self.navigationController.navigationBarHidden = NO;
}

- (void)configureView {
    //[self configureTitleField];
    self.view.backgroundColor = PRIMARY_LIGHT_GRAY_COLOR;
    _topHorizontal.frame = CGRectMake(0, 0, 320, 2);
    
    [self configureMessageField];
    
    UIView *bottomBar = [[UIView alloc]init];
    bottomBar.frame = CGRectMake(0, self.view.bounds.size.height - 64, self.view.bounds.size.width, 64);
    bottomBar.backgroundColor = PRIMARY_ORANGE_COLOR;
    [self.view insertSubview:bottomBar belowSubview:_backBtn];
    _backBtn.frame = CGRectMake(0, self.view.frame.size.height - 64, 96, 68);
    _botHorizontal.frame = CGRectMake(0, self.view.frame.size.height - 64, 320, 2);
    
    [self configureTimestampLabel];
    [self configureOriginatorLabel];
    _bumpBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 25, self.view.frame.size.height - 20 - 25, 25, 25);
    [self checkIfBumpd];
    _bumpScoreLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 25, _bumpBtn.frame.origin.y + _bumpBtn.frame.size.height -3, _bumpBtn.frame.size.width, 21);
    _bumpScoreLabel.center = CGPointMake(self.bumpBtn.center.x, self.bumpScoreLabel.center.y);
    _bumpScoreLabel.text = [NSString stringWithFormat:@"%@",_postObject[@"points"]];
    [self.view insertSubview:_botHorizontal aboveSubview:_backBtn];
}

/*
- (void)configureTitleField {
    _titleField.textColor = [UIColor whiteColor];
    _titleField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:32];
    _titleField.text = _postObject[@"title"];
    _titleField.tag = 0;
}
*/

- (void)configureMessageField {
    _messageField.delegate = self;
    _messageField.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 400);
    _messageField.text = [_postObject objectForKey:@"message"];
    _messageField.textColor = PRIMARY_BLACK_COLOR;
    _messageField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:20];
    _messageField.backgroundColor = [UIColor clearColor];
    _messageField.tag = 1;
    
    // this will allow us to respond to changes in the textView content size
    // so we can vertically align text
    [_messageField addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
}

- (void)configureTimestampLabel {
    //_originatorUsername.text = _postObject[@"user"];
    NSDate *createdAt = _postObject.createdAt;
    
    // The time interval
    NSTimeInterval theTimeInterval = createdAt.timeIntervalSinceNow;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;// | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    //NSLog(@"Conversion: %ldmin %ldhours",(long)[conversionInfo minute], (long)[conversionInfo hour]);
    
    NSMutableString *timeSince = [NSMutableString new];
    if (-[conversionInfo hour] > 0) {
        [timeSince appendString:[NSString stringWithFormat:@"%ldh ", (long)-[conversionInfo hour]]];
    }
    if (-[conversionInfo minute] > 0) {
        [timeSince appendString:[NSString stringWithFormat:@"%ldm ", (long)-[conversionInfo minute]]];
    }
    if (!(-[conversionInfo hour]) > 0 && !(-[conversionInfo minute]) > 0) {
        [timeSince appendString:@"moments "];
    }
    [timeSince appendString:@"ago"];
    _timestamp.text = timeSince;
    _timestamp.textColor = PRIMARY_BLACK_COLOR;
    [_timestamp sizeToFit];
    _timestamp.frame = CGRectMake(10, _botHorizontal.frame.origin.y - _timestamp.frame.size.height - 5, _timestamp.frame.size.width, _timestamp.frame.size.height);
}

- (void)configureOriginatorLabel {
    _originatorUsername.text = [NSString stringWithFormat:@"by: %@", _postObject[@"originator"]];
    [_originatorUsername sizeToFit];
    _originatorUsername.frame = CGRectMake(_timestamp.frame.origin.x + _timestamp.frame.size.width + 5, _timestamp.frame.origin.y, _originatorUsername.frame.size.width, _originatorUsername.frame.size.height);
    _originatorUsername.textColor = PRIMARY_BLACK_COLOR;
}

- (void)configureDistanceLabel {
    [_distance setHidden:true];
    
    PFGeoPoint *pfPostLoc = self.postObject[@"location"];
    CLLocation *clPostLoc = [[CLLocation alloc]initWithLatitude:pfPostLoc.latitude longitude:pfPostLoc.longitude];
    
    float distInMeter = [self.currentLocation distanceFromLocation:clPostLoc];
    NSLog(@"disInMeters: %2.f", distInMeter);
    float distInYards = distInMeter * kMetersPerYard;
    if (distInYards <= 30) {
        _distance.text = @"~30yd away";
    } else if (distInYards > 30 && distInYards <= 50) {
        _distance.text = @"~50yd away";
    } else if (distInYards > 50 && distInYards <= 100) {
        _distance.text = @"~100yd away";
    } else if (distInYards > 100 && distInYards <= 200) {
        _distance.text = @"~200yd away";
    } else if (distInYards > 200 && distInYards <= 300) {
        _distance.text = @"~300yd away";
    } else if (distInYards > 300 && distInYards <= kYardsPerMile/4) {
        _distance.text = @"~1/4mi away";
    } else if (distInYards > kYardsPerMile/4 && distInYards <= kYardsPerMile/2) {
        _distance.text = @"~1/2mi away";
    } else if (distInYards > kYardsPerMile/2 && distInYards <= kYardsPerMile) {
        _distance.text = @"~1mi away";
    } else if (distInYards > kYardsPerMile && distInYards <= kYardsPerMile*2) {
        _distance.text = @"~2mi away";
    } else if (distInYards > kYardsPerMile*2 && distInYards <= kYardsPerMile*3) {
        _distance.text = @"~3mi away";
    } else if (distInYards > kYardsPerMile*3 && distInYards <= kYardsPerMile*4) {
        _distance.text = @"~4mi away";
    } else if (distInYards > kYardsPerMile*4 && distInYards <= kYardsPerMile*5) {
        _distance.text = @"~5mi away";
    } else if (distInYards > kYardsPerMile*5 && distInYards <= kYardsPerMile*6) {
        _distance.text = @"~6mi away";
    } else if (distInYards > kYardsPerMile*6 && distInYards <= kYardsPerMile*7) {
        _distance.text = @"~7mi away";
    } else if (distInYards > kYardsPerMile*7 && distInYards <= kYardsPerMile*8) {
        _distance.text = @"~8mi away";
    } else if (distInYards > kYardsPerMile*8 && distInYards <= kYardsPerMile*9) {
        _distance.text = @"~9mi away";
    } else if (distInYards > kYardsPerMile*9) {
        _distance.text = @"~10mi away";
    }
    
    //[_distance sizeToFit];
    //_distance.frame = CGRectMake(self.view.frame.size.width - _distance.frame.size.width - 10, _timestamp.frame.origin.y, _distance.frame.size.width, _distance.frame.size.height);
}

- (void)checkIfBumpd {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"] count] > 0) {
        //NSLog(@"bumpdPosts count: %lu", (unsigned long)[[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"] count]);
        NSArray *bumpdPosts = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
        for (NSDictionary *dict in bumpdPosts) {
            for (id key in dict)
            {
                NSLog(@"key: %@", key);
                if ([key isEqual:[_postObject objectId]]) {
                    [_bumpBtn setSelected:YES];
                    //[_bumpBtn setUserInteractionEnabled:NO];
                    _bumpScoreLabel.textColor = [UIColor colorWithRed:0 green:.91 blue:1 alpha:1];
                    break;
                } else {
                    if (![_bumpBtn isSelected]) {
                        [_bumpBtn setSelected:NO];
                        [_bumpBtn setUserInteractionEnabled:YES];
                    }
                }
            }
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *txtview = object;
    CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
    
    /*
    if ([keyPath isEqualToString:@"contentSize"]) {
        CFRunLoopPerformBlock(CFRunLoopGetCurrent(), kCFRunLoopCommonModes, ^{
            [object removeObserver:self forKeyPath:@"contentSize"];
        });
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(id)sender {
    [self.backBtn setSelected:true];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"scrollToTop"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeObservers {
    [_messageField removeObserver:self forKeyPath:@"contentSize"];
}

- (IBAction)bumpBtn:(id)sender {
    if (![_postObject[@"originator"] isEqualToString:[PFUser currentUser].username]) {
        // upvote
        if (![_bumpBtn isSelected]) {
            [self bump];
            [_bumpBtn setSelected:YES];
            
            NSMutableArray *bumpdPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
            NSMutableDictionary *bumpd = [[NSMutableDictionary alloc]init];
            bumpd[_postObject.objectId] = _postObject.createdAt;
            if (![bumpdPosts containsObject:bumpd]) {
                [bumpdPosts addObject:bumpd];
                [[NSUserDefaults standardUserDefaults] setObject:bumpdPosts forKey:@"bumpdPosts"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            // save new bump point increment
            [_postObject incrementKey:@"points"];
            [_postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //
                if (error) // Failed to save, show an alert view with the error message
                {
                    NSLog(@"Couldn't Bump Post!");
                    NSLog(@"%@", error);
                    UIAlertView *alertView =
                    [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"]
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Ok", nil];
                    [alertView show];
                    return;
                }
                if (succeeded) // Successfully saved, post a notification to tell other view controllers
                {
                    NSLog(@"Successfully Bumpd Post!");
                }
            }];
            
            // create an array to hold any Points objects returned by our query
            NSMutableArray *pointsArray = [NSMutableArray new];
            PFQuery __block *pointsQuery = [PFQuery queryWithClassName:@"Points"];
            [pointsQuery whereKey:@"username" equalTo:(NSString*)_postObject[@"originator"]];
            [pointsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %lu point records to increment.", (unsigned long)objects.count);
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                        [pointsArray addObject:object];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // if our query found objects increment their points
                        if (pointsArray.count > 0) {
                            for (PFObject *object in pointsArray) {
                                [object incrementKey:@"points"];
                                [object saveInBackground];
                            }
                        }
                        // if query did not find objects create new Point object
                        else {
                            PFObject *pointScore = [PFObject objectWithClassName:@"Points"];
                            pointScore[@"username"] = _postObject[@"originator"];
                            [pointScore incrementKey:@"points"];
                            [pointScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    // The object has been saved.
                                    NSLog(@"Points.%@.points incremented", _postObject[@"originator"]);
                                } else {
                                    // There was a problem, check error.description
                                }
                            }];
                        }
                    });
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        
        // else remove upvote
        else {
            NSLog(@"remove upvote");
            [_bumpBtn setSelected:NO];
            
            NSMutableArray *bumpdPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
            NSMutableDictionary *bumpd = [[NSMutableDictionary alloc]init];
            bumpd[_postObject.objectId] = _postObject.createdAt;
            if ([bumpdPosts containsObject:bumpd]) {
                [bumpdPosts removeObject:bumpd];
                [[NSUserDefaults standardUserDefaults] setObject:bumpdPosts forKey:@"bumpdPosts"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            // save new point decrement on Post object
            if ([_postObject[@"points"] intValue] > 0) {
                [_postObject incrementKey:@"points" byAmount:@(-1)];
                [_postObject saveInBackground];
            }
            
            
            // create an array to hold any Points objects returned by our query
            NSMutableArray *pointsArray = [NSMutableArray new];
            PFQuery __block *pointsQuery = [PFQuery queryWithClassName:@"Points"];
            [pointsQuery whereKey:@"username" equalTo:(NSString*)_postObject[@"originator"]];
            [pointsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %lu point records to increment.", (unsigned long)objects.count);
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                        [pointsArray addObject:object];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // if our query found objects deccrement their points
                        int incrementor = [_bumpScoreLabel.text intValue];
                        if (incrementor > 0) {
                            incrementor -= 1;
                            _bumpScoreLabel.text = [NSString stringWithFormat:@"%d", incrementor];
                        }
                        if (pointsArray.count > 0) {
                            for (PFObject *object in pointsArray) {
                                if ([object[@"points"] intValue] > 0) {
                                    [object incrementKey:@"points" byAmount:@(-1)];
                                    [object saveInBackground];
                                }
                            }
                        }
                    });
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
    else {
        NSLog(@"current user is post originator. can not remove vote");
    }
}

- (UIView*)drawBumpinB {
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    // Drawing code
    UIImageView *bumpBot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_lowerBupvote.png"]];
    [bumpBot setContentMode:UIViewContentModeScaleAspectFit];
    bumpBot.tag = 102;
    [bView addSubview:bumpBot];
    bumpBot.frame = CGRectMake(10, 55, 25, 25);
    
    UIImageView *bumpMid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_upvoteMid.png"]];
    [bumpMid setContentMode:UIViewContentModeScaleAspectFit];
    bumpMid.tag = 101;
    [bView addSubview:bumpMid];
    bumpMid.frame = CGRectMake(10, 53, 8, 5);
    
    UIImageView *bumpTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_upvoteArrow.png"]];
    [bumpTop setContentMode:UIViewContentModeScaleAspectFit];
    bumpTop.tag = 100;
    [bView addSubview:bumpTop];
    bumpTop.frame = CGRectMake(6, 39, 17, 17);
    
    return bView;
}

#warning animate upvote
- (void)bump {
    NSLog(@"bumpn");
    
    _bumpScoreLabel.textColor = [UIColor colorWithRed:0 green:.91 blue:1 alpha:1];
    int incrementor = [_bumpScoreLabel.text intValue];
    incrementor += 1;
    _bumpScoreLabel.text = [NSString stringWithFormat:@"%d", incrementor];
    
    
    // animate
    
    /*
    [_bumpBtn setHidden:YES];
    //[_bumpScoreLabel setHidden:YES];
    // b
    if (![_bumpnB isDescendantOfView:self.view]) {
        _bumpnB = [self drawBumpinB];
        [self.view addSubview:_bumpnB];
        [self.view bringSubviewToFront:_bumpBtn];
        _bumpnB.frame = CGRectMake(245, self.view.frame.size.height - 98, 40, 40);
    }
    
    CGRect originalTopFrame = CGRectMake([_bumpnB viewWithTag:100].frame.origin.x, [_bumpnB viewWithTag:100].frame.origin.y, [_bumpnB viewWithTag:100].frame.size.width, [_bumpnB viewWithTag:100].frame.size.height);
    CGRect originalMidFrame = CGRectMake([_bumpnB viewWithTag:101].frame.origin.x, [_bumpnB viewWithTag:101].frame.origin.y, [_bumpnB viewWithTag:101].frame.size.width, [_bumpnB viewWithTag:101].frame.size.height);
    
    // animate arrow down
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // arrow top down
                         [_bumpnB viewWithTag:100].frame = CGRectMake([_bumpnB viewWithTag:100].frame.origin.x, [_bumpnB viewWithTag:100].frame.origin.y +3, [_bumpnB viewWithTag:100].frame.size.width, [_bumpnB viewWithTag:100].frame.size.height);
                         // arrow mid down
                         [_bumpnB viewWithTag:101].frame = CGRectMake([_bumpnB viewWithTag:101].frame.origin.x, [_bumpnB viewWithTag:101].frame.origin.y +2, [_bumpnB viewWithTag:101].frame.size.width, [_bumpnB viewWithTag:101].frame.size.height);
                     } completion:^(BOOL finished) {
                         // Animate arrow up
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // arrow top up
                                              [_bumpnB viewWithTag:100].frame = CGRectMake([_bumpnB viewWithTag:100].frame.origin.x, [_bumpnB viewWithTag:100].frame.origin.y - 16, [_bumpnB viewWithTag:100].frame.size.width, [_bumpnB viewWithTag:100].frame.size.height);
                                              [_bumpnB viewWithTag:100].frame = CGRectInset([_bumpnB viewWithTag:100].frame, -5, -5);
                                              // arrow mid up
                                              [_bumpnB viewWithTag:101].frame = CGRectMake([_bumpnB viewWithTag:101].frame.origin.x, [_bumpnB viewWithTag:101].frame.origin.y - 5, [_bumpnB viewWithTag:101].frame.size.width, [_bumpnB viewWithTag:101].frame.size.height);
                                          } completion:^(BOOL finished) {
                                              // animate arrow back down
                                              [UIView animateWithDuration:0.2
                                                                    delay:0.3
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   // arrow top down
                                                                   [_bumpnB viewWithTag:100].frame = originalTopFrame;
                                                                   // arrow mid down
                                                                   [_bumpnB viewWithTag:101].frame = originalMidFrame;
                                                               } completion:^(BOOL finished) {
                                                                   //
                                                                   [_bumpnB removeFromSuperview];
                                                                   [_bumpBtn setUserInteractionEnabled:NO];
                                                                   [_bumpBtn setHidden:NO];
                                                                   
                                                                   _bumpScoreLabel.textColor = [UIColor colorWithRed:0 green:.91 blue:1 alpha:1];
                                                                   int incrementor = [_bumpScoreLabel.text intValue];
                                                                   incrementor += 1;
                                                                   _bumpScoreLabel.text = [NSString stringWithFormat:@"%d", incrementor];
                                                               }];
                                          }];
                     }];
     */
}

@end
