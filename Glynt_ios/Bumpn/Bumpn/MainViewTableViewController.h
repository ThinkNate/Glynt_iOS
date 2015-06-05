//
//  MainViewTableViewController.h
//  Bumpn
//
//  Created by Nate Berman on 9/1/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MainViewCell.h"
#import "MainView.h"

const static int kNoPostsLabelTag = 477;

@class MainView;

@interface MainViewTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, MainViewCellDelegate>

@property (nonatomic) MainView *host;

- (BOOL)shouldGetPosts;
- (void)getPosts;
@property (nonatomic, strong) NSMutableArray *allPostsArray;
@property (nonatomic) NSMutableArray *rejiggeredPostObjectArray;
@property (nonatomic, strong) NSMutableArray *postsInRange;
- (void)filterAllPostsToRange;

@property (nonatomic, strong) NSMutableArray *bumpdPosts;

@property (nonatomic) UIView *activityCover;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;


@end
