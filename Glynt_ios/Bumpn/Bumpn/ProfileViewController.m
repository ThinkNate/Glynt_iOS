//
//  ProfileViewController.m
//  Bumpn
//
//  Created by Nate Berman on 10/4/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "TransitionLogoutToLogin.h"
#import "LoginViewController.h"

@interface ProfileViewController ()

@property (nonatomic) NSString *username;

@property (nonatomic) UIButton *editBtn;
@property (nonatomic) UILabel *editLabel;

@property (nonatomic) UIView *topHorizontal;

@property (nonatomic) UITextView *taglineTextView;
@property (nonatomic) NSString *tagline;

@property (nonatomic) UIView *botHorizontal;
@property (nonatomic) UIView *bottomBar;

//@property (nonatomic) UIButton *backBtn;
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic) UIButton *logoutBtn;
- (IBAction)logoutBtn:(id)sender;

@property (nonatomic) UILabel *glyntPointsLabel;
@property (nonatomic) UILabel *pointsLabel;

@property (nonatomic) int __block points;


@end

@implementation ProfileViewController

bool editMode;

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
    self.title = [PFUser currentUser].username;
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"GurmukhiSangamMN" size:40], NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    // set Nav Title Font and Size
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"GurmukhiSangamMN" size:40], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    self.username = [PFUser currentUser].username;
    self.tagline = [PFUser currentUser][@"tagline"];
    
    [self getPoints];
    
    [self configureView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillLayoutSubviews {
    
    self.bottomBar.frame = CGRectMake(0, self.view.bounds.size.height - 64, self.view.bounds.size.width, 64);
    self.backBtn.frame = CGRectMake(0, self.view.frame.size.height - 68 - 20 - 40 - 4, 96, 68);
    _backBtn.frame = CGRectMake(0, self.view.frame.size.height - 64, 96, 68);
    self.botHorizontal.frame = CGRectMake(0, self.view.frame.size.height - 64, 320, 2);
    
    self.pointsLabel.frame = CGRectMake(20, self.botHorizontal.frame.origin.y - 50 - 120, self.view.bounds.size.width - 40, 120);
    self.pointsLabel.center = CGPointMake(self.view.center.x, self.pointsLabel.center.y);

    self.glyntPointsLabel.frame = CGRectMake(20, self.pointsLabel.frame.origin.y, self.view.bounds.size.width - 40, 10);

    self.topHorizontal.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2);
    
    self.taglineTextView.frame = CGRectMake(20, self.topHorizontal.frame.origin.y + self.topHorizontal.frame.size.height, self.view.bounds.size.width - 40, 200);
    self.taglineTextView.contentSize = CGSizeFromString(NSStringFromCGRect(self.taglineTextView.frame));
    self.taglineTextView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

}

- (void)viewDidLayoutSubviews {
    
}

- (void)configureView {
    
    self.view.backgroundColor = PRIMARY_LIGHT_GRAY_COLOR;
    
    // add a top horizontal for interest
    self.topHorizontal = [[UIView alloc]init];
    self.topHorizontal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topHorizontal];
    
    // generate text view for user taglines
    self.taglineTextView = [[UITextView alloc]init];
    [self.view addSubview:self.taglineTextView];
    self.tagline = [NSString stringWithFormat:@"%@",[PFUser currentUser][@"tagline"]];
    if ([self.tagline isEqualToString:@"(null)"]) {
        self.taglineTextView.text = @"add flavor text here";
    } else {
        self.taglineTextView.text = self.tagline;
    }
    self.taglineTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.taglineTextView.autocorrectionType = UITextAutocorrectionTypeYes;
    self.taglineTextView.backgroundColor = [UIColor clearColor];
    self.taglineTextView.delegate = self;
    self.taglineTextView.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:20];
    self.taglineTextView.textAlignment = NSTextAlignmentCenter;
    self.taglineTextView.textColor = PRIMARY_BLACK_COLOR;
    
    // add a toolbar with Cancel & Done buttons
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.taglineTextView.inputAccessoryView = toolBar;
    self.taglineTextView.inputAccessoryView.backgroundColor = [UIColor clearColor];
    
    // stylized back button
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"backarrow_downstate.png"] forState: UIControlStateHighlighted];
    [self.backBtn setImage:[UIImage imageNamed:@"backarrow.png"] forState: UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"backarrow_downstate.png"] forState: UIControlStateSelected];
    [self.backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    // complete stylized framing 
    self.bottomBar = [[UIView alloc]init];
    self.bottomBar.backgroundColor = PRIMARY_ORANGE_COLOR;
    [self.view insertSubview:self.bottomBar belowSubview:_backBtn];
    
    // add a bottom horizontal for interest
    self.botHorizontal = [[UIView alloc]init];
    self.botHorizontal.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.botHorizontal];
    [self.view bringSubviewToFront:self.botHorizontal];
    
    self.pointsLabel = [[UILabel alloc]init];
    [self.view addSubview:self.pointsLabel];
    self.pointsLabel.backgroundColor = [UIColor clearColor];
    self.pointsLabel.font = [UIFont fontWithName:@"GurmukhiMN" size:100];
    self.pointsLabel.textAlignment = NSTextAlignmentCenter;
    self.pointsLabel.adjustsFontSizeToFitWidth = true;
    self.pointsLabel.textColor = PRIMARY_BLACK_COLOR;
    
    self.glyntPointsLabel = [[UILabel alloc]init];
    [self.view addSubview:self.glyntPointsLabel];
    self.glyntPointsLabel.backgroundColor = [UIColor clearColor];
    self.glyntPointsLabel.font = [UIFont fontWithName:@"GurmukhiMN" size:12];
    self.glyntPointsLabel.textAlignment = NSTextAlignmentCenter;
    self.glyntPointsLabel.textColor = PRIMARY_BLACK_COLOR;
    self.glyntPointsLabel.text = @"GLYNT POINTS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPoints {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Points"];
    [postQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu Point objects.", (unsigned long)objects.count);
            if (objects.count == 0) {
                self.points = 0;
                self.pointsLabel.text = @"0";
            }
            else {
                // POINTS UP!!
                for (PFObject *object in objects) {
                    NSLog(@"object.points: %@", object[@"points"]);
                    self.points = [object[@"points"] intValue];
                    NSLog(@"points: %i", self.points);
                    [self animatePoints];
                }
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)animatePoints {
    if (!self.points) {
        self.pointsLabel.text = [NSString stringWithFormat:@"%d", 1];
        [self performSelector:@selector(animatePoints) withObject:self afterDelay:0.01];
    }
    else if (self.points > [self.pointsLabel.text intValue]) {
        self.pointsLabel.text = [NSString stringWithFormat:@"%d", [self.pointsLabel.text intValue] + 1];
        [self performSelector:@selector(animatePoints) withObject:self afterDelay:0.01];
    }
    else if (self.points < [self.pointsLabel.text intValue]) {
        self.pointsLabel.text = [NSString stringWithFormat:@"%d", [self.pointsLabel.text intValue] - 1];
        [self performSelector:@selector(animatePoints) withObject:self afterDelay:0.01];
    }
    else {
        self.pointsLabel.text = [NSString stringWithFormat:@"%d", self.points];
    }
}

#pragma mark Actions
- (IBAction)backBtn:(id)sender {
    [self.backBtn setSelected:true];
    [self.backBtn setImage:[UIImage imageNamed:@"backarrow_downstate.png"] forState: UIControlStateNormal];
    [self popToMain];
}

- (IBAction)logoutBtn:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"user"];
    [PFUser logOut];
    //self.navigationController.delegate = self;
    //[self.navigationController popToRootViewControllerAnimated:false];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
    [self.navigationController.viewControllers[0] presentViewController:loginViewController animated:true completion:^{
        //
        //[self.navigationController popViewControllerAnimated:false];
    }];
    
    //[self transitionToLogin];
}

