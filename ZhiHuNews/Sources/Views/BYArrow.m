//
//  SelectionButton.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
// common_button_white

#import "BYArrow.h"

@implementation BYArrow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"Arrow.png"] forState:0];
        [self setImage:[UIImage imageNamed:@"Arrow.png"] forState:1<<0];
        self.backgroundColor = UIColorRGB(238.0, 238.0, 238.0,0.9);
        [self addTarget:self
                 action:@selector(ArrowClick)
       forControlEvents:1 << 6];
    }
    return self;
}

-(void)ArrowClick{
    if (self.arrowBtnClick) {
        self.arrowBtnClick();
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageSize = 18;
    return CGRectMake((contentRect.size.width-imageSize)/2, (30-imageSize)/2, imageSize, imageSize);
}

@end
