//
//  DiZhiTableViewCell.m
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DiZhiTableViewCell.h"
@interface DiZhiTableViewCell()
@property(nonatomic,strong)UIImageView *SelectedImage;
@property(nonatomic,strong)UILabel *SelectedLabel;
@end
@implementation DiZhiTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _DefaultImage=[[UIImageView alloc]init];
    _DefaultImage.image=[UIImage imageNamed:@"address_ok"];
    //_DefaultImage.highlightedImage=[UIImage imageNamed:@"center_add_ok"];
    _DefaultImage.hidden=YES;
    [self addSubview:_DefaultImage];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    [self addSubview:_NameLabel];
    
    _AdressLabel=[[UILabel alloc]init];
    _AdressLabel.numberOfLines=0;
    _AdressLabel.font=_NameLabel.font;
    [self addSubview:_AdressLabel];
    
    _EditButton=[[UIButton alloc]init];
   // [_EditButton setTitle:@"编辑" forState:UIControlStateNormal];
   // [_EditButton setTitleColor:grayTextColor forState:UIControlStateNormal];
    //_EditButton.titleLabel.font=Small10Font(self.scale);
    [_EditButton setImage:[UIImage imageNamed:@"address_ico"] forState:UIControlStateNormal];

    [self addSubview:_EditButton];
    
//    _DeleteButton=[[UIButton alloc]init];
//    [_DeleteButton setTitle:@"删除" forState:UIControlStateNormal];
//    [_DeleteButton setTitleColor:grayTextColor forState:UIControlStateNormal];
//    _DeleteButton.titleLabel.font=Small10Font(self.scale);
//    [self addSubview:_DeleteButton];
    
//    _DefaultLabel=[[UILabel alloc]init];
//    _DefaultLabel.text=@"【默认】";
//    _DefaultLabel.font=Small10Font(self.scale);
//    _DefaultLabel.textAlignment=NSTextAlignmentRight;
//     _DefaultLabel.hidden=YES;
//    _DefaultLabel.textColor=[UIColor redColor];
//    [self addSubview:_DefaultLabel];
    
//    _SetDefaultButton=[[UIButton alloc]init];
//    _SelectedImage=[[UIImageView alloc]init];
//    _SelectedImage.image=[UIImage imageNamed:@"choose_01"];
//    [_SetDefaultButton addSubview:_SelectedImage];
//    _SelectedLabel=[[UILabel alloc]init];
//    _SelectedLabel.text=@"设为默认地址";
//    _SelectedLabel.textColor=grayTextColor;
//    _SelectedLabel.font=Small10Font(self.scale);
//    [_SetDefaultButton addSubview:_SelectedLabel];
//    [self addSubview:_SetDefaultButton];
    _TopLine=[[UIImageView alloc]init];
    _TopLine.backgroundColor=blackLineColore;
    [self addSubview:_TopLine];
    
    _BottomLine=[[UIImageView alloc]init];
    _BottomLine.backgroundColor=blackLineColore;
    [self addSubview:_BottomLine];

}
-(void)layoutSubviews{
    _TopLine.frame=CGRectMake(0, 0, self.width, .5);
    _DefaultImage.frame=CGRectMake(0, 0, 21*self.scale, 18*self.scale);
    _NameLabel.frame=CGRectMake(10*self.scale, 10*self.scale, self.width-60*self.scale, 20*self.scale);
    _AdressLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, _NameLabel.width, [self Text:_AdressLabel.text Size:CGSizeMake(_NameLabel.width, 35*self.scale) Font:_AdressLabel.font].height);
    _EditButton.frame=CGRectMake(self.width-40*self.scale, _NameLabel.bottom, 25*self.scale, 30*self.scale);
//    _DeleteButton.frame=CGRectMake(_EditButton.right+5*self.scale, _EditButton.top, _EditButton.width, _EditButton.height);
//    _SetDefaultButton.frame=CGRectMake(_NameLabel.right + 5*self.scale, self.height-25*self.scale, 70*self.scale, 20*self.scale);
    _SelectedImage.frame=CGRectMake(0,5*self.scale, _SetDefaultButton.height-10*self.scale, _SetDefaultButton.height-10*self.scale);
    _SelectedLabel.frame=CGRectMake(_SelectedImage.right, 0, _SetDefaultButton.width-_SelectedImage.right, _SetDefaultButton.height);
    _DefaultLabel.frame=_SetDefaultButton.frame;
    _BottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
}


-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:fone, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return   [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}
-(void)setIsDefault:(BOOL)isDefault{
    
    _DefaultImage.hidden=!isDefault;
    _DefaultLabel.hidden=!isDefault;
    _SetDefaultButton.hidden=isDefault;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
