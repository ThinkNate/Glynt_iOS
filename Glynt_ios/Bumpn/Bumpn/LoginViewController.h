//
//  LoginViewController.h
//  Bumpn
//
//  Created by Nate Berman on 10/26/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic) UIView *blackBackground;

@property (nonatomic) UIImageView *glyntImage;

@property (nonatomic) UITextField *nameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UITextField *emailField;

@property (nonatomic) UIButton *backBtn;
@property (nonatomic) UIButton *checkBtn;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *email;

@property (nonatomic) UIButton *loginBtn;
@property (nonatomic) BOOL login;
@property (nonatomic) UIButton *newuserBtn;
@property (nonatomic) BOOL newUser;

@property (nonatomic) UIView *activityCover;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end
