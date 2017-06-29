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
    self.progressView.progress = _videoModel.progressOne;
    CGFloat total = _videoModel.totalLength/1024.00/1024.00;
    CGFloat expect = _videoModel.expectLength/1024.00/1024.00;
    [self updateState:_videoModel.status andTotal:total andExpect:expect];
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
            self.downBtn.enabled = NO;
            self.progressView.hidden = YES;
            self.projessLabel.textAlignment = NSTextAlignmentLeft;
            self.progressView.progressTintColor = UIColorFromRGB(0xafafaf);
            self.projessLabel.textColor = UIColorFromRGB(0xc1c1c1);
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
            self.downBtn.selected = YES;
        }
            break;
        case SRDownloadStateSuspended://暂停
        {
            [[SRDownloadManager sharedManager]resumeDownloadOfURL:model.URL];
            self.downBtn.selected = YES;
        }
            break;
        case SRDownloadStateCanceled://取消
        {
            [[SRDownloadManager sharedManager]resumeDownloadOfURL:model.URL];
            self.downBtn.selected = YES;

        }
            break;
        case SRDownloadStateRunning:
        {
            [[SRDownloadManager sharedManager]suspendDownloadOfURL:model.URL];
            self.downBtn.selected = NO;

        }
            break;
        case SRDownloadStateWaiting:
        {
            [[SRDownloadManager sharedManager]resumeDownloadOfURL:model.URL];
            self.downBtn.selected = YES;

        }
            break;
        default:
            self.downBtn.selected = NO;
            break;
    }

}
@end
