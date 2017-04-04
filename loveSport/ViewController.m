//
//  ViewController.m
//  loveSport
//
//  Created by mac on 2017/4/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
@interface ViewController ()<MAMapViewDelegate>
{
    CLLocationCoordinate2D coords1[5];
    CLLocationCoordinate2D coords2[6];
    CLLocationCoordinate2D coords3[10];//五角星
}

///地图
@property (nonatomic, strong) MAMapView *mapView;
///支持动画效果的点标注
@property (nonatomic, strong) MAAnimatedAnnotation* annotation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCoordinates];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    
    //add overlay
    MAPolyline *polyline1 = [MAPolyline polylineWithCoordinates:coords1 count:sizeof(coords1) / sizeof(coords1[0])];
    MAPolyline *polyline2 = [MAPolyline polylineWithCoordinates:coords2 count:sizeof(coords2) / sizeof(coords2[0])];
    MAPolyline *polyline3 = [MAPolyline polylineWithCoordinates:coords3 count:sizeof(coords3) / sizeof(coords3[0])];
    [self.mapView addOverlays:@[polyline1, polyline2, polyline3]];
    
    MAAnimatedAnnotation *anno = [[MAAnimatedAnnotation alloc] init];
    anno.title = @"znb";
    anno.coordinate = coords1[0];
    self.annotation = anno;
    
    [self.mapView addAnnotation:self.annotation];
    
    [self initButton];
}
- (void)initCoordinates {
    ///1
    coords1[0].latitude = 39.852136;
    coords1[0].longitude = 116.30095;
    
    coords1[1].latitude = 39.852136;
    coords1[1].longitude = 116.40095;
    
    coords1[2].latitude = 39.932136;
    coords1[2].longitude = 116.40095;
    
    coords1[3].latitude = 39.932136;
    coords1[3].longitude = 116.40095;
    
    coords1[4].latitude = 39.982136;
    coords1[4].longitude = 116.48095;
    
    ///2
    coords2[0].latitude = 39.982136;
    coords2[0].longitude = 116.48095;
    
    coords2[1].latitude = 39.832136;
    coords2[1].longitude = 116.42095;
    
    coords2[2].latitude = 39.902136;
    coords2[2].longitude = 116.42095;
    
    coords2[3].latitude = 39.902136;
    coords2[3].longitude = 116.44095;
    
    coords2[4].latitude = 39.932136;
    coords2[4].longitude = 116.44095;
    
    
    ///3
    [self generateStarPoints:coords3 pointsCount:10 atCenter:CLLocationCoordinate2DMake(39.800892, 116.293413)];//生成多角星的坐标
    
    coords2[5] = coords3[0];
}

- (void)initButton
{
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(10, 50, 70,25);
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"Go" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(10, 100,70,25);
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"Stop" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}
/*!
 @brief  生成多角星坐标
 @param coordinates 输出的多角星坐标数组指针。内存需在外申请，方法内不释放，多角星坐标结果输出。
 @param pointsCount 输出的多角星坐标数组元素个数。
 @param starCenter  多角星的中心点位置。
 */
- (void)generateStarPoints:(CLLocationCoordinate2D *)coordinates pointsCount:(NSUInteger)pointsCount atCenter:(CLLocationCoordinate2D)starCenter
{
#define STAR_RADIUS 0.05
#define PI 3.1415926
    NSUInteger starRaysCount = pointsCount / 2;
    for (int i =0; i<starRaysCount; i++)
    {
        float angle = 2.f*i/starRaysCount*PI;
        int index = 2 * i;
        coordinates[index].latitude = STAR_RADIUS* sin(angle) + starCenter.latitude;
        coordinates[index].longitude = STAR_RADIUS* cos(angle) + starCenter.longitude;
        
        index++;
        angle = angle + (float)1.f/starRaysCount*PI;
        coordinates[index].latitude = STAR_RADIUS/2.f* sin(angle) + starCenter.latitude;
        coordinates[index].longitude = STAR_RADIUS/2.f* cos(angle) + starCenter.longitude;
    }
}
- (void)button1 {
    self.annotation.coordinate = coords1[0];
    
    MAAnimatedAnnotation *anno = self.annotation;
    [anno addMoveAnimationWithKeyCoordinates:coords1 count:sizeof(coords1) / sizeof(coords1[0]) withDuration:2 withName:nil completeCallback:^(BOOL isFinished) {
    }];
    
    [anno addMoveAnimationWithKeyCoordinates:coords2 count:sizeof(coords2) / sizeof(coords2[0]) withDuration:2 withName:nil completeCallback:^(BOOL isFinished) {
    }];
    
    
    [anno addMoveAnimationWithKeyCoordinates:coords3 count:sizeof(coords3) / sizeof(coords3[0]) withDuration:2 withName:nil completeCallback:^(BOOL isFinished) {
    }];
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
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return annotationView;
    }
    
    return nil;
}

@end
