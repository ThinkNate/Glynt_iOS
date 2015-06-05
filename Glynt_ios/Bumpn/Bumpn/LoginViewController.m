//
//  LoginViewController.m
//  Bumpn
//
//  Created by Nate Berman on 10/26/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "LoginViewController.h"
#import "DTDAppDelegate.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "MainView.h"
#import "TransitionLoginToMain.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController setNavigationBarHidden:YES];
    [self configureBaseView];
    [self showNewAndLoginButtons];
    [[UIApplication sharedApplication]setStatusBarHidden:true];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.activityCover = [[UIView alloc]init];
    self.activityCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.activityCover.layer.cornerRadius = 5;
    self.activityCover.hidden = true;
    [self.view addSubview:self.activityCover];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityCover addSubview:self.activityIndicator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    self.activityCover.frame = CGRectMake(0, 0, 50, 50);
    self.activityCover.center = self.view.center;
    self.activityIndicator.frame = self.activityCover.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return true;
}


#pragma mark View Placement
- (void)configureBaseView {
    
    // background
    self.blackBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.blackBackground.backgroundColor = PRIMARY_ORANGE_COLOR;
    [self.view addSubview: self.blackBackground];
    [self.view sendSubviewToBack:self.blackBackground];
    
    // Glynt Triangle
    self.glyntImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Glynt_Triangle_Login.png"]];
    self.glyntImage.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    [self.view addSubview:self.glyntImage];
    
    // keyboard resigner
    UIButton *resigner = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view insertSubview:resigner aboveSubview:self.glyntImage];
    resigner.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [resigner addTarget:self action:@selector(resignResponder) forControlEvents:UIControlEventTouchUpInside];
    resigner.tag = 999;
    
}

- (void)showNewAndLoginButtons {
    _newUser = FALSE;
    _login = FALSE;
    // newBtn
    _newuserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_newuserBtn];
    NSAttributedString *newString = [[NSAttributedString alloc]initWithString:@"new" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_newuserBtn setAttributedTitle:newString forState:UIControlStateNormal];
    newString = [[NSAttributedString alloc]initWithString:@"new" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_newuserBtn setAttributedTitle:newString forState:UIControlStateHighlighted];
    [_newuserBtn addTarget:self action:@selector(newBtn:) forControlEvents:UIControlEventTouchUpInside];
    _newuserBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, [UIScreen mainScreen].bounds.size.height/2 - 40, 100, _newuserBtn.titleLabel.font.pointSize);
    _newuserBtn.alpha = 0;
    
    // loginBtn
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_loginBtn];
    NSAttributedString *loginString = [[NSAttributedString alloc]initWithString:@"login" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_loginBtn setAttributedTitle:loginString forState:UIControlStateNormal];
    loginString = [[NSAttributedString alloc]initWithString:@"login" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_loginBtn setAttributedTitle:loginString forState:UIControlStateHighlighted];
    _loginBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, _newuserBtn.frame.origin.y + _newuserBtn.frame.size.height + 35, 100, _loginBtn.titleLabel.font.pointSize);
    [_loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.alpha = 0;
    
    // animate buttons in to place
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _newuserBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, [UIScreen mainScreen].bounds.size.height/2 - 30, 100, _newuserBtn.titleLabel.font.pointSize);
                         _newuserBtn.alpha = 1;
                     } completion:^(BOOL finished) {
                         //
                     }];
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _loginBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, _newuserBtn.frame.origin.y + _newuserBtn.frame.size.height + 40, 100, _loginBtn.titleLabel.font.pointSize);
                         _loginBtn.alpha = 1;
                     } completion:^(BOOL finished) {
                         //
                     }];
}

- (void)hideNewAndLoginButtons {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:NO
                     animations:^{
                         _loginBtn.frame = CGRectMake(_loginBtn.frame.origin.x, _loginBtn.frame.origin.y + 10, _loginBtn.frame.size.width, _loginBtn.frame.size.height);
                         _loginBtn.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_loginBtn removeFromSuperview];
                     }];
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:NO
                     animations:^{
                         _newuserBtn.frame = CGRectMake(_newuserBtn.frame.origin.x, _newuserBtn.frame.origin.y + 10, _newuserBtn.frame.size.width, _newuserBtn.frame.size.height);
                         _newuserBtn.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_newuserBtn removeFromSuperview];
                     }];
}

