//
//  RecordCell.m
//  PhoneDemo
//
//  Created by czzz on 15/8/7.
//  Copyright (c) 2015年 czzz. All rights reserved.
//

#import "RecordCell.h"
#import "Record.h"
@implementation RecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    style = UITableViewCellStyleSubtitle;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)setRecord:(Record *)record
{
    _record = record;
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    });

    self.textLabel.text = record.name;
    self.detailTextLabel.text = [formatter stringFromDate:record.createAt];
    
    // 如果是未接来电，用红色字体展示
    self.textLabel.textColor = record.isMissed ? [UIColor redColor] : [UIColor blackColor];
}

@end
