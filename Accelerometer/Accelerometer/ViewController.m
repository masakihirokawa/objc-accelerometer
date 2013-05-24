//
//  ViewController.m
//  Accelerometer
//
//  Created by 廣川政樹 on 2013/05/24.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

#define FILTERING_FACTOR 0.1

@interface ViewController ()

@end

@implementation ViewController

//初期化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ラベルの生成
    _label = [self makeLabel:CGPointMake(0, 0)
                        text:@"Accelerometer"
                        font:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_label];
    
    //値の初期化
    _aX = 0;
    _aY = 0;
    _aZ = 0;
    _orientation = @"";
    
    //加速度通知の開始
    UIAccelerometer *accelermeter = [UIAccelerometer sharedAccelerometer];
    accelermeter.updateInterval = 0.1f;
    accelermeter.delegate = self;
    
    //端末回転通知の開始
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

//ラベルのリサイズ
- (void)resizeLabel:(UILabel *)label
{
    CGRect frame = label.frame;
    frame.size = [label.text sizeWithFont:label.font
                        constrainedToSize:CGSizeMake(512, 512)
                            lineBreakMode:NSLineBreakByWordWrapping];
    [label setFrame:frame];
}

//ラベルの生成
- (UILabel *)makeLabel:(CGPoint)pos
                 text:(NSString *)text
                 font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [self resizeLabel:label];
    return label;
}

//端末の向きの取得
- (void)didRotate:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[notification object] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        _orientation = @"横(左90度回転)";
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        _orientation = @"横(右90度回転)";
    } else if (orientation==UIDeviceOrientationPortraitUpsideDown) {
        _orientation = @"縦(上下逆)";
    } else if (orientation == UIDeviceOrientationPortrait) {
        _orientation = @"縦";
    } else if (orientation == UIDeviceOrientationFaceUp) {
        _orientation = @"画面が上向き";
    } else if (orientation == UIDeviceOrientationFaceDown) {
        _orientation = @"画面が下向き";
    }
}

//加速度通知時に呼ばれる
- (void)accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
    //加速度にローパスフィルタをあてる
    _aX = (acceleration.x * FILTERING_FACTOR) + (_aX * (1.0 - FILTERING_FACTOR));
    _aY = (acceleration.y * FILTERING_FACTOR) + (_aY * (1.0 - FILTERING_FACTOR));
    _aZ = (acceleration.z * FILTERING_FACTOR) + (_aZ * (1.0 - FILTERING_FACTOR));
    
    //ラベルの更新
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"Accelerometer\n\n"];
    [str appendFormat:@"X軸加速度: %+.2f\n", _aX];
    [str appendFormat:@"Y軸加速度: %+.2f\n", _aY];
    [str appendFormat:@"Z軸加速度: %+.2f\n\n", _aZ];
    [str appendFormat:@"端末の向き: %@", _orientation];
    [_label setText:str];
    [self resizeLabel:_label];
}

@end
