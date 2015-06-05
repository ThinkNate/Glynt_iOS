//
//  MainViewTableViewController.m
//  Bumpn
//
//  Created by Nate Berman on 9/1/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "MainViewTableViewController.h"
#import "DTDAppDelegate.h"
#import "RetrievedPost.h"
#import "Constants.h"

@interface MainViewTableViewController ()

@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSIndexPath *previouslyExpandedIndexPath;
@property (nonatomic) CGRect expandedMessageLabelFrame;
@property (strong, nonatomic) NSString *expandedObject;

@property (nonatomic) UILabel *noPostsLabel;

@property (nonatomic) NSMutableArray *postObjectArray;

@end

@implementation MainViewTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!_allPostsArray) {
        _allPostsArray = [NSMutableArray new];
    }
    if (!_postsInRange) {
        _postsInRange = [NSMutableArray new];
    }
    if (!self.postObjectArray) {
        self.postObjectArray = [NSMutableArray new];
    }
    if (!self.rejiggeredPostObjectArray) {
        self.rejiggeredPostObjectArray = [NSMutableArray new];
    }
    
    /*
    if ([self shouldGetPosts]) {
        [self getPosts];
    }
     */
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSMutableArray new] forKey:@"bumpdPosts"];
    }
    
    self.tableView.estimatedRowHeight = 100;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainViewCell" bundle:nil] forCellReuseIdentifier:@"MainViewCell"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    NSLog(@"MainViewTableVC viewWillAppear");
    
    if (_host.newPostCreated) {
        NSLog(@"MainViewTableVC getting posts");
        [self getPosts];
        _host.newPostCreated = NO;
    }
    
    /*
    if ([_postsInRange count] > 0) {
        NSLog(@"viewWillAppear filterAllPostsToRange");
        [self filterAllPostsToRange];
    }
    */
    
    [self removeOldBumpd];
    _bumpdPosts = [NSMutableArray new];
    
    NSArray *bumpdPostsFromDefaults = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
    for (NSDictionary *dict in bumpdPostsFromDefaults) {
        for (id key in dict)
        {
            [_bumpdPosts addObject:key];
        }
    }
}

