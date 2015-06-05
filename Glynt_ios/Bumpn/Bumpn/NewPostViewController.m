//
//  NewPostViewController.m
//  Bumpn
//
//  Created by Nate Berman on 8/20/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "NewPostViewController.h"
#import "MainViewTableViewController.h"
#import "Constants.h"
#import "DTDAppDelegate.h"

@interface NewPostViewController ()

@property (nonatomic) PFObject *postObject;
@property (nonatomic) CGRect messageFieldFrame;

@property (nonatomic) UITextView *activeTextView;

@property (nonatomic) BOOL keyboardIsVisible;
@property (nonatomic) CGSize keyboardSize;

@property (nonatomic) NSData *photoData;
@property (nonatomic) NSData *thumbnailData;

@property (nonatomic) UIView *bottomBar;

@end

@implementation NewPostViewController
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:true];
    
    // Set the view title
    self.title = @"new post";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"GurmukhiSangamMN" size:40], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    // add observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:self.messageField];
	
    [self registerForKeyboardNotifications];
    
    self.view.backgroundColor = PRIMARY_LIGHT_GRAY_COLOR;
    
    //_topGuard.layer.shadowOffset = CGSizeMake(0, 4);
    //_topGuard.layer.shadowColor = [UIColor blackColor].CGColor;
    //_topGuard.layer.shadowRadius = 4;
    //_topGuard.layer.shadowOpacity = 0.6;
    _topGuard.hidden = true;

    self.bottomBar = [[UIView alloc]init];
    self.bottomBar.backgroundColor = PRIMARY_ORANGE_COLOR;
    
    [self.view insertSubview:self.bottomBar belowSubview:self.backBtn];
    [self.view insertSubview:self.botHorizontal aboveSubview:self.bottomBar];
    
    _cameraBtn.hidden = true;
    
    self.messageField.tag = 1;
    self.messageField.textColor = PRIMARY_BLACK_COLOR; //optional
    self.messageField.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:20];
    self.messageField.textAlignment = NSTextAlignmentCenter;
    [self.messageField setAutocorrectionType:UITextAutocorrectionTypeYes];
    self.messageField.returnKeyType = UIReturnKeyDone;
    self.messageField.text = @"text";
    
    self.characterCount = [[UILabel alloc] init];
    self.characterCount.backgroundColor = [UIColor clearColor];
    self.characterCount.textColor = [UIColor whiteColor];
    self.characterCount.text = @"  0/200";
    
    self.activityCover = [[UIView alloc]init];
    self.activityCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.activityCover.layer.cornerRadius = 5;
    self.activityCover.hidden = true;
    [self.view addSubview:self.activityCover];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityCover addSubview:self.activityIndicator];

}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"NewPostViewController viewWillAppear");
    
    _topHorizontal.frame = CGRectMake(0, 0, 320, 2);
    
    self.botHorizontal.frame = CGRectMake(0, self.view.frame.size.height - 64, 320, 2);
    self.bottomBar.frame = CGRectMake(0, self.botHorizontal.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 64);
    
    _backBtn.frame = CGRectMake(0, self.view.frame.size.height - 64, 96, 68);
    
    _checkBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 96, self.view.frame.size.height - 64, 96, 68);
    self.checkBtn.alpha = 0;

    //_cameraBtn.frame = CGRectMake(0, self.view.frame.size.height - 68, 96, 68);
    //_cameraBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, _cameraBtn.center.y);
    
    self.scrollView.frame = CGRectMake(0, self.topHorizontal.frame.origin.y + self.topHorizontal.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.botHorizontal.frame.origin.y - self.topHorizontal.frame.origin.y - self.topHorizontal.frame.size.height);
    
    if (![self.photoData length] > 0) {
        self.photoImage.frame = CGRectMake(0, 10, self.scrollView.frame.size.width, 0);
        self.messageField.frame = CGRectMake(0, 10, self.scrollView.bounds.size.width, self.scrollView.frame.size.height);
    }
    else {
        self.messageField.frame = CGRectMake(0, self.photoImage.frame.origin.y + self.photoImage.frame.size.height + 20, self.scrollView.bounds.size.width, self.scrollView.frame.size.height);
    }
    
    self.messageFieldFrame = self.messageField.frame;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barTintColor = PRIMARY_ORANGE_COLOR;
    self.characterCount.frame = CGRectMake(20, 0, 100, 21);
    UIBarButtonItem *counterBtn = [[UIBarButtonItem alloc]initWithCustomView:self.characterCount];
    [toolBar setItems:[NSArray arrayWithObjects:counterBtn, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], nil]];
    [self.messageField setInputAccessoryView:toolBar];
    
    self.scrollContentView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.messageField.frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollContentView.frame.size.width, self.scrollContentView.frame.size.height);
    
    self.activityCover.frame = CGRectMake(0, 0, 50, 50);
    self.activityCover.center = self.scrollView.center;
    self.activityIndicator.frame = self.activityCover.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:true];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:true];
    @try{
        [self.messageField removeObserver:self forKeyPath:@"contentSize"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    @try{
        //[_messageField removeObserver:self forKeyPath:@"contentSize"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MainViewTableViewController *vc = [segue destinationViewController];
    if ([vc.view viewWithTag:kNoPostsLabelTag]) {
        [[vc.view viewWithTag:kNoPostsLabelTag] removeFromSuperview];
    }
}

- (void)createParsePostObject {
    // Dismiss keyboard
    [_messageField resignFirstResponder];
    
    // Capture current text field contents:
	[self updateCharacterCount:self.messageField];
	BOOL isAcceptableAfterAutocorrect = [self checkCharacterCount:self.messageField];
    
	if (!isAcceptableAfterAutocorrect) {
		[self.messageField becomeFirstResponder];
        [_checkBtn setUserInteractionEnabled:YES];
		return;
	}
    
    _postObject = [PFObject objectWithClassName:@"Post"];
    
    // Create a PFGeoPoint using the user's location
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:((DTDAppDelegate*)[[UIApplication sharedApplication] delegate]).currentLocation];
    _postObject[@"location"] = geoPoint;
    
    //Get the currently logged in PFUser
    PFUser *user = [PFUser currentUser];
    [_postObject setObject:user forKey:@"user"];
    [_postObject setObject:user.username forKey:@"originator"];
    
    // set points to 1 because the originator is always upvoting their own post at creation time
    [_postObject setValue:@1 forKey:@"points"];
    
    // Set the access control list on the postObject to restrict future modifications
    // to this object
    PFACL *readOnlyACL = [PFACL ACL];
    [readOnlyACL setPublicReadAccess:YES]; // Create read-only permissions
    [readOnlyACL setPublicWriteAccess:YES];
    [_postObject setACL:readOnlyACL]; // Set the permissions on the postObject
    
    // Get the post's title
    //NSString *postTitle = _titleField.text;
    //[_postObject setObject:postTitle forKey:@"title"];
    
    // Get the post's message
    NSString *postMessage = [NSString new];
    if (![_messageField.text  isEqual: @"text"]) {
        postMessage = _messageField.text;
    } else {
        postMessage = @"";
    }
    [_postObject setObject:postMessage forKey:@"message"];
    
    // handle image / thumbnail
    if ([self.photoData length] > 0) {
        PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:self.photoData];
        [_postObject setObject:imageFile forKey:@"image"];
        PFFile *thumbFile = [PFFile fileWithName:@"thumbnail.jpg" data:self.thumbnailData];
        [_postObject setObject:thumbFile forKey:@"thumbnail"];
    }
    
    NSLog(@"postObjectCreated");
    [self postObjectToParse];
}

