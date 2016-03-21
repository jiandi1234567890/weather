//
//  cityGroups.m
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "cityGroups.h"

@implementation cityGroups{NSArray *plistArray;}

-(instancetype)init
{
    if(self=[super init])
  {
    [self getplist];
  }
    return self;
}
//得到plist文件路径并转成数组
-(void) getplist{

    NSString *path=[[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
    
    plistArray=[NSArray arrayWithContentsOfFile:path];

}


-(NSArray *)getModelArray{
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    for(NSDictionary *dict in plistArray)
    {
        cityGroups *modle=[[cityGroups alloc] init];
        modle.title=[dict objectForKey:@"title"];
        modle.cities=[dict objectForKey:@"cities"];
        [dataArray addObject:modle];
    }
    
    return dataArray;

}




@end
