//
//  DTDViewController.m
//  Bumpn
//
//  Created by Nate Berman on 7/19/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "DTDViewController.h"
#import "DTDAppDelegate.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "MainView.h"

@interface DTDViewController ()

@property (nonatomic) UITextField *nameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UITextField *emailField;

@property (nonatomic) UIButton *backBtn;
@property (nonatomic) UIButton *checkBtn;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *email;

@property (nonatomic) UIView *bumpnB;
@property (nonatomic) UIImageView *umpn;

@property (nonatomic) BOOL login;
@property (nonatomic) BOOL newUser;

@property (nonatomic) UIView *activityCover;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation DTDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self configureLogin];
}

- (void)configureLogin {
    
    // background
    UIView *blackBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    blackBackground.backgroundColor = PRIMARY_ORANGE_COLOR;
    [self.view addSubview: blackBackground];
    [self.view sendSubviewToBack:blackBackground];
    // b
    if (![_bumpnB isDescendantOfView:self.view]) {
        _bumpnB = [self drawBumpinB];
        [self.view addSubview:_bumpnB];
        _bumpnB.frame = CGRectMake(15, 10, 58, 100);
        // umpn
        _umpn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Umpn_01_white.png"]];
        [self.view addSubview:_umpn];
        [_umpn sizeToFit];
        _umpn.frame = CGRectMake(_bumpnB.frame.origin.x + _bumpnB.frame.size.width, _bumpnB.frame.origin.y+57, _umpn.image.size.width/2, _umpn.image.size.height/2);
    }
    // resigner
    UIButton *resigner = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view insertSubview:resigner belowSubview:_bumpnB];
    resigner.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [resigner addTarget:self action:@selector(resignResponder) forControlEvents:UIControlEventTouchUpInside];
    
    [self newOrLogin:@"setup"];
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

- (UIView*)drawBumpinBSmall {
    UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 58, 100)];
    // Drawing code
    UIImageView *bumpBot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_bottom_B.png"]];
    [bumpBot setContentMode:UIViewContentModeScaleAspectFit];
    bumpBot.tag = 102;
    [bView addSubview:bumpBot];
    bumpBot.frame = CGRectMake(10, 55, 48/2, 40/2);
    
    UIImageView *bumpMid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_arrowTail.png"]];
    [bumpMid setContentMode:UIViewContentModeScaleAspectFit];
    bumpMid.tag = 101;
    [bView addSubview:bumpMid];
    bumpMid.frame = CGRectMake(12, 49, 10/2, 12/2);
    
    UIImageView *bumpTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_top_arrow.png"]];
    [bumpTop setContentMode:UIViewContentModeScaleAspectFit];
    bumpTop.tag = 100;
    [bView addSubview:bumpTop];
    bumpTop.frame = CGRectMake(6, 38, 34/2, 24/2);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bumpSmaller:)];
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

- (void)bumpSmaller:(UITapGestureRecognizer*)bump {
    
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
                                              [bump.view viewWithTag:100].frame = CGRectMake([bump.view viewWithTag:100].frame.origin.x, [bump.view viewWithTag:100].frame.origin.y - 10, [bump.view viewWithTag:100].frame.size.width, [bump.view viewWithTag:100].frame.size.height);
                                              [bump.view viewWithTag:100].frame = CGRectInset([bump.view viewWithTag:100].frame, -3, -3);
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

// goes to new user scene
- (IBAction)newBtn:(id)sender {
    _newUser = TRUE;
    _login = FALSE;
    [self newOrLogin:@"new"];
    NSAttributedString *newString = [[NSAttributedString alloc]initWithString:@"new" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:.91 blue:1 alpha:1], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_newuserBtn setAttributedTitle:newString forState:UIControlStateNormal];
}

- (IBAction)loginBtn:(id)sender {
    _login = TRUE;
    _newUser = FALSE;
    [self newOrLogin:@"login"];
    NSAttributedString *newString = [[NSAttributedString alloc]initWithString:@"login" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:.91 blue:1 alpha:1], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_loginBtn setAttributedTitle:newString forState:UIControlStateNormal];
}