- (void)resetTextfieldPlacement {
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.view endEditing:YES];
                         _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 30, self.view.bounds.size.width - 20, 44);
                         _nameField.alpha = 1;
                         _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                         _passwordField.alpha = 1;
                         _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                         _emailField.alpha = 1;
                     }];
}

- (UIView*)drawBumpinB {
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 58, 100)];
    // Drawing code
    UIImageView *bumpBot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_bottom_B.png"]];
    [bumpBot setContentMode:UIViewContentModeScaleAspectFit];
    bumpBot.tag = 102;
    [bView addSubview:bumpBot];
    bumpBot.frame = CGRectMake(10, 55, 48, 48);
    
    UIImageView *bumpMid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_arrowTail.png"]];
    [bumpMid setContentMode:UIViewContentModeScaleAspectFit];
    bumpMid.tag = 101;
    [bView addSubview:bumpMid];
    bumpMid.frame = CGRectMake(11, 47, 12, 14);
    
    UIImageView *bumpTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_top_arrow.png"]];
    [bumpTop setContentMode:UIViewContentModeScaleAspectFit];
    bumpTop.tag = 100;
    [bView addSubview:bumpTop];
    bumpTop.frame = CGRectMake(0, 27, 36, 26);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bump:)];
    [bView addGestureRecognizer:tap];
    [bView setUserInteractionEnabled:YES];
    
    return bView;
}

- (void)bump:(UITapGestureRecognizer*)bump {
    
    CGRect originalTopFrame = CGRectMake([bump.view viewWithTag:100].frame.origin.x, [bump.view viewWithTag:100].frame.origin.y, [bump.view viewWithTag:100].frame.size.width, [bump.view viewWithTag:100].frame.size.height);
    CGRect originalMidFrame = CGRectMake([bump.view viewWithTag:101].frame.origin.x, [bump.view viewWithTag:101].frame.origin.y, [bump.view viewWithTag:101].frame.size.width, [bump.view viewWithTag:101].frame.size.height);
    
    // turn off user interaction
    // turn user interaction back on at the end of this animation chain
    [bump.view setUserInteractionEnabled:NO];
    // animate arrow down
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // arrow top down
                         [bump.view viewWithTag:100].frame = CGRectMake([bump.view viewWithTag:100].frame.origin.x, [bump.view viewWithTag:100].frame.origin.y +3, [bump.view viewWithTag:100].frame.size.width, [bump.view viewWithTag:100].frame.size.height);
                         // arrow mid down
                         [bump.view viewWithTag:101].frame = CGRectMake([bump.view viewWithTag:101].frame.origin.x, [bump.view viewWithTag:101].frame.origin.y +2, [bump.view viewWithTag:101].frame.size.width, [bump.view viewWithTag:101].frame.size.height);
                     } completion:^(BOOL finished) {
                         // Animate arrow up
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // arrow top up
                                              [bump.view viewWithTag:100].frame = CGRectMake([bump.view viewWithTag:100].frame.origin.x, [bump.view viewWithTag:100].frame.origin.y - 16, [bump.view viewWithTag:100].frame.size.width, [bump.view viewWithTag:100].frame.size.height);
                                              [bump.view viewWithTag:100].frame = CGRectInset([bump.view viewWithTag:100].frame, -5, -5);
                                              // arrow mid up
                                              [bump.view viewWithTag:101].frame = CGRectMake([bump.view viewWithTag:101].frame.origin.x, [bump.view viewWithTag:101].frame.origin.y - 5, [bump.view viewWithTag:101].frame.size.width, [bump.view viewWithTag:101].frame.size.height);
                                          } completion:^(BOOL finished) {
                                              // animate arrow back down
                                              [UIView animateWithDuration:0.2
                                                                    delay:0.3
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   // arrow top down
                                                                   [bump.view viewWithTag:100].frame = originalTopFrame;
                                                                   // arrow mid down
                                                                   [bump.view viewWithTag:101].frame = originalMidFrame;
                                                               } completion:^(BOOL finished) {
                                                                   // turn on user interaction
                                                                   [bump.view setUserInteractionEnabled:YES];
                                                               }];
                                          }];
                     }];
    
    // animate arrow mid up
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // arrow mid up
                         [bump.view viewWithTag:101].frame = CGRectMake([bump.view viewWithTag:101].frame.origin.x, [bump.view viewWithTag:101].frame.origin.y - 5, [bump.view viewWithTag:101].frame.size.width, [bump.view viewWithTag:101].frame.size.height);
                     } completion:^(BOOL finished) {
                         // animate arrow back down
                         [UIView animateWithDuration:0.2
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // arrow mid down
                                              [bump.view viewWithTag:101].frame = originalMidFrame;
                                          } completion:^(BOOL finished) {
                                              //
                                          }];
                     }];
    
    
}


