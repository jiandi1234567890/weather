//
//  citychoseViewController.m
//  weather
//
//  Created by 张海禄 on 16/3/18.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "citychoseViewController.h"
#import "cityGroups.h"
#import "searchresultTableViewController.h"
#import "ViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface citychoseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *cityArray;
    UIView  *viewtohide;
    UISearchBar *searchcity;

    searchresultTableViewController *searchresultVC;
    ViewController *mainVC;
}


@end

@implementation citychoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
   //新建城市选择界面的搜索框
    searchcity=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 50)];
    searchcity.placeholder=@"请输入要搜索的城市";
    searchcity.delegate=self;
    [self.view addSubview:searchcity];
    


    //新建城市选择的tableview
    UITableView *citylist=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenHeight-70) style:UITableViewStylePlain];
    citylist.delegate=self;
    citylist.dataSource=self;
    [self.view addSubview:citylist];
    
   
    
    //新建一个view用于在搜索框时遮盖tableview,需要放在tableview的上层，这样将它的hidden属性设置为no时才能遮盖tableView
    viewtohide=[[UIView alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenHeight-70)];
    viewtohide.backgroundColor=[UIColor blackColor];
    viewtohide.alpha=0.6;
    viewtohide.hidden=YES;
    [self.view addSubview:viewtohide];
    
  
    
    
    //获取城市列表的数据源
    cityGroups *modle=[[cityGroups alloc]init];
    cityArray=[modle getModelArray];

    
    
}


#pragma mark _UITableViewDataSource
//总共有多少组

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cityArray.count;
}

//设置标题头名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //获取城市列表的数据源

    cityGroups *model=[cityArray objectAtIndex:section];
    
    return model.title;

}

//每个分组里总共有多少行数，分组里的子行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[cityArray objectAtIndex:section] cities].count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
        
        }
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    //获取城市列表的数据
        cityGroups *model=[cityArray objectAtIndex:indexPath.section];
    
    cell.textLabel.text=model.cities[indexPath.row];
   
    
    return cell;
}

#pragma  mark -UITableViewDelegate
//点击tableview的反选的事件
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}




//点击tableView的相应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
     [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"已选择城市");
    cityGroups *model=[cityArray objectAtIndex:indexPath.section];

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"citychange" object:nil userInfo:model.cities[indexPath.row]];
    


}



#pragma mark -UISearchBarDelegate
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
       viewtohide.hidden=NO;

}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

        viewtohide.hidden=YES;
    
   
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        [self searchresultVC];
        searchresultVC.view.hidden=NO;
        searchresultVC.searchtext=searchText;
        NSLog(@"输入文字%@",searchText);
    }else {
    
    searchresultVC.view.hidden=YES;
    
    
    }

}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}



#pragma mark -懒加载创建搜索结果界面
-(searchresultTableViewController *)searchresultVC{
    
    if (!searchresultVC) {
        searchresultVC=[[searchresultTableViewController alloc]init];
        
        [self.view addSubview:searchresultVC.view];
        
       [self addChildViewController:searchresultVC];
        
        
    }

    
    return searchresultVC;
}



//







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
