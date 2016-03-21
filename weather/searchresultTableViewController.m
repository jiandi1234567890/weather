//
//  searchresultTableViewController.m
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "searchresultTableViewController.h"
#import "cities.h"
#import "ViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface searchresultTableViewController ()
@property(nonatomic,strong) NSMutableArray *searchcityresult;

@end

@implementation searchresultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame=CGRectMake(0, 70, ScreenWidth, ScreenHeight-70);
    
}



-(void)setSearchtext:(NSString *)searchtext
{
    
    //将传递过来的值全部转成小写
     _searchtext=[searchtext lowercaseString];
    NSLog(@"%@",_searchtext);
    //获取城市数组
    if (!_citiesArray) {
        _citiesArray=[cities getCities];
    }
    
    _searchcityresult=[[NSMutableArray alloc]init];
    
    //调用模型遍历获得数组，并将结果赋值给搜所结果数组
    
    for (cities *city in _citiesArray) {
        if ([city.name containsString:_searchtext]||[city.pinYin containsString:_searchtext]||[city.pinYinHead containsString:_searchtext])
        {
            
            [_searchcityresult addObject:city];
            
        }
    }
    //当输入有变化时，重新加载数组显示
    [self.tableView reloadData];
   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
  
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _searchcityresult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellidentifier=@"searchresultcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
               }
    
 
       cities *model=[_searchcityresult objectAtIndex:indexPath.row];
       cell.textLabel.text=model.name;
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [self.view endEditing:YES];
    cities *model=[_searchcityresult objectAtIndex:indexPath.row];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"citychange" object:nil  userInfo:model.name];
    
//    ViewController   *mainVC=[[ViewController alloc]init];
//    
//    mainVC.citychose2=model.name;
    
    [self dismissViewControllerAnimated:YES completion:nil];


}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