#pragma mark TEXTFIELD DELEGATE PROTOCOLS
#define MAXLENGTH 40
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    switch (textField.tag) {
        case 0:
            self.username = textField.text;
            break;
        case 1:
            self.password = textField.text;
            break;
        case 2:
            self.email = textField.text;
        default:
            break;
    }
    
    return newLength <= MAXLENGTH || returnKey;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    // slide keyboard up
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    // If we found a nextResponder set focus.
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    }
    
    // No more nextResponders found, so remove keyboard.
    else {
        [textField resignFirstResponder];
        _nameField.alpha = 1;
        _passwordField.alpha = 1;
        if (_newUser) {
            _emailField.alpha = 1;
        }
        _username = _nameField.text;
        _password = _passwordField.text;
        _email = _emailField.text;
        if ([_email length] > 50) {
            _email = [_email substringToIndex:50];
        }
        [self resetTextfieldPlacement];
        [self confirmFieldEntry];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

// move textFields to keep focus on responder
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    switch (textField.tag) {
            // nameField selected
        case 0:{
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 30, self.view.bounds.size.width - 20, 44);
                                 _nameField.alpha = 1;
                                 _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                                 _passwordField.alpha = .3;
                                 if (_newUser) {
                                     _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                                     _emailField.alpha = .3;
                                 }
                             }];}
            break;
            // passwordField selected
        case 1:{
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 90, self.view.bounds.size.width - 20, 44);
                                 _nameField.alpha = .3;
                                 _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                                 _passwordField.alpha = 1;
                                 if (_newUser) {
                                     _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                                     _emailField.alpha = .3;
                                 }
                             }];}
            break;
            // emailField selected
        case 2:{
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 140, self.view.bounds.size.width - 20, 44);
                                 _nameField.alpha = .3;
                                 _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                                 _passwordField.alpha = .3;
                                 if (_newUser) {
                                     _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                                     _emailField.alpha = 1;
                                 }
                             }];}
            break;
        default:{
        }
            break;
    }
    return YES;
}

// when resigningResponder validate fields and show checkBtn if appropriate
- (void)resignResponder {
    NSLog(@"resigner tapped");
    [self.view endEditing:YES];
    [self resetTextfieldPlacement];
    if (_newUser) {
        if (_username && _password && _email) {
            if ([self NSStringIsValidEmail:_email]) {
                NSLog(@"email is properly formed");
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     _checkBtn.alpha = 1;
                                     _checkBtn.frame = CGRectMake(175, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
                                 }];
            }
        }
    }
    else if (_login) {
        if (_username.length > 0 && _password.length > 0) {
            [UIView animateWithDuration:0.4
                             animations:^{
                                 _checkBtn.alpha = 1;
                                 _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
                             }];
        }
    }
}


