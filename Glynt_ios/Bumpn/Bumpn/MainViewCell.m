//
//  MainViewCell.m
//  Bumpn
//
//  Created by Nate Berman on 9/7/14.
//  Copyright (c) 2014 Dream Team Digital. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

- (void)awakeFromNib
{
    // Initialization code    
    self.titleLabel.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:28];
    
    self.messageLabel.font = [UIFont fontWithName:@"GurmukhiSangamMN" size:16];
    self.messageLabel.numberOfLines = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mediaBtn:(id)sender {
    //[self.mediaBtn setSelected:YES];
    [self.delegate mediaBtnPressed:sender];
}
- (IBAction)bumpBtn:(id)sender {
    [self.delegate bumpScoreBtnPressed:sender];
}

@end
