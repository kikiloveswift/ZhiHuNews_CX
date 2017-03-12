//
//  HomeViewController+NewsList.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//  Height 92

#import "HomeViewController+NewsList.h"
#import "HomeTableViewCell.h"

@implementation HomeViewController (NewsList)


- (NSInteger)n_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mTableView)
    {
        return self.dataArrMiddle.count;
    }
    else if(tableView == self.lTableView)
    {
        return self.dataArrLeft.count;
    }
    else if(tableView == self.rTableView)
    {
        return self.dataArrRight.count;
    }
    return 0;
}

- (UITableViewCell *)n_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArr;
    if (tableView == self.mTableView)
    {
        dataArr = self.dataArrMiddle;
    }
    else if(tableView == self.lTableView)
    {
        dataArr = self.dataArrLeft;
    }
    else if(tableView == self.rTableView)
    {
        dataArr = self.dataArrRight;
    }
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:nil][0];
    }
    cell.model = dataArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)n_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = UIColorRGB(34, 34, 34, 0.498);
}


@end