#pragma mark Actions
// goes to new user scene
- (IBAction)newBtn:(id)sender {
    _newUser = TRUE;
    _login = FALSE;
    
    // turn text colors
    NSAttributedString *newString = [[NSAttributedString alloc]initWithString:@"new" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_newuserBtn setAttributedTitle:newString forState:UIControlStateNormal];
    
    [self hideNewAndLoginButtons];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // name
    _nameField = [[UITextField alloc]init];
    _nameField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:_nameField];
    NSAttributedString *nameString = [[NSAttributedString alloc]initWithString:@"name" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36], NSParagraphStyleAttributeName : paragraphStyle}];
    _nameField.backgroundColor = PRIMARY_ORANGE_COLOR;
    [_nameField setAttributedPlaceholder:nameString];
    _nameField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:36];
    _nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameField.returnKeyType = UIReturnKeyNext;
    _nameField.textAlignment = NSTextAlignmentCenter;
    _nameField.textColor = [UIColor whiteColor];
    _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 50, self.view.bounds.size.width - 20, 44);
    _nameField.adjustsFontSizeToFitWidth = YES;
    _nameField.minimumFontSize = 16;
    _nameField.delegate = self;
    _nameField.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0.5
                        options:0
                     animations:^{
                         _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 40, self.view.bounds.size.width - 20, 44);
                         _nameField.alpha = 1;
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    // password
    _passwordField = [[UITextField alloc]init];
    _passwordField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:_passwordField];
    NSAttributedString *passwordString = [[NSAttributedString alloc]initWithString:@"password" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36], NSParagraphStyleAttributeName : paragraphStyle}];
    _passwordField.backgroundColor = PRIMARY_ORANGE_COLOR;
    [_passwordField setAttributedPlaceholder:passwordString];
    _passwordField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:36];
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _passwordField.textAlignment = NSTextAlignmentCenter;
    _passwordField.textColor = [UIColor whiteColor];
    _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 10, self.view.bounds.size.width - 20, 44);
    _passwordField.adjustsFontSizeToFitWidth = YES;
    _passwordField.minimumFontSize = 16;
    [_passwordField setSecureTextEntry:YES];
    _passwordField.delegate = self;
    _passwordField.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0.7
                        options:0
                     animations:^{
                         _passwordField.alpha = 1;
                         _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    _emailField = [[UITextField alloc]init];
    _emailField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:_emailField];
    NSAttributedString *emailString = [[NSAttributedString alloc]initWithString:@"email" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36], NSParagraphStyleAttributeName : paragraphStyle}];
    _emailField.backgroundColor = PRIMARY_ORANGE_COLOR;
    [_emailField setAttributedPlaceholder:emailString];
    _emailField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:36];
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailField.returnKeyType = UIReturnKeyDone;
    _emailField.textAlignment = NSTextAlignmentCenter;
    _emailField.textColor = [UIColor whiteColor];
    _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 10, self.view.bounds.size.width - 20, 44);
    _emailField.adjustsFontSizeToFitWidth = YES;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.minimumFontSize = 6;
    _emailField.delegate = self;
    _emailField.tag = 2;
    _emailField.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:1
                        options:0
                     animations:^{
                         _emailField.alpha = 1;
                         _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    // back
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"backarrow_downstate.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.alpha = 0;
    _backBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, 100, 77);
    [UIView animateWithDuration:0.3
                          delay:1.2
                        options:0
                     animations:^{
                         _backBtn.alpha = 1;
                         _backBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    // check
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setImage:[UIImage imageNamed:@"newcheck.png"] forState:UIControlStateNormal];
    [_checkBtn setImage:[UIImage imageNamed:@"newcheck_downstate.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_checkBtn];
    [_checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
    _checkBtn.alpha = 0;
    _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
    
    
    _nameField.tag = 0;
    _passwordField.tag = 1;
    
    [self.view bringSubviewToFront:self.glyntImage];
}

- (IBAction)loginBtn:(id)sender {
    //self.navigationController.delegate = self;
    _login = TRUE;
    _newUser = FALSE;
    
    // turn text blue
    NSAttributedString *newString = [[NSAttributedString alloc]initWithString:@"login" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_loginBtn setAttributedTitle:newString forState:UIControlStateNormal];
    
    [self hideNewAndLoginButtons];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    // name
    _nameField = [[UITextField alloc]init];
    _nameField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:_nameField];
    NSAttributedString *nameString = [[NSAttributedString alloc]initWithString:@"name" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36], NSParagraphStyleAttributeName : paragraphStyle}];
    _nameField.backgroundColor = PRIMARY_ORANGE_COLOR;
    [_nameField setAttributedPlaceholder:nameString];
    _nameField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:36];
    _nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameField.returnKeyType = UIReturnKeyNext;
    _nameField.textAlignment = NSTextAlignmentCenter;
    _nameField.textColor = [UIColor whiteColor];
    _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 50, self.view.bounds.size.width - 20, 44);
    _nameField.adjustsFontSizeToFitWidth = YES;
    _nameField.minimumFontSize = 16;
    _nameField.delegate = self;
    _nameField.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0.5
                        options:0
                     animations:^{
                         _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 40, self.view.bounds.size.width - 20, 44);
                         _nameField.alpha = 1;
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    // password
    _passwordField = [[UITextField alloc]init];
    _passwordField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:_passwordField];
    NSAttributedString *passwordString = [[NSAttributedString alloc]initWithString:@"password" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36], NSParagraphStyleAttributeName : paragraphStyle}];
    _passwordField.backgroundColor = PRIMARY_ORANGE_COLOR;
    [_passwordField setAttributedPlaceholder:passwordString];
    _passwordField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:36];
    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _passwordField.textAlignment = NSTextAlignmentCenter;
    _passwordField.text = nil;
    _passwordField.textColor = [UIColor whiteColor];
    _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 10, self.view.bounds.size.width - 20, 44);
    _passwordField.adjustsFontSizeToFitWidth = YES;
    _passwordField.minimumFontSize = 16;
    [_passwordField setSecureTextEntry:YES];
    _passwordField.delegate = self;
    _passwordField.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0.7
                        options:0
                     animations:^{
                         _passwordField.alpha = 1;
                         _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, self.view.bounds.size.width - 20, 44);
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    // back
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"backarrow_downstate.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.alpha = 0;
    _backBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, 100, 77);
    [UIView animateWithDuration:0.3
                          delay:1
                        options:0
                     animations:^{
                         _backBtn.alpha = 1;
                         _backBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
                     } completion:^(BOOL finished) {
                         //
                     }];
    
    // check
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setImage:[UIImage imageNamed:@"newcheck.png"] forState:UIControlStateNormal];
    [_checkBtn setImage:[UIImage imageNamed:@"newcheck_downstate.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_checkBtn];
    [_checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
    _checkBtn.alpha = 0;
    _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
    
    
    
    _nameField.tag = 0;
    _passwordField.tag = 1;
}

// deconstructs scene and returns to default launch scene
- (IBAction)backBtn:(id)sender {
    [_nameField setUserInteractionEnabled:false];
    [_passwordField setUserInteractionEnabled:false];
    [_emailField setUserInteractionEnabled:false];
    
    if (_newUser) {
        // remove email field
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _emailField.frame = CGRectMake(_emailField.frame.origin.x, _emailField.frame.origin.y + 10, _emailField.frame.size.width, _emailField.frame.size.height);
                             _emailField.alpha = 0;
                         } completion:^(BOOL finished) {
                             _emailField.text = nil;
                             [_emailField removeFromSuperview];
                             _email = @"";
                         }];
        // remove password field
        [UIView animateWithDuration:0.3
                              delay:0.2
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _passwordField.frame = CGRectMake(_passwordField.frame.origin.x, _passwordField.frame.origin.y + 10, _passwordField.frame.size.width, _passwordField.frame.size.height);
                             _passwordField.alpha = 0;
                         } completion:^(BOOL finished) {
                             _passwordField.text = nil;
                             [_passwordField removeFromSuperview];
                             _password = @"";
                         }];
        // remove name field
        [UIView animateWithDuration:0.3
                              delay:0.4
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _nameField.frame = CGRectMake(_nameField.frame.origin.x, _nameField.frame.origin.y + 10, _nameField.frame.size.width, _nameField.frame.size.height);
                             _nameField.alpha = 0;
                         } completion:^(BOOL finished) {
                             _nameField.text = nil;
                             [_nameField removeFromSuperview];
                             _username = @"";
                             [self showNewAndLoginButtons];
                         }];
    }
    else {
        // remove password field
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _passwordField.frame = CGRectMake(_passwordField.frame.origin.x, _passwordField.frame.origin.y + 10, _passwordField.frame.size.width, _passwordField.frame.size.height);
                             _passwordField.alpha = 0;
                         } completion:^(BOOL finished) {
                             _passwordField.text = nil;
                             [_passwordField removeFromSuperview];
                             _password = @"";
                         }];
        // remove name field
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _nameField.frame = CGRectMake(_nameField.frame.origin.x, _nameField.frame.origin.y + 10, _nameField.frame.size.width, _nameField.frame.size.height);
                             _nameField.alpha = 0;
                         } completion:^(BOOL finished) {
                             _nameField.text = nil;
                             [_nameField removeFromSuperview];
                             _username = @"";
                             [self showNewAndLoginButtons];
                         }];
    }
    // either way, remove back and check buttons
    [_backBtn setImage:[UIImage imageNamed:@"backarrow_downstate.png"] forState:UIControlStateNormal];
    [UIView animateKeyframesWithDuration:0.4
                                   delay:0
                                 options:NO
                              animations:^{
                                  _backBtn.frame = CGRectMake(_backBtn.frame.origin.x, _backBtn.frame.origin.y + 10, _backBtn.frame.size.width, _backBtn.frame.size.height);
                                  _backBtn.alpha = 0;
                              } completion:^(BOOL finished) {
                                  //
                              }];
    [UIView animateKeyframesWithDuration:0.4
                                   delay:0
                                 options:NO
                              animations:^{
                                  _checkBtn.frame = CGRectMake(_checkBtn.frame.origin.x, _checkBtn.frame.origin.y + 10, _checkBtn.frame.size.width, _checkBtn.frame.size.height);
                                  _checkBtn.alpha = 0;
                              } completion:^(BOOL finished) {
                                  //
                              }];
}

