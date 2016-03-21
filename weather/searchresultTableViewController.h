//
//  searchresultTableViewController.h
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchresultTableViewController : UITableViewController
@property(nonatomic,copy) NSString *searchtext;
@property(nonatomic,strong) NSArray *citiesArray;

@end
