//
//  ManagerDownloadCell.m
//  CommunityProject
//
//  Created by bjike on 2017/6/26.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "ManagerDownloadCell.h"


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
-(void)configureVideo:(VideoDownloadListModel *)videlModel{
    
    self.titleLabel.text = videlModel.title;
//    self.progressView.progress = videlModel.so_downloadProgress;
////    float mb = videlModel.so_downloadSpeed/1024.00/1024.00;
//    NSSLog(@"%lu",(unsigned long)videlModel.so_downloadState);;
//    self.videoModel = videlModel;
//    [self updateState:videlModel.so_downloadState];
}
//- (void)updateState:(SODownloadState)state {
////    float allMb = [videlModel.mbStr floatValue];
//    switch (state) {
//        case SODownloadStateWait:
//        {
//            self.projessLabel.text = [NSString stringWithFormat:@"等待中:MB"];
//            self.downBtn.selected = NO;
//            [self common];
//        }
//            
//            break;
//        case SODownloadStatePaused:
//        {
//            self.projessLabel.text = [NSString stringWithFormat:@"已暂停:/MB"];
//            self.downBtn.selected = NO;
//            [self common];
//        }
//            break;
//        case SODownloadStateError:
//        {
//            self.projessLabel.text = [NSString stringWithFormat:@"失败:MB"];
//            self.downBtn.selected = NO;
//            [self common];
//        }
//            break;
//        case SODownloadStateLoading:
//            
//        {
//            self.projessLabel.text = [NSString stringWithFormat:@"缓存中:MB"];
//            self.downBtn.selected = YES;
//            self.progressView.hidden = NO;
//            self.projessLabel.textAlignment = NSTextAlignmentRight;
//            self.progressView.progressTintColor = UIColorFromRGB(0x10db9f);
//            self.projessLabel.textColor = UIColorFromRGB(0x0fbb88);
//            
//        }
//            break;
//        case SODownloadStateComplete:
//        {
//            self.projessLabel.text = [NSString stringWithFormat:@"大小:MB"];
//            self.downBtn.enabled = NO;
//            self.progressView.hidden = YES;
//            self.projessLabel.textAlignment = NSTextAlignmentLeft;
//            self.progressView.progressTintColor = UIColorFromRGB(0xafafaf);
//            self.projessLabel.textColor = UIColorFromRGB(0xc1c1c1);
//        }
//            break;
//        default:
//        {
//            self.projessLabel.text = [NSString stringWithFormat:@"未下载:MB"];
//            self.downBtn.selected = NO;
//            [self common];
//            
//        }
//            break;
//    }
//
//}

-(void)common{
    self.progressView.hidden = NO;
    self.projessLabel.textAlignment = NSTextAlignmentRight;
    self.progressView.progressTintColor = UIColorFromRGB(0xafafaf);
    self.projessLabel.textColor = UIColorFromRGB(0xc1c1c1);
  
}
- (IBAction)downloadClick:(id)sender {
    self.downBtn.selected = !self.downBtn.selected;
    UIButton * button = (UIButton *)sender;
    ManagerDownloadCell * cell = (ManagerDownloadCell *)[[button superview]superview];
    //操作下载
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    VideoDownloadListModel * model = self.dataArr[indexPath.row];
//    switch (model.so_downloadState) {
//        case SODownloadStateError:
//        {
//            [[SODownloader videoDownloader]resumeItem:model];
//            self.downBtn.selected = YES;
//        }
//            break;
//        case SODownloadStatePaused:
//        {
//            [[SODownloader videoDownloader]resumeItem:model];
//            self.downBtn.selected = YES;
//        }
//            break;
//        case SODownloadStateNormal:
//        {
//            [[SODownloader videoDownloader]downloadItem:model];
//            self.downBtn.selected = YES;
//
//        }
//            break;
//        case SODownloadStateLoading:
//        {
//            [[SODownloader videoDownloader]pauseItem:model];
//            self.downBtn.selected = NO;
//
//        }
//            break;
//        case SODownloadStateWait:
//        {
//            [[SODownloader videoDownloader]pauseItem:model];
//            self.downBtn.selected = NO;
//
//        }
//            break;
//        default:
//            break;
//    }

}
@end
