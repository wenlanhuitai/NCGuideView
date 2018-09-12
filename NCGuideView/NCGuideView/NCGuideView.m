//
//  NCGuideView.m
//  NCGuideView
//
//  Created by 谢印超 on 2018/9/12.
//  Copyright © 2018年 360. All rights reserved.
//

#import "NCGuideView.h"
@interface NCGuide : NSObject
@property (assign) NCGuideType GuideType;
@end;
@implementation NCGuide
@end

//圆形
@interface NCCircleGuide : NCGuide
@property (assign) CGPoint GuideCenterPoint;
@property (assign) CGFloat GuideWeith;
@property (assign) CGFloat GuideHeight;
@end
@implementation NCCircleGuide
@end

//矩形
@interface NCRectGuide : NCGuide
@property (assign) CGRect GuideRect;
@end
@implementation NCRectGuide
@end

//圆角矩形
@interface NCRoundedRectGuide  : NCRectGuide
@property (assign) CGFloat GuideCornerRadius;
@end
@implementation NCRoundedRectGuide
@end

//自定义
@interface NCCustomRectGuide : NCRectGuide
@property (strong) UIView *customView;
@end
@implementation NCCustomRectGuide
@end



@interface NCGuideView ()
@property (strong ,nonatomic) NSMutableArray *Guides;
@end

@implementation NCGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _Guides = [NSMutableArray new];
    /// 设置默认数据
    self.backgroundColor = [UIColor clearColor];
    _guideColor = [UIColor blackColor];
    self.alpha  = 0.0f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetectedForGesture:)];
    [self addGestureRecognizer:tapGesture];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self removeCustomViews];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) {
        return;
    }
    
    [self.guideColor setFill];
    UIRectFill(rect);
    
    for (NCGuide* Guide in self.Guides) {
        
        [[UIColor clearColor] setFill];
        
        if (Guide.GuideType == NCGuideTypeRoundedRect) {
            NCRoundedRectGuide *rectGuide = (NCRoundedRectGuide *)Guide;
            CGRect GuideRectIntersection = CGRectIntersection( rectGuide.GuideRect, self.frame);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:GuideRectIntersection
                                                                  cornerRadius:rectGuide.GuideCornerRadius];
            
            //填充挖空颜色
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor] CGColor]);
            //设置挖空的边缘路径
            CGContextAddPath(UIGraphicsGetCurrentContext(), bezierPath.CGPath);
            //设置混合模式，类似PS中的图层混合选项
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            //绘制
            CGContextFillPath(UIGraphicsGetCurrentContext());
            
        } else if (Guide.GuideType == NCGuideTypeRect) {
            NCRectGuide *rectGuide = (NCRectGuide *)Guide;
            CGRect GuideRectIntersection = CGRectIntersection( rectGuide.GuideRect, self.frame);
            UIRectFill( GuideRectIntersection );
            
        } else if (Guide.GuideType == NCGuideTypeCirle) {
            NCCircleGuide *circleGuide = (NCCircleGuide *)Guide;
            CGRect rectInView = CGRectMake(floorf(circleGuide.GuideCenterPoint.x - circleGuide.GuideWeith*0.5f),
                                           floorf(circleGuide.GuideCenterPoint.x - circleGuide.GuideHeight*0.5f),
                                           circleGuide.GuideWeith,
                                           circleGuide.GuideHeight);
            
            CGContextSetFillColorWithColor( context, [UIColor redColor].CGColor );
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextFillEllipseInRect( context, rectInView);
//            画笔颜色设置
            CGContextSetRGBStrokeColor(context,0.6,0.9,0,1.0);
//            设置画笔线的宽度
            CGContextSetLineWidth(context,3.0);
//            画圆
            CGContextAddEllipseInRect(context, rectInView);
            CGContextStrokePath(context);
        }
    }
    [self addCustomViews];
}

#pragma mark - Add methods

- (NSInteger)addGuideCircleCenteredOnPosition:(CGPoint)centerPoint andGuideWeith:(CGFloat)weith andGuideHeight:(CGFloat)height
{
    
    NCCircleGuide *circleGuide = [NCCircleGuide new];
    circleGuide.GuideCenterPoint = centerPoint;
    circleGuide.GuideWeith = weith;
    circleGuide.GuideHeight = height;
    circleGuide.GuideType = NCGuideTypeCirle;
    [self.Guides addObject:circleGuide];
    [self setNeedsDisplay];
    
    return [self.Guides indexOfObject:circleGuide];
}

