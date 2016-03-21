//
//  cities.h
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cities : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *pinYin;
@property(nonatomic,copy) NSString *pinYinHead;
@property(nonatomic,strong) NSArray *regions;

+(NSArray *)getCities;

@end