- (IBAction)editBtn:(id)sender {
    
    if (editMode) {
        editMode = false;
        [self resignFirstResponder];
        self.editLabel.text = @"edit";
        self.editLabel.textColor = [UIColor colorWithRed:.27 green:.47 blue:.53 alpha:1];
        
        self.taglineTextView.userInteractionEnabled = false;
        
        self.backBtn.hidden = false;
        
        // save changes
        // tagline
        if (![self.taglineTextView.text isEqualToString:@"(null)"] &&
            ![self.taglineTextView.text isEqualToString:@"add flavor text here"] &&
            ![self.taglineTextView.text isEqualToString:self.tagline])
        {
            self.tagline = self.taglineTextView.text;
            [PFUser currentUser][@"tagline"] = self.tagline;
            [[PFUser currentUser] saveInBackground];
        }
    } else {
        editMode = true;
        self.editLabel.text = @"save";
        self.editLabel.textColor = [UIColor colorWithRed:0 green:.9 blue:.99 alpha:1];
        
        self.taglineTextView.userInteractionEnabled = true;
        
        self.backBtn.hidden = true;
    }
}



- (void)doneTouched:(UIBarButtonItem *)sender {
    // resign the keyboard
    [self.taglineTextView resignFirstResponder];
    
    // save changes
    // tagline
    if (![self.taglineTextView.text isEqualToString:@"(null)"] &&
        ![self.taglineTextView.text isEqualToString:@"add flavor text here"] &&
        ![self.taglineTextView.text isEqualToString:self.tagline])
    {
        self.tagline = self.taglineTextView.text;
        [PFUser currentUser][@"tagline"] = self.tagline;
        [[PFUser currentUser] saveInBackground];
    }
    
    // evaluate for username save
    /*
    if (![self.usernameField.text isEqualToString:self.username]) {
        // query if the user exists
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:self.usernameField.text];
        //PFObject *existingUser = [userQuery getFirstObject];
        
        // if user does not exist update username and save user
        if (![userQuery getFirstObject]) {
            //
            self.username = self.usernameField.text;
            [PFUser currentUser].username = self.usernameField.text;
            [[PFUser currentUser]saveInBackground];
        }
        
        // if user does exist show alert that username already taken
        // revert username
        else {
            self.usernameField.text = self.username;
        }
    }
    */
}

#pragma mark Navigation
- (void)popToMain {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)transitionToLogin {
    //[self.navigationController setNavigationBarHidden:NO];
    //[self performSegueWithIdentifier:@"loginSegue" sender:self];
    //self.navigationController.delegate = self;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[LoginViewController class]]) {
        NSLog(@"return TransitionLogoutToLogin");
        TransitionLogoutToLogin *animationController = [[TransitionLogoutToLogin alloc]init];
        animationController.duration = .3;
        return animationController;
    }
    else return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *) presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[TransitionLogoutToLogin alloc] init];
}

@end
