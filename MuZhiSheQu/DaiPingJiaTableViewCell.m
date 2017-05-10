

//
//  DaiPingJiaTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DaiPingJiaTableViewCell.h"

@implementation DaiPingJiaTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
        
    }
    
    return self;
}


-(void)newView{
    
    _cell1 = [CellView new];
    [self.contentView addSubview:_cell1];
    _cell2 = [CellView new];
    [self.contentView addSubview:_cell2];
    _cell3 = [CellView new];
    [self.contentView addSubview:_cell3];
    
    
    
    
    _headImg = [UIImageView new];
    [_cell1 addSubview:_headImg];
    
    _nameLa = [UILabel new];
    _nameLa.font=DefaultFont(self.scale);
    [_cell1 addSubview:_nameLa];
    
    _jiantouImg = [UIImageView new];
    [_cell1 addSubview:_jiantouImg];
    
    _talkImg = [UIButton new];
    [_cell1 addSubview:_talkImg];
    
    _teleImg = [UIButton new];
    [_cell1 addSubview:_teleImg];
    
    _states = [UILabel  new];
    _states.font=DefaultFont(self.scale);
    [_cell1 addSubview:_states];
    
    _fuwuXiangMu = [UILabel new];
    _fuwuXiangMu.textColor=grayTextColor;
    _fuwuXiangMu.font=SmallFont(self.scale);
    [_cell2 addSubview:_fuwuXiangMu];
    
    _xiaDanShiJian = [UILabel new];
    _xiaDanShiJian.textColor=grayTextColor;
    _xiaDanShiJian.font=SmallFont(self.scale);
    [_cell2 addSubview:_xiaDanShiJian];
    
    _beizhu = [UILabel new];
    _beizhu.textColor=grayTextColor;
    _beizhu.font=SmallFont(self.scale);
    [_cell2 addSubview:_beizhu];
    
    _yuyueshijian = [UILabel new];
    _yuyueshijian.textColor=grayTextColor;
    _yuyueshijian.font=SmallFont(self.scale);
    [_cell2 addSubview:_yuyueshijian];
    
    _fuwudizhi = [UILabel new];
    _fuwudizhi.textColor=grayTextColor;
    _fuwudizhi.font=SmallFont(self.scale);
    [_cell2 addSubview:_fuwudizhi];
    
    
    _qupingjia = [UIButton new];
    _qupingjia.layer.cornerRadius=4*self.scale;
    _qupingjia.layer.borderWidth=.5;
    _qupingjia.titleLabel.font=SmallFont(self.scale);
    _qupingjia.layer.borderColor=grayTextColor.CGColor;
    [_qupingjia setTitle:@"去评价" forState:UIControlStateNormal];
    [_qupingjia setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cell3 addSubview:_qupingjia];
    
    
    _shanchu = [UIButton new];
    _shanchu.layer.cornerRadius=4*self.scale;
    _shanchu.layer.borderWidth=.5;
    _shanchu.titleLabel.font=SmallFont(self.scale);
    _shanchu.layer.borderColor=grayTextColor.CGColor;
    [_shanchu setTitle:@"删除订单" forState:UIControlStateNormal];
    [_shanchu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cell3 addSubview:_shanchu];
    
    _topLine = [UIView new];
    _topLine.backgroundColor=blackLineColore;
    [_cell1 addSubview:_topLine];
    
    _botLine = [UIView new];
    _botLine.backgroundColor=superBackgroundColor;
    [self.contentView addSubview:_botLine];
    _cellBtn = [UIButton new];
    [_cell2 addSubview:_cellBtn];
    
    
}
-(void)layoutSubviews{
    
    _cell1.frame=CGRectMake(0, 0, self.width, 50*self.scale);

    
    _topLine.frame=CGRectMake(0, 0, self.width, .5);
    
    _headImg.frame=CGRectMake(10*self.scale, 10*self.scale, 40*self.scale, 30*self.scale);
    _cell1.height=_headImg.bottom+10*self.scale;
    
    _nameLa.frame=CGRectMake(_headImg.right+5*self.scale, _cell1.height/2-10*self.scale, 100*self.scale, 20*self.scale);
    [_nameLa sizeToFit];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
//    CGSize size = [_nameLa.text boundingRectWithSize:CGSizeMake(200, 20*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    
//    if (size.width>100) {
//        size.width=100;
//    }
//    _nameLa.width=size.width;

    _jiantouImg.frame=CGRectMake(_nameLa.right+5*self.scale, _cell1.height/2-7*self.scale, 15*self.scale, 14*self.scale);
    
//    _talkImg.frame=CGRectMake(_jiantouImg.right+3*self.scale, _cell1.height/2-10*self.scale, 20*self.scale, 20*self.scale);
    _teleImg.frame=CGRectMake(_jiantouImg.right+3*self.scale, _cell1.height/2-10*self.scale, 20*self.scale, 20*self.scale);

    
    _states.frame=CGRectMake(self.width-60*self.scale, _cell1.height/2-10*self.scale, 50*self.scale, 20*self.scale);
    _states.textColor=[UIColor redColor];
    
    
    
    
    
    _cell2.frame=CGRectMake(0, _cell1.bottom, self.width, 100);
    _cellBtn.frame=CGRectMake(0, 0, _cell2.width, _cell2.height);
    _fuwuXiangMu.frame=CGRectMake(10*self.scale, 10*self.scale, self.width-20*self.scale, 20*self.scale);
    [_fuwuXiangMu sizeToFit];
    if (_fuwuXiangMu.height<20*self.scale) {
        _fuwuXiangMu.height=20*self.scale;
    }
    
    
    _xiaDanShiJian.frame=CGRectMake(_fuwuXiangMu.left, _fuwuXiangMu.bottom, self.width-20*self.scale, 20*self.scale);
    
    
    _beizhu.frame=CGRectMake(_xiaDanShiJian.left, _xiaDanShiJian.bottom, _xiaDanShiJian.width, _xiaDanShiJian.height);
    [_beizhu sizeToFit];
    if (_beizhu.height<20*self.scale) {
        _beizhu.height=20*self.scale;
    }
    
    
    _yuyueshijian.frame=CGRectMake(_beizhu.left, _beizhu.bottom, self.width-20*self.scale, _beizhu.height);
    
    
//    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle1.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:12*self.scale], NSParagraphStyleAttributeName:paragraphStyle1.copy};
//    CGSize size1 = [_fuwudizhi.text boundingRectWithSize:CGSizeMake(self.contentView.width-20*self.scale, 35*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
    
    _fuwudizhi.frame=CGRectMake(_yuyueshijian.left, _yuyueshijian.bottom, _yuyueshijian.width, 10);
    [_fuwudizhi sizeToFit];
    if (_fuwudizhi.height<20*self.scale) {
        _fuwudizhi.height=20*self.scale;
    }
    
    
    _cell2.height=_fuwudizhi.bottom+10*self.scale;
    
    
    _cell3.frame=CGRectMake(0, _cell2.bottom, self.width, 40*self.scale);
    _qupingjia.frame=CGRectMake(self.width-130*self.scale, _cell3.height/2-12.5*self.scale, 50*self.scale, 25*self.scale);
    
    
    
    _shanchu.frame=CGRectMake(_qupingjia.right+10*self.scale, _cell3.height/2-12.5*self.scale, 60*self.scale, 25*self.scale);
    _cell3.height=_shanchu.bottom+10*self.scale;
    
    _botLine.frame=CGRectMake(0, _cell3.bottom, self.width, 10*self.scale);
    
}

@end
