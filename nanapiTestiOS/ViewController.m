//
//  ViewController.m
//  nanapiTestiOS
//
//  Created by kozyty on 2014/08/19.
//  Copyright (c) 2014年 nanapi Inc. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *nanapiList;

@end

#define NANAPI_API_URL @"http://api.nanapi.jp/v1/recipeSearchDetails/?key=4b542e23e43f6&format=json&query=%E3%82%B5%E3%82%A4%E3%82%AF%E3%83%AA%E3%83%B3%E3%82%B0%20%E8%87%AA%E8%BB%A2%E8%BB%8A%20%E3%83%90%E3%82%A4%E3%82%AF"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // デリゲート初期化
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // JSONの取得コール
    [self getJson];
}

- (void)getJson
{
    NSURL *url = [NSURL URLWithString:NANAPI_API_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // JSON形式のデータをNSDictへ
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // リスト管理するプロパティへ挿入
        self.nanapiList = [[dict objectForKey:@"response"] objectForKey:@"recipes"];
        
        // データ取得後テーブルを再描画
        [self.tableView reloadData];
    }];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 表示は3件のみ
    return 3.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // セクションはいらない
    return 1.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *recipe = [self.nanapiList objectAtIndex:indexPath.row];
    cell.textLabel.text = [recipe objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
