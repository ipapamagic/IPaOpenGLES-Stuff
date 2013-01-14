//
//  Shader.fsh
//  TestGL
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec2 v_texCoord; // Varying in vertex shader
uniform sampler2D texture;
void main()
{
    gl_FragColor = colorVarying + texture2D(texture, v_texCoord);
}
