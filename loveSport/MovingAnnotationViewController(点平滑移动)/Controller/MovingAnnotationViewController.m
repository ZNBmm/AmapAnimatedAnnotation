//
//  MovingAnnotationViewController.m
//  loveSport
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MovingAnnotationViewController.h"

@interface MovingAnnotationViewController ()<MAMapViewDelegate>
{
    CLLocationCoordinate2D coords1[1];
}
@property (strong, nonatomic) NSArray *dataArr;
///地图
@property (nonatomic, strong) MAMapView *mapView;
///支持动画效果的点标注
@property (nonatomic, strong) MAAnimatedAnnotation* annotation;

@end

@implementation MovingAnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"anno.plist" ofType:nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@",dict[@"Data"]);
    self.dataArr = dict[@"Data"];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    
    
    //add overlay
    
    [self initCoordinates];
    
    MAAnimatedAnnotation *anno = [[MAAnimatedAnnotation alloc] init];
    anno.title = @"znb";
    anno.coordinate = coords1[0];
    self.annotation = anno;
    [self.mapView setSelectedAnnotations:@[anno]];
    [self.mapView addAnnotation:self.annotation];
    
    [self initButton];
}

- (void)initCoordinates {
    
    CLLocationCoordinate2D coords[self.dataArr.count];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSDictionary *dict= self.dataArr[i];
        if (i==0) {
            coords1[0].latitude = [dict[@"latitude"] doubleValue];
            coords1[0].longitude = [dict[@"longitude"] doubleValue];
        }
        coords[i].latitude = [dict[@"latitude"] doubleValue];
        coords[i].longitude = [dict[@"longitude"] doubleValue];
        
    }
    MAPolyline *polyline1 = [MAPolyline polylineWithCoordinates:coords count:sizeof(coords) / sizeof(coords[0])];
    [self.mapView addOverlays:@[polyline1]];
    
    
}

- (void)initButton
{
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(10, 100, 70,25);
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"Go" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(10, 150,70,25);
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"Stop" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)button1 {
    
    self.annotation.coordinate = coords1[0];
    MAAnimatedAnnotation *anno = self.annotation;
    CLLocationCoordinate2D coords[1];
    __weak __typeof(anno) WeakAnno = anno;
    NSDictionary *dict= self.dataArr[0];
    anno.title = dict[@"speed"];
    for (int i = 1; i < self.dataArr.count; i++) {
        NSDictionary *dict= self.dataArr[i];
        coords[0].latitude = [dict[@"latitude"] doubleValue];
        coords[0].longitude = [dict[@"longitude"] doubleValue];
        [anno addMoveAnimationWithKeyCoordinates:coords count:sizeof(coords) / sizeof(coords[0]) withDuration:.5 withName:nil completeCallback:^(BOOL isFinished) {
            WeakAnno.title = dict[@"speed"];
        }];
    }
    
    
    
}

- (void)button2 {
    for(MAAnnotationMoveAnimation *animation in [self.annotation allMoveAnimations]) {
        [animation cancel];
    }
    
    self.annotation.movingDirection = 0;
    self.annotation.coordinate = coords1[0];
}
#pragma mark - <MAMapViewDelegate>
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth    = 8.f;
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        return polylineRenderer;
        
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        NSString *pointReuseIndetifier = @"myReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
            
            UIImage *imge  =  [UIImage imageNamed:@"userPosition"];
            annotationView.image =  imge;
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = NO;
        annotationView.draggable                    = NO;
        annotationView.rightCalloutAccessoryView    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop"]];
        
        [annotationView setSelected:YES animated:NO];
        return annotationView;
    }
    
    return nil;
}
@end
