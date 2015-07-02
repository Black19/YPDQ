//
//  YpClassController.m
//  YPDQ
//
//  Created by 何浩 on 15/6/15.
//  Copyright (c) 2015年 何浩. All rights reserved.
//

#import "YpClassController.h"
@interface YpClassController()
<UITableViewDelegate,UITableViewDataSource>
@end


@implementation YpClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    //APIData *myData = [[APIData alloc] init];
    NSString *httpUrl = @"http://apis.baidu.com/yi18/medicine/class";
    NSString *httpArg = @"id=4&title=水电解质及酸碱";
    [self request:httpUrl withHttpArg:httpArg];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *ypClassName = (UILabel *)[cell viewWithTag:101] ;
    UILabel *ypClassNameId = (UILabel *)[cell viewWithTag:102] ;
    ypClassNameId.text = [NSString stringWithFormat:@"%@",[self.keys objectAtIndex:indexPath.row]];

    ypClassName.text = [NSString stringWithFormat:@"%@",[self.data objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSString *ids = [self.keys objectAtIndex:[indexPath row]];
//    NSString *httpUrl = @"http://apis.baidu.com/yi18/medicine/list";
//    NSString *httpArg = @"page=1&limit=10&type=id&id=";
//    httpArg = [httpArg stringByAppendingString:ids];
//    APIData *myData = [[APIData alloc] init];
//    [myData request:httpUrl withHttpArg:httpArg];
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:@"哈哈" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
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
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   [self analytical:responseString];
                                   NSLog(@"HttpResponseCode:%ld", (long)responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
}

-(void)analytical:(NSString*)responseString{
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (json == nil) {
        NSLog(@"解析错误");
    }else{
        NSMutableArray *key =[[NSMutableArray alloc]init];
        NSMutableArray *values =[[NSMutableArray alloc]init];
        NSArray *dic1 = [json objectForKey:@"yi18"];
        for (int i=0; i<[dic1 count]; i++) {
            NSMutableDictionary *ypClassData = [dic1 objectAtIndex:i];
            [key addObject:[ypClassData objectForKey:@"id"]];
            [values addObject:[ypClassData objectForKey:@"title"]];
            NSLog(@"%@",[ypClassData objectForKey:@"id"]);
            NSLog(@"%@",[ypClassData objectForKey:@"title"]);
            
        }
        self.keys = key;
        self.data = values;
        [self.myTableView reloadData];
    }
}

@end