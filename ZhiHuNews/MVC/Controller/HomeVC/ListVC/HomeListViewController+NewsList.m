//
//  HomeListViewController+NewsList.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/9.
//  Copyright © 2017年 陈鑫. All rights reserved.
//  Height 92

#import "HomeListViewController+NewsList.h"
#import "HomeTableViewCell.h"
#import "DetailViewController.h"

@implementation HomeListViewController (NewsList)


- (NSInteger)n_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrMiddle.count;
    
}

- (UITableViewCell *)n_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:nil][0];
    }
    cell.model = self.dataArrMiddle[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)n_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = UIColorRGB(34, 34, 34, 0.498);
    
    HomeModel_NewsList *hModel = cell.model;
    
    DetailViewController *detailVC = [[DetailViewController alloc] initWithtag:hModel.id_n];
    NSLog(@"SELF NAV IS %@",self.navigationController);
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
}


@end