- (void)postObjectToParse {
    [_postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [self hideActivityIndicator];
         if (error) // Failed to save, show an alert view with the error message
         {
             NSLog(@"Couldn't Save Post!");
             NSLog(@"%@", error);
             UIAlertView *alertView =
             [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"]
                                        message:nil
                                       delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
             [alertView show];
             [_checkBtn setUserInteractionEnabled:YES];
             return;
         }
         if (succeeded) // Successfully saved, post a notification to tell other view controllers
         {
             NSLog(@"Successfully Saved Post!");
             NSLog(@"%@", _postObject);
             
             /*
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostCreatedNotification"
                                                                     object:nil];
             });
            */
             
             NSLog(@"_postObject.objectId: %@", _postObject.objectId);
             NSMutableArray *bumpdPosts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"bumpdPosts"]];
             NSMutableDictionary *bumpd = [[NSMutableDictionary alloc]init];
             bumpd[_postObject.objectId] = _postObject.createdAt;
             [bumpdPosts addObject:bumpd];
             [[NSUserDefaults standardUserDefaults] setObject:bumpdPosts forKey:@"bumpdPosts"];
             [[NSUserDefaults standardUserDefaults] synchronize];

             [self.navigationController popViewControllerAnimated:YES];
         } 
     }];
    _host.newPostCreated = YES;
    
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