- (void)viewWillLayoutSubviews {
    self.tableView.backgroundColor = PRIMARY_LIGHT_GRAY_COLOR;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:true];
    if (_expandedIndexPath) {
        NSLog(@"expandedIndexPath");
        [self mediaBtnPressed:((MainViewCell*)[self.tableView cellForRowAtIndexPath:_expandedIndexPath])];
    }
    [self removeOldBumpd];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_postsInRange count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MainViewCell";

    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *post = ((RetrievedPost*)_postsInRange[indexPath.row]).postObject;
    
    if (cell == nil) {
        cell = [[MainViewCell alloc] init];
    }
    
    cell.backgroundColor = PRIMARY_LIGHT_GRAY_COLOR;
    
    if (!cell.post) {
        cell.post = post;
    }
    
    if ([_bumpdPosts containsObject:[post objectId]]) {
        [cell.bumpBtn setSelected:YES];
        cell.bumpScoreLabel.textColor = [UIColor colorWithRed:0 green:.91 blue:1 alpha:1];
    } else {
        [cell.bumpBtn setSelected:NO];
        cell.bumpScoreLabel.textColor = [UIColor colorWithRed:0.27 green:.47 blue:.53 alpha:1];
    }
    
    // mediaBtn
    if (post[@"image"]) {
        [cell.mediaBtn setImage:[UIImage imageNamed:@"icon_photocontent.png"] forState:UIControlStateNormal];
        [cell.mediaBtn setImage:[UIImage imageNamed:@"icon_photocontent_downstate.png"] forState:UIControlStateSelected];
    } else {
        [cell.mediaBtn setImage:[UIImage imageNamed:@"icon_textcontent.png"] forState:UIControlStateNormal];
        [cell.mediaBtn setImage:[UIImage imageNamed:@"icon_textcontent_downstate.png"] forState:UIControlStateSelected];
    }
    
    if (((RetrievedPost*)_postsInRange[indexPath.row]).expanded == true) {
        [cell.mediaBtn setSelected:YES];
    } else {
        [cell.mediaBtn setSelected:NO];
    }
    
    // time
    NSAttributedString *timeString = [[NSAttributedString alloc]initWithString:[self configureTimestampLabel:post] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"GurmukhiSangamMN" size:12], NSForegroundColorAttributeName: PRIMARY_BLACK_COLOR}];
    cell.timeLabel.attributedText = timeString;
    
    // title
    //cell.titleLabel.text = post[@"title"];
    //cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    //cell.titleLabel.minimumScaleFactor = 0.5;
    
    // messageLabel
    if (![cell.contentView viewWithTag:4]) {
        cell.messageLabel = [UILabel new];
        [cell.contentView addSubview:cell.messageLabel];
        cell.messageLabel.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:18];
        cell.messageLabel.textColor = PRIMARY_BLACK_COLOR;
        cell.messageLabel.numberOfLines = 10;
        cell.messageLabel.tag = 4;
    }
    ((UILabel*)[cell viewWithTag:4]).text = post[@"message"];
    ((UILabel*)[cell viewWithTag:4]).numberOfLines = 10;
    [cell viewWithTag:4].frame = CGRectMake(58, 10, 208, 72);
    [[cell viewWithTag:4] sizeToFit];
    if ([indexPath compare:self.expandedIndexPath] != NSOrderedSame) {
        if ([cell viewWithTag:4].frame.size.height > 50) {
            [cell viewWithTag:4].frame = CGRectMake(58, 10, 208, 72);
        }
    }
    
    // bottom stripe
    if (![cell.contentView viewWithTag:5] && indexPath.row < [_postsInRange count]) {
        UIView *bottomStripe = [UIView new];
        [cell addSubview:bottomStripe];
        bottomStripe.backgroundColor = PRIMARY_BLACK_COLOR;
        bottomStripe.tag = 5;
        [cell viewWithTag:5].frame = CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 2);
    } else {
        [[cell.contentView viewWithTag:5] removeFromSuperview];
    }
    //[cell viewWithTag:5].frame = CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 2);
    
    // bump Score
    cell.bumpScoreLabel.text = [NSString stringWithFormat:@"%@", post[@"points"]];

    cell.delegate = self;
    
    tableView.rowHeight = 100;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        if (self.expandedMessageLabelFrame.size.height > 50) {
            return self.expandedMessageLabelFrame.origin.y + self.expandedMessageLabelFrame.size.height + 20;
        }
    }
    
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_host viewPostDetailView:((RetrievedPost*)[_postsInRange objectAtIndex:indexPath.row]).postObject];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString*)configureTimestampLabel:(PFObject *)postObject {
    //_originatorUsername.text = _postObject[@"user"];
    NSDate *createdAt = postObject.createdAt;
    
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
        [timeSince appendString:[NSString stringWithFormat:@"%ld h", (long)-[conversionInfo hour]]];
    }
    else if (-[conversionInfo minute] > 0) {
        [timeSince appendString:[NSString stringWithFormat:@"%ld m", (long)-[conversionInfo minute]]];
    }
    else if (!(-[conversionInfo hour]) > 0 && !(-[conversionInfo minute]) > 0) {
        [timeSince appendString:@"now"];
    }
    //[timeSince appendString:@"ago"];
    return timeSince;
    //_timestamp.text = timeSince;
    //[_timestamp sizeToFit];
    //_timestamp.frame = CGRectMake(10, _botHorizontal.frame.origin.y - _timestamp.frame.size.height - 5, _timestamp.frame.size.width, _timestamp.frame.size.height);
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldGetPosts {
    
    [_host.refreshBtn setUserInteractionEnabled:NO];
    
    NSDate *lastRefresh = [NSDate new];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kRefreshTimerKey]) {
        lastRefresh = [[NSUserDefaults standardUserDefaults] valueForKey:kRefreshTimerKey];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kJustLaunched] == YES) {
        if ([[NSDate date] timeIntervalSinceDate:lastRefresh] < kSecondsBetweenRefresh) {
            [self showActivityIndicator];
            [self performSelector:@selector(hideActivityIndicator) withObject:self afterDelay:.5];
            return NO;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kJustLaunched];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kRefreshTimerKey];
    
    return YES;
}

