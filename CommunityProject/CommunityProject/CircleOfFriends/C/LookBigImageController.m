//
//  LookBigImageController.m
//  CommunityProject
//
//  Created by bjike on 17/4/18.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "LookBigImageController.h"

@interface LookBigImageController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
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
    NSSLog(@"%ld",self.count);
    self.pageCon.currentPage = self.count;
     //放大图片手势
    [self setTapUI];
    //点击手势返回
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}
-(void)tapClick{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)setTapUI{
//    WeakSelf;
    for (int i = 0; i < self.imageArr.count; i++) {
        //alloc]initWithFrame:CGRectMake(i*KMainScreenWidth,-20, KMainScreenWidth, KMainScreenHeight)
        UIImageView * imageView = [UIImageView new];
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(i*KMainScreenWidth);
            make.width.mas_equalTo(KMainScreenWidth);
            make.height.mas_equalTo(KMainScreenHeight);
        }];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.imageArr[i]]]] placeholderImage:[UIImage imageNamed:@"banner2"]];
        //风火轮加载
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:NetURL,[ImageUrl changeUrl:self.imageArr[i]]]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                NSSLog(@"%f==%f==",image.size.height,image.size.width);
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    [MBProgressHUD hideHUDForView:self.view animated:YES];
////                });
//                if (finished) {
//                    if (image.size.height > KMainScreenHeight) {
//                         imageView.frame = CGRectMake(i*KMainScreenWidth,-20, KMainScreenWidth, KMainScreenHeight);
//                    }else{
//                         imageView.frame = CGRectMake(i*KMainScreenWidth,(KMainScreenHeight- image.size.height)/2, KMainScreenWidth, image.size.height);
//                    }
//                }else{
//                    imageView.frame = CGRectMake(((KMainScreenWidth-100)/2)+i*KMainScreenWidth,(KMainScreenHeight-100)/2, 100, 100);
//                }
//                
//            }];
        
            
            
//        });
       
        //缩放手势
        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchClicked:)];
        pinch.delegate = self;
        pinch.cancelsTouchesInView = NO;
        [imageView addGestureRecognizer:pinch];
        
        //平移手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        pan.delegate = self;
        pan.cancelsTouchesInView = NO;
        [imageView addGestureRecognizer:pan];
    }
    [self.scrollView setContentOffset:CGPointMake(self.pageCon.currentPage * KMainScreenWidth, 0) animated:NO];

    self.viewWidthCons.constant = KMainScreenWidth*self.imageArr.count;
   

    
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
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    return YES;
}
@end
