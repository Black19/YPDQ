//
//  YpClassController.h
//  YPDQ
//
//  Created by 何浩 on 15/6/15.
//  Copyright (c) 2015年 何浩. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface  YpClassController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property NSMutableArray *data;
@property NSMutableArray *keys;
//获取数据
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;
//把获取的json解析成字典
-(void)analytical:(NSString*)responseString;
@end
