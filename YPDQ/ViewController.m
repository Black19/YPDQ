//
//  ViewController.m
//  YPDQ
//
//  Created by 何浩 on 15/6/12.
//  Copyright (c) 2015年 何浩. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _mySearchBar.delegate = self;
    _searchResultTable.delegate = self;
    _searchResultTable.dataSource = self;
    [self.searchResultTable setHidden:YES];
    _searchResultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchResultTable.rowHeight = 150;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)test:(NSNotification *)notification{
    id obj = [notification object];
    NSLog(@"%@",obj);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keywords =_mySearchBar.text;
    if (keywords == nil) {
        keywords = @"健康";
    }
    NSString *httpUrl = @"http://apis.baidu.com/yi18/medicine/search";
    NSString *httpArg = @"page=1&limit=10&keyword=";
    httpArg = [httpArg stringByAppendingString:keywords];
    [self request:httpUrl withHttpArg:httpArg];
    [searchBar resignFirstResponder];
//    SearchResultController *searchResult = [[SearchResultController alloc]init];
//    searchResult.keys = keywords;
//    [self presentViewController:searchResult animated:YES completion:nil];
   // httpArg = [httpArg stringByAppendingString:keywords];
   // APIData *data = [[APIData alloc]init];
    //[data request:httpUrl withHttpArg:httpArg];
   // NSLog(@"%@",keywords);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"tableviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    UILabel *contont = (UILabel *) [cell viewWithTag:201];
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:202];
    if ([_imgurl count] != 0) {
        NSString* filePath =  [NSString stringWithFormat:@"http://www.yi18.net/%@",[_imgurl objectAtIndex:indexPath.row]];
        
        NSData *images = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
        if(images!=nil){
            [img setImage:[UIImage imageWithData:images]];
        }
    }
    
    
    if ([_contents count] !=0) {
        contont.text = [NSString stringWithFormat:@"%@",[_contents objectAtIndex:indexPath.row]];
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
        NSMutableArray *contents = [[NSMutableArray alloc] init];
        NSMutableArray *imgurl = [[NSMutableArray alloc] init];
        for (int i=0; i<[[self datas] count]; i++) {
            NSDictionary *data =  [_datas objectAtIndex:i];
            NSLog(@"%@",[data objectForKey:@"img"]);
            NSString* cont = [Utils flattenHTML:[data objectForKey:@"title"] trimWhiteSpace:YES];
            [imgurl addObject:[data objectForKey:@"img"]];
            [contents addObject:cont];

        }
        self.imgurl = imgurl;
        self.contents = contents;
        [[self searchResultTable] reloadData];
        [self.searchResultTable setHidden:NO];

    }
}

@end
