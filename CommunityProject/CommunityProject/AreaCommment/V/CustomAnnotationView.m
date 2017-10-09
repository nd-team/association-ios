//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIImageView * firstImageView;
@property (nonatomic,strong)UIImageView * secondImageView;
@property (nonatomic,strong)UIImageView * thirdImageView;

@end

@implementation CustomAnnotationView

@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;
@synthesize backView = _backView;

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
        WeakSelf;
        self.bounds = CGRectMake(0.f, 0.f, 120, 90);
        self.backgroundColor = [UIColor clearColor];
        self.backView = [UIView new];
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(5);
            make.left.equalTo(self).mas_offset(18);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(25.5);
        }];
        UIImageView * imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"whiteHead.png"];
        [self.backView addSubview:imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.bottom.equalTo(weakSelf.backView);
        }];
        self.firstImageView = [UIImageView new];
        [self.backView addSubview:self.firstImageView];
        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backView).mas_offset(3);
            make.left.equalTo(weakSelf.backView).mas_offset(3);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        self.secondImageView = [UIImageView new];
        [self.backView addSubview:self.secondImageView];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backView).mas_offset(3);
            make.left.equalTo(weakSelf.firstImageView.mas_right).mas_offset(3);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        self.thirdImageView = [UIImageView new];
        [self.backView addSubview:self.thirdImageView];
        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.backView).mas_offset(3);
            make.left.equalTo(weakSelf.secondImageView.mas_right).mas_offset(3);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [UIImageView new];
        [self addSubview:self.portraitImageView];
        [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.backView.mas_bottom).mas_offset(3);
            make.height.mas_equalTo(29);
            make.width.mas_equalTo(25.5);
        }];
        NSString * url = [NSString stringWithFormat:JAVAURL,@"file/thumbnails?path=%@"];
        switch (self.imageArr.count) {
            case 1:
            {
                self.backView.hidden = NO;
                [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.imageArr[0]]] placeholderImage:[UIImage imageNamed:@"default"]];
            }
                break;
            case 2:
            {
                self.backView.hidden = NO;
                [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.imageArr[0]]] placeholderImage:[UIImage imageNamed:@"default"]];
                [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.imageArr[1]]] placeholderImage:[UIImage imageNamed:@"default"]];
            }
                break;
            case 3:
            {
                self.backView.hidden = NO;
                [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.imageArr[0]]] placeholderImage:[UIImage imageNamed:@"default"]];
                [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.imageArr[1]]] placeholderImage:[UIImage imageNamed:@"default"]];
                [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:url,self.imageArr[2]]] placeholderImage:[UIImage imageNamed:@"default"]];
            }
                break;
            default:
                self.backView.hidden = YES;
                break;
        }
        /* Create name label. */
        self.nameLabel = [UILabel new];
        self.nameLabel.backgroundColor  = [UIColor whiteColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = UIColorFromRGB(0x333333);
        self.nameLabel.font             = [UIFont systemFontOfSize:13.f];
        self.nameLabel.layer.cornerRadius = 9.5;
        self.nameLabel.layer.masksToBounds = YES;
        self.nameLabel.layer.borderWidth = 1;
        self.nameLabel.layer.borderColor = UIColorFromRGB(0xeceef0).CGColor;
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLabel.preferredMaxLayoutWidth = (110);
        [self.nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.portraitImageView.mas_bottom).mas_offset(3);
            make.height.mas_equalTo(19);
        }];
    }
    
    return self;
}
@end
