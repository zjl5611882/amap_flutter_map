//
//  ReplaceMarkerView.m
//  Pods
//
//  Created by 赵俊龙 on 2022/4/18.
//

#import "ReplaceMarkerView.h"

#import "AMapInfoWindow.h"


#define kWidth  95
#define kHeight    70

#define ktopHeight 25
#define kImageHeight 40
#define kImageWidth 36



///flutter 自定义的标记点
@interface ReplaceMarkerView ()
@property (nonatomic, strong)UIImageView *sImageView;
@property (nonatomic, strong) UILabel *descLabel;


@end

@implementation ReplaceMarkerView

//type： 0换电地图 1充电地图
//num：type=0时，电池数量，type=1时，可用充电枪数量
//desc：type=0时，排队人数，type=1时，当前价格
//value：type=0时，排队：0 | 电池：0   type=1时，￥0.0/度
//imageString：图片名称
- (void)setMarkerData:(NSDictionary *)markerData{
    _markerData = markerData;
    
    self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",markerData[@"imageString"]]];
    self.sImageView.image = image;
    self.sImageView.frame = CGRectMake((kWidth - kImageWidth)/2, kHeight - kImageHeight, kImageWidth, kImageHeight);
    
    NSString *value = [NSString stringWithFormat:@"%@",markerData[@"value"]];
    NSString *desc = [NSString stringWithFormat:@"%@",markerData[@"desc"]];
    NSString *num = [NSString stringWithFormat:@"%@",markerData[@"num"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:value];
    if ([desc isEqualToString: num]) {
        NSRange range1 = [value rangeOfString:desc];
        // 从第一个0之后开始查找最后一个0的范围
        NSRange searchRange = NSMakeRange(range1.location + 1, [value length] - range1.location - 1);
        NSRange range2 = [value rangeOfString:num options:NSBackwardsSearch range:searchRange];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
    
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range2];
    }else{
        NSRange range1 = [value rangeOfString:desc];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range1];
        NSRange range2 = [value rangeOfString:num];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range2];
    }
    
    self.descLabel.attributedText = attributedString;
    self.descLabel.frame = CGRectMake(0, 0, kWidth, ktopHeight);
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.centerOffset = CGPointMake(0, -kHeight / 2.0);
        
        
        self.sImageView = [[UIImageView alloc] init];
        [self addSubview:self.sImageView];
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.backgroundColor = [UIColor whiteColor];
        self.descLabel.layer.cornerRadius = ktopHeight/2;
        self.descLabel.layer.masksToBounds = YES;
        self.descLabel.font = [UIFont systemFontOfSize:8];
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        self.descLabel.textColor = [UIColor blackColor];
        [self addSubview:self.descLabel];
        
        
    }
    
    return self;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    //    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

//- (void)drawInContext:(CGContextRef)context
//{
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetFillColorWithColor(context, kBackgroundColor.CGColor);
//    [self getDrawPath:context];
//    CGContextFillPath(context);
//}
//
//- (void)getDrawPath:(CGContextRef)context
//{
//    CGRect rrect = self.bounds;
//    CGFloat radius = 6.0;
//    CGFloat minx = CGRectGetMinX(rrect),
//    midx = CGRectGetMidX(rrect),
//    maxx = CGRectGetMaxX(rrect);
//    CGFloat miny = CGRectGetMinY(rrect),
//    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
//
//    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
//
//    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
//    CGContextClosePath(context);
//}


@end