// send user object to server for validation
// if success response save token and log in
// if fail provide alert with reason
- (IBAction)checkBtn:(id)sender {
    
    // alert if no location services are enabled
    if ((![CLLocationManager locationServicesEnabled])
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Are Disabled"
                                                             message:@"Please enable location services in your phone's settings"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        return;
    }
    
    // deflect curiosity
    [_checkBtn setUserInteractionEnabled:NO];
    [self showActivityIndicator];
    
    _username = _nameField.text;
    _password = _passwordField.text;
    
    PFUser *user = [PFUser user];
    user.username = [_username lowercaseString];
    user.password = _password;
    
    // new user
    if (_newUser) {
        _email = _emailField.text;
        if ([_email length] > 50) {
            _email = [_email substringToIndex:50];
        }
        user.email= [_email lowercaseString];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             NSLog(@"sending new user to parse");
             if (error) {
                 
                 NSLog(@"error.code: %ld", (long)error.code);
                 UIAlertView *alertView = nil;
                 // invalid email address
                 if (error.code == 125) {
                     alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"invalid email address"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
                 // username already exists
                 else if (error.code == 202) {
                     alertView = [[UIAlertView alloc] initWithTitle:@"Too Slow!"
                                                            message:@"someone's already claimed the username you entered"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
                 // email address already exists in system. no new user can be created
                 else if (error.code == 203) {
                     alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh!"
                                                            message:@"the email address you are trying to sign up with already exists in our system"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
                 else // Login failed for another reason
                 {
                     // Create an alert view to tell the user
                     alertView = [[UIAlertView alloc] initWithTitle:@"An error occured"
                                                            message:@"Please wait a few minutes, or try again with different credentials"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self hideActivityIndicator];
                 [alertView show];
                 [_checkBtn setUserInteractionEnabled:YES];
             });
             return;
             } else {
                  NSLog(@"new user created");
                 [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"user"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
                 // range
                 [[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:kFilterDistanceKey];
                 [[NSUserDefaults standardUserDefaults] setDouble:0.5 forKey:kRangeSliderKey];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideActivityIndicator];
                     [self showNavigationAndLogIn];
                 });
             }
         }];
    }
    
    // already a user
    else {
        [PFUser logInWithUsernameInBackground:_username
                                     password:_password
                                        block:^(PFUser *user, NSError *error)
         {
             if (!error) // Login successful
             {
                 NSLog(@"successful login");
                 [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"user"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
                 // range
                 [[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:kFilterDistanceKey];
                 [[NSUserDefaults standardUserDefaults] setDouble:0.5 forKey:kRangeSliderKey];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideActivityIndicator];
                     [self showNavigationAndLogIn];
                 });
             }
             else // Login failed
             {
                 NSLog(@"error.code: %ld", (long)error.code);
                 UIAlertView *alertView = nil;
                 // Login failed because of an invalid username and password
                 if (error == nil)
                 {
                     alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"incorrect username/password\ncombination"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
                 // invalid email address
                 else if (error.code == 101) {
                     alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"invalid login credentials"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
                 else // Login failed for another reason
                 {
                     // Create an alert view to tell the user
                     alertView = [[UIAlertView alloc] initWithTitle:@"An error occured"
                                                            message:@"Please wait a few minutes, or try again with different credentials"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
                 }
                 // Show the alert view
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self hideActivityIndicator];
                     [alertView show];
                     [_checkBtn setUserInteractionEnabled:YES];
                 });
             }
         }];
    }
}


