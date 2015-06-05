//
//  TransitionLogoutToLogin.m
//  Bumpn
//
//  Created by Nate Berman on 12/17/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "TransitionLogoutToLogin.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"

@implementation TransitionLogoutToLogin

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"animating Dash to Menu");
    ProfileViewController *fromViewController = (ProfileViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    LoginViewController *toViewController = (LoginViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //[toViewController viewDidLoad];
    UIView *containerView = [transitionContext containerView];
    
    // Add the toView to the container
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    CGRect screenbounds = [[UIScreen mainScreen]bounds];
    
    CGAffineTransform toVCCompletionTranslationTransform = CGAffineTransformIdentity;
    CGAffineTransform toVCStartingTranslationTransform = CGAffineTransformMakeTranslation(screenbounds.size.width, 0);
    
    CGAffineTransform fromVCCompletionTranslationTransform = CGAffineTransformMakeTranslation(-screenbounds.size.width, 0);
    
    toViewController.view.transform = toVCStartingTranslationTransform;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay: 0
                        options: 0
                     animations:^{
                         // slide up the second view controller's view
                         fromViewController.view.alpha = 0;
                         toViewController.view.transform = toVCCompletionTranslationTransform;
                         fromViewController.view.transform = fromVCCompletionTranslationTransform;
                         
                     } completion:^(BOOL finished) {
                         // Clean up
                         // Declare that we've finished
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         NSMutableArray *navArray = [[NSMutableArray alloc]initWithObjects:toViewController, nil];
                         toViewController.navigationController.viewControllers = navArray;
                     }];
}

@end
