//
//  SignaturePoint.h
//  MakeYourOwnPPS
//
//  Created by Jessie Serrino on 4/26/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

// Vertex structure containing 3D point and color
struct SignaturePoint
{
    GLKVector3		vertex;
    GLKVector3		color;
};
typedef struct SignaturePoint SignaturePoint;
