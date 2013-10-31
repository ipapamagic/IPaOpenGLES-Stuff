varying lowp vec2 v_texCoord;
varying lowp float diffuseLight;
varying lowp float specularLight;
varying highp float edge;
uniform sampler2D texture;
void main()
{
    if  (edge < 0.2)
    {
        gl_FragColor = vec4(0,0,0,1);
    }
    else {
        if (diffuseLight < 0.5)
        {
            gl_FragColor = vec4(0.3,0.3,0.3,1);
        }
        else if(diffuseLight >= 0.5 && diffuseLight < 0.85)
        {
            gl_FragColor = texture2D(texture, v_texCoord);
        }
        else
        {
            gl_FragColor = vec4(specularLight,specularLight,specularLight,1);
        }
    }
}