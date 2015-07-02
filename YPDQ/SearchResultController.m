//
//  SearchResultController.m
//  YPDQ
//
//  Created by 何浩 on 15/6/22.
//  Copyright (c) 2015年 何浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultController.h"
@interface SearchResultController()
<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchResultController


- (void)viewDidLoad {
    [super viewDidLoad];
        NSString *httpUrl = @"http://apis.baidu.com/yi18/medicine/search";
        NSString *httpArg = @"page=1&limit=10&keyword=";
    _keys = @"健康";
    httpArg = [httpArg stringByAppendingString:[self keys]];
    [self request:httpUrl withHttpArg:httpArg];
    _searchResultTable.delegate = self;
    _searchResultTable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *contont = (UILabel *) [cell viewWithTag:201];
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    NSMutableArray *imgurl = [[NSMutableArray alloc] init];
    for (int i=0; i<[[self datas] count]; i++) {
        NSDictionary *data =  [_datas objectAtIndex:i];
        NSLog(@"%@",[data objectForKey:@"img"]);
      //  NSString *nsContent = [data objectForKey:@"content"];
        //[_imageUrl addObjectsFromArray:[data objectForKey:@"img"]] ];
        [imgurl addObject:[data objectForKey:@"img"]];
        [contents addObject:[data objectForKey:@"title"]];
       
    }
    UIImageView *img = (UIImageView *)[cell viewWithTag:202];
    if ([imgurl count] != 0) {
        NSString* filePath =  [NSString stringWithFormat:@"http://www.yi18.net/%@",[imgurl objectAtIndex:indexPath.row]];
        
        NSData *images = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
        if(images!=nil){
            [img setImage:[UIImage imageWithData:images]];
        }
    }


    if ([contents count] !=0) {
        contont.text = [NSString stringWithFormat:@"%@",[contents objectAtIndex:indexPath.row]];
    }
       return cell;
}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSString *myUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:myUrlStr];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"5ce9317fda88d9a85ff70dba44b0ccbb" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                               } else {
//                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   [self analytical:responseString];
//                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
//                                   NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
}
-(void)analytical:(NSString*)responseString{
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (json == nil) {
        NSLog(@"解析错误");
    }else{
      self.datas = [json objectForKey:@"yi18"];
     [[self searchResultTable] reloadData];
    }
}

@end