// deconstructs scene and returns to default launch scene
- (IBAction)backBtn:(id)sender {
    if (_newUser) {
        // remove email field
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _emailField.frame = CGRectMake(_emailField.frame.origin.x, _emailField.frame.origin.y + 10, _emailField.frame.size.width, _emailField.frame.size.height);
                             _emailField.alpha = 0;
                         } completion:^(BOOL finished) {NO;}];
        // remove password field
        [UIView animateWithDuration:0.3
                              delay:0.2
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _passwordField.frame = CGRectMake(_passwordField.frame.origin.x, _passwordField.frame.origin.y + 10, _passwordField.frame.size.width, _passwordField.frame.size.height);
                             _passwordField.alpha = 0;
                         } completion:^(BOOL finished) {NO;}];
        // remove name field
        [UIView animateWithDuration:0.3
                              delay:0.4
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _nameField.frame = CGRectMake(_nameField.frame.origin.x, _nameField.frame.origin.y + 10, _nameField.frame.size.width, _nameField.frame.size.height);
                             _nameField.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self configureLogin];
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
                         } completion:^(BOOL finished) {NO;}];
        // remove name field
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _nameField.frame = CGRectMake(_nameField.frame.origin.x, _nameField.frame.origin.y + 10, _nameField.frame.size.width, _nameField.frame.size.height);
                             _nameField.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self configureLogin];
                         }];
    }
    [_backBtn setImage:[UIImage imageNamed:@"backarrowbutton_green.png"] forState:UIControlStateNormal];
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
             if (error) // Something went wrong
             {
                 // Display an alert view to show the error message
                 UIAlertView *alertView =
                 [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"]
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"Ok", nil];
                 [self hideActivityIndicator];
                 [alertView show];
                 [_checkBtn setUserInteractionEnabled:YES];
                 // Bring the keyboard back up, user will probably need to change something
                 //[usernameField becomeFirstResponder];
                 return;
             }
             
             // Success!
             [_bumpnB removeFromSuperview];
             [_umpn removeFromSuperview];
             [_nameField removeFromSuperview];
             [_passwordField removeFromSuperview];
             [_emailField removeFromSuperview];
             [self hideActivityIndicator];
             [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"user"];
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
             [self clearUserData];
             NSLog(@"new user created");
             // range
             [[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:kFilterDistanceKey];
             [[NSUserDefaults standardUserDefaults] setDouble:0.5 forKey:kRangeSliderKey];
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
             [self showNavigationAndLogIn];
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
                 [_bumpnB removeFromSuperview];
                 [_umpn removeFromSuperview];
                 [_nameField removeFromSuperview];
                 [_passwordField removeFromSuperview];
                 [self hideActivityIndicator];
                 [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"user"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
                 [self clearUserData];
                 NSLog(@"successful login");
                 // range
                 [[NSUserDefaults standardUserDefaults] setDouble:1.0 forKey:kFilterDistanceKey];
                 [[NSUserDefaults standardUserDefaults] setDouble:0.5 forKey:kRangeSliderKey];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJustLaunched];
                 [self showNavigationAndLogIn];
             }
             else // Login failed
             {
                 UIAlertView *alertView = nil;
                 
                 if (error == nil) // Login failed because of an invalid username and password
                 {
                     // Create an alert view to tell the user
                     alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't log in:"
                                  "\nThe username or password were wrong."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
                 }
                 else // Login failed for another reason
                 {
                     // Create an alert view to tell the user
                     alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
                 }
                 // Show the alert view
                 [self hideActivityIndicator];
                 [alertView show];
                 [_checkBtn setUserInteractionEnabled:YES];
                 // Bring the keyboard back up, user will probably need to change something
                 //[usernameField becomeFirstResponder];
             }
         }];
    }
}

