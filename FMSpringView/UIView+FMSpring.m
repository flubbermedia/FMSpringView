//
//  UIView+FMSpring.m
//
//  Created by Maurizio Cremaschi and Andrea Ottolina on 8/2/12.
//  Copyright 2012 Flubber Media Ltd.
//
//  Distributed under the permissive zlib License
//  Get the latest version from https://github.com/flubbermedia/FMSpringView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "UIView+FMSpring.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (FMSpring)

- (void)enableSpring:(BOOL)enable
{
    if (enable)
    {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(-2.0, 2.0);
        self.layer.shadowRadius = 1.0;
        self.layer.shadowOpacity = 0.5;
        
        UIPanGestureRecognizer *springPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(springPan:)];
        [self addGestureRecognizer:springPanGesture];
    }
    else
    {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 0.0;
        self.layer.shadowOpacity = 0.0;
        
        for (UIGestureRecognizer *gesture in self.gestureRecognizers)
        {
            [gesture removeTarget:self action:@selector(springPan:)];
        }
    }
}

- (void)springPan:(UIPanGestureRecognizer *)gesture
{
	CGPoint translate = [gesture translationInView:[self superview]];
    
	if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled)
	{
		self.transform = CGAffineTransformIdentity;
		self.layer.shadowOffset = CGSizeMake(-2.0, 2.0);
		
		CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		animation.duration = 0.2;
		
		int steps = 100;
		NSMutableArray *points = [NSMutableArray arrayWithCapacity:steps];
		CGPoint point = CGPointZero;
		for (int t = 0; t < steps; t++)
		{
			float scale = powf(M_E, -0.05 * (t+20)) * cosf(0.5 * t);
			CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
			CGPoint translationPoint = CGPointApplyAffineTransform(translate, scaleTransform);
			point = CGPointApplyAffineTransform(self.center, CGAffineTransformMakeTranslation(translationPoint.x, translationPoint.y));
			[points addObject:[NSValue valueWithCGPoint:point]];
		}
		
		animation.values = points;
		
		animation.removedOnCompletion = YES;
		animation.fillMode = kCAFillModeForwards;
		[self.layer addAnimation:animation forKey:nil];
		
		return;
	}
	
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1.0f / 500.0f;
	transform = CATransform3DTranslate(transform, translate.x * 0.2, translate.y * 0.2, 0);
	transform = CATransform3DRotate(transform, M_PI / 180 * translate.x / 10, 0, 1, 0);
	transform = CATransform3DRotate(transform, M_PI / 180 * -translate.y / 10, 1, 0, 0);
	self.layer.transform = transform;
	
	self.layer.shadowOffset = CGSizeMake((-2 - (translate.x / (self.frame.size.width / 2)) * 2), (2 - (translate.y / (self.frame.size.height / 2)) * 2));
	
	BOOL pointInside = [self pointInside:[gesture locationInView:self] withEvent:nil];
	
	if (pointInside == NO)
	{
		gesture.enabled = NO;
		gesture.enabled = YES;
	}	
}

@end
