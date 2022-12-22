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
//imageString：图片名称
- (void)setMarkerData:(NSDictionary *)markerData{
    _markerData = markerData;
    
    self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",markerData[@"imageString"]]];
    self.sImageView.image = image;
    self.sImageView.frame = CGRectMake((kWidth - kImageWidth)/2, kHeight - kImageHeight, kImageWidth, kImageHeight);
    
    NSString *titleString = [NSString stringWithFormat:@"排队:%@ | 电池:%@",markerData[@"desc"],markerData[@"num"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
    NSRange range1 = [titleString rangeOfString:@"排队:"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:range1];
    NSRange range2 = [titleString rangeOfString:@"电池:"];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:range2];
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
        self.descLabel.font = [UIFont systemFontOfSize:12];
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
