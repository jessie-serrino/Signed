//
//  Signature.m
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignatureMaker.h"

@interface SignatureMaker ()
@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic)   CGPoint upperLeftCorner;
@property (nonatomic)   CGPoint bottomRightCorner;

@end


@implementation SignatureMaker

- (instancetype) initWithFrame: (CGRect) frame
{
    self = [super init];
        
    self.frame = frame;
    self.penPreference = FountainPen;
    self.penColor = [UIColor blackColor];
    
    //self.backgroundColor = [UIColor redColor].CGColor;
    
    self.bottomRightCorner = CGPointMake(0, 0);
    self.upperLeftCorner = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
    
    return self;
}

- (void) logBounds
{
    NSLog(@"top left: %f, %f", _upperLeftCorner.x, _upperLeftCorner.y);
    NSLog(@"bottom right: %f, %f", _bottomRightCorner.x, _bottomRightCorner.y);

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
    
    return [self cropImage:outputImage];
}

- (void) undoLine
{
    if(self.lines.count)
    {
        Line *line = [self.lines lastObject];
        [line undoLine];
        
        [self.lines removeLastObject];
    }
}

- (CGRect) boundRectangle
{
    CGFloat x1, y1, x2, y2;
    CGFloat padding = 5.0;
    x1 = self.upperLeftCorner.x - padding;
    y1 = self.upperLeftCorner.y - padding;
    x2 = self.bottomRightCorner.x + padding;
    y2 = self.bottomRightCorner.y + padding;
    if(x1 < 0.0)
        x1 = 0.0;
    if(y1 < 0.0)
        y1 = 0.0;
    if(x2 > self.bounds.size.width)
        x2 = self.bounds.size.width;
    if(y2 > self.bounds.size.height)
        y2 = self.bounds.size.height;
    
    return CGRectMake(x1, y1, x2 - x1 + 5, y2 - y1 + 5);
}

- (void) adjustBounds: (CGPoint) point
{
    CGFloat farLeft = (self.upperLeftCorner.x < point.x)? self.upperLeftCorner.x : point.x;
    CGFloat farRight = (self.bottomRightCorner.x > point.x)? self.bottomRightCorner.x : point.x;
    CGFloat top = (self.upperLeftCorner.y < point.y)? self.upperLeftCorner.y : point.y;
    CGFloat bottom = (self.bottomRightCorner.y > point.y)? self.bottomRightCorner.y : point.y;
    self.upperLeftCorner = CGPointMake(farLeft, top);
    self.bottomRightCorner = CGPointMake(farRight, bottom);

}

- (UIImage *)cropImage: (UIImage *) image{
    CGRect rect = [self boundRectangle];
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return result;
}


- (void) startLineWithPoint: (CGPoint) point
{
    [self.lines addObject: [[Line alloc] initWithStartingPoint:point andPenPreference:self.penPreference andColor:self.penColor]];
    [self adjustBounds:point];
}

- (void) continueLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity
{
    if(point.y >= 0)
    {
        Line *currentLine = self.lines.lastObject;
        CAShapeLayer *latestLayer = [currentLine addConnectedPoint:point withVelocity:velocity];
        if(latestLayer)
            [self addSublayer:latestLayer];
        [self adjustBounds:point];
    }
    else
        [self endLineWithPoint:point andVelocity:velocity];
}

- (void) endLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity
{
    Line *currentLine = self.lines.lastObject;
    [currentLine endLineAtPoint:point withVelocity:velocity];
    [self adjustBounds:point];
}


@end
