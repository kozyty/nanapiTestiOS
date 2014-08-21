//
//  MapViewController.h
//  nanapiTestiOS
//
//  Created by kozyty on 2014/08/21.
//  Copyright (c) 2014年 nanapi Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
