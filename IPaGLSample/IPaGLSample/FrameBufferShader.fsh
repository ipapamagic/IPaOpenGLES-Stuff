//
//  Shader.fsh
//  GLTest
//
//  Created by IPaPa on 12/8/13.
//  Copyright (c) 2012 IPaPa. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    highp float x = gl_PointCoord.x - 0.5;
    highp float y = gl_PointCoord.y - 0.5;
    
    
    if ( x*x + y*y > 0.25)
        discard;
    gl_FragColor = colorVarying;
}
