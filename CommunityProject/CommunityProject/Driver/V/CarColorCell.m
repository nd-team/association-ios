//
//  CarColorCell.m
//  CommunityProject
//
//  Created by bjike on 2017/8/7.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CarColorCell.h"

@implementation CarColorCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.colorView.layer.cornerRadius = 10;
    self.colorView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showView:(NSString *)color{
    self.colorLabel.text = color;
    if ([color isEqualToString:@"黑"]) {
        self.colorView.backgroundColor = [UIColor blackColor];
        self.colorView.layer.borderColor = [UIColor blackColor].CGColor;

    }else if ([color isEqualToString:@"白"]){
        self.colorView.backgroundColor = [UIColor whiteColor];
        self.colorView.layer.borderColor = UIColorFromRGB(0xeceef0).CGColor;

    }else if ([color isEqualToString:@"银"]){
        self.colorView.backgroundColor = UIColorFromRGB(0xeceef0);
        self.colorView.layer.borderColor = UIColorFromRGB(0xeceef0).CGColor;
        
    }else if ([color isEqualToString:@"红"]){
        self.colorView.backgroundColor = [UIColor redColor];
        self.colorView.layer.borderColor = [UIColor redColor].CGColor;
        
    }else if ([color isEqualToString:@"橙"]){
        self.colorView.backgroundColor = RGB(238,154,38);
        self.colorView.layer.borderColor = RGB(238,154,38).CGColor;
        
    }else if ([color isEqualToString:@"黄"]){
        self.colorView.backgroundColor = [UIColor yellowColor];
        self.colorView.layer.borderColor = [UIColor yellowColor].CGColor;
        
    }else if ([color isEqualToString:@"绿"]){
        self.colorView.backgroundColor = [UIColor greenColor];
        self.colorView.layer.borderColor = [UIColor greenColor].CGColor;
        
    }else if ([color isEqualToString:@"蓝"]){
        self.colorView.backgroundColor = [UIColor blueColor];
        self.colorView.layer.borderColor = [UIColor blueColor].CGColor;
        
    }else if ([color isEqualToString:@"靛"]){
        self.colorView.backgroundColor = RGB(26,72,151);
        self.colorView.layer.borderColor = RGB(26,72,151).CGColor;
        
    }else if ([color isEqualToString:@"紫"]){
        self.colorView.backgroundColor = RGB(133,32,127);
        self.colorView.layer.borderColor = RGB(133,32,127).CGColor;
        
    }else if ([color isEqualToString:@"棕"]){
        self.colorView.backgroundColor = [UIColor brownColor];
        self.colorView.layer.borderColor = [UIColor brownColor].CGColor;
        
    }else if ([color isEqualToString:@"粉"]){
        self.colorView.backgroundColor = RGB(229,162,192);
        self.colorView.layer.borderColor = RGB(229,162,192).CGColor;
        
    }
}
@end
