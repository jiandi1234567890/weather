//
//  ViewController.m
//  weather
//
//  Created by 张海禄 on 16/3/10.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "ViewController.h"
#import "cityGroups.h"
#import "cities.h"
#import "citychoseViewController.h"
#import "searchresultTableViewController.h"


#import <CoreLocation/CoreLocation.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<CLLocationManagerDelegate>{
    NSString *cityid;}

//设置gps管理者为全局
@property(nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,strong)NSString *httpUrl;
@property(nonatomic,strong)NSString *httpArg;
@property(nonatomic,strong) NSString *showweather;

@end

@implementation ViewController

int i=0;

#pragma mark -- manager懒加载

-(CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}


//移除观察者
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
    reflash=[UIButton buttonWithType:UIButtonTypeSystem];
    reflash.frame=CGRectMake(20, 370, 150, 30);
    reflash.backgroundColor=[UIColor redColor];
    [reflash setTitle:@"重新获取GPS位置" forState:UIControlStateNormal];
    [reflash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reflash addTarget:self action:@selector(reflashClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reflash];
    
    
    
    labellocation=[[UILabel alloc]init];
    labellocation.frame=CGRectMake(20, 300, 230, 50);
    labellocation.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    // labellocation.textColor=[UIColor whiteColor];
    labellocation.layer.cornerRadius=10;
    labellocation.layer.masksToBounds=true;
    labellocation.lineBreakMode=NSLineBreakByCharWrapping;
    labellocation.numberOfLines=0;
    //labellocation.font=[UIFont systemFontOfSize:23];
    [self.view addSubview:labellocation];
    
    
    
    
    
    
    //天气显示框
    labelweather=[[UILabel alloc]init];
    labelweather.frame=CGRectMake(30, 30, ScreenWidth-60, ScreenHeight/3);
    labelweather.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];;
    //labelweather.textColor=[UIColor blackColor];
    labelweather.layer.cornerRadius=10;
    labelweather.layer.masksToBounds=true;
    labelweather.lineBreakMode=NSLineBreakByCharWrapping;
    labelweather.numberOfLines=0;
    //labelweather.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:labelweather];
    
    
    
    
    //城市选择按键
    citychose=[UIButton buttonWithType:UIButtonTypeSystem];
    citychose.frame=CGRectMake(200, 370, 100, 30);
    citychose.backgroundColor=[UIColor blueColor];
    [citychose setTitle:@"城市切换" forState:UIControlStateNormal];
    [citychose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [citychose addTarget:self  action:@selector(citychoseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:citychose];
    
    
    
    
    //通知中心传值，添加观察者,记得要移除掉
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(citychange:) name:@"citychange" object:nil];
    
    
    
    //网络数据请求的url
    
    _httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    
    cityid=@"福州";
    NSString *string1=@"city=";
    NSString *arg=[string1 stringByAppendingString:cityid];
    //NSString *arg=@"city=福州";
    // _httpArg = @"city=fuzhou";
    //将数据中的中文转换下，url不允许中文出现
    // _httpArg=[arg stringByAppending:；
    // _httpArg= [arg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//这个有告警，用下面那个
    
    _httpArg= [arg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self request: _httpUrl withHttpArg: _httpArg];//请求数据
    
    
    NSLog(@"%@",_httpArg);
    
    
    //1、创建CoreLocation的管理者：manager
    
    //2、成为Corelocation管理者的代理，监听位置的获取
    
    
    self.manager.delegate = self;
    
    /*
     iOS 7 只要开始定位，系统就会自动要求用户对你的应用程序授权，但是从iOS8开始，想要定位必须先主动请求
     在iOS8中不仅仅需要自动请求，还需要在info.list中配置属性才能弹出窗口授权
     
     NSLocationWhenInUserDescription    允许在前台获取GPS描述
     NSLocationAlwaysInUserDescription  允许在后台获取GPS描述
     */
    
    //2.1、 判断是不是iOS8
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        NSLog(@"8.0+");
        
        //一授权成功就会改变通知代理
        [self.manager requestAlwaysAuthorization]; // 请求前台和后台定位权限
        //[self.manager requestWhenInUseAuthorization]; // 请求前台定位权限
    }
    else
    {
        NSLog(@"7.0-");
        [self.manager startUpdatingLocation];
    }
    //距离超过1000米重新再定位
    self.manager.distanceFilter = 10000;
    //定位精度
    //self.manager.desiredAccuracy=kCLLocationAccuracyBest;
    //3、开始监听
    
    
}



-(void)citychange:(NSNotification  *)notice
{
    
    
    NSString *city=notice.userInfo;
    _httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    cityid=city;
    NSString *string1=@"city=";
    NSString *arg=[string1 stringByAppendingString:cityid];
    
    _httpArg= [arg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self request: _httpUrl withHttpArg: _httpArg];//请求数据
    
    
}





-(void)reflashClick
{
    i=0;
    [self.manager startUpdatingLocation];
    
}



#pragma mark -- 城市切换按键
//城市选择

-(void)citychoseClick
{
    
    citychoseViewController *citychoseVC=[[citychoseViewController alloc] initWithNibName:@"citychoseViewController" bundle:nil];
    //模态弹窗的显示格式只有在ipad上有效，在iphone上始终是全屏
    //citychoseVC.modalPresentationStyle=UIModalPresentationFormSheet;
    
    [self presentViewController:citychoseVC animated:YES completion:nil];
    
    
}


