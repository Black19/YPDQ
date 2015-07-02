//
//  ViewController.h
//  YPDQ
//
//  Created by 何浩 on 15/6/12.
//  Copyright (c) 2015年 何浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTable;
-(void)test:(NSNotification*)notification;
//获取数据
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;
//把获取的json解析成字典
-(void)analytical:(NSString*)responseString;
@property  NSMutableArray* datas;
@property NSMutableArray* imgurl;
@property NSMutableArray* contents;
@end

