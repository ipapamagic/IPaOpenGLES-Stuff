//
//  Shader.vsh
//  GLTest
//
//  Created by IPaPa on 12/8/13.
//  Copyright (c) 2012 IPaPa. All rights reserved.
//

attribute vec4 position;
uniform float pointSize;
uniform vec4 pointColor;
varying lowp vec4 colorVarying;


void main()
{


    colorVarying = pointColor;
    gl_Position = position;
    gl_PointSize = pointSize;

    
}


