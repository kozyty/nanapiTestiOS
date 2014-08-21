//
//  MapViewController.m
//  nanapiTestiOS
//
//  Created by kozyty on 2014/08/21.
//  Copyright (c) 2014年 nanapi Inc. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

#define kLatitudeShibuya 35.658987
#define kLongitudeShibuya 139.702776
#define kLatitudeRoppongi 35.665213
#define kLongitudeRoppongi 139.730011

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// 参考: http://qiita.com/fizzco/items/0a39c649eafd6b2ab735
    // 位置情報を作成（現在地：渋谷）
    CLLocationCoordinate2D fromCoordinate = CLLocationCoordinate2DMake(kLatitudeShibuya, kLongitudeShibuya);
    
    // 位置情報を作成（目的地：六本木）
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(kLatitudeRoppongi, kLongitudeRoppongi);
    
    // 位置情報を元に、100m四方で表示
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromCoordinate, 5000, 5000);
    [self.mapView setRegion:region];

    // デリゲート設定
    [self.mapView setDelegate:self];
    
    // ビルなどの表示
    [self.mapView setShowsBuildings:YES];
    
    // 目印になる建造物の表示
    [self.mapView setShowsPointsOfInterest:YES];
    
    // ユーザーの現在地表示プロパティ（シュミレーターでは正常に動かない)
    [self.mapView setShowsUserLocation:YES];
    
    
    /// 参考: http://qiita.com/koogawa/items/d047a8056a0db5b05771
    // CLLocationCoordinate2D から MKPlacemark を生成
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    
    // MKPlacemark から MKMapItem を生成
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    // MKMapItem をセットして MKDirectionsRequest を生成
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;
    
    // MKDirectionsRequest から MKDirections を生成
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 経路検索を実行
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) return;
         
         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];
             NSLog(@"distance: %.2f meter", route.distance);
             
             // 地図上にルートを描画
             [self.mapView addOverlay:route.polyline];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 地図上に描画するルートの色などを指定（これを実装しないと何も表示されない）
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 5.0;
        routeRenderer.strokeColor = [UIColor redColor];
        return routeRenderer;
    }
    else {
        return nil;
    }
}

@end