- (NSInteger)addGuideRectOnRect:(CGRect)rect
{
    NCRectGuide *rectGuide = [NCRectGuide new];
    rectGuide.GuideRect = rect;
    rectGuide.GuideType = NCGuideTypeRect;
    [self.Guides addObject:rectGuide];
    [self setNeedsDisplay];
    
    return [self.Guides indexOfObject:rectGuide];
}

- (NSInteger)addGuideRoundedRectOnRect:(CGRect)rect withCornerRadius:(CGFloat)cornerRadius
{
    NCRoundedRectGuide *rectGuide = [NCRoundedRectGuide new];
    rectGuide.GuideRect = rect;
    rectGuide.GuideCornerRadius = cornerRadius;
    rectGuide.GuideType = NCGuideTypeRoundedRect;
    [self.Guides addObject:rectGuide];
    [self setNeedsDisplay];
    
    return [self.Guides indexOfObject:rectGuide];
}

- (NSInteger)addHCustomView:(UIView *)customView onRect:(CGRect)rect
{
    NCCustomRectGuide *customGuide = [NCCustomRectGuide new];
    customGuide.GuideRect = rect;
    customGuide.customView = customView;
    customGuide.GuideType = NCGuideTypeCustomRect;
    [self.Guides addObject:customGuide];
    [self setNeedsDisplay];
    
    return [self.Guides indexOfObject:customGuide];
}

/**
 *  显示
 */
- (void)show
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f animations:^{
        weakSelf.alpha = weakSelf.guideAlpha;
        [weakSelf setNeedsDisplay];
    }];
}

#pragma mark - Action Method

/**
 *  隐藏
 */
- (void)hide
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}


- (void)removeGuides
{
    [self.Guides removeAllObjects];
    [self removeCustomViews];
    [self setNeedsDisplay];
}


#pragma mark - Tap Gesture

- (void)tapGestureDetectedForGesture:(UITapGestureRecognizer *)gesture
{
    if ([self.guideViewDelegate respondsToSelector:@selector(GuidedView:didSelectGuideAtIndex:)]) {
        CGPoint touchLocation = [gesture locationInView:self];
        [self.guideViewDelegate GuidedView:self didSelectGuideAtIndex:[self GuideViewIndexForAtPoint:touchLocation]];
    }
}

- (NSUInteger)GuideViewIndexForAtPoint:(CGPoint)touchLocation
{
    __block NSUInteger idxToReturn = NSNotFound;
    [self.Guides enumerateObjectsUsingBlock:^(NCGuide *Guide, NSUInteger idx, BOOL *stop) {
        if (Guide.GuideType == NCGuideTypeRoundedRect ||
            Guide.GuideType == NCGuideTypeRect ||
            Guide.GuideType == NCGuideTypeCustomRect) {
            NCRectGuide *rectGuide = (NCRectGuide *)Guide;
            if (CGRectContainsPoint(rectGuide.GuideRect, touchLocation)) {
                idxToReturn = idx;
                *stop = YES;
            }
            
        } else if (Guide.GuideType == NCGuideTypeCirle) {
            NCCircleGuide *circleGuide = (NCCircleGuide *)Guide;
            CGRect rectInView = CGRectMake(floorf(circleGuide.GuideCenterPoint.x - circleGuide.GuideWeith*0.5f),
                                           floorf(circleGuide.GuideCenterPoint.x - circleGuide.GuideHeight*0.5f),
                                           circleGuide.GuideWeith,
                                           circleGuide.GuideHeight);
            if (CGRectContainsPoint(rectInView, touchLocation)) {
                idxToReturn = idx;
                *stop = YES;
            }
        }
    }];
    
    return idxToReturn;
}

#pragma mark - Custom Views

- (void)removeCustomViews
{
    [self.Guides enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NCCustomRectGuide class]]) {
            NCCustomRectGuide *Guide = (NCCustomRectGuide *)obj;
            [Guide.customView removeFromSuperview];
        }
    }];
}

- (void)addCustomViews
{
    [self.Guides enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NCCustomRectGuide class]]) {
            NCCustomRectGuide *Guide = (NCCustomRectGuide *)obj;
            [Guide.customView superview];
            [Guide.customView setFrame:Guide.GuideRect];
            [self addSubview:Guide.customView];
        }
    }];
}


@end
