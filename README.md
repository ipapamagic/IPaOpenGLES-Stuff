IPaOpenGLES-Stuff
=================

some framework for OpenGL ES 2.0 and GLKit


IPaWavefrontObjLoader is a wavefront obj loader

IPaGLObject is a mesh collection, it has multiple IPaGLRenderGroup

IPaGLRenderGroup has vertex indexes for render

IPaGLMaterial is material for object,it records object color and texture

IPaGLRenderer has two subclass - IPaGLShaderRenderer and IPaGLKitRenderer

IPaGLShaderRenderer is for opengles 2.0 shader

it can load shader, normally you need to subclass IPaGLShaderRenderer to use your own shaders

IPaGLKitRenderer is much easier

it use GLKBaseEffect from GLKit

you don't need to subclass IPaGLKitRenderer

IPaGLRenderer can render by IPaGLRenderer (if you want to use different renderer for each group) or render by IPaGLObject (every group in object use the same renderer)




check sample code for more detail information
