//
//  ManagerDownloadCell.m
//  CommunityProject
//
//  Created by bjike on 2017/6/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ManagerDownloadCell.h"
#import "SRDownloadManager.h"


@implementation ManagerDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //暂停下载的状态
    [self.downBtn setImage:[UIImage imageNamed:@"startLoad"] forState:UIControlStateNormal];
    //下载状态
    [self.downBtn setImage:[UIImage imageNamed:@"stopLoad"] forState:UIControlStateSelected];
    //下载完成
    [self.downBtn setImage:[UIImage imageNamed:@"finishLoad"] forState:UIControlStateDisabled];

    self.progressView.progress = 0;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setVideoModel:(SRDownloadModel *)videoModel{
    _videoModel = videoModel;
    self.titleLabel.text = _videoModel.title;
    WeakSelf;
    if (_videoModel.status != 1) {
        
        [weakSelf updateState:_videoModel.status andTotal:_videoModel.totalLength/1024.00/1024.00 andExpect:0];

    }else{
        //下载中才走block
        _videoModel.progress = ^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            weakSelf.progressView.progress = progress;
            [weakSelf updateState:weakSelf.videoModel.status andTotal:expectedSize/1024.00/1024.00 andExpect:receivedSize/1024.00/1024.00];
            if (progress == 1.0) {
                weakSelf.projessLabel.text = [NSString stringWithFormat:@"大小:%.2fMB",expectedSize/1024.00/1024.00];
                [weakSelf finish];

            }
        };
    }
}

- (void)updateState:(SRDownloadState)state andTotal:(CGFloat)totalSize andExpect:(CGFloat)expectSize{
    switch (state) {
        case SRDownloadStateWaiting:
        {
            self.projessLabel.text = [NSString stringWithFormat:@"等待中:%.2fMB",totalSize];
            self.downBtn.selected = NO;
            [self common];
        }
            
            break;
        case SRDownloadStateSuspended:
        {
            self.projessLabel.text = [NSString stringWithFormat:@"已暂停:%.2f/%.2fMB",expectSize,totalSize];
            self.downBtn.selected = NO;
            [self common];
        }
            break;
        case SRDownloadStateFailed:
        {
            self.projessLabel.text = [NSString stringWithFormat:@"失败:%.2fMB",totalSize];
            self.downBtn.selected = NO;
            [self common];
        }
            break;
        case SRDownloadStateRunning:
            
        {
            self.projessLabel.text = [NSString stringWithFormat:@"缓存中:%.2f/%.2fMB",expectSize,totalSize];
            self.downBtn.selected = YES;
            self.progressView.hidden = NO;
            self.projessLabel.textAlignment = NSTextAlignmentRight;
            self.progressView.progressTintColor = UIColorFromRGB(0x10db9f);
            self.projessLabel.textColor = UIColorFromRGB(0x0fbb88);
            
        }
            break;
        case SRDownloadStateCompleted:
        {
            self.projessLabel.text = [NSString stringWithFormat:@"大小:%.2fMB",totalSize];
            [self finish];
        }
            break;
        default:
        {
            self.projessLabel.text = [NSString stringWithFormat:@"未下载:%.2fMB",totalSize];
            self.downBtn.selected = NO;
            [self common];
            
        }
            break;
    }

}
-(void)finish{
    self.downBtn.enabled = NO;
    self.progressView.hidden = YES;
    self.projessLabel.textAlignment = NSTextAlignmentLeft;
    self.progressView.progressTintColor = UIColorFromRGB(0xafafaf);
    self.projessLabel.textColor = UIColorFromRGB(0xc1c1c1);

}
-(void)common{
    self.progressView.hidden = NO;
    self.projessLabel.textAlignment = NSTextAlignmentRight;
    self.progressView.progressTintColor = UIColorFromRGB(0xafafaf);
    self.projessLabel.textColor = UIColorFromRGB(0xc1c1c1);
  
}
- (IBAction)downloadClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    ManagerDownloadCell * cell = (ManagerDownloadCell *)[[button superview]superview];
    //操作下载
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    SRDownloadModel * model = self.dataArr[indexPath.row];
    switch (model.status) {
        case SRDownloadStateFailed://失败
        {
            [[SRDownloadManager sharedManager]resumeDownloadOfURL:model.URL];
        }
            break;
        case SRDownloadStateSuspended://暂停
        {
            [[SRDownloadManager sharedManager]resumeDownloadOfURL:model.URL];
        }
            break;
        case SRDownloadStateCanceled://取消
        {   //先判断是否下载过 没有就下载否则就继续下载
            if ([[SRDownloadManager sharedManager]isDownloadCompletedOfURL:model.URL]) {
                [[SRDownloadManager sharedManager]resumeDownloadOfURL:model.URL];
            }else{
                //发送通知下载
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DownloadVideo" object:@{@"URL":model.URL,@"title":model.title}];
            }

        }
            break;
        case SRDownloadStateRunning:
        {
            [[SRDownloadManager sharedManager]suspendDownloadOfURL:model.URL];

        }
            break;
        case SRDownloadStateWaiting:
        {
            //下载 如果是已经有3个正在下载就不做操作否则下载 统计正在下载的个数
            int count = 0;
            for (SRDownloadModel * model in self.dataArr) {
                if (model.status == SRDownloadStateRunning) {
                    count++;
                }
            }
            if (count < 3) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DownloadVideo" object:@{@"URL":model.URL,@"title":model.title}];
                self.downBtn.selected = YES;
            }else{
                self.downBtn.selected = NO;
            }

        }
            break;
        default:
            break;
    }
//刷新列表
    self.block();
}
@end
