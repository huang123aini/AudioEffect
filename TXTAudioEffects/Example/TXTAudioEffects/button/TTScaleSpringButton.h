//
//  TTScaleSpringButton.h
//  elijah
//
//  Created by elijah on 2018/4/27.
//  Copyright © 2018年 elijah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTScaleSpringButton : UIButton

// 按下时的形变时长,默认为0.25s,详见动画的duration参数
@property (nonatomic, assign) NSTimeInterval duration;
// 形变系数,默认值0.88，小于等于0的值效果均为0的效果
@property (nonatomic, assign) CGFloat scaleFactor;
// 支持外部自定义的仿射变换，优先级高于形变系数
@property (nonatomic, assign) CGAffineTransform transformWhenTouchDown;

@end
