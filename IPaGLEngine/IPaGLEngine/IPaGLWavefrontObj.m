//
//  IPaGLWavefrontObj.m
//  IPaGLEngine
//
//  Created by IPaPa on 13/3/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaGLWavefrontObj.h"
#import "IPaGLRenderSource.h"
#import "IPaGLRenderer.h"
#import "IPaGLWavefrontObjRenderGroup.h"
#import "IPaGLVertexIndexes.h"
#import "IPaGLMaterial.h"
#import "IPaGLTexture.h"
#import <GLKit/GLKit.h>
@implementation IPaGLWavefrontObj
-(IPaGLWavefrontObj*)initWithFilePath:(NSString*)filePath
{
    self = [super init];
    self.filePath = filePath;
    
    NSString *basePath = [filePath stringByDeletingLastPathComponent];
    // Get lines
    
    NSString *objData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];
    
    // Count number of v, vt and vn, so we can allocate temporary memory.
    IPaGLWavefrontObjRenderGroup *currentGroup = nil;
    NSMutableArray *currentFaceData = [@[] mutableCopy];
    
    NSMutableDictionary *groupsFaces = [@{} mutableCopy];
    //        NSMutableArray *totalVertex = [@[] mutableCopy];
    //        NSMutableSet *totalVertexSet = [NSMutableSet set];
    NSMutableDictionary *totalVertexDict = [@{} mutableCopy];
    NSMutableArray *totalVertexList = [@[] mutableCopy];
    NSMutableArray *vertexList = [@[] mutableCopy];
    NSMutableArray *vertexTexCoordList = [@[] mutableCopy];
    NSMutableArray *vertexNormalList = [@[] mutableCopy];
    NSMutableArray *groups = [@[] mutableCopy];
    NSMutableDictionary *groupsDict = [@{} mutableCopy];
    
    NSInteger currentFaceType = -1;
    for (NSString *_line in lines) {
        NSString *line = [_line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([line hasPrefix:@"v "]) {
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *lineComponents = [lineTrunc componentsSeparatedByString:@" "];
            [vertexList addObject:lineComponents];
            
        } else if ([line hasPrefix:@"vt "]) {
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineComponents = [lineTrunc componentsSeparatedByString:@" "];
            [vertexTexCoordList addObject:lineComponents];
        } else if ([line hasPrefix:@"vn "]) {
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineComponents = [lineTrunc componentsSeparatedByString:@" "];
            [vertexNormalList addObject:lineComponents];
            
        } else if ([line hasPrefix:@"mtllib "]) {
            NSString *truncLine = [line substringFromIndex:7];
            
            self.materials = [IPaGLWavefrontObj loadIPaGLMaterialsFromMTLFile:truncLine withBasePath:basePath];
        } else if ([line hasPrefix:@"g "]) {
            NSString *groupName = [line substringFromIndex:2];
            currentGroup = [groupsDict objectForKey:groupName];
            if (currentGroup == nil) {
                currentGroup = [[IPaGLWavefrontObjRenderGroup alloc] initWithName:groupName];
                [groups addObject:currentGroup];
                currentFaceData = [@[] mutableCopy];
                groupsFaces[groupName] = currentFaceData;
                groupsDict[groupName] = currentGroup;
            }
            else {
                currentFaceData = groupsFaces[groupName];
            }
            
            
            //reset faceCount
            
            currentFaceType = -1;
            
        }
        else if ([line hasPrefix:@"usemtl "])
        {
            if (currentGroup == nil) {
                currentGroup = [[IPaGLWavefrontObjRenderGroup alloc] initWithName:@"default"];
                groupsFaces[@"default"] = currentFaceData;
                [groups addObject:currentGroup];
                groupsDict[@"default"] = currentGroup;
            }
            NSString *materialKey = [line substringFromIndex:7];
            currentGroup.material = [self.materials objectForKey:materialKey];
        }
        else if ([line hasPrefix:@"f "]) {
            if (currentGroup == nil) {
                currentGroup = [[IPaGLWavefrontObjRenderGroup alloc] initWithName:@"default"];
                groupsFaces[@"default"] = currentFaceData;
                [groups addObject:currentGroup];
                groupsDict[@"default"] = currentGroup;
            }
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *lineComponents = [lineTrunc componentsSeparatedByString:@" "];
            
            
            
            if (currentFaceType == -1)
            {
                //check current face type
                NSString *vertexComponent = lineComponents[0];
                NSArray *result = [vertexComponent componentsSeparatedByString:@"//"];
                if (result.count == 2) {
                    //vertex // normal
                    currentFaceType = 0;
                }
                else {
                    result = [vertexComponent componentsSeparatedByString:@"/"];
                    //currentFaceType = 1: vertex only, 2:vertex/textCoord, 3:vertex/textCoord/normal
                    currentFaceType = result.count;
                }
            }
            for (NSString *lineComponent in lineComponents) {
                NSString *processString = @"0/0/0";
                switch (currentFaceType) {
                    case 0:
                    {
                        //vertex // normal
                        NSArray *result = [lineComponent componentsSeparatedByString:@"//"];
                        
                        processString = [NSString stringWithFormat:@"%@/0/%@",result[0],result[1]];
                    }
                        break;
                    case 1:
                    {
                        //vertex only
                        processString = [NSString stringWithFormat:@"%@/0/0",lineComponent];
                    }
                        break;
                    case 2:
                    {
                        //vertex/textCoord
                        NSArray *result = [lineComponent componentsSeparatedByString:@"/"];
                        processString = [NSString stringWithFormat:@"%@/%@/0",result[0],result[1]];
                    }
                        break;
                    case 3:
                    {
                        //vertex/textCoord/normal
                        processString = lineComponent;
                        //                            NSArray *result = [lineComponent componentsSeparatedByString:@"/"];
                        //                            processString = [NSString stringWithFormat:@"%@/%@/%@",result[0],result[1],result[2]];
                    }
                        break;
                    default:
                        break;
                }
                
                NSNumber *currentIdx = totalVertexDict[processString];
                if (currentIdx == nil) {
                    currentIdx = @(totalVertexDict.count);
                    totalVertexDict[processString] = currentIdx;
                    [totalVertexList addObject:processString];
                }
                [currentFaceData addObject:currentIdx];
                //                    [totalVertexSet addObject:processString];
                
                
            }
            
        }
    }
    
    // See if we have texcoords and normals
    self.attrHasTexCoords = vertexTexCoordList.count > 0;
    self.attrHasNormal = vertexNormalList.count > 0;
    self.attrHasPosZ = YES;
    size_t vertexAttributeSize = sizeof(GLfloat) * (3 + ((self.attrHasNormal)?3:0) + ((self.attrHasTexCoords)?2:0));
    // Now, it's time to collect the vertex attributes that we're really interested in
    self.vertexAttributeCount = [totalVertexDict count];
    self.vertexAttributes = malloc(vertexAttributeSize * self.vertexAttributeCount);
    
    
    NSUInteger index = 0;
    
    for (NSString *vertex in totalVertexList) {
        // Find the vertex attributes that we're setting
        void *vertexAttribute = (void*)(self.vertexAttributes + (index * vertexAttributeSize));
        NSArray *data = [vertex componentsSeparatedByString:@"/"];
        NSInteger vertexIdx = [data[0] integerValue] - 1;
        NSArray *vertexData = vertexList[vertexIdx];
        GLfloat vertexValue[3];
        size_t dataSize;
        
        vertexValue[0] = [vertexData[0] floatValue];
        vertexValue[1] = [vertexData[1] floatValue];
        vertexValue[2] = [vertexData[2] floatValue];
        dataSize = sizeof(GLfloat)*3;
        memcpy(vertexAttribute, vertexValue, dataSize);
        vertexAttribute = (void*)(vertexAttribute + dataSize);
        
        if (self.attrHasTexCoords) {
            vertexIdx = [data[1] integerValue] - 1;
            
            if (vertexIdx >= 0) {
                vertexData = vertexTexCoordList[vertexIdx];
                vertexValue[0] = [vertexData[0] floatValue];
                vertexValue[1] = [vertexData[1] floatValue];
                
            }
            else {
                vertexValue[0] = 0;
                vertexValue[1] = 0;
            }
            dataSize = sizeof(GLfloat)*2;
            memcpy(vertexAttribute, vertexValue, dataSize);
            vertexAttribute = (void*)(vertexAttribute + dataSize);
        }
        
        if (self.attrHasNormal) {
            vertexIdx = [data[2] integerValue] - 1;
            if (vertexIdx >= 0) {
                vertexData = vertexNormalList[vertexIdx];
                vertexValue[0] = [vertexData[0] floatValue];
                vertexValue[1] = [vertexData[1] floatValue];
                vertexValue[2] = [vertexData[2] floatValue];
                
            }
            else {
                vertexValue[0] = 0;
                vertexValue[1] = 0;
                vertexValue[2] = 0;
            }
            dataSize = sizeof(GLfloat)*3;
            memcpy(vertexAttribute, vertexValue, dataSize);
            vertexAttribute = (void*)(vertexAttribute + dataSize);
        }
        
        
        index++;
    }
    [self createBufferStatic];
    //        NSArray *totalVertex = [totalVertexSet allObjects];
    for (IPaGLWavefrontObjRenderGroup* group in groups) {
        NSArray *facesList = groupsFaces[group.name];
        
        NSUInteger indexNumber = facesList.count;
        NSUInteger index = 0;
        GLushort *vertexIndexes = malloc(indexNumber * sizeof(GLushort));
        for (NSNumber* faceVertex in facesList) {
            GLushort faceIdx = [faceVertex unsignedShortValue];
            //                GLushort faceIdx = (GLushort)[totalVertex indexOfObject:faceVertex];
            memcpy(&vertexIndexes[index], &faceIdx, sizeof(GLushort));
            
            index++;
        }
        IPaGLVertexIndexes *glVertexIndexes = [[IPaGLVertexIndexes alloc] initWithVertexIndexes:vertexIndexes withIndexNumber:indexNumber];
        
        group.vertexIndexes = glVertexIndexes;
        
        
        
        
    }
    self.renderGroup = groups;
    
    
    return self;
}
-(void)dealloc
{
    for (IPaGLMaterial* material in self.materials.allValues) {
        [material releaseResource];
    }
    self.materials = nil;
}
-(void)renderWithRenderer:(IPaGLRenderer *)renderer
{
    [super renderWithRenderer:renderer];
    
    
    for (IPaGLWavefrontObjRenderGroup* group in self.renderGroup) {
        [group.vertexIndexes bindBuffer];
        [renderer prepareToRenderWithMaterial:group.material];
        
        glDrawElements(GL_TRIANGLES, group.vertexIndexes.indexNumber,GL_UNSIGNED_SHORT, 0);
    }
    
}

+(NSDictionary*)loadIPaGLMaterialsFromMTLFile:(NSString*)fileName withBasePath:(NSString*)basePath
{
    NSString *path = [basePath stringByAppendingPathComponent:fileName];
	NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    
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
            
			
			IPaGLMaterial *material = [[IPaGLMaterial alloc] init];
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
                    
                    NSString *textureFileName = [basePath stringByAppendingPathComponent:[parseLine substringFromIndex:7]];
                    IPaGLTexture* texture = [IPaGLTexture textureFromFile:textureFileName];
                    material.texture = texture;
                    
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

@end
