IPaOpenGLES-Stuff
=================

some framework for OpenGL ES 2.0 and GLKit


IPaGLRenderSource is a mesh collection

IPaGLTexture record texture

IPaGLFramebufferTexture is a frame buffer connected with a texture

you can draw anything on it and use it as texture

size of frame buffer must be power of 2

IPaGLMaterial is material for object,it records object color and texture

IPaGLRenderer has two subclass - IPaGLShaderRenderer and IPaGLKitRenderer

IPaGLShaderRenderer is for opengles 2.0 shader

it can load shader, normally you need to subclass IPaGLShaderRenderer to use your own shaders

IPaGLKitRenderer is much easier

it use GLKBaseEffect from GLKit

you don't need to subclass IPaGLKitRenderer

IPaGLRenderer can render by IPaGLRenderer (if you want to use different renderer for each group) or render by IPaGLObject (every group in object use the same renderer)


IPaGLWavefronObj is subclass of IPaGLRenderSource

it can load wavefront object(.obj)

IPaGLSprite2D is a sprite object that can draw 2D image on screen 




check sample code for more detail information