- (IBAction)backBtn:(id)sender {
    NSLog(@"backBtn pressed");
    [self.backBtn setSelected:true];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkBtn:(id)sender {
    [_checkBtn setUserInteractionEnabled:NO];
    [self showActivityIndicator];
    [self createParsePostObject];
}


#pragma mark Title UITextField delegate methods
#define MAX_TITLE_LENGTH 50
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= MAX_TITLE_LENGTH && range.length == 0) {return NO;}
    else {return YES;}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing");
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barTintColor = PRIMARY_ORANGE_COLOR;
    UIBarButtonItem *counterBtn = [[UIBarButtonItem alloc]initWithCustomView:self.characterCount];
    [toolBar setItems:[NSArray arrayWithObjects:counterBtn, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], nil]];
    [textField setInputAccessoryView:toolBar];
    
    textField.placeholder = @" ";
    //[self updateKeyboardReturnKey];
    //if ([textField.text isEqualToString:@"title"]) {
    //    textField.text = @"";
    //}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //NSAttributedString *titleFieldPlaceholder = [[NSAttributedString alloc]initWithString:@"title" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"GurmukhiSangamMN" size:32], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //[_titleField setAttributedPlaceholder: titleFieldPlaceholder];
}

// when titleField 'Next' key pressed, shift first responder to messageView
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSLog(@"textFieldShouldReturn");
    /*
    // if title and message both empty resign responder
    if (([_titleField.text isEqualToString:@""] || [_titleField.text caseInsensitiveCompare:@"title"] == NSOrderedSame) && ([_messageField.text isEqualToString:@""] || [_messageField.text caseInsensitiveCompare:@"text"] == NSOrderedSame) ) {
        [_titleField resignFirstResponder];
        [_messageField resignFirstResponder];
        //return NO;
    }
    
    // if title and message both full resign responder
    if ((![_titleField.text isEqualToString:@""] && [_titleField.text caseInsensitiveCompare:@"title"] != NSOrderedSame) && (![_messageField.text isEqualToString:@""] && [_messageField.text caseInsensitiveCompare:@"text"] != NSOrderedSame) ) {
        [_titleField resignFirstResponder];
        [_messageField resignFirstResponder];
        //return NO;
    }
    
    // if title has content and message empty make message responder
    if ((![_titleField.text isEqualToString:@""] && [_titleField.text caseInsensitiveCompare:@"title"] != NSOrderedSame) && ([_messageField.text isEqualToString:@""] || [_messageField.text caseInsensitiveCompare:@"text"] == NSOrderedSame) ) {
        [_titleField resignFirstResponder];
        [_messageField becomeFirstResponder];
        //return NO;
    }
    
    // if title empty and message has content resign
    if (([_titleField.text isEqualToString:@""] || [_titleField.text caseInsensitiveCompare:@"title"] == NSOrderedSame) && (![_messageField.text isEqualToString:@""] && [_messageField.text caseInsensitiveCompare:@"text"] != NSOrderedSame) ) {
        [_titleField resignFirstResponder];
        [_messageField resignFirstResponder];
        //return NO;
    }
    */
    /*
    NSLog(@"textFieldShouldReturn");
    if ([textField.text isEqualToString:@""] || [textField.text caseInsensitiveCompare:@"title"] == NSOrderedSame) {
        textField.text = @"title";
    }
    if (![_messageField.text isEqualToString:@"text"]) {
        [_titleField resignFirstResponder];
    } else {
        [_titleField resignFirstResponder];
        [_messageField resignFirstResponder];
    }
     */
    if ([self checkFieldCompletion]) {
        [self showCheckBtn];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


#pragma mark UITextView notification methods
#define MAX_MESSAGE_LENGTH 200
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //[self updateKeyboardReturnKey];
    if([text isEqualToString:@"\n"]) {
        [[self view] endEditing:YES];
        [_messageField resignFirstResponder];
        //[_titleField resignFirstResponder];
        if ([self checkFieldCompletion]) {
            [self showCheckBtn];
        }
    }
    if (textView.text.length >= MAX_MESSAGE_LENGTH && range.length == 0) {
        NSLog(@"textView should NOT changeText");
    	return NO; // return NO to not change text
    }
    else {
        NSLog(@"textView shouldChangeText");
        return YES;
    }
}