- (void)showNavigationAndLogIn {
    [self.navigationController setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

// configures default launch scene
- (void)showHome {
    _newUser = FALSE;
    _login = FALSE;
    // newBtn
    _newuserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_newuserBtn];
    NSAttributedString *newString = [[NSAttributedString alloc]initWithString:@"new" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_newuserBtn setAttributedTitle:newString forState:UIControlStateNormal];
    newString = [[NSAttributedString alloc]initWithString:@"new" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:255/255. blue:156/255. alpha:1], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_newuserBtn setAttributedTitle:newString forState:UIControlStateHighlighted];
    [_newuserBtn addTarget:self action:@selector(newBtn:) forControlEvents:UIControlEventTouchUpInside];
    _newuserBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, [UIScreen mainScreen].bounds.size.height/2 - 40, 100, _newuserBtn.titleLabel.font.pointSize);
    _newuserBtn.alpha = 0;
    
    // loginBtn
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_loginBtn];
    NSAttributedString *loginString = [[NSAttributedString alloc]initWithString:@"login" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GurmukhiSangamMN" size:36]}];
    [_loginBtn setAttributedTitle:loginString forState:UIControlStateNormal];
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

- (void)hideHomeButtons {
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

// either trigger showHome, or configure the login/newUser scene
- (void)newOrLogin:(NSString*)key {
    // set up initial launch screen
    if ([key isEqualToString:@"setup"]) {
        [self showHome];
    }
    // login screen with conditional new user creation
    else {
        [self hideHomeButtons];
        
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
        _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 40, 300, 44);
        _nameField.adjustsFontSizeToFitWidth=YES;
        _nameField.minimumFontSize = 16;
        _nameField.delegate = self;
        _nameField.alpha = 0;
                             
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
        _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, 300, 44);
        _passwordField.adjustsFontSizeToFitWidth=YES;
        _passwordField.minimumFontSize = 16;
        [_passwordField setSecureTextEntry:YES];
        _passwordField.delegate = self;
        _passwordField.alpha = 0;
                             
        // back
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"backarrowbutton.png"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"backarrowbutton_green.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:_backBtn];
        [_backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.alpha = 0;
        _backBtn.frame = CGRectMake(25, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
        
        // OK
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@"newcheck.png"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"newcheck_downstate.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:_checkBtn];
        [_checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn.frame = CGRectMake(175, [UIScreen mainScreen].bounds.size.height - 80, 100, 77);
        _checkBtn.alpha = 0;
                             
        _nameField.tag = 0;
        _passwordField.tag = 1;
        
        // email
        if (_newUser == TRUE) {
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
            _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, 300, 44);
            //_emailField.adjustsFontSizeToFitWidth=YES;
            _emailField.keyboardType = UIKeyboardTypeEmailAddress;
            _emailField.minimumFontSize = 16;
            _emailField.delegate = self;
            _emailField.tag = 2;
            _emailField.alpha = 0;
        } else {
            [_emailField removeFromSuperview];
        }
                                 
        // animate textfields in to place
        [UIView animateWithDuration:0.4
                              delay:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _backBtn.frame = CGRectMake(25, [UIScreen mainScreen].bounds.size.height - 80, 100, 77);
                             _backBtn.alpha = 1;
                         } completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.4
                              delay:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 30, 300, 44);
                             _nameField.alpha = 1;
                         } completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.3
                              delay:0.7
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, 300, 44);
                             _passwordField.alpha = 1;
                         } completion:^(BOOL finished) {}];
        if ([key isEqualToString:@"new"]) {
            [UIView animateWithDuration:0.3
                                  delay:0.9
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, 300, 44);
                                 _emailField.alpha = 1;
                             } completion:^(BOOL finished) {}];
        }
    }
}

#pragma mark TEXTFIELD DELEGATE PROTOCOLS

#define MAXLENGTH 20

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    switch (textField.tag) {
        case 0:
            _username = textField.text;
            break;
        case 1:
            // HASH CODE GOES HERE
            _password = textField.text;
            
            break;
        case 2:
            _email = textField.text;
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
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
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
        [self confirmFieldEntryFor:0];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //double distance = _passwordField.frame.origin.y - (_nameField.frame.origin.y + _nameField.frame.size.height);
    //NSLog(@"distance: %f", distance);
    
    switch (textField.tag) {
        case 0:{
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 30, 300, 44);
                                 _nameField.alpha = 1;
                                 _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, 300, 44);
                                 _passwordField.alpha = .3;
                                 if (_newUser) {
                                     _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, 300, 44);
                                     _emailField.alpha = .3;
                                 }
                             }];}
            break;
        case 1:{
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 90, 300, 44);
                                 _nameField.alpha = .3;
                                 _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, 300, 44);
                                 _passwordField.alpha = 1;
                                 if (_newUser) {
                                     _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, 300, 44);
                                     _emailField.alpha = .3;
                                 }
                             }];}
            break;
        case 2:{
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 140, 300, 44);
                                 _nameField.alpha = .3;
                                 _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, 300, 44);
                                 _passwordField.alpha = .3;
                                 if (_newUser) {
                                     _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, 300, 44);
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
                                 _checkBtn.frame = CGRectMake(175, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
                             }];
        }
    }
}