#pragma mark -- CoreLocation Delegate

/**
 *  授权状态改变的时候会被调用
 *
 *  @param manager 调用者
 *  @param status  调用的状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    // CLAuthorizationStatus
    /*
     用户从未选择过权限
     kCLAuthorizationStatusNotDetermined
     
     无法使用定位服务，该状态用户无法改变
     kCLAuthorizationStatusRestricted
     
     用户拒绝该应用使用定位服务，或是定位服务总开关处于关闭状态
     kCLAuthorizationStatusDenied
     
     已经授权（废弃）
     kCLAuthorizationStatusAuthorized
     
     用户允许该程序无论何时都可以使用地理信息
     kCLAuthorizationStatusAuthorizedAlways
     
     用户同意程序在可见时使用地理位置
     kCLAuthorizationStatusAuthorizedWhenInUse*/
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"授权成功");
        
        [self.manager startUpdatingLocation];
        
    }
    else if(status == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"等待用户授权");
    }
    else{
        NSLog(@"授权失败");
    }
}

/**
 *  获取到位置信息之后就会去调用（如果不做控制会频繁调用，浪费电量）
 *
 *  @param manager   调用者
 *  @param locations 获取到的地理位置信息
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
    NSLog(@"%s",__func__);
    
    if (i>4) {
        i=5;
        [self.manager stopUpdatingLocation];    }
    else i++;
    //打印经纬度
    
    
    CLLocation *local = [locations lastObject];
    NSString *latitude=[NSString stringWithFormat:@"%f",local.coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",local.coordinate.longitude];
    NSString *count=[NSString stringWithFormat:@"%d",i];
    NSString *location=[NSString stringWithFormat:@"纬度：%@\n经度：%@    %@次",latitude,longitude,count];
    NSLog(@"%f,%f,%u",local.coordinate.latitude,local.coordinate.longitude,i);
    
    labellocation.text=location;
    
}







//网络请求天气api并json解析返回的数据

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    
    //经行网络请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"您自己的api" forHTTPHeaderField: @"apikey"];
    // queue ：存放completionHandler这个任务
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               
                               
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                   
                               } else {
                                   // 解析服务器返回的JSON数据
                                   
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data    options:NSJSONReadingMutableContainers error:nil];
                                   
                                   
                                   
                                   NSArray *city=[dict objectForKey:@"HeWeather data service 3.0"];
                                   
                                   //该数组只有一个值，这个值里包含了所有的字典
                                   
                                   NSDictionary *city2=[city objectAtIndex:0];
                                   
                                   NSDictionary *basic=[city2 objectForKey:@"suggestion"];
                                   NSDictionary *comf=[basic objectForKey:@"comf"];
                                   //舒适度描述
                                   NSString *comftxt=[comf objectForKey:@"txt"];
                                   
                                   NSDictionary *now=[city2 objectForKey:@"now"];
                                   //气温
                                   NSString *tmp=[now objectForKey:@"tmp"];
                                   
                                   
                                   //天气晴雨情况
                                   NSArray *daily_forecast=[city2 objectForKey:@"daily_forecast"];
                                   NSDictionary *qingyu=[daily_forecast objectAtIndex:0];
                                   NSDictionary *cond=[qingyu objectForKey:@"cond"];
                                   NSString  *txt_d=[cond objectForKey:@"txt_d"];
                                   
                                   //空气质量
                                   NSDictionary *aqi=[city2 objectForKey:@"aqi"];
                                   NSDictionary *city3=[aqi objectForKey:@"city"];
                                   NSString *qlty=[city3 objectForKey:@"qlty"];
                                   
                                   
                                   NSString *cityweather=[NSString stringWithFormat:@"           %@\n气温：%@°C\n天气：%@\n空气质量：%@\n%@",cityid,tmp,txt_d,qlty,comftxt];
                                                                      NSLog(@"%@",city3);
                                   
                                   
                                   labelweather.text=cityweather;
                                   
                                   
                                   NSLog(@"%@",labelweather.text);
                                   
                                   
                               }
                               
                           }];
    
}



//// 3.发送用户名和密码给服务器(走HTTP协议)
//// 创建一个URL ： 请求路径
//NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/Server/login?username=%@&pwd=%@",usernameText, pwdText];
//NSURL *url = [NSURL URLWithString:urlStr];
//
//// 创建一个请求
//NSURLRequest *request = [NSURLRequest requestWithURL:url];
////    NSLog(@"begin---");

//// 发送一个同步请求(在主线程发送请求)
//// queue ：存放completionHandler这个任务
//NSOperationQueue *queue = [NSOperationQueue mainQueue];
//[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
// ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//     // 这个block会在请求完毕的时候自动调用
//     if (connectionError || data == nil) {
//         [MBProgressHUD showError:@"请求失败"];
//         return;
//     }
//
//     // 解析服务器返回的JSON数据
//     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//     NSString *error = dict[@"error"];
//     if (error) {
//         // {"error":"用户名不存在"}
//         // {"error":"密码不正确"}
//         [MBProgressHUD showError:error];
//     } else {
//         // {"success":"登录成功"}
//         NSString *success = dict[@"success"];
//         [MBProgressHUD showSuccess:success];
//     }
// }];
//
////    NSLog(@"end---");
//}
//









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
