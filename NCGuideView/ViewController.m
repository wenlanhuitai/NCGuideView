//
//  ViewController.m
//  NCGuideView
//
//  Created by 谢印超 on 2018/9/12.
//  Copyright © 2018年 360. All rights reserved.
//

#import "ViewController.h"
#import "NCGuideView.h"
@interface ViewController ()<NCGuideViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation ViewController

// NCGuideViewDelegate
- (void)GuidedView:(NCGuideView *)GuidedView didSelectGuideAtIndex:(NSUInteger)index{
    //引导页被触摸，已经消失
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)btn1_click:(id)sender {
    [self addPopGuideViewOn:self.btn1];
}

- (IBAction)btn2_click:(id)sender {
    [self addPopGuideViewOn:self.btn2];
}

- (void) addPopGuideViewOn:(UIView *)onView {
    
    NCGuideView *guideView = [[NCGuideView alloc] initWithFrame:self.view.bounds];
    guideView.guideAlpha = 0.7f;
    guideView.tag = 8888;
    [self.view addSubview:guideView];
    [self.view bringSubviewToFront:guideView];
    guideView.guideViewDelegate = self;
    UIView *view = onView;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect guideRect=[view convertRect: view.bounds toView:window];
    [guideView addGuideRoundedRectOnRect:guideRect withCornerRadius:5.0f];
    
    
    UIImage *customImage = [UIImage imageNamed:@"guide_1"];
    UIImageView *custimView = [[UIImageView alloc] initWithImage:customImage];
    [custimView sizeToFit];
    
    CGFloat guideOffsetX = (guideRect.origin.x - customImage.size.width) + (CGRectGetWidth(guideRect) * 0.5 + 12.0);
    [guideView addHCustomView:custimView onRect:CGRectMake(guideOffsetX, CGRectGetMaxY(guideRect), customImage.size.width, customImage.size.height)];
    [guideView show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
