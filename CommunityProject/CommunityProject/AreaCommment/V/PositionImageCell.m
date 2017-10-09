//
//  PositionImageCell.m
//  CommunityProject
//
//  Created by bjike on 2017/7/21.
//  Copyright © 2017年 来自任性傲娇的女王. All rights reserved.
//

#import "PositionImageCell.h"

@implementation PositionImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    
}
-(void)setUploadModel:(UploadImageModel *)uploadModel{
    
    _uploadModel = uploadModel;
    
    self.delBtn.hidden = _uploadModel.isHide;
    
    if (_uploadModel.isPlaceHolder) {
        if (self.isRaise) {
            self.headImageView.image = [UIImage imageNamed:@"addFriend.png"];
        }else{
            self.headImageView.image = [UIImage imageNamed:@"uploadImg.png"];
        }
    }else{
        self.headImageView.image = _uploadModel.image;
    }
    
}
- (IBAction)deleteClick:(id)sender {
    UIButton * button = (UIButton *)sender;
    PositionImageCell * cell = (PositionImageCell *)[[button superview]superview];
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    UploadImageModel * model = self.dataArr[indexPath.row];
    if (self.isRaise) {
        //删除的第一张替换成占位图，
        if (indexPath.row == 0 && self.dataArr.count == 3) {
            model.isPlaceHolder = YES;
            model.isHide = YES;
            model.image = [UIImage imageNamed:@"addFriend.png"];
        }else if(self.dataArr.count == 3&&indexPath.row != 0){
            //总共3张(没有占位图)，删除的不是第一张的时候，在0插入一组数据
            int i = 0;
            for (UploadImageModel * subModel in self.dataArr) {
                if (subModel.isPlaceHolder) {
                    i++;
                    break;
                }
            }
            if (i == 0) {
                UploadImageModel * upload = [UploadImageModel new];
                upload.isPlaceHolder = YES;
                upload.isHide = YES;
                upload.image = [UIImage imageNamed:@"addFriend.png"];
                self.change(upload,indexPath);
            }else{
                self.delete(indexPath);
            }
           
        }else{
            self.delete(indexPath);
        }
        
    }else{
        //判断如果删除的是第九张，最后一张变成占位图，如果是其他的要删除并且把最后一张变成占位图

        if (indexPath.row == 8) {
            model.isPlaceHolder = YES;
            model.isHide = YES;
        }else if(indexPath.row != 8 && self.dataArr.count == 9){
            //删除一个cell
            UploadImageModel * upload = self.dataArr[8];
            upload.isPlaceHolder = YES;
            upload.isHide = YES;
            self.delete(indexPath);
            
        }else{
            self.delete(indexPath);
        }
    }
   

    //刷新UI
    self.refresh();
    
}

@end
