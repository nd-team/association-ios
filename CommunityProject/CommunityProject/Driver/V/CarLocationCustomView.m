//
//  CarLocationCustomView.m
//  CommunityProject
//
//  Created by bjike on 2017/8/10.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "CarLocationCustomView.h"

#define kWidth  123.f
#define kHeight 52.f

@interface CarLocationCustomView ()
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CarLocationCustomView
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        self.portraitImageView.image = [UIImage imageNamed:@"fromHere.png"];
        [self addSubview:self.portraitImageView];
        UIImageView * smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 16, 20)];
        smallImageView.image = [UIImage imageNamed:@"redLocation.png"];
        [self addSubview:smallImageView];
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(38,12,80,20)];
//        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textColor        = UIColorFromRGB(0x666666);
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
    }
    
    return self;
}
@end
