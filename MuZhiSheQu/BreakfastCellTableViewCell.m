//
//  BreakfastCellTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#import "SuperViewController.h"
#import "BreakfastCellTableViewCell.h"
#import "SuperViewController.h"
@implementation BreakfastCellTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}

-(void)newView{

    self.headImg = [UIImageView new];
    self.headImg.contentMode=UIViewContentModeScaleAspectFill;
    self.headImg.clipsToBounds=YES;
    [self.contentView addSubview:_headImg];
    
    self.titleLa = [UILabel new];
    self.titleLa.font = DefaultFont(self.scale);
    [self.contentView addSubview:_titleLa];
    
    self.contextLa = [UILabel new];
    self.contextLa.font = SmallFont(self.scale);
    [self.contextLa sizeToFit];
    [self.contentView addSubview:_contextLa];
    
    self.addressLa = [UILabel new];
    self.addressLa.font = SmallFont(self.scale);
    self.addressLa.textColor = grayTextColor;
    [self.contentView addSubview:_addressLa];
    

    
    self.scoreLa = [UILabel new];
    self.scoreLa.font = SmallFont(1);
    self.scoreLa.textColor = [UIColor redColor];
    [self.contentView addSubview:_scoreLa];
    
    self.distanceLa = [UILabel new];
    self.distanceLa.font = SmallFont(1);
    self.distanceLa.textAlignment=NSTextAlignmentRight;
    self.distanceLa.textColor = grayTextColor;
    [self.contentView addSubview:_distanceLa];
    
    self.start = [UIView new];
    self.start.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_start];
    
    self.addressImg = [UIImageView new];
    [self.contentView addSubview:_addressImg];
    
    self.addLa = [UILabel new];
    self.addLa.font = SmallFont(1);
    self.addLa.numberOfLines=0;
    self.addLa.textColor = [UIColor colorWithRed:20/255.0 green:129/255.0 blue:243/255.0 alpha:1];
    [self.contentView addSubview:_addLa];
    
    self.addImg = [UIImageView new];
    [self.contentView addSubview:_addImg];
    
    self.SolidLine = [UIView new];
    self.SolidLine.backgroundColor = blackLineColore;
    [self.contentView addSubview:_SolidLine];
    
    self.renZheng = [UIImageView new];
    [self.renZheng setImage:[UIImage imageNamed:@"jp"]];
    [self.contentView addSubview:self.renZheng];
    
}
-(void)layoutSubviews{
    self.headImg.frame = CGRectMake(10*self.scale,10*self.scale, 100*self.scale, 75*self.scale);

    
    self.renZheng.frame=CGRectMake(self.headImg.right+5*self.scale,self.headImg.top-0*self.scale, 20*self.scale, 20*self.scale);
    
    self.titleLa.frame = CGRectMake(self.renZheng.right+5*self.scale,self.headImg.top, self.width-self.headImg.right-40*self.scale, 20*self.scale);
    if (!_isJin) {
        self.titleLa.frame = CGRectMake(self.headImg.right+10*self.scale,self.headImg.top, self.width-self.headImg.right-20*self.scale, 20*self.scale);

    }
   
    
    float startY=self.titleLa.bottom+0*self.scale;
    
    if (![_StartNumber isEqualToString:@"0"]) {

        self.start.frame =CGRectMake(self.titleLa.left, startY, 80*self.scale, 15*self.scale);
        self.start.width=[_StartNumber intValue]*13*self.scale;
        self.scoreLa.frame = CGRectMake(self.start.right+5*self.scale, _start.top, 50*self.scale, 12*self.scale);
        startY=self.start.bottom;
    }
    
    
    

    self.contextLa.frame = CGRectMake(self.headImg.right+10*self.scale,startY, self.titleLa.width, 10);
    _contextLa.numberOfLines=0;

    [_contextLa sizeToFit];
    if (_contextLa.height>30) {
        _contextLa.height=30*self.scale;
    }
    if (_contextLa.height<20*self.scale) {
        _contextLa.height=20*self.scale;
    }

    self.addressImg.frame = CGRectMake(self.headImg.right+10*self.scale,self.contextLa.bottom+5*self.scale, 7*self.scale, 10*self.scale);

    
    self.addressLa.frame = CGRectMake(self.headImg.right+10*self.scale+10*self.scale, _addressImg.top-2*self.scale, self.titleLa.width-50*self.scale,10*self.scale);
    _addressLa.numberOfLines=0;
    [self.addressLa sizeToFit];
    if (_addressLa.height>30) {
        _addressLa.height=30*self.scale;
    }
//    if (_addressLa.height<20*self.scale) {
//        _addressLa.height=20*self.scale;
//    }
    
    self.distanceLa.frame = CGRectMake(self.width-75*self.scale, self.addressLa.top, 65*self.scale, 20*self.scale);
    
    
    self.addImg.frame = CGRectMake(self.headImg.right+10*self.scale,self.addressLa.bottom+5*self.scale, 10*self.scale, 10*self.scale);
    self.addLa.frame = CGRectMake(self.addImg.right+2*self.scale, _addImg.top-5*self.scale, self.titleLa.width, 10*self.scale);
    _addLa.numberOfLines=0;

    [self.addLa sizeToFit];
    if (_addLa.height>30) {
        _addLa.height=30*self.scale;
    }
    if (_addLa.height<20*self.scale) {
        _addLa.height=20*self.scale;
    }
    
    
    
    if (self.headImg.bottom>self.contentView.height) {
        self.headImg.height = self.contentView.height-20*self.scale;
    }
    
   
    self.SolidLine.frame = CGRectMake(0, self.contentView.height-.5,self.width, .5);
}
-(void)setStartNumber:(NSString *)StartNumber
{
    if (_start) {
        [_start removeFromSuperview];
        _start=nil;
    }
    
    if (_scoreLa) {
        [_scoreLa removeFromSuperview];
        _scoreLa=nil;
        
    }
    _StartNumber=StartNumber;
   
    if (StartNumber==nil || [StartNumber isEqualToString:@""] || [StartNumber isEqualToString:@"0"]) {
            StartNumber=@"0";
        _StartNumber=StartNumber;
        return;
    }
    
    float star=[StartNumber floatValue];
    if (star>5) {
        star=5;
    }
    
    _start=[[UIView alloc]initWithFrame:CGRectMake(_titleLa.left, _titleLa.bottom+5, 70*self.scale, 15*self.scale)];
    [self.contentView addSubview:_start];

        int num=(int)star;
        float setX = 0;
        for (int i=0; i<num; i++)
        {
            UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
            starImg.image=[UIImage imageNamed:@"xq_star01"];
            setX = starImg.right +3*self.scale;
            [_start addSubview:starImg];
        }
    if (star>num)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star02"];
        [_start addSubview:starImg];
    }
    _scoreLa = [[UILabel alloc]initWithFrame:CGRectMake(self.start.right+5*self.scale, _start.top, 50*self.scale, 12*self.scale)];
    self.scoreLa.font = SmallFont(1);
    self.scoreLa.textColor = [UIColor redColor];
    [self.contentView addSubview:_scoreLa];

    self.scoreLa.text=[NSString stringWithFormat:@"%@分",StartNumber];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