- (void)textInputChanged:(NSNotification *)note {
	// Listen to the current textView and count characters.
	UITextView *localTextView = [note object];
	[self updateCharacterCount:localTextView];
	[self checkCharacterCount:localTextView];
    //[self updateKeyboardReturnKey];
}
/*
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textViewDidChangea");
    if (![_messageField.text isEqualToString:@""] && ![_messageField.text isEqualToString:@"text"]) {
        NSLayoutManager *layoutManager = [textView layoutManager];
        unsigned nbLines, glyphIndex, numberOfGlyphs = (int)[layoutManager numberOfGlyphs];
        NSRange lineRange;
        
        for (nbLines = 0, glyphIndex = 0; (int)index < numberOfGlyphs; ++nbLines)
        {
            [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:&lineRange];
            glyphIndex = (int)NSMaxRange(lineRange); // Skip to after last glyph of the line for next iteration
        }
        //[_messageField sizeToFit];
        _messageField.frame = CGRectMake(_messageFieldFrame.origin.x, [UIScreen mainScreen].bounds.size.height - _keyboardSize.height - (nbLines * _messageField.font.pointSize ), _messageFieldFrame.size.width, _messageField.frame.size.height);
    } else {
        _messageField.frame = CGRectMake(_messageFieldFrame.origin.x, [UIScreen mainScreen].bounds.size.height - _keyboardSize.height - _messageField.font.lineHeight - 30, _messageFieldFrame.size.width, 20);
    }
    //CGRect rect = self.messageField.frame;
    //rect.size.height -= _keyboardSize.height;
}
*/

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing");
    
    
    
    //[self updateKeyboardReturnKey];
    [self adjustSelection:textView];
    self.activeTextView = _messageField;
    
    if ([_messageField.text isEqualToString:@"text"]) {
        _messageField.text = @"";
        self.characterCount.text = @"  0/200";
    } else if (![_messageField.text isEqualToString:@""] && ![_messageField.text isEqualToString:@"text"]) {
        //
    }
    
}

