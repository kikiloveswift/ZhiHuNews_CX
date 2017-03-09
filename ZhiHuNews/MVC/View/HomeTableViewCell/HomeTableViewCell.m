//
//  HomeTableViewCell.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HomeModel_NewsList *)model
{
    if (_model != model)
    {
        _model = model;
    }
    [self assignUI];
}

- (void)assignUI
{
    self.titleLabel.text = _model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.images] placeholderImage:[UIImage imageNamed:@"wallpaper_profile"]];
}


@end