- (void)resetTextfieldPlacement {
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self.view endEditing:YES];
                         _nameField.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2 - 30, 300, 44);
                         _nameField.alpha = 1;
                         _passwordField.frame = CGRectMake(10, _nameField.frame.origin.y + _nameField.frame.size.height + 20, 300, 44);
                         _passwordField.alpha = 1;
                         _emailField.frame = CGRectMake(10, _passwordField.frame.origin.y + _passwordField.frame.size.height + 20, 300, 44);
                         _emailField.alpha = 1;
                     }];
}

// primary login method
// sign in option: 0 is newuser 1 is login
- (void)confirmFieldEntryFor:(int)signInOption {
    // if new user flow
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
                                 _checkBtn.frame = CGRectMake(175, [UIScreen mainScreen].bounds.size.height - 90, 100, 77);
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
/*
- (void)bump:(UITapGestureRecognizer*)bump {
    
    CGRect originalTopFrame = CGRectMake([bump.view viewWithTag:100].frame.origin.x, [bump.view viewWithTag:100].frame.origin.y, [bump.view viewWithTag:100].frame.size.width, [bump.view viewWithTag:100].frame.size.height);
    CGRect originalMidFrame = CGRectMake([bump.view viewWithTag:101].frame.origin.x, [bump.view viewWithTag:101].frame.origin.y, [bump.view viewWithTag:101].frame.size.width, [bump.view viewWithTag:101].frame.size.height);
    // Animate arrow top up
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [bump.view viewWithTag:100].frame = CGRectMake([bump.view viewWithTag:100].frame.origin.x, [bump.view viewWithTag:100].frame.origin.y - 10, [bump.view viewWithTag:100].frame.size.width, [bump.view viewWithTag:100].frame.size.height);
                     } completion:^(BOOL finished) {
                         // animate arrow back down
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [bump.view viewWithTag:100].frame = originalTopFrame;
                                          } completion:^(BOOL finished) {
                                              //
                                          }];
                     }];
    // animate arrow mid up
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [bump.view viewWithTag:101].frame = CGRectMake([bump.view viewWithTag:101].frame.origin.x, [bump.view viewWithTag:101].frame.origin.y - 5, [bump.view viewWithTag:101].frame.size.width, [bump.view viewWithTag:101].frame.size.height);
                     } completion:^(BOOL finished) {
                         // animate arrow back down
                         [UIView animateWithDuration:0.2
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              [bump.view viewWithTag:101].frame = originalMidFrame;
                                          } completion:^(BOOL finished) {
                                              //
                                          }];
                     }];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentMainViewController {
    NSLog(@"presenting MainView controller");
    [self.navigationController setNavigationBarHidden:NO];
    [self clearUserData];
    [self.navigationController setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (void) clearUserData {
    //[_nameField removeFromSuperview];
    //_nameField = [UITextField new];
    _username = [NSString new];
    //[_passwordField removeFromSuperview];
    //_passwordField = [UITextField new];
    _password = [NSString new];
    //[_emailField removeFromSuperview];
    //_emailField = [UITextField new];
    _email = [NSString new];
    //[_backBtn removeFromSuperview];
    //[_checkBtn removeFromSuperview];
    
    [self performSelector:@selector(backBtn:) withObject:self];
}

- (void)showActivityIndicator {
    _activityCover = [UIView new];
    //_activityCover.frame = self.view.frame;
    _activityCover.frame = CGRectMake(0, _bumpnB.frame.origin.y + _bumpnB.frame.size.height + 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_activityCover];
    _activityCover.backgroundColor = PRIMARY_ORANGE_COLOR;
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityCover addSubview:_activityIndicator];
    _activityIndicator.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - _activityIndicator.frame.size.width/2, [UIScreen mainScreen].bounds.size.height/2 - _activityIndicator.frame.size.height/2 - self.navigationController.navigationBar.frame.size.height - 20, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height);
    [_activityIndicator startAnimating];
    
}

- (void)hideActivityIndicator {
    NSLog(@"hiding activity indicatory");
    [_activityCover removeFromSuperview];
}

@end
