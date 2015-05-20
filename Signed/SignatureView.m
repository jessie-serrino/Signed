#import "SignatureView.h"
#import <OpenGLES/ES2/glext.h>
#import "SignatureLine.h"



#define             STROKE_WIDTH_MIN 0.005 // Stroke width determined by touch velocity
#define             STROKE_WIDTH_MAX 0.035
#define       STROKE_WIDTH_SMOOTHING 0.5   // Low pass filter alpha

#define           VELOCITY_CLAMP_MIN 20
#define           VELOCITY_CLAMP_MAX 1000

#define QUADRATIC_DISTANCE_TOLERANCE 3.0   // Minimum distance to make a curve

#define             MAXIMUM_LINES 50



static GLKVector3 StrokeColor = { 0, 0, 0 };
static float clearColor[4] = { 1, 1, 1, 0 };


// Maximum verteces in signature
static const int maxLines = MAXIMUM_LINES;

// Append vertex to array buffer
static inline void addVertex(uint *length, SignaturePoint v) {
    if ((*length) >= maxLength) {
        return;
    }
    
    GLvoid *data = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
    memcpy(data + sizeof(SignaturePoint) * (*length), &v, sizeof(SignaturePoint));
    glUnmapBufferOES(GL_ARRAY_BUFFER);
    
    (*length)++;
}

static inline CGPoint QuadraticPointInCurve(CGPoint start, CGPoint end, CGPoint controlPoint, float percent) {
    double a = pow((1.0 - percent), 2.0);
    double b = 2.0 * percent * (1.0 - percent);
    double c = pow(percent, 2.0);
    
    return (CGPoint) {
        a * start.x + b * controlPoint.x + c * end.x,
        a * start.y + b * controlPoint.y + c * end.y
    };
}

static float generateRandom(float from, float to) { return random() % 10000 / 10000.0 * (to - from) + from; }
static float clamp(float min, float max, float value) { return fmaxf(min, fminf(max, value)); }


// Find perpendicular vector from two other vectors to compute triangle strip around line
static GLKVector3 perpendicular(SignaturePoint p1, SignaturePoint p2) {
    GLKVector3 ret;
    ret.x = p2.vertex.y - p1.vertex.y;
    ret.y = -1 * (p2.vertex.x - p1.vertex.x);
    ret.z = 0;
    return ret;
}

static SignaturePoint LocationInGL(CGPoint viewPoint, CGRect bounds, GLKVector3 color) {
    
    return (SignaturePoint) {
        {
            (viewPoint.x / bounds.size.width * 2.0 - 1),
            ((viewPoint.y / bounds.size.height) * 2.0 - 1) * -1,
            0
        },
        color
    };
}


@interface SignatureView () {
    Line *lines;
    uint currentLine;
    
    // OpenGL state
    EAGLContext *context;
    GLKBaseEffect *effect;
}

@end


@implementation SignatureView


- (void)commonInit {
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    lines = calloc(sizeof(Line), maxLines);
    
    currentLine = 0;
    
    if (context) {
        time(NULL);
        
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = NO;
        
        self.context = context;
        self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        self.enableSetNeedsDisplay = YES;
        
        // Turn on antialiasing
        self.drawableMultisample = GLKViewDrawableMultisample4X;
        
        [self setupGL];
        
        // Capture touches
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
        pan.cancelsTouchesInView = YES;
        [self addGestureRecognizer:pan];
        
    } else [NSException raise:@"NSOpenGLES2ContextException" format:@"Failed to create OpenGL ES2 context"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}


- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)ctx
{
    if (self = [super initWithFrame:frame context:ctx]) [self commonInit];
    return self;
}


- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    context = nil;
}


- (void)drawRect:(CGRect)rect
{
    glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3]);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [effect prepareToDraw];
    
    
    for(int i = 0 ; i <= currentLine; i++)
    {
        // Drawing of signature lines
        if (lines[i].length > 2) {
            glBindVertexArrayOES(lines[i].vertexArray);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, lines[i].length);
        }
    }
    

}


- (void)undo {


    if(currentLine != 0 && lines[currentLine].length==0)
    {
        currentLine = currentLine - 1;
    }
    lines[currentLine].length = 0;
    
    self.hasSignature = NO;
    
    NSLog(@"Current Line: %d", currentLine);

    [self setNeedsDisplay];
}

