//
//  ViewController.h
//  Accelerometer
//
//  Created by 廣川政樹 on 2013/05/24.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAccelerometerDelegate> {
    UILabel*   _label;
    float      _aX;
    float      _aY;
    float      _aZ;
    NSString*  _orientation;
}

@end
