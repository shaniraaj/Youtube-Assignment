//
//  ButtonX.m
//  Onzebook
//
//  Created by Shanaishwar Chungade on 6/21/17.
//  Copyright © 2017 Undecimo. All rights reserved.
//

#import "ButtonX.h"


@implementation ButtonX

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderWidth    = 1;
        self.cornerRadious  = 1;
        self.borderColor = [UIColor clearColor];
        self.tintColor = [UIColor orangeColor];
        [self customInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self customInit];
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    [self customInit];
}

-(void)setNeedsLayout
{
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


-(void)prepareForInterfaceBuilder
{
    [self customInit];
}

-(void)customInit
{
    self.layer.cornerRadius = self.cornerRadious;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    
    if (self.cornerRadious > 0)
    {
        self.layer.masksToBounds = YES;
    }
}


@end