#pragma mark Field Confirmation
- (void)confirmFieldEntry {
    NSLog(@"confirming field entry");
    // if new user flow
    if (_newUser) {
        if (_username.length > 0 && _password.length > 0 && _email.length > 0) {
            NSLog(@"all fiends have data");
            if ([self NSStringIsValidEmail:_email]) {
                NSLog(@"email is properly formed");
                _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height -80, 100, 77);
                [UIView animateWithDuration:0.4
                                 animations:^{
                                     _checkBtn.alpha = 1;
                                     _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height -90, 100, 77);

                                 }];
            }
        }
    }
    else if (_login) {
        if (_username.length > 0 && _password.length > 0) {
            NSLog(@"all fiends have data");
            _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height -80, 100, 77);
            [UIView animateWithDuration:0.4
                             animations:^{
                                 _checkBtn.alpha = 1;
                                 _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height -90, 100, 77);

                             }];
        }
    }
}

// verify email address could be a possible address before
// if fail send alert about email address not looking legit
-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    NSLog(@"confirming email address: %@", checkString);
    //BOOL stricterFilter = YES;
    //NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{1,}";//{2}[A-Za-z]*";
    //NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSString *emailRegex = laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark Navigation
- (void)showNavigationAndLogIn {
    //[self.navigationController setNavigationBarHidden:NO];
    //[self performSegueWithIdentifier:@"loginSegue" sender:self];
    /*
    self.navigationController.delegate = self;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MainView *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self.navigationController pushViewController:vc animated:YES];
    */
    [[UIApplication sharedApplication]setStatusBarHidden:false];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToMainView" object:nil];
    [self dismissViewControllerAnimated:true completion:^{
        //
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[MainView class]]) {
        NSLog(@"return TransitionLoginToMain");
        TransitionLoginToMain *animationController = [[TransitionLoginToMain alloc]init];
        animationController.duration = 1.5;
        return animationController;
    }
    else return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *) presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    NSLog(@"presenting animation TransitionLoginToMain");
    return [[TransitionLoginToMain alloc] init];
}


#pragma mark Activity Indicator
- (void)showActivityIndicator {
    //[self.refreshBtn setUserInteractionEnabled:NO];
    [self.view bringSubviewToFront:self.activityCover];
    self.activityCover.frame = CGRectMake(self.activityCover.frame.origin.x, self.nameField.frame.origin.y - 50 - 20, 50, 50);
    [self.activityIndicator startAnimating];
    self.activityCover.hidden = false;
}

- (void)hideActivityIndicator {
    NSLog(@"hiding activity indicatory");
    self.activityCover.hidden = true;
    [self.activityIndicator stopAnimating];
}

@end
