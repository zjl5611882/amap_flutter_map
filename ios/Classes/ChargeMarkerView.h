//
//  ChargeMarkerView.h
//  amap_flutter_map
//
//  Created by 赵俊龙 on 2022/11/28.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN
///充电地图标记站点
@interface ChargeMarkerView : MAAnnotationView
@property (nonatomic, strong)NSDictionary *markerData;

@end

NS_ASSUME_NONNULL_END