- (void)getPosts {
    
    [self showActivityIndicator];
    
    [self collapseCells];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"scrollToTop"] == true) {
        NSLog(@"scrolling to top");
        [self scrollToTop];
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"scrollToTop"];
        NSLog(@"NOT scrolling to top");
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    double range = 10.0; // range in miles
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation];
    [query whereKey:@"location" nearGeoPoint:geoPoint withinMiles:range];
    NSDate *earliest = [NSDate dateWithTimeIntervalSinceNow:-1*60*60*24];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:earliest];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
            NSLog(@"currentLocation: %@", ((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation);
            
            // Do something with the found objects
            _allPostsArray = [[NSMutableArray alloc]initWithArray:objects];
            [self sortAllPosts];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kRefreshTimerKey];
}

- (void)sortAllPosts {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // sort _allPosts based on points
        // if 2 items have same points sort based on createdAt
        NSSortDescriptor *pointSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:NO];
        NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:pointSortDescriptor, dateSortDescriptor, nil];
        NSArray *sortedArray = [_allPostsArray sortedArrayUsingDescriptors:sortDescriptors];
        NSMutableArray *pointSortedArray = [NSMutableArray arrayWithArray:sortedArray];
        
        _allPostsArray = [NSMutableArray new];
    
        // separate posts less than an hour old for the top of the list
        NSMutableArray *dateSortedArray = [NSMutableArray new];
        for (NSDictionary *object in pointSortedArray) {
            NSLog(@"post is %f old", [[NSDate date] timeIntervalSinceDate:(NSDate*)[object valueForKey:@"createdAt"]]);
            if ([[NSDate date] timeIntervalSinceDate:(NSDate*)[object valueForKey:@"createdAt"]] < 60*60) {
                [dateSortedArray addObject:object];
            }
        }

        [pointSortedArray removeObjectsInArray:dateSortedArray];
    
        if ([dateSortedArray count] > 0) {
            NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
            NSSortDescriptor *pointSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, pointSortDescriptor, nil];
            [dateSortedArray sortedArrayUsingDescriptors:sortDescriptors];
            //dateSortedArray = [NSMutableArray arrayWithArray:sortedArray];
            _allPostsArray = [[NSMutableArray alloc] initWithArray:dateSortedArray];
        }
        
    
        [_allPostsArray addObjectsFromArray:pointSortedArray];
        self.rejiggeredPostObjectArray = [NSMutableArray new];
        for (PFObject *postObject in _allPostsArray) {
            RetrievedPost *newPost = [RetrievedPost new];
            newPost.postObject = postObject;
            [self.rejiggeredPostObjectArray addObject:newPost];
        }
        
        [self filterAllPostsToRange];
        [self hideActivityIndicator];
        
    });
}

