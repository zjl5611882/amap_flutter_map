//
//  ChargeMarkerView.m
//  amap_flutter_map
//
//  Created by 赵俊龙 on 2022/11/28.
//

#import "ChargeMarkerView.h"


#define kWidth  65
#define kHeight    70

#define ktopHeight 25
#define kImageHeight 40
#define kImageWidth 36




@interface ChargeMarkerView ()

@property (nonatomic, strong)UIImageView *sImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;


@end

@implementation ChargeMarkerView

//type： 0换电地图 1充电地图
//num：type=0时，电池数量，type=1时，可用充电枪数量
//desc：type=0时，排队人数，type=1时，当前价格
//value：type=0时，排队：0 | 电池：0   type=1时，￥0.0/度
//imageString：图片名称
- (void)setMarkerData:(NSDictionary *)markerData{
    _markerData = markerData;
    
    self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",markerData[@"imageString"]]];
    
    NSString *value = [NSString stringWithFormat:@"%@",markerData[@"value"]];
    NSString *desc = [NSString stringWithFormat:@"%@",markerData[@"desc"]];
    NSString *num = [NSString stringWithFormat:@"%@",markerData[@"num"]];
    
    self.sImageView.image = image;
    self.sImageView.frame = CGRectMake((kWidth - kImageWidth)/2, kHeight - kImageHeight, kImageWidth, kImageHeight);
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:value];
    NSRange descRange = [value rangeOfString:desc];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:descRange];
    self.descLabel.attributedText = attributedString;
    self.descLabel.frame = CGRectMake(0, 0, kWidth, ktopHeight);
    
    
    self.titleLabel.text = num;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.sImageView.center.x, self.sImageView.center.y - 2);
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
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.backgroundColor = [UIColor whiteColor];
        self.descLabel.textColor = [UIColor blackColor];
        self.descLabel.layer.cornerRadius = ktopHeight/2;
        self.descLabel.layer.masksToBounds = YES;
        self.descLabel.font = [UIFont systemFontOfSize:8];
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.descLabel];
        
    }
    
    return self;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{    
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}
@end
