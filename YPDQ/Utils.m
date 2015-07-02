//
//  Utils.m
//  YPDQ
//
//  Created by 何浩 on 15/7/2.
//  Copyright (c) 2015年 何浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
@interface Utils()

@end;
@implementation Utils

+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim{
    　　NSScanner *theScanner = [NSScanner scannerWithString:html];
    　　NSString *text = nil;
    　　while ([theScanner isAtEnd] == NO) {
        　　// find start of tag
        　　[theScanner scanUpToString:@"<" intoString:NULL] ;
        　　// find end of tag
        　　[theScanner scanUpToString:@">" intoString:&text] ;
        　　// replace the found tag with a space
        　　//(you can filter multi-spaces out later if you wish)
        　　html = [html stringByReplacingOccurrencesOfString:
                  　　[ NSString stringWithFormat:@"%@>", text]
                  　　withString:@""];
        　　}
    　　return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
    　　}

@end