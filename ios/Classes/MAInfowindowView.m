//
//  MAInfowindowView.m
//  Pods
//
//  Created by 赵俊龙 on 2022/4/18.
//

#import "MAInfowindowView.h"

#import "AMapInfoWindow.h"

//#define kMinWidth  80
#define kHeight    48

#define kMaxWidth  100


#define kHoriMargin 3
#define kVertMargin 3

#define kFontSize   14

#define kArrorHeight        8
#define kBackgroundColor    [UIColor whiteColor]


///flutter 自定义的标记点
@interface MAInfowindowView ()
@property (nonatomic, strong)UIImageView *sImageView;
@property (nonatomic, strong) UILabel *pdLabel;
@property (nonatomic, strong) UILabel *dcLabel;


@end

@implementation MAInfowindowView


- (void)setMarker:(AMapMarker *)marker{
    _marker = marker;
    self.pdLabel.text = marker.infoWindow.title;
    self.dcLabel.text = marker.infoWindow.snippet;
    self.sImageView.image = marker.image;
    
    
    float childWH = kHeight - kArrorHeight;
    float titleMaxW = kMaxWidth - childWH;
    
    self.bounds = CGRectMake(0.f, 0.f, kMaxWidth, kHeight);
    self.sImageView.frame = CGRectMake(0, 0, childWH, childWH);
    self.pdLabel.frame =  CGRectMake(childWH, 0, titleMaxW, childWH/2);
    self.dcLabel.frame =  CGRectMake(childWH, CGRectGetMaxY(self.pdLabel.frame), titleMaxW, childWH/2);
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0.f, 0.f, kMaxWidth, kHeight);
        self.centerOffset = CGPointMake(0, -kHeight / 2.0);
        
        
        self.sImageView = [[UIImageView alloc] init];
//        self.sImageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.sImageView];
        
        self.pdLabel = [[UILabel alloc] init];
        self.pdLabel.backgroundColor = [UIColor clearColor];
        self.pdLabel.textColor = [UIColor blackColor];
        self.pdLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self addSubview:self.pdLabel];
        
        self.dcLabel = [[UILabel alloc] init];
        self.dcLabel.backgroundColor = [UIColor clearColor];
        self.dcLabel.textColor = [UIColor blackColor];
        self.dcLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self addSubview:self.dcLabel];
        
    }
    
    return self;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, kBackgroundColor.CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


@end