- (double)distanceFromCurrentLocationToPostLocation:(CLLocation*)postLocation {
    NSLog(@"distanceFromCurrentLocationToPostLocation");
    return [((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation distanceFromLocation:postLocation];
}

- (void)filterAllPostsToRange {
    //NSLog(@"currentLocation: %@", ((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation);
    NSLog(@"filtering posts to range: %f", [[NSUserDefaults standardUserDefaults]doubleForKey:kFilterDistanceKey]);
    _postsInRange = [[NSMutableArray alloc]init];
    /*
    for (PFObject *post in _allPostsArray) {
        CLLocation *postLocation = [[CLLocation alloc]initWithLatitude:((PFGeoPoint*)post[@"location"]).latitude longitude:((PFGeoPoint*)post[@"location"]).longitude];
        if ([((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation distanceFromLocation:postLocation] <= [[NSUserDefaults standardUserDefaults]doubleForKey:kFilterDistanceKey] * kMetersPerMile) {
            [_postsInRange addObject:post];
        }
    }
     */
    for (RetrievedPost *post in self.rejiggeredPostObjectArray) {
        CLLocation *postLocation = [[CLLocation alloc]initWithLatitude:((PFGeoPoint*)post.postObject[@"location"]).latitude longitude:((PFGeoPoint*)post.postObject[@"location"]).longitude];
        if ([((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation distanceFromLocation:postLocation] <= [[NSUserDefaults standardUserDefaults]doubleForKey:kFilterDistanceKey] * kMetersPerMile) {
            if (![_postsInRange containsObject:post]) {
                [_postsInRange addObject:post];
            }
        }
    }
    NSLog(@"%lu postsInRange", (unsigned long)[_postsInRange count]
          );
    if ([_postsInRange count] > 0) {
        for (UILabel *label in [self.view subviews]) {
            if (label.tag == kNoPostsLabelTag) {
                [label removeFromSuperview];
            }
        }
    } else {
        if (![self.view viewWithTag:kNoPostsLabelTag]) {
            _noPostsLabel = [[UILabel alloc]init];
            _noPostsLabel.tag = kNoPostsLabelTag;
            NSAttributedString *noPostsString = [[NSAttributedString alloc]initWithString:@"There are no posts in range." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"GurmukhiSangamMN" size:20], NSForegroundColorAttributeName: PRIMARY_BLACK_COLOR}];
            _noPostsLabel.attributedText = noPostsString;
            [_noPostsLabel sizeToFit];
            [self.view addSubview:_noPostsLabel];
            _noPostsLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - _noPostsLabel.frame.size.width/2, self.tableView.frame.size.height/2 - _noPostsLabel.frame.size.height/2 - 20, _noPostsLabel.frame.size.width, _noPostsLabel.frame.size.height);
        }
    }
    
    [self.tableView reloadData];
}

- (void)mediaBtnPressed:(id)sender {
    NSLog(@"mediaBtnPressed");
    // get the indexPath of the cell
    NSIndexPath *indexPath = [self GetIndexPathFromSender:sender];
    RetrievedPost *postPressed = (RetrievedPost*)_postsInRange[indexPath.row];
    
    if (postPressed.expanded == true) {
        postPressed.expanded = false;
        [sender setSelected:NO];
    } else {
        ((RetrievedPost*)_postsInRange[_previouslyExpandedIndexPath.row]).expanded = false;
        [((MainViewCell*)[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath]).mediaBtn setSelected:NO];
        postPressed.expanded = true;
        [((MainViewCell*)[self.tableView cellForRowAtIndexPath:indexPath]).mediaBtn setSelected:YES];
        self.expandedMessageLabelFrame = [self frameOfMessageLabel:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
    
    // get our 'expanded' message frame
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
    } else {
        self.expandedIndexPath = indexPath;
    }
    
    // add slick animations
    if (self.expandedMessageLabelFrame.size.height > 50) {
        [[sender superview] viewWithTag:4].alpha = 0;
        [UIView animateWithDuration:0.1
                              delay:0.3
                            options:0
                         animations:^{
                             [[sender superview] viewWithTag:4].alpha = 1;
                         } completion:^(BOOL finished) {
                             //
                         }];
    } else {
        [[sender superview] viewWithTag:4].alpha = 0;
        [UIView animateWithDuration:0.1
                              delay:0.1
                            options:0
                         animations:^{
                             [[sender superview] viewWithTag:4].alpha = 1;
                         } completion:^(BOOL finished) {
                             //
                             [UIView animateWithDuration:0.1
                                                   delay:0.1
                                                 options:0
                                              animations:^{
                                                  [[sender superview] viewWithTag:4].alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  //
                                                  [UIView animateWithDuration:0.1
                                                                        delay:0.1
                                                                      options:0
                                                                   animations:^{
                                                                       [[sender superview] viewWithTag:4].alpha = 1;
                                                                   } completion:^(BOOL finished) {
                                                                       //
                                                                       postPressed.expanded = false;
                                                                       [sender setSelected:NO];
                                                                   }];
                                              }];
                         }];
    }
    
    [self reconfigureCell:[self.tableView cellForRowAtIndexPath:indexPath]];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:YES];
    
    _previouslyExpandedIndexPath = indexPath;
}

- (void)scrollToTop {
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForRowAtPoint:CGPointMake(0, 0)] atScrollPosition:0 animated:YES];
}

- (void)collapseCells {
    // if we have an expanded cell collapse it
    if (_expandedIndexPath) {
        [((MainViewCell*)[self.tableView cellForRowAtIndexPath:_expandedIndexPath]).mediaBtn setSelected:NO];
        //_expandedIndexPath = nil;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        // if we'll be expanding the cell we trigger a text fade animation
        if (self.expandedMessageLabelFrame.size.height > 50) {
            ((MainViewCell*)[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath]).messageLabel.alpha = 0;
            [UIView animateWithDuration:0.1
                                  delay:0.3
                                options:0
                             animations:^{
                                 ((MainViewCell*)[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath]).messageLabel.alpha = 1;
                             } completion:^(BOOL finished) {
                                 //
                             }];
        }
        
        [self reconfigureCell:[self.tableView cellForRowAtIndexPath:_expandedIndexPath]];
        _expandedIndexPath = nil;
        [((MainViewCell*)[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath]).mediaBtn setSelected:NO];
    }
}