// return on message field
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"textViewDidEndEditing");
    
    /*
    // if title and message both blank resign
    if (([_titleField.text caseInsensitiveCompare:@"title"] == NSOrderedSame || [_titleField.text isEqualToString:@""]) && ([_messageField.text caseInsensitiveCompare:@"text"] == NSOrderedSame || [_messageField.text isEqualToString:@""])) {
        NSLog(@"resign all");
        [_messageField resignFirstResponder];
        [_titleField resignFirstResponder];
    }
    
    // if title empty and message has content title become responder
    if (([_titleField.text caseInsensitiveCompare:@"title"] == NSOrderedSame || [_titleField.text isEqualToString:@""]) && ([_messageField.text caseInsensitiveCompare:@"text"] != NSOrderedSame && ![_messageField.text isEqualToString:@""])) {
        NSLog(@"make title responder");
        [_messageField resignFirstResponder];
        [_titleField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
    }
    */
    
    if ([_messageField.text isEqualToString:@""] || [_messageField.text caseInsensitiveCompare:@"text"] == NSOrderedSame) {
        _messageField.text = @"text";
    }
    
    [self.view endEditing:true];
    
    /*
    else {
        [_titleField becomeFirstResponder];
    }

     
    CGFloat topoffset = ([_messageField bounds].size.height - [_messageField contentSize].height * [_messageField zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    _messageField.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
    */
    if ([self checkFieldCompletion]) {
        NSLog(@"show check btn");
        [self showCheckBtn];
    }
}

- (void)adjustSelection:(UITextView *)textView {
    
    // workaround to UITextView bug, text at the very bottom is slightly cropped by the keyboard
    if ([textView respondsToSelector:@selector(textContainerInset)]) {
        [textView layoutIfNeeded];
        CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
        caretRect.size.height += textView.textContainerInset.bottom;
        [textView scrollRectToVisible:caretRect animated:NO];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    [self adjustSelection:textView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    /*
    if (!_keyboardIsVisible) {
        UITextView *txtview = object;
        CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
        topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
        txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
    }
     */
}

#pragma mark PHOTO
- (IBAction)cameraBtn:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //picker.allowsEditing = true;
        //picker.mediaTypes = [[NSArray alloc]initWithObjects:(NSString*)kUTTypeImage, nil];
        [self presentViewController:picker animated:true completion:NULL];
    } else {
        // alert that you must have a camera to take a photo
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Resize photo image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // convert photo image to data
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    self.photoData = imageData;
    
    // create thumbnail
    UIGraphicsBeginImageContext(CGSizeMake(640/4, 960/4));
    [image drawInRect: CGRectMake(0, 0, 640/4, 960/4)];
    UIImage *thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // convert thumbnail to data
    NSData *thumbData = UIImageJPEGRepresentation(thumbnailImage, 0.05f);
    self.thumbnailData = thumbData;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:NULL];
}

- (void)uploadImage:(NSData*)imageData {
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *newPost = [PFObject objectWithClassName:@"Post"];
            [newPost setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            newPost.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [newPost setObject:user forKey:@"user"];
            
            [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        //
    }];
}


#pragma mark Video
// modular thumb image generator for a video at filepath
- (UIImage*)generateThumbImage : (NSString *)filepath {
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 1000; //Time in milliseconds
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}


#pragma mark Private helper methods
- (void)updateCharacterCount:(UITextView *)aTextView {
	NSUInteger count = aTextView.text.length;
	self.characterCount.text = [NSString stringWithFormat:@"  %lu/200", (unsigned long)count];
	if (count > kPostMaximumCharacterCount || count == 0) {
		self.characterCount.font = [UIFont boldSystemFontOfSize:self.characterCount.font.pointSize];
	} else {
		self.characterCount.font = [UIFont systemFontOfSize:self.characterCount.font.pointSize];
	}
    [aTextView reloadInputViews];
}

- (BOOL)checkCharacterCount:(UITextView *)aTextView {
	NSUInteger count = aTextView.text.length;
	if (count > kPostMaximumCharacterCount || count == 0) {
		//postButton.enabled = NO;
		return NO;
	} else {
		//postButton.enabled = YES;
		return YES;
	}
}
// used to trigger appearance of check button
- (BOOL)checkFieldCompletion {
    NSLog(@"checking field completion");
    NSLog(@"message: %@", _messageField.text);

    if (![_messageField.text caseInsensitiveCompare:@"text"] == NSOrderedSame && ![_messageField.text isEqualToString:@""]) {
        NSLog(@"fields complete");
        return true;
    }
    [UIView animateWithDuration:0
                     animations:^{
                         _checkBtn.alpha = 0;
                     }];
    return false;
}

