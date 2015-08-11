//
//  ViewController.m
//  PhoneDemo
//
//  Created by czzz on 15/8/7.
//  Copyright (c) 2015年 czzz. All rights reserved.
//

#import "ViewController.h"
#import "RecordCell.h"
#import "Record.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
/**所有通话记录*/
@property (nonatomic,strong) NSArray *allRecords;
/**存放展示的通话记录*/
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ViewController

#pragma mark - 懒加载
- (NSArray *)allRecords
{
    if (!_allRecords) {
        [self creatRecord];
    }
    return _allRecords;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"所有通话",@"未接电话"]];
    [segmentedControl addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[RecordCell class] forCellReuseIdentifier:@"record"];
    [self.view addSubview:self.tableView];
    
    [segmentedControl setSelectedSegmentIndex:0];
    [self changeData:segmentedControl];
}

/**在这里面切换数据*/
- (void)changeData:(UISegmentedControl *)seg
{
    
    RecentsType type = seg.selectedSegmentIndex;
    switch (type) {
        case RecentsTypeAll:
        {
            [self.dataArray removeAllObjects];
            for (Record *rec in self.allRecords) {
                [self.dataArray addObject:rec];
            }
            
            [self.tableView reloadData];

            [UIView animateWithDuration:0.25 animations:^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }];
            
            break;
        }
            
        case RecentsTypeMissed:
        {
            [self.dataArray removeAllObjects];
            for (Record *rec in self.allRecords) {
                
                if (rec.isMissed) {
                    [self.dataArray addObject:rec];
                }
                
            }
            [self.tableView reloadData];
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
            }];
            
            break;
        }
        default:
            break;
    }
    
    
}

// 创建数据
- (void)creatRecord
{
    NSArray *nameArr = @[@"小明",@"小红",@"小丽",@"小翠",@"虎头"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 50; ++i) {
        Record *record = [[Record alloc] init];
        int randomInt = arc4random() % 10 + 1;
        int randomPhone = arc4random() % (119 - 110) + 110;
        NSString *name = [NSString stringWithFormat:@"%@%d",nameArr[i % nameArr.count],randomInt];
        record.name = name;
        record.phoneNum = [NSString stringWithFormat:@"%d",randomPhone];
        record.missed = randomInt % 2;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:random()];
        record.createAt = date;
        [arr addObject:record];
    }
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Record *record1 = (Record *)obj1;
        Record *record2 = (Record *)obj2;
        return [record2.createAt compare:record1.createAt];
    }];
   
    self.allRecords = arr;
    
    [self.tableView reloadData];
    
}
#pragma mark -tableView 数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"record";
    
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.record = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 取模型
    Record *record = self.dataArray[indexPath.row];
    
    // 打电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",record.phoneNum]]];
    
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
