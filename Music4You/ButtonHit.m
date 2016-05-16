//
//  ButtonHit.m
//  Free Music 
//
//  Created by Tam Nguyen on 3/21/14.
//  Copyright (c) 2014 Tam Nguyen. All rights reserved.
//

#import "ButtonHit.h"
#define TINTCOLOR [UIColor colorWithRed:0.988 green:0.133 blue:0.133 alpha:1]
@implementation ButtonHit

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int expandMargin = 20;
    CGRect extendedFrame = CGRectMake(0 - expandMargin , 0 - expandMargin , self.frame.size.width + (expandMargin * 2) , self.frame.size.height + (expandMargin * 2));
    return (CGRectContainsPoint(extendedFrame , point) == 1) ? self : nil;
}
@end
