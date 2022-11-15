//
//  MAInfowindowView.h
//  Pods
//
//  Created by 赵俊龙 on 2022/4/18.
//

#import <MAMapKit/MAMapKit.h>
#import "AMapMarker.h"
NS_ASSUME_NONNULL_BEGIN

@interface MAInfowindowView : MAAnnotationView

@property (nonatomic, strong)AMapMarker *marker;

@end

NS_ASSUME_NONNULL_END
