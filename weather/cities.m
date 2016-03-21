//
//  cities.m
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "cities.h"

@implementation cities


+(NSArray *)getCities
{
    
        NSString *path=[[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil];
   
    NSArray *plistArray=[NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *citiesArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in plistArray) {
        cities *model=[[cities alloc]init];
        
        model.name=[dict objectForKey:@"name"];
        model.pinYin=[dict objectForKey:@"pinYin"];
        model.pinYinHead=[dict objectForKey:@"pinYinHead"];
        model.regions=[dict objectForKey:@"regions"];
        [citiesArray addObject:model];
        
    }
    
    return citiesArray;

}

@end
