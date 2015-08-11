//
//  Record.h
//  PhoneDemo
//
//  Created by czzz on 15/8/7.
//  Copyright (c) 2015年 czzz. All rights reserved.
//  存放通话记录的模型

#import <Foundation/Foundation.h>

@interface Record : NSObject
/**姓名*/
@property (nonatomic,copy) NSString *name;
/**电话号码*/
@property (nonatomic,copy) NSString *phoneNum;
/**是否是未接电话*/
@property (nonatomic,assign,getter=isMissed) BOOL missed;
/**通话创建时间*/
@property (nonatomic,strong) NSDate *createAt;

@end
