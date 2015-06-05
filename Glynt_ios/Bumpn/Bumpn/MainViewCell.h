//
//  MainViewCell.h
//  Bumpn
//
//  Created by Nate Berman on 9/7/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTDBumpnB.h"
#import <Parse/Parse.h>

@protocol MainViewCellDelegate <NSObject>

- (void)mediaBtnPressed:(id)sender;
- (void)bumpScoreBtnPressed:(id)sender;

@end

@interface MainViewCell : UITableViewCell
    
@property (nonatomic, weak) id <MainViewCellDelegate> delegate;

@property (nonatomic) int indexPathRow;

@property (nonatomic, strong) PFObject *post;

@property (nonatomic, strong) id postID;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *mediaBtn;
- (IBAction)mediaBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet DTDBumpnB *bumpn;

@property (weak, nonatomic) IBOutlet UIButton *bumpBtn;
- (IBAction)bumpBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bumpScoreLabel;


@end
