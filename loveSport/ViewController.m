//
//  ViewController.m
//  loveSport
//
//  Created by mac on 2017/4/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "MovingAnnotationViewController.h"
#import "CustomAnnotationViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation ViewController
- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView = tableView;
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.定义一个重用标识
    static NSString *ID = @"cell";
    // 1.去缓存池中找可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 2.如果缓存池中没有可循环利用的cell,自己创建
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 3.设置数据
    if (indexPath.row == 0) {
        cell.textLabel.text = @"点平滑移动";
    }else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"自定义大头针以及泡泡View";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [self.navigationController pushViewController:[MovingAnnotationViewController new] animated:YES];
    }else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[CustomAnnotationViewController new] animated:YES];
    }
}

@end
