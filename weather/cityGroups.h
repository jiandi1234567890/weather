//
//  cityGroups.h
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityGroups : NSObject
//属性的声明，cityGroups.plist 中有两个属性 一个是title字符串 一个是cities数组
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSArray *cities;

-(NSArray *)getModelArray;

@end
