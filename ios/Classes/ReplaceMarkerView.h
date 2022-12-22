//
//  ReplaceMarkerView.h
//  Pods
//
//  Created by 赵俊龙 on 2022/4/18.
//

#import <MAMapKit/MAMapKit.h>
#import "AMapMarker.h"
NS_ASSUME_NONNULL_BEGIN
///换电地图标记站点
@interface ReplaceMarkerView : MAAnnotationView

@property (nonatomic, strong)NSDictionary *markerData;
@end

NS_ASSUME_NONNULL_END
