//
//  PostDetailViewController.h
//  Bumpn
//
//  Created by Nate Berman on 9/1/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) PFObject *postObject;

//@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *messageField;

@property(weak, nonatomic) IBOutlet UILabel *originatorUsername;
@property (nonatomic, weak) IBOutlet UILabel *timestamp;
@property (nonatomic, weak) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet UIView *topHorizontal;

@property (weak, nonatomic) IBOutlet UIView *botHorizontal;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *bumpBtn;
- (IBAction)bumpBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *bumpScoreLabel;

@end
