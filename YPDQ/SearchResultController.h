//
//  SearchResultController.h
//  YPDQ
//
//  Created by 何浩 on 15/6/22.
//  Copyright (c) 2015年 何浩. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SearchResultController : UIViewController
@property (nonatomic,weak) NSString* keys;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;
//获取数据
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;
//把获取的json解析成字典
-(void)analytical:(NSString*)responseString;
@property  NSMutableArray* datas;

@end
