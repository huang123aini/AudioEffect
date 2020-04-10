//
//  TTScaleSpringButton.m
//  elijah
//
//  Created by elijah on 2018/4/27.
//  Copyright © 2018年 elijah. All rights reserved.
//

#import "TTScaleSpringButton.h"


@implementation TTScaleSpringButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _duration = 0.25;
        _scaleFactor = 0.88;
        _transformWhenTouchDown = CGAffineTransformIdentity;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGFloat scale = self.scaleFactor;
    CGAffineTransform to =  CGAffineTransformEqualToTransform(self.transformWhenTouchDown, CGAffineTransformIdentity) ?
    CGAffineTransformMakeScale(scale, scale) : self.transformWhenTouchDown;
    [self animateDuration:self.duration toTrans:to];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self animateDuration:self.duration toTrans:CGAffineTransformIdentity];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self animateDuration:self.duration toTrans:CGAffineTransformIdentity];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - Private methods

- (void)animateDuration:(NSTimeInterval)duration toTrans:(CGAffineTransform)to
{
    UIViewAnimationOptions ops = UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:duration delay:0 options:ops animations:^{
        self.transform = to;
    } completion:^(BOOL finished)
    {
        
    }];
}

#pragma mark - Accessor

- (CGFloat)scaleFactor
{
    if (_scaleFactor <= 0) {
        return 0;
    } else {
        return _scaleFactor;
    }
}

@end
