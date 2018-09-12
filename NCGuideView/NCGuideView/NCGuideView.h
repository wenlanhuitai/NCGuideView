//
//  NCGuideView.h
//  NCGuideView
//
//  Created by 谢印超 on 2018/9/12.
//  Copyright © 2018年 360. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NCGuideType)
{
    NCGuideTypeCirle,//圆形
    NCGuideTypeRect,//矩形
    NCGuideTypeRoundedRect,//圆角矩形
    NCGuideTypeCustomRect//自定义
};

@class NCGuideView;

@protocol NCGuideViewDelegate <NSObject>

- (void)GuidedView:(NCGuideView *)GuidedView didSelectGuideAtIndex:(NSUInteger)index;

@end

@interface NCGuideView : UIView
/** 引导页面背景色,默认黑色 */
@property (strong, nonatomic) UIColor *guideColor;
/** 引导页面背景色,默认0.5 */
@property (assign, nonatomic) CGFloat guideAlpha;
@property (weak,nonatomic) id <NCGuideViewDelegate>guideViewDelegate;

- (NSInteger)addGuideCircleCenteredOnPosition:(CGPoint)centerPoint andGuideWeith:(CGFloat)weith andGuideHeight:(CGFloat)height;
- (NSInteger)addGuideRectOnRect:(CGRect)rect;
- (NSInteger)addGuideRoundedRectOnRect:(CGRect)rect withCornerRadius:(CGFloat)cornerRadius;
- (NSInteger)addHCustomView:(UIView *)customView onRect:(CGRect)rect;

- (void)show;
- (void)hide;
- (void)removeGuides;



@end
