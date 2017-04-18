//
//  LookBigImageController.m
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "LookBigImageController.h"

@interface LookBigImageController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthCons;

@end

@implementation LookBigImageController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCon.numberOfPages = self.imageArr.count;
    self.pageCon.currentPage = self.count;
    [self.scrollView setContentOffset:CGPointMake(self.pageCon.currentPage * KMainScreenWidth, 0) animated:NO];
     //放大图片手势
    [self setTapUI];
    //点击手势返回
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
}
-(void)tapClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTapUI{
    WeakSelf;
    for (int i = 0; i < self.imageArr.count; i++) {
        
        __block CGFloat height;
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.imageArr[i]]]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            height = image.size.height+10;
        }];
        //alloc]initWithFrame:CGRectMake(i*KMainScreenWidth, 0, KMainScreenWidth, height)
         UIImageView * imageView = [UIImageView new];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.scrollView).offset(KMainScreenWidth*i);
            make.centerY.equalTo(weakSelf.view);
            make.width.mas_equalTo(KMainScreenWidth);
            make.height.mas_equalTo(height);
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.imageArr[i]]]] placeholderImage:[UIImage imageNamed:@"banner2"]];
        
        [self.scrollView addSubview:imageView];
        //缩放手势
        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchClicked:)];
        
        [imageView addGestureRecognizer:pinch];
        
        //平移手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
        [imageView addGestureRecognizer:pan];
    }

  
    
    
}
-(void)pinchClicked:(UIPinchGestureRecognizer *)pinch{
    
    UIImageView * image = (UIImageView *) pinch.view;
    
    image.transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
}
-(void)tapAction:(UIPanGestureRecognizer *)pan{
    
    UIImageView * image = (UIImageView *) pan.view;
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [pan translationInView:image.superview];
        
        image.center = (CGPoint){image.center.x+point.x,image.center.y+point.y};
        
        [pan setTranslation:CGPointZero inView:image.superview];
    }
    
}
- (IBAction)pageAction:(id)sender {
    
    UIPageControl *pageCon = (UIPageControl *)sender;
    
    [self.scrollView setContentOffset:CGPointMake(pageCon.currentPage * KMainScreenWidth, 0) animated:NO];
    
    
}

//scrollView的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x/KMainScreenWidth;
    
    _pageCon.currentPage = page;
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.viewWidthCons.constant = KMainScreenWidth;
}
@end
