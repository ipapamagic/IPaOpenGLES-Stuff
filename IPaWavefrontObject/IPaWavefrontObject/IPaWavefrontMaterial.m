//
//  IPaWavefrontMaterial.m
//  IPaWavefrontObject
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaWavefrontMaterial.h"
@implementation IPaWavefrontMaterial
{
    //for GLKBaseEffect
    GLKTextureInfo *textureInfo;
    //for custom shader
    GLuint texture;
}
- (id)initWithName:(NSString *)inName shininess:(GLfloat)inShininess diffuse:(UIColor*)inDiffuse ambient:(UIColor*)inAmbient specular:(UIColor*)inSpecular
{
    return [self initWithName:inName shininess:inShininess diffuse:inDiffuse ambient:inAmbient specular:inSpecular textureFileName:nil];
}
- (id)initWithName:(NSString *)inName shininess:(GLfloat)inShininess diffuse:(UIColor*)inDiffuse ambient:(UIColor*)inAmbient specular:(UIColor*)inSpecular textureFileName:(NSString *)textureFileName
{
	if ((self = [super init]))
	{
		self.name = (inName == nil) ? @"default" : inName;
		self.diffuse = inDiffuse;
		self.ambient = inAmbient;
		self.specular = inSpecular;
		self.shininess = inShininess;
		self.textureFileName = textureFileName;
	}
	return self;
}+ (id)defaultMaterial
{
	return [[IPaWavefrontMaterial alloc] initWithName:@"default"
												shininess:65.0
												  diffuse:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]
												  ambient:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
												 specular:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
	
}
+ (id)materialsFromBasePath:(NSString*)basePath MtlFileName:(NSString *)fileName
{
    NSString *path = [basePath stringByAppendingPathComponent:fileName];
	NSMutableDictionary *ret = [NSMutableDictionary dictionary];
	[ret setObject:[IPaWavefrontMaterial defaultMaterial] forKey:@"default"];
	NSString *mtlData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSArray *mtlLines = [mtlData componentsSeparatedByString:@"\n"];
	// Can't use fast enumeration here, need to manipulate line order
	for (int i = 0; i < [mtlLines count]; i++)
	{
		NSString *line = [mtlLines objectAtIndex:i];
		if ([line hasPrefix:@"newmtl"]) // Start of new material
		{
			// Determine start of next material
			int mtlEnd = -1;
			for (int j = i+1; j < [mtlLines count]; j++)
			{
				NSString *innerLine = [mtlLines objectAtIndex:j];
				if ([innerLine hasPrefix:@"newmtl"])
				{
					mtlEnd = j-1;
					
					break;
				}
                
			}
			if (mtlEnd == -1)
				mtlEnd = [mtlLines count]-1;
            
			
			IPaWavefrontMaterial *material = [[IPaWavefrontMaterial alloc] init];
			for (int j = i; j <= mtlEnd; j++)
			{
				NSString *parseLine = [mtlLines objectAtIndex:j];
				// ignore Ni, d, and illum, and texture - at least for now
				if ([parseLine hasPrefix:@"newmtl "])
					material.name = [parseLine substringFromIndex:7];
				else if ([parseLine hasPrefix:@"Ns "])
					material.shininess = [[parseLine substringFromIndex:3] floatValue];
				else if ([parseLine hasPrefix:@"Ka spectral"]) // Ignore, don't want consumed by next else
				{
					
				}
				else if ([parseLine hasPrefix:@"Ka "])  // CIEXYZ currently not supported, must be specified as RGB
				{
					NSArray *colorParts = [[parseLine substringFromIndex:3] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
					material.ambient = [UIColor colorWithRed:[colorParts[0] floatValue] green:[colorParts[1] floatValue] blue:[colorParts[2] floatValue] alpha:1.0];
                    
                    
				}
				else if ([parseLine hasPrefix:@"Kd "])
				{
					NSArray *colorParts = [[parseLine substringFromIndex:3] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
					material.diffuse =  [UIColor colorWithRed:[colorParts[0] floatValue] green:[colorParts[1] floatValue] blue:[colorParts[2] floatValue] alpha:1.0];
				}
				else if ([parseLine hasPrefix:@"Ks "])
				{
					NSArray *colorParts = [[parseLine substringFromIndex:3] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
					material.specular =  [UIColor colorWithRed:[colorParts[0] floatValue] green:[colorParts[1] floatValue] blue:[colorParts[2] floatValue] alpha:1.0];
				}
				else if ([parseLine hasPrefix:@"map_Kd "])
				{
					NSString *texName = [parseLine substringFromIndex:7];
                    material.textureFileName = [basePath stringByAppendingPathComponent:texName];

					
                    
//                    NSString *baseName = [[texName componentsSeparatedByString:@"."] objectAtIndex:0];
//					
//					// Okay, since PVRT files are compressed and not supported by UIImage, we have to have a way
//					// of knowing the size of the PVRT file beforehand. What we'll do is, when we create the PVRT
//					// file, we'll incorporate the size into the filename, so texture1.jpg becomes texture1-512.pvr4
//					// when converted to a PVRT file, assuming it's 512x512 pixes.
//					NSString *textureFilename = nil;
//					int width = 0, height = 0;
//					for (int i=4; i <= 1028; i*=2)
//					{
//						
//						NSString *newBase = [NSString stringWithFormat:@"%@-%d", baseName, i];
//                        
//                        NSString *filePath = [basePath stringByAppendingPathComponent:newBase];
//                        NSString *fullFilePath = [filePath stringByAppendingPathExtension:@"pvr4"];
//                        if ([[NSFileManager defaultManager] fileExistsAtPath:fullFilePath]) {                
//							textureFilename = [NSString stringWithFormat:@"%@.pvr4", newBase];
//							width = i;
//							height = i;
//							break;
//						}
//                        fullFilePath = [filePath stringByAppendingPathExtension:@"pvr2"];
//						
//						if ([[NSFileManager defaultManager] fileExistsAtPath:fullFilePath])  
//						{
//							textureFilename = [NSString stringWithFormat:@"%@.pvr2", newBase];
//							width = i;
//							height = i;
//							break;
//						}
//						
//					}
//					// No PVRT file found use original file
//					if (textureFilename == nil)
//                    {
//						textureFilename = texName;
//                    }
//                    // TODO: Look for PVRT file
//                    material.textureFileName = textureFilename;
//
				}
                
			}
			[ret setObject:material forKey:material.name];
			i = mtlEnd;
		}
	}
	return ret;
}
-(void)prepareGLKBaseEffect:(GLKBaseEffect*)glkEffect
{
    UIColor *color = self.diffuse;
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    glkEffect.light0.diffuseColor = GLKVector4Make(r,g,b,a);
    color = self.specular;
    [color getRed:&r green:&g blue:&b alpha:&a];
    glkEffect.light0.specularColor = GLKVector4Make(r,g,b,a);
    color = self.ambient;
    [color getRed:&r green:&g blue:&b alpha:&a];
    glkEffect.light0.ambientColor = GLKVector4Make(r,g,b,a);
    glkEffect.light0.linearAttenuation = self.shininess;
    if (textureInfo != nil) {
        glkEffect.texture2d0.name = textureInfo.name;
        glkEffect.constantColor = GLKVector4Make(0.0, 0.0, 0.0, 1);
        glkEffect.texture2d0.enabled = YES;
        glkEffect.texture2d0.envMode = GLKTextureEnvModeDecal;
    }
    else {
        glkEffect.texture2d0.enabled = NO;
    }
    
}
-(void)bindTextureWithGLKTextureLoader
{
    if ([self.textureFileName length] > 0)
    {
        
        NSData *texData = [[NSData alloc] initWithContentsOfFile:self.textureFileName];
        
        
        NSError *error;
        NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft : @(YES)};
        textureInfo = [GLKTextureLoader textureWithContentsOfData:texData options:options error:nil];
        if (textureInfo == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
        }
        
        
    }
}
-(void)createTexture
{
    if ([self.textureFileName length] > 0) {
        NSData *texData = [[NSData alloc] initWithContentsOfFile:self.textureFileName];
        if (texData != nil) {
            
            UIImage *image = [[UIImage alloc] initWithData:texData];
            
            if (image != nil) {
                glGenTextures(1, &texture);
                glBindTexture(GL_TEXTURE_2D, texture);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
                glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
                glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
                GLuint width = CGImageGetWidth(image.CGImage);
                GLuint height = CGImageGetHeight(image.CGImage);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                void *imageData = malloc( height * width * 4 );
                CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
                CGColorSpaceRelease( colorSpace );
                CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
                CGContextTranslateCTM( context, 0, height - height );
                CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
                
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
                
                CGContextRelease(context);
                
                free(imageData);

            }
//            
//            // Assumes pvr4 is RGB not RGBA, which is how texturetool generates them
//            if ([self.textureFileName.lastPathComponent isEqualToString:@"pvr4"])
//            {
//                glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, inWidth, inHeight, 0, (inWidth * inHeight) / 2, [texData bytes]);
//            }
//            else if ([extension isEqualToString:@"pvr2"])
//                glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG, inWidth, inHeight, 0, (inWidth * inHeight) / 2, [texData bytes]);

        }


    }
    
}
-(void)bindTexture
{
    if (texture) {
        glBindTexture(GL_TEXTURE_2D, texture);
    }

}
-(void)dealloc
{
    if (texture) {
        glDeleteTextures(1, &texture);
    }
}
#pragma mark - description
- (NSString *)description
{
    CGFloat diffuseRed,diffuseGreen,diffuseBlue,diffuseAlpha;
    CGFloat ambientRed,ambientGreen,ambientBlue,ambientAlpha;
    CGFloat specularRed,specularGreen,specularBlue,specularAlpha;
    [self.diffuse getRed:&diffuseRed green:&diffuseGreen blue:&diffuseBlue alpha:&diffuseAlpha];
    [self.ambient getRed:&ambientRed green:&ambientGreen blue:&ambientBlue alpha:&ambientAlpha];
    [self.specular getRed:&specularRed green:&specularGreen blue:&specularBlue alpha:&specularAlpha];
    return [NSString stringWithFormat:@"Material: %@ (Shininess: %f, Diffuse: {%f, %f, %f, %f}, Ambient: {%f, %f, %f, %f}, Specular: {%f, %f, %f, %f})", self.name, self.shininess, diffuseRed, diffuseGreen, diffuseBlue, diffuseAlpha, ambientRed, ambientGreen, ambientBlue, ambientAlpha, specularRed, specularGreen, specularBlue, specularAlpha];
}
@end
