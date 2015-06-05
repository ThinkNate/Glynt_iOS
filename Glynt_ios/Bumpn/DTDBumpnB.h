//
//  DTDBumpnB.h
//  Bumpn
//
//  Created by Nate Berman on 7/19/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDBumpnB : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bumpTop;
@property (strong, nonatomic) IBOutlet UIImageView *bumpMid;
@property (strong, nonatomic) IBOutlet UIImageView *bumpBot;
@property (strong, nonatomic) IBOutlet UIButton *bumpBtn;
- (IBAction)bumpBtn:(id)sender;

@end
