//
//  DTDBumpnB.m
//  Bumpn
//
//  Created by Nate Berman on 7/19/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "DTDBumpnB.h"

@implementation DTDBumpnB

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _bumpBot = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_bottom_B.png"]];
    [self addSubview:_bumpBot];
    _bumpBot.frame = CGRectMake(10, 55, 48, 40);
    
    _bumpMid = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_arrowTail.png"]];
    [self addSubview:_bumpMid];
    _bumpMid.frame = CGRectMake(15, 48, 10, 12);
    
    _bumpTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bumpn_top_arrow.png"]];
    [self addSubview:_bumpTop];
    _bumpTop.frame = CGRectMake(2, 27, 37, 26);
}


- (IBAction)bumpBtn:(id)sender {
    CGRect originalTopFrame = CGRectMake(_bumpTop.frame.origin.x, _bumpTop.frame.origin.y, _bumpTop.frame.size.width, _bumpTop.frame.size.height);
    CGRect originalMidFrame = CGRectMake(_bumpMid.frame.origin.x, _bumpMid.frame.origin.y, _bumpMid.frame.size.width, _bumpMid.frame.size.height);
    // Animate arrow top up
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bumpTop.frame = CGRectMake(_bumpTop.frame.origin.x, _bumpTop.frame.origin.y + 20, _bumpTop.frame.size.width, _bumpTop.frame.size.width);
                     } completion:^(BOOL finished) {
                         // animate arrow back down
                         [UIView animateWithDuration:0.3
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              _bumpTop.frame = originalTopFrame;
                                          } completion:^(BOOL finished) {
                                              //
                                          }];
                     }];
    // animate arrow mid up
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bumpTop.frame = CGRectMake(_bumpMid.frame.origin.x, _bumpMid.frame.origin.y + 20, _bumpMid.frame.size.width, _bumpMid.frame.size.width);
                     } completion:^(BOOL finished) {
                         // animate arrow back down
                         [UIView animateWithDuration:0.3
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              _bumpMid.frame = originalMidFrame;
                                          } completion:^(BOOL finished) {
                                              //
                                          }];
                     }];
}
@end