- (void)reconfigureCell:(UITableViewCell*)cell {
    // tell the table to update
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    // animate cell changes
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         // set bottomLines
                         [cell viewWithTag:5].frame = CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 2);
                         [[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath] viewWithTag:5].frame = CGRectMake(0, [self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath].frame.size.height - 2, self.tableView.frame.size.width, 2);
                         
                         // evaluate and adjust previously expanded cell's messageLabel
                         if ([[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath] viewWithTag:4].frame.size.height > 50) {
                             [[self.tableView cellForRowAtIndexPath:_previouslyExpandedIndexPath] viewWithTag:4].frame = CGRectMake(58, 10, 208, 72);
                         }
                         
                         // if we have an indexPath to expand resize the cell's messageLabel
                         if (_expandedIndexPath) {
                             [[cell viewWithTag:4] sizeToFit];
                         }
                     } completion:^(BOOL finished) {
                     }];
}

- (NSIndexPath*)GetIndexPathFromSender:(id)sender{
    
    if(!sender) { return nil; }
    
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = sender;
        return [self.tableView indexPathForCell:cell];
    }
    
    return [self GetIndexPathFromSender:((UIView*)[sender superview])];
}

// send me a MainViewCell and i'll tell you how big its messageLabel frame wants to be
- (CGRect)frameOfMessageLabel:(UITableViewCell*)cell {
    UILabel *labelCopy = [UILabel new];
    labelCopy.numberOfLines = 10;
    labelCopy.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:18];
    labelCopy.frame = CGRectMake(58, 10, 208, 400);
    labelCopy.text = ((UILabel*)[cell viewWithTag:4]).text;
    [labelCopy sizeToFit];
    return labelCopy.frame;
}

- (void)showActivityIndicator {
    [_host showActivityIndicator];
}

- (void)hideActivityIndicator {
    [_host hideActivityIndicator];
}