- (void)showCheckBtn {
    NSLog(@"showing check btn");
    [self.view bringSubviewToFront:_checkBtn];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _checkBtn.alpha = 1;
                     }];
}


#pragma mark Activity Indicator
- (void)showActivityIndicator {
    [self.activityIndicator startAnimating];
    self.activityCover.hidden = false;
}

- (void)hideActivityIndicator {
    self.activityCover.hidden = true;
    [self.activityIndicator stopAnimating];
}


#pragma mark Keyboard Notifications
- (void)registerForKeyboardNotifications {
    // observe keyboard hide and show notifications to resize the text view appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    //[self updateKeyboardReturnKey];
    _keyboardIsVisible = YES;
}

- (void)keyboardDidShow:(NSNotification*)aNotification {
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //CGPoint offset = self.scrollView.contentOffset;
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= keyboardSize.height;
    self.scrollView.frame = viewFrame;
    
    // Step 2: Adjust the bottom content inset of the scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    _messageField.contentInset = contentInsets;
    _messageField.scrollIndicatorInsets = contentInsets;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, _activeTextView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeTextView.frame.origin.y - (keyboardSize.height-15));
        [_messageField setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _messageField.contentInset = contentInsets;
    _messageField.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    _keyboardIsVisible = NO;
    
    if ([self checkFieldCompletion]) {
        NSLog(@"show check btn");
        [self showCheckBtn];
    }
}

/*
- (void)updateKeyboardReturnKey {
    
    // if message is responder and title has value show done else show next
    if ([_messageField isFirstResponder]) {
        if (![_titleField.text isEqualToString:@""] || [_titleField.text caseInsensitiveCompare:@"title"] != NSOrderedSame) {
            [_messageField setReturnKeyType:UIReturnKeyDone];
            [_titleField setReturnKeyType:UIReturnKeyNext];
        } else {
            [_messageField setReturnKeyType:UIReturnKeyNext];
            [_titleField setReturnKeyType:UIReturnKeyDone];
        }
    }
    
    // if title is responder and message has value show done else show next
    if ([_titleField isFirstResponder]) {
        if (![_messageField.text isEqualToString:@""] || [_messageField.text caseInsensitiveCompare:@"text"] != NSOrderedSame) {
            [_titleField setReturnKeyType:UIReturnKeyDone];
            [_messageField setReturnKeyType:UIReturnKeyNext];
        } else {
            [_titleField setReturnKeyType:UIReturnKeyNext];
            [_messageField setReturnKeyType:UIReturnKeyDone];
        }
    }
    
    // if title and message both empty done button
    if (([_titleField.text isEqualToString:@""] || [_titleField.text caseInsensitiveCompare:@"title"] == NSOrderedSame) && ([_messageField.text isEqualToString:@""] || [_messageField.text caseInsensitiveCompare:@"text"] == NSOrderedSame) ) {
        [_titleField setReturnKeyType:UIReturnKeyDone];
        [_messageField setReturnKeyType:UIReturnKeyDone];
    }
    
    // if title and message both have content done button
    if ((![_titleField.text isEqualToString:@""] && [_titleField.text caseInsensitiveCompare:@"title"] != NSOrderedSame) && (![_messageField.text isEqualToString:@""] && [_messageField.text caseInsensitiveCompare:@"text"] != NSOrderedSame) ) {
        [_titleField setReturnKeyType:UIReturnKeyDone];
        [_messageField setReturnKeyType:UIReturnKeyDone];
    }
    
}
*/

- (void)cancelTouched:(id)sender {
    [self.view endEditing:true];
}


@end
