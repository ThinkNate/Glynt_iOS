//
//  NewPostViewController.h
//  Bumpn
//
//  Created by Nate Berman on 8/20/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MainView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface NewPostViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UITextView *messageField;

@property (weak, nonatomic) IBOutlet UIView *topGuard;

@property (weak, nonatomic) IBOutlet UIView *topHorizontal;

@property (weak, nonatomic) IBOutlet UIView *botHorizontal;

@property (nonatomic, strong) IBOutlet UILabel *characterCount;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
- (IBAction)cameraBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkBtn:(id)sender;


- (BOOL)checkCharacterCount:(UITextView *)aTextView;
- (void)updateCharacterCount:(UITextView *)aTextView;

@property (nonatomic) UIView *activityCover;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@property (nonatomic) MainView *host;

@end