// removes posts older than 24 hours from the userDefaults bumpdPosts array
- (void)removeOldBumpd {
    NSMutableArray *newbumpdPosts = [[NSMutableArray alloc]init];
    NSArray *bumpdPosts = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
    for (NSDictionary *dict in bumpdPosts) {
        for (id key in dict)
        {
            id value = [dict objectForKey:key];
            
            if ([[NSDate date] timeIntervalSinceDate:value] < 60*60*24) {
                [newbumpdPosts addObject:dict];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:newbumpdPosts forKey:@"bumpdPosts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)bumpScoreBtnPressed:(id)sender {
    NSIndexPath *indexPath = [self GetIndexPathFromSender:sender];
    PFObject *postObject = ((PFObject*)((RetrievedPost*)_postsInRange[indexPath.row]).postObject);
    
    if (![postObject[@"originator"] isEqualToString:[PFUser currentUser].username]) {
        if (![sender isSelected]) { // remove the is selected
            [sender setSelected:YES];
            //((MainViewCell*)[self.tableView cellForRowAtIndexPath:indexPath]).bumpScoreLabel.textColor = [UIColor colorWithRed:0. green:1. blue:.61 alpha:1];
            NSMutableArray *bumpdPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
            NSMutableDictionary *bumpd = [[NSMutableDictionary alloc]init];
            bumpd[postObject.objectId] = postObject.createdAt;
            // bumpd = @{objectId: createdAt}
            if (![bumpdPosts containsObject:bumpd]) {
                NSLog(@"adding bumpd to bumpdPosts");
                [bumpdPosts addObject:bumpd];
                
                [[NSUserDefaults standardUserDefaults] setObject:bumpdPosts forKey:@"bumpdPosts"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (![_bumpdPosts containsObject:postObject.objectId]) {
                    [_bumpdPosts addObject:postObject.objectId];
                }
                
                /*
                 _bumpdPosts = [NSMutableArray new];
                 for (NSDictionary *dict in bumpdPosts) {
                 for (id key in dict)
                 {
                 [_bumpdPosts addObject:key];
                 }
                 }
                 */
            }
            
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            
            [self bump:indexPath];
            //PFObject *postObject = ((PFObject*)((RetrievedPost*)_postsInRange[indexPath.row]).postObject);
            long val = [[postObject valueForKey:@"points"] integerValue];
            [postObject setValue:[NSNumber numberWithLong:val+1] forKey:@"points"];
            [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
                    //NSLog(@"%@", postObject);
                }
            }];
            
            // create an array to hold any Points objects returned by our query
            NSMutableArray *pointsArray = [NSMutableArray new];
            PFQuery __block *pointsQuery = [PFQuery queryWithClassName:@"Points"];
            [pointsQuery whereKey:@"username" equalTo:(NSString*)postObject[@"originator"]];
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
                            pointScore[@"username"] = postObject[@"originator"];
                            [pointScore incrementKey:@"points"];
                            [pointScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    // The object has been saved.
                                    NSLog(@"Points.%@.points incremented", postObject[@"originator"]);
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
        
        // else undo selection
        else {
            [sender setSelected:NO];
            //((MainViewCell*)[self.tableView cellForRowAtIndexPath:indexPath]).bumpScoreLabel.textColor = [UIColor colorWithRed:0. green:1. blue:.61 alpha:1];
            NSMutableArray *bumpdPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
            NSMutableDictionary *bumpd = [[NSMutableDictionary alloc]init];
            // key = objectId value = createdAt
            bumpd[postObject.objectId] = postObject.createdAt;
            if ([bumpdPosts containsObject:bumpd]) {
                NSLog(@"removing bumpd from bumpdPosts");
                [bumpdPosts removeObject:bumpd];
                
                [[NSUserDefaults standardUserDefaults] setObject:bumpdPosts forKey:@"bumpdPosts"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([_bumpdPosts containsObject:postObject.objectId]) {
                    [_bumpdPosts removeObject:postObject.objectId];
                }
            }
            
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            
            [self unbump:indexPath];
            
            long val = [[postObject valueForKey:@"points"] integerValue];
            [postObject setValue:[NSNumber numberWithLong:val-1] forKey:@"points"];
            //PFObject *postObject = (PFObject*)_postsInRange[indexPath.row];
            [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //
                if (error) // Failed to save, show an alert view with the error message
                {
                    NSLog(@"Couldn't UN-Bump Post!");
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
                    NSLog(@"Successfully UN-Bumped Post!");
                    //NSLog(@"%@", postObject);
                }
            }];
            
            // create an array to hold any Points objects returned by our query
            NSMutableArray *pointsArray = [NSMutableArray new];
            PFQuery __block *pointsQuery = [PFQuery queryWithClassName:@"Points"];
            [pointsQuery whereKey:@"username" equalTo:(NSString*)postObject[@"originator"]];
            [pointsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %lu point records to increment.", (unsigned long)objects.count);
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                        [pointsArray addObject:object];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // if our query found objects increment their points
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
}

- (UIView*)drawBumpinBWithFrame:(CGRect)frame {
    UIView *bView = [[UIView alloc]initWithFrame:frame];
    // Drawing code
    UIImageView *bumpBot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_lowerBupvote.png"]];
    [bumpBot setContentMode:UIViewContentModeScaleAspectFit];
    bumpBot.tag = 102;
    [bView addSubview:bumpBot];
    bumpBot.frame = CGRectMake(12, 16, 19, 19);
    
    UIImageView *bumpMid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_upvoteMid.png"]];
    [bumpMid setContentMode:UIViewContentModeScaleAspectFit];
    bumpMid.tag = 101;
    [bView addSubview:bumpMid];
    bumpMid.frame = CGRectMake(12, 14, 6, 4);
    
    UIImageView *bumpTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_upvoteArrow.png"]];
    [bumpTop setContentMode:UIViewContentModeScaleAspectFit];
    bumpTop.tag = 100;
    [bView addSubview:bumpTop];
    bumpTop.frame = CGRectMake(9, 4, 12, 12);
    
    return bView;
}

// upvote animation goes here
- (void)bump:(NSIndexPath*)indexPath {
    MainViewCell *cell = (MainViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // draw glynt 1
    // draw glynt 2
    // grow and spin glynt 1 right and glynt 2 left

    cell.bumpScoreLabel.textColor = [UIColor colorWithRed:0 green:.91 blue:1 alpha:1];
    int incrementor = [cell.bumpScoreLabel.text intValue];
    incrementor += 1;
    cell.bumpScoreLabel.text = [NSString stringWithFormat:@"%d", incrementor];
    
    // increment the originators points by one
    NSLog(@"cell.post: %@", cell.post);
    
    // increment the posts points by one
}

- (void)unbump:(NSIndexPath*)indexPath {
    MainViewCell *cell = (MainViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.bumpScoreLabel.textColor = [UIColor colorWithRed:0.27 green:.47 blue:.53 alpha:1];
    int decrementor = [cell.bumpScoreLabel.text intValue];
    decrementor -= 1;
    cell.bumpScoreLabel.text = [NSString stringWithFormat:@"%d", decrementor];
    
    // decrement the originators points by one
}
/*
- (void)bump:(NSIndexPath*)indexPath {
    NSLog(@"bumpn");
    
    MainViewCell *cell = (MainViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell.bumpBtn setHidden:YES];
    
    // draw the sprite
    // b
    UIView *bumpnB = [self drawBumpinBWithFrame:cell.bumpBtn.frame];
    [cell addSubview:bumpnB];
    bumpnB.frame = cell.bumpBtn.frame;
    
    CGRect originalTopFrame = CGRectMake([bumpnB viewWithTag:100].frame.origin.x, [bumpnB viewWithTag:100].frame.origin.y, [bumpnB viewWithTag:100].frame.size.width, [bumpnB viewWithTag:100].frame.size.height);
    CGRect originalMidFrame = CGRectMake([bumpnB viewWithTag:101].frame.origin.x, [bumpnB viewWithTag:101].frame.origin.y, [bumpnB viewWithTag:101].frame.size.width, [bumpnB viewWithTag:101].frame.size.height);

    // animate arrow down
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // arrow top down
                         [bumpnB viewWithTag:100].frame = CGRectMake([bumpnB viewWithTag:100].frame.origin.x, [bumpnB viewWithTag:100].frame.origin.y +3, [bumpnB viewWithTag:100].frame.size.width, [bumpnB viewWithTag:100].frame.size.height);
                         // arrow mid down
                         [bumpnB viewWithTag:101].frame = CGRectMake([bumpnB viewWithTag:101].frame.origin.x, [bumpnB viewWithTag:101].frame.origin.y +2, [bumpnB viewWithTag:101].frame.size.width, [bumpnB viewWithTag:101].frame.size.height);
                     } completion:^(BOOL finished) {
                         // Animate arrow up
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // arrow top up
                                              [bumpnB viewWithTag:100].frame = CGRectMake([bumpnB viewWithTag:100].frame.origin.x, [bumpnB viewWithTag:100].frame.origin.y - 16, [bumpnB viewWithTag:100].frame.size.width, [bumpnB viewWithTag:100].frame.size.height);
                                              [bumpnB viewWithTag:100].frame = CGRectInset([bumpnB viewWithTag:100].frame, -5, -5);
                                              // arrow mid up
                                              [bumpnB viewWithTag:101].frame = CGRectMake([bumpnB viewWithTag:101].frame.origin.x, [bumpnB viewWithTag:101].frame.origin.y - 5, [bumpnB viewWithTag:101].frame.size.width, [bumpnB viewWithTag:101].frame.size.height);
                                          } completion:^(BOOL finished) {
                                              // animate arrow back down
                                              [UIView animateWithDuration:0.2
                                                                    delay:0.3
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   // arrow top down
                                                                   [bumpnB viewWithTag:100].frame = originalTopFrame;
                                                                   // arrow mid down
                                                                   [bumpnB viewWithTag:101].frame = originalMidFrame;
                                                               } completion:^(BOOL finished) {
                                                                   [bumpnB removeFromSuperview];
                                                                   [cell.bumpBtn setHidden:NO];
                                                                   
                                                                   cell.bumpScoreLabel.textColor = [UIColor colorWithRed:0 green:.91 blue:1 alpha:1];
                                                                   int incrementor = [cell.bumpScoreLabel.text intValue];
                                                                   incrementor += 1;
                                                                   cell.bumpScoreLabel.text = [NSString stringWithFormat:@"%d", incrementor];
                                                               }];
                                          }];
                     }];
}
*/

@end
