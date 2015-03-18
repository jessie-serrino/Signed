//
//  Signature.m
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "Signature.h"

@interface Signature ()
@property (nonatomic, strong) NSMutableArray *lines;
@end


@implementation Signature

- (instancetype) initWithFrame: (CGRect) frame
{
    self = [super init];
        
    self.frame = frame;
    self.backgroundColor = [UIColor redColor].CGColor;
    
    return self;
}

- (NSMutableArray *) lines
{
    if(!_lines)
    {
        _lines = [[NSMutableArray alloc] init];
    }
    return _lines;
}

- (UIImage *)image
{
    UIGraphicsBeginImageContext([self frame].size);
    
    [self renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void) startLineWithPoint: (CGPoint) point
{
    [self.lines addObject: [[Line alloc] initWithStartingPoint:point]];
}

- (void) continueLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity
{
    Line *currentLine = self.lines.lastObject;
    CAShapeLayer *latestLayer = [currentLine addConnectedPoint:point withVelocity:velocity];
    if(latestLayer)
        [self addSublayer:latestLayer];
}

- (void) endLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity
{
    Line *currentLine = self.lines.lastObject;
    [currentLine endLineAtPoint:point withVelocity:velocity];
}

@end
