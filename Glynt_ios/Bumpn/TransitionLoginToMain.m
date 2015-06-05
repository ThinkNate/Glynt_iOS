//
//  TransitionLoginToMain.m
//  Bumpn
//
//  Created by Nate Berman on 12/17/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "TransitionLoginToMain.h"
#import "LoginViewController.h"
#import "MainView.h"

@implementation TransitionLoginToMain

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"animating transition");
    LoginViewController *fromViewController = (LoginViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect screenbounds = [[UIScreen mainScreen]bounds];
    
    CGAffineTransform toVCCompletionTranslationTransform = CGAffineTransformIdentity; // reset transform
    CGAffineTransform toVCStartingTranslationTransform = CGAffineTransformMakeTranslation(0, 10);
    CGAffineTransform fromVCCompletionTranslationTransform = CGAffineTransformMakeTranslation(0, -screenbounds.size.height);
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         fromViewController.nameField.frame = CGRectMake(fromViewController.nameField.frame.origin.x, fromViewController.nameField.frame.origin.y + 10,fromViewController.nameField.frame.size.width, fromViewController.nameField.frame.size.height);
                         fromViewController.nameField.alpha = 0;
                         fromViewController.passwordField.frame = CGRectMake(fromViewController.passwordField.frame.origin.x, fromViewController.passwordField.frame.origin.y + 10, fromViewController.passwordField.frame.size.width, fromViewController.passwordField.frame.size.height);
                         fromViewController.passwordField.alpha = 0;
                         fromViewController.emailField.frame = CGRectMake(fromViewController.emailField.frame.origin.x, fromViewController.emailField.frame.origin.y + 10, fromViewController.emailField.frame.size.width, fromViewController.emailField.frame.size.height);
                         fromViewController.emailField.alpha = 0;
                         fromViewController.backBtn.frame = CGRectMake(fromViewController.backBtn.frame.origin.x, fromViewController.backBtn.frame.origin.y + 10, fromViewController.backBtn.frame.size.width, fromViewController.backBtn.frame.size.height);
                         fromViewController.backBtn.alpha = 0;
                         fromViewController.checkBtn.frame = CGRectMake(fromViewController.checkBtn.frame.origin.x, fromViewController.checkBtn.frame.origin.y + 10, fromViewController.checkBtn.frame.size.width, fromViewController.checkBtn.frame.size.height);
                         fromViewController.checkBtn.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateKeyframesWithDuration:.5
                                                        delay:0
                                                      options:0
                                                   animations:^{
                                                       fromViewController.glyntImage.frame = CGRectMake(fromViewController.glyntImage.frame.origin.x, -fromViewController.glyntImage.frame.size.height, fromViewController.glyntImage.frame.size.width, fromViewController.glyntImage.frame.size.height);
                                                       fromViewController.glyntImage.alpha = 0;
                                                   } completion:^(BOOL finished) {
                                                       // login now gone
                                                       [[UIApplication sharedApplication]setStatusBarHidden:false];
                                                       if ([fromViewController respondsToSelector:@selector(edgesForExtendedLayout)]) fromViewController.edgesForExtendedLayout = UIRectEdgeNone;
                                                       [fromViewController.navigationController setNavigationBarHidden:NO];
                                                       MainView *toViewController = (MainView*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
                                                       if ([toViewController respondsToSelector:@selector(edgesForExtendedLayout)]) toViewController.edgesForExtendedLayout = UIRectEdgeNone;
                                                       [toViewController viewDidLoad];
                                                       toViewController.view.alpha = 0;
                                                       toViewController.profileBtn.enabled = false;
                                                       toViewController.postBtn.enabled = false;
                                                       // Add the toView to the container
                                                       [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
                                                       toViewController.view.transform = toVCStartingTranslationTransform;
            
                                                       fromViewController.view.transform = fromVCCompletionTranslationTransform;
                                                       [UIView animateWithDuration:.5
                                                                             delay:.2
                                                                           options:0
                                                                        animations:^{
                                                                            toViewController.view.alpha = 1;
                                                                            toViewController.view.transform = toVCCompletionTranslationTransform;
                                                                            toViewController.navigationController.navigationBarHidden = false;
                                                                        } completion:^(BOOL finished) {
                                                                            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                                                                            NSMutableArray *navArray = [[NSMutableArray alloc]initWithObjects:toViewController, nil];
                                                                            toViewController.navigationController.viewControllers = navArray;
                                                                            toViewController.profileBtn.enabled = true;
                                                                            toViewController.postBtn.enabled = true;
                                                                        }];
                                                   }];
                     }];
}

@end
