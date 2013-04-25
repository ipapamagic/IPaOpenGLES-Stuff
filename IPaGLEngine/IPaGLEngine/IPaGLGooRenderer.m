//
//  IPaGLGooRenderer.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/4/25.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLGooRenderer.h"

@implementation IPaGLGooRenderer
{
    GLint gooVectorUniform;
    GLint maxMoveUniform;
    GLint rangeUniform;
    GLint matrixUniform;
    GLint inverseMatUniform;
}
-(NSString*)vertexShaderSource
{
    return @"attribute vec4 position;\
            attribute vec2 texCoord;\
            varying lowp vec2 v_texCoord;\
            uniform vec4 gooVector;\
            uniform lowp float maxMove;\
            uniform lowp float range;\
            uniform lowp mat4 matrix;\
            uniform lowp mat4 inverseMat;\
            const lowp float C_ZERO = 0.0;\
            void main()\
            {\
                v_texCoord = texCoord;\
                vec4 screenPos = matrix * position;\
                vec2 movVec = gooVector.zw - gooVector.xy;\
                vec2 verVec = screenPos.xy - gooVector.zw;\
                lowp float cosV = dot(verVec,movVec) / length(movVec) / length(verVec);\
                if (cosV > C_ZERO) {\
                    gl_Position = position;\
                    return;\
                }\
                verVec = screenPos.xy - gooVector.xy;\
                cosV = dot(verVec,movVec) / length(movVec) / length(verVec);\
                movVec = cosV * movVec;\
                vec2 projVec = verVec - movVec;\
                if (length(projVec) >= range)\
                {\
                    gl_Position = position;\
                    return;\
                }\
                if(cosV <= C_ZERO)\
                {\
                    gl_Position = position;\
                }\
                else {\
                    movVec = normalize(movVec);\
                    movVec = cosV * maxMove * movVec;\
                    screenPos = vec4(screenPos.x + movVec.x,screenPos.y + movVec.y,screenPos.z,screenPos.w);\
                    gl_Position = inverseMat * screenPos;\
                }\
            }";
    
}
-(NSString*)fragmentShaderSource
{
    return @"varying lowp vec2 v_texCoord;\
            uniform sampler2D texture;\
            void main(void)\
            {\
                lowp vec4 texColour = texture2D(texture, v_texCoord);\
                gl_FragColor = texColour;\
            }";
}

-(void)onBindGLAttributes:(GLuint)_program
{
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord");
    
}
-(void)onGetGLUniforms:(GLuint)_program
{
    gooVectorUniform = glGetUniformLocation(_program, "gooVector");
    maxMoveUniform = glGetUniformLocation(_program, "maxMove");
    matrixUniform = glGetUniformLocation(_program, "matrix");
    inverseMatUniform = glGetUniformLocation(_program, "inverseMat");
    rangeUniform = glGetUniformLocation(_program, "range");
}
-(void)onBindGLUniforms
{
    glUniform4fv(gooVectorUniform, 1, self.gooVector.v);
    glUniform1f(maxMoveUniform, self.maxMove);
    glUniform1f(rangeUniform, self.range);
    glUniformMatrix4fv(matrixUniform, 1, GL_FALSE, self.matrix.m);
    bool isInvertable;
    GLKMatrix4 inverseMatrix = GLKMatrix4Invert(self.matrix,&isInvertable);
        
    glUniformMatrix4fv(inverseMatUniform, 1, GL_FALSE, inverseMatrix.m);
    
}

@end
