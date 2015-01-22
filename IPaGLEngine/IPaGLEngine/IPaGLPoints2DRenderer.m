//
//  IPaGLPoints2DRenderer.m
//  IPaGLEngine
//
//  Created by IPa Chen on 2015/1/22.
//  Copyright (c) 2015年 IPaPa. All rights reserved.
//

#import "IPaGLPoints2DRenderer.h"
#import "IPaGLPoints2D.h"
@implementation IPaGLPoints2DRenderer
{
    GLint penSizeUniform;
    GLint pointColorUniform;
    GLint matrixUniform;
    GLint radiusFactorUniform;
}
-(id)initWithDisplaySize:(GLKVector2)displaySize radiusFactor:(GLfloat)factor
{
    self = [super initWithDisplaySize:displaySize];
    self.radiusFactor = factor;
    return self;
}
- (instancetype) initWithDisplaySize:(GLKVector2)displaySize
{
    return [self initWithDisplaySize:displaySize radiusFactor:0.5];
}
-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
            uniform float pointSize;\
            uniform vec4 pointColor;\
            uniform highp float radiusFactor;\
            varying highp float radiusFactorVarying;\
            varying lowp vec4 colorVarying;\
            uniform mat4 matrix;\
            void main()\
            {\
                colorVarying = pointColor;\
                gl_Position = matrix * position;\
                gl_PointSize = pointSize;\
                radiusFactorVarying = radiusFactor;\
            }";
    
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec4 colorVarying;\
            varying highp float radiusFactorVarying;\
            void main()\
            {\
                highp float x = gl_PointCoord.x - radiusFactorVarying;\
                highp float y = gl_PointCoord.y - radiusFactorVarying;\
                if ( (x*x + y*y) > (radiusFactorVarying * radiusFactorVarying))\
                    discard;\
                gl_FragColor = colorVarying;\
            }";
}
-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
}
-(void)onGetGLUniforms:(GLuint)_program
{
    penSizeUniform = glGetUniformLocation(_program, "pointSize");
    pointColorUniform = glGetUniformLocation(_program, "pointColor");
    matrixUniform = glGetUniformLocation(_program, "matrix");
    radiusFactorUniform = glGetUniformLocation(_program, "radiusFactor");
}
-(void)onBindGLUniforms
{
    glUniform1f(penSizeUniform,self.penSize);
    glUniform4fv(pointColorUniform, 1, self.penColor.v);
    GLKMatrix4 matrix = GLKMatrix4Multiply(self.projectionMatrix, self.modelMatrix);
    glUniformMatrix4fv(matrixUniform, 1, 0, matrix.m);
    glUniform1f(radiusFactorUniform,self.radiusFactor);
}
- (void)prepareToRenderPoints2D:(IPaGLPoints2D *)points
{
    self.penSize = points.pointSize;
    self.penColor = points.pointColor;
    self.modelMatrix = points.matrix;
    
}


@end
