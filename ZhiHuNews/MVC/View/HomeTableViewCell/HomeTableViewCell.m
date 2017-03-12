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
    _imgView.layer.cornerRadius = 6.0f;
    _imgView.layer.masksToBounds = YES;
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
    if (self.selected)
    {
        self.titleLabel.textColor = UIColorRGB(34, 34, 34, 0.498);
    }
    else
    {
        self.titleLabel.textColor = UIColorRGB(34, 34, 34, 1);
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.images] placeholderImage:[UIImage imageNamed:@"wallpaper_profile"]];
    
}


@end
