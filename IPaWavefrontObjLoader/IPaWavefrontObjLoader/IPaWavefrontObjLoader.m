//
//  IPaWavefrontObjLoader.m
//  IPaWavefrontObjLoader
//
//  Created by IPaPa on 13/1/12.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaWavefrontObjLoader.h"
#import "IPaGLObject.h"
#import "IPaGLRenderGroup.h"
#import "IPaGLMaterial.h"
@implementation IPaWavefrontObjLoader
+(IPaGLObject*)loadIPaGLObjectFromObjFile:(NSString*)filePath
{
    IPaGLObject *glObject = [[IPaGLObject alloc] init];
    
	
    NSString *basePath = [filePath stringByDeletingLastPathComponent];
    // Get lines
        
    NSString *objData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];
        
        // Count number of v, vt and vn, so we can allocate temporary memory.
    IPaGLRenderGroup *currentGroup = nil;
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
            
            glObject.materials = [self loadIPaGLMaterialsFromMTLFile:truncLine withBasePath:basePath];
        } else if ([line hasPrefix:@"g "]) {
            NSString *groupName = [line substringFromIndex:2];
            
            currentGroup = [[IPaGLRenderGroup alloc] initWithName:groupName];
            
            [groups addObject:currentGroup];
            //reset faceCount
            currentFaceData = [@[] mutableCopy];
            groupsFaces[groupName] = currentFaceData;
            currentFaceType = -1;
            
        }
        else if ([line hasPrefix:@"usemtl "])
        {
            if (currentGroup == nil) {
                currentGroup = [[IPaGLRenderGroup alloc] initWithName:@"default"];
                groupsFaces[@"default"] = currentFaceData;
                [groups addObject:currentGroup];
                
            }
            NSString *materialKey = [line substringFromIndex:7];
            currentGroup.material = [glObject.materials objectForKey:materialKey];
        }
        else if ([line hasPrefix:@"f "]) {
            if (currentGroup == nil) {
                currentGroup = [[IPaGLRenderGroup alloc] initWithName:@"default"];
                groupsFaces[@"default"] = currentFaceData;
                [groups addObject:currentGroup];
                
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
    glObject.hasTexCoords = vertexTexCoordList.count > 0;
    glObject.hasNormals = vertexNormalList.count > 0;
    
    glObject.vertexAttributeSize = sizeof(GLfloat) * (3 + ((glObject.hasNormals)?3:0) + ((glObject.hasTexCoords)?2:0));
    // Now, it's time to collect the vertex attributes that we're really interested in
    glObject.vertexAttributeCount = [totalVertexDict count];
    glObject.vertexAttributes = calloc(glObject.vertexAttributeCount, glObject.vertexAttributeSize);
    
    NSUInteger index = 0;
    
    for (NSString *vertex in totalVertexList) {
        // Find the vertex attributes that we're setting
        void *vertexAttribute = (void*)(glObject.vertexAttributes + (index * glObject.vertexAttributeSize));
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
        
        if (glObject.hasTexCoords) {
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
        
        if (glObject.hasNormals) {
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
    
    //        NSArray *totalVertex = [totalVertexSet allObjects];
    for (IPaGLRenderGroup* group in groups) {
        NSArray *facesList = groupsFaces[group.name];
        
        group.indexNumber = facesList.count;
        NSUInteger index = 0;
        
        for (NSNumber* faceVertex in facesList) {
            GLushort faceIdx = [faceVertex unsignedShortValue];
            //                GLushort faceIdx = (GLushort)[totalVertex indexOfObject:faceVertex];
            memcpy(&group.vertexIndexes[index], &faceIdx, sizeof(GLushort));
            
            index++;
        }
        
        
        
        
    }
    glObject.groups = groups;
    return glObject;
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
                    NSDictionary * options = @{ GLKTextureLoaderOriginBottomLeft : @(YES)};
					material.textureInfo = [GLKTextureLoader textureWithContentsOfFile:textureFileName options:options error:nil];
                    
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