- (void) erase
{
    for(int i = 0 ; i < currentLine ; i++)
        [self undo];
}

/* */
- (UIImage *)signatureImage
{
    if (!self.hasSignature)
        return nil;
    
    //    self.hidden = YES;
    //
    //    self.strokeColor = [UIColor whiteColor];
    //    [self setNeedsDisplay];
    UIImage *screenshot = [self snapshot];
    
    //    self.strokeColor = nil;
    //
    //    self.hidden = NO;
    return screenshot;
}


#pragma mark - Gesture Recognizers

- (void)pan:(UIPanGestureRecognizer *)p {
    glBindBuffer(GL_ARRAY_BUFFER, lines[currentLine].vertexBuffer);
    
    CGPoint v = [p velocityInView:self];
    CGPoint l = [p locationInView:self];
    
    lines[currentLine].currentVelocity = LocationInGL(v, self.bounds, (GLKVector3){0,0,0});
    float distance = 0.;
    
    CGPoint previousPoint = lines[currentLine].previousPoint;
    
    if (previousPoint.x > 0) {
        distance = sqrtf((l.x - previousPoint.x) * (l.x - previousPoint.x) + (l.y - previousPoint.y) * (l.y - previousPoint.y));
    }
    
    float velocityMagnitude = sqrtf(v.x*v.x + v.y*v.y);
    float clampedVelocityMagnitude = clamp(VELOCITY_CLAMP_MIN, VELOCITY_CLAMP_MAX, velocityMagnitude);
    float normalizedVelocity = (clampedVelocityMagnitude - VELOCITY_CLAMP_MIN) / (VELOCITY_CLAMP_MAX - VELOCITY_CLAMP_MIN);
    
    float lowPassFilterAlpha = STROKE_WIDTH_SMOOTHING;
    float newThickness = (STROKE_WIDTH_MAX - STROKE_WIDTH_MIN) * (1 - normalizedVelocity) + STROKE_WIDTH_MIN;
    lines[currentLine].penThickness = (lines[currentLine].penThickness) * lowPassFilterAlpha + newThickness * (1 - lowPassFilterAlpha);
    
    if(currentLine < maxLines)
        if ([p state] == UIGestureRecognizerStateBegan) {
            
            
            lines[currentLine].previousPoint = l;
            lines[currentLine].previousMidPoint = l;
            
            SignaturePoint startPoint = LocationInGL(l, self.bounds, (GLKVector3){1, 1, 1});
            lines[currentLine].previousVertex = startPoint;
            lines[currentLine].previousThickness = lines[currentLine].penThickness;
            
            addVertex(&(lines[currentLine].length), startPoint);
            addVertex(&(lines[currentLine].length), (lines[currentLine].previousVertex));
            
            self.hasSignature = YES;
            
        } else if ([p state] == UIGestureRecognizerStateChanged) {
            
            CGPoint mid = CGPointMake((l.x + previousPoint.x) / 2.0, (l.y + previousPoint.y) / 2.0);
            
            if (distance > QUADRATIC_DISTANCE_TOLERANCE) {
                // Plot quadratic bezier instead of line
                unsigned int i;
                
                int segments = (int) distance / 1.5;
                
                float startPenThickness = lines[currentLine].previousThickness;
                float endPenThickness = lines[currentLine].penThickness;
                lines[currentLine].previousThickness = lines[currentLine].penThickness;
                
                for (i = 0; i < segments; i++)
                {
                    lines[currentLine].penThickness = startPenThickness + ((endPenThickness - startPenThickness) / segments) * i;
                    
                    CGPoint quadPoint = QuadraticPointInCurve(lines[currentLine].previousMidPoint, mid, previousPoint, (float)i / (float)(segments));
                    
                    SignaturePoint v = LocationInGL(quadPoint, self.bounds, StrokeColor);
                    [self addTriangleStripPointsForPrevious:lines[currentLine].previousVertex next:v];
                    
                    lines[currentLine].previousVertex = v;
                }
            } else if (distance > 1.0) {
                
                SignaturePoint v = LocationInGL(l, self.bounds, StrokeColor);
                [self addTriangleStripPointsForPrevious:(lines[currentLine].previousVertex) next:v];
                
                lines[currentLine].previousVertex = v;
                lines[currentLine].previousThickness = lines[currentLine].penThickness;
            }
            
            lines[currentLine].previousPoint = l;
            lines[currentLine].previousMidPoint = mid;
            
        } else if (p.state == UIGestureRecognizerStateEnded | p.state == UIGestureRecognizerStateCancelled) {
            
            SignaturePoint v = LocationInGL(l, self.bounds, (GLKVector3){1, 1, 1});
            addVertex(&(lines[currentLine].length), v);
            
            lines[currentLine].previousVertex = v;
            addVertex(&(lines[currentLine].length), lines[currentLine].previousVertex);
            currentLine++;
            [self setupLine];
        }
    
    [self setNeedsDisplay];
}


- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self updateStrokeColor];
}


#pragma mark - Private

- (void)updateStrokeColor {
    CGFloat red, green, blue, alpha, white;
    if (effect && self.strokeColor && [self.strokeColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
        effect.constantColor = GLKVector4Make(red, green, blue, alpha);
    } else if (effect && self.strokeColor && [self.strokeColor getWhite:&white alpha:&alpha]) {
        effect.constantColor = GLKVector4Make(white, white, white, alpha);
    } else effect.constantColor = GLKVector4Make(0,0,0,1);
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    CGFloat red, green, blue, alpha, white;
    if ([backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
        clearColor[0] = red;
        clearColor[1] = green;
        clearColor[2] = blue;
    } else if ([backgroundColor getWhite:&white alpha:&alpha]) {
        clearColor[0] = white;
        clearColor[1] = white;
        clearColor[2] = white;
    }
}

- (void)bindShaderAttributes {
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SignaturePoint), 0);
    //    glEnableVertexAttribArray(GLKVertexAttribColor);
    //    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE,  6 * sizeof(GLfloat), (char *)12);
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:context];
    effect = [[GLKBaseEffect alloc] init];
    [self updateStrokeColor];
    glDisable(GL_DEPTH_TEST);
    
    [self setupLine];
    
    
    // Perspective
    GLKMatrix4 ortho = GLKMatrix4MakeOrtho(-1, 1, -1, 1, 0.1f, 2.0f);
    effect.transform.projectionMatrix = ortho;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.0f);
    effect.transform.modelviewMatrix = modelViewMatrix;
    

}

- (void) setupLine
{
    // Signature Lines
    glGenVertexArraysOES(1, &(lines[currentLine].vertexArray));
    glBindVertexArrayOES(lines[currentLine].vertexArray);
    
    glGenBuffers(1, &(lines[currentLine].vertexBuffer));
    glBindBuffer(GL_ARRAY_BUFFER, lines[currentLine].vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(lines[currentLine].SignatureVertexData), lines[currentLine].SignatureVertexData, GL_DYNAMIC_DRAW);
    [self bindShaderAttributes];
    
    
    lines[currentLine].length = 0;
    lines[currentLine].penThickness = STROKE_WIDTH_MAX;
    lines[currentLine].previousPoint = CGPointMake(-100, -100);
    
    glBindVertexArrayOES(0);
}



- (void)addTriangleStripPointsForPrevious:(SignaturePoint)previous next:(SignaturePoint)next {

    
    float toTravel = (lines[currentLine].penThickness) / 2.0;
    
    for (int i = 0; i < 2; i++) {
        GLKVector3 p = perpendicular(previous, next);
        GLKVector3 p1 = next.vertex;
        GLKVector3 ref = GLKVector3Add(p1, p);
        
        float distance = GLKVector3Distance(p1, ref);
        float difX = p1.x - ref.x;
        float difY = p1.y - ref.y;
        float ratio = -1.0 * (toTravel / distance);
        
        difX = difX * ratio;
        difY = difY * ratio;
        
        SignaturePoint stripPoint = {
            { p1.x + difX, p1.y + difY, 0.0 },
            StrokeColor
        };
        addVertex(&(lines[currentLine].length), stripPoint);
        
        toTravel *= -1;
    }
}


- (void)tearDownGL
{
    [EAGLContext setCurrentContext:context];
    
    
    for(int i = 0; i < currentLine; i++)
    {
        glDeleteVertexArraysOES(1, &(lines[i].vertexArray));
        glDeleteBuffers(1, &(lines[i].vertexBuffer));
    }
    
    effect = nil;
}

@end
