//
//  SignatureLine.h
//  MakeYourOwnPPS
//
//  Created by Jessie Serrino on 4/26/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignaturePoint.h"

#define             MAXIMUM_VERTECES 100000


static const int maxLength = MAXIMUM_VERTECES;



struct Line
{
    // Width of line at current and previous vertex
    float penThickness;
    float previousThickness;
    
    
    GLuint vertexArray;
    GLuint vertexBuffer;
    GLuint dotsArray;
    GLuint dotsBuffer;
    
    // Previous points for quadratic bezier computations
    CGPoint previousPoint;
    CGPoint previousMidPoint;
    SignaturePoint previousVertex;
    SignaturePoint currentVelocity;
    
    // Array of verteces, with current length
    SignaturePoint SignatureVertexData[maxLength];
    uint length;
    
    SignaturePoint SignatureDotsData[maxLength];
    uint dotsLength;
    
};

typedef struct Line Line;