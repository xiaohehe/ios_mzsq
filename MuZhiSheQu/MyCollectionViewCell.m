//
//  MyCollectionViewCell.m
//  CollectionViewDemo1
//
//  Created by IOS.Mac on 16/10/27.
//  Copyright © 2016年 com.elepphant.pingchuan. All rights reserved.
//

#import "MyCollectionViewCell.h"
//#import "Masonry.h"
#import "UIImageView+WebCache.h"

NSString *const kMyCollectionViewCellID = @"kMyCollectionViewCellID";
@interface MyCollectionViewCell()

@property (strong, nonatomic) UIImageView *posterView;
@property(nonatomic,assign) float scale;

@end

@implementation MyCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _posterView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480){
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if (_posterView) {
        return;
    }
    _posterView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.frame=CGRectMake(0, 0,20*self.scale,20*self.scale);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius=5;
        [self.contentView addSubview:imageView];
        imageView;
    });
}

#pragma mark - Public Method

- (void)configureCellWithPostURL:(NSString *)posterURL {
    [_posterView sd_setImageWithURL:[NSURL URLWithString:posterURL] placeholderImage:[UIImage imageNamed:@"not_1"]];
}


@end
