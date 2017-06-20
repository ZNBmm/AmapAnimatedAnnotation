//
//  CustomAnnotationView.h
//  loveSport
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) CustomCalloutView *calloutView;

@end
