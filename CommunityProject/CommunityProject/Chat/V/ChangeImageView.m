//
//  ChangeImageView.m
//  CommunityProject
//
//  Created by bjike on 17/3/23.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ChangeImageView.h"

@implementation ChangeImageView

-(void)containerViewWillAppear{
    [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
    
    [self.switchButton setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
}
-(void)containerViewWillDisappear{
    [self.switchButton setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
    [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
}
-(void)containerViewDidAppear{
    [self.switchButton setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
    [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
}
@end
