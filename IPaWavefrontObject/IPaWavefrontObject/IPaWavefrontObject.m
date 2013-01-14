//
//  IPaWavefrontObject.m
//  IPaWavefrontObject
//
//  Created by IPaPa on 13/1/8.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "IPaWavefrontObject.h"
#import "IPaWavefrontMaterial.h"
#import "IPaWavefrontGroup.h"
#import <GLKit/GLKit.h>
@interface IPaWavefrontObject()
@property (nonatomic, readwrite) void *vertexAttributes;
@property (nonatomic, readwrite) uint vertexAttributeCount;
@property (nonatomic, readwrite) size_t vertexAttributeSize;
@property (nonatomic, readwrite) BOOL hasNormals, hasTexCoords;
@end
@implementation IPaWavefrontObject
{
    NSMutableArray *groups;

    GLuint vertexArray;
    GLuint vertexBuffer;
}

-(IPaWavefrontGroup*)createDefaultGroup
{
    IPaWavefrontGroup *group;
    //create default group
    IPaWavefrontMaterial *tempMaterial = nil;
    NSArray *materialKeys = [self.materials allKeys];
    if ([materialKeys count] == 2)
    {
        // 2 means there's one in file, plus default
        for (NSString *key in materialKeys)
        {
            if (![key isEqualToString:@"default"])
            {
                tempMaterial = [self.materials objectForKey:key];
            }
        }
    }
    if (tempMaterial == nil)
    {
        tempMaterial = [IPaWavefrontMaterial defaultMaterial];
    }
    group = [[IPaWavefrontGroup alloc] initWithName:@"default"];
    group.material = tempMaterial;
    return group;
}
- (id)initWithBasePath:(NSString*)basePath withFileName:(NSString *)fileName
{
    if ((self = [super init]))
	{
        // Get lines
        NSString *path = [basePath stringByAppendingPathComponent:fileName];
        NSString *objData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [objData componentsSeparatedByString:@"\n"];
        
        // Count number of v, vt and vn, so we can allocate temporary memory.
        IPaWavefrontGroup *currentGroup = nil;
        NSMutableArray *currentFaceData = [@[] mutableCopy];

        NSMutableDictionary *groupsFaces = [@{} mutableCopy];
//        NSMutableArray *totalVertex = [@[] mutableCopy];
//        NSMutableSet *totalVertexSet = [NSMutableSet set];
        NSMutableDictionary *totalVertexDict = [@{} mutableCopy];
        NSMutableArray *totalVertexList = [@[] mutableCopy];
        NSMutableArray *vertexList = [@[] mutableCopy];
        NSMutableArray *vertexTexCoordList = [@[] mutableCopy];
        NSMutableArray *vertexNormalList = [@[] mutableCopy];
        
        groups = [@[] mutableCopy];

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

				_materials = [IPaWavefrontMaterial materialsFromBasePath:basePath MtlFileName:truncLine];
            } else if ([line hasPrefix:@"g "]) {
                NSString *groupName = [line substringFromIndex:2];
                                
                currentGroup = [[IPaWavefrontGroup alloc] initWithName:groupName];

                [groups addObject:currentGroup];
                //reset faceCount
                currentFaceData = [@[] mutableCopy];
                groupsFaces[groupName] = currentFaceData;
                currentFaceType = -1;

            }
            else if ([line hasPrefix:@"usemtl "])
			{
                if (currentGroup == nil) {
                    currentGroup = [self createDefaultGroup];
                    groupsFaces[@"default"] = currentFaceData;
                    [groups addObject:currentGroup];
                    
                }
				NSString *materialKey = [line substringFromIndex:7];
				currentGroup.material = [self.materials objectForKey:materialKey];
			}
            else if ([line hasPrefix:@"f "]) {
                if (currentGroup == nil) {
                    currentGroup = [self createDefaultGroup];
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
        _hasTexCoords = vertexTexCoordList.count > 0;
        _hasNormals = vertexNormalList.count > 0;
        
        self.vertexAttributeSize = sizeof(GLfloat) * (3 + ((_hasNormals)?3:0) + ((_hasTexCoords)?2:0));
        // Now, it's time to collect the vertex attributes that we're really interested in
        self.vertexAttributeCount = [totalVertexDict count];
        self.vertexAttributes = calloc(self.vertexAttributeCount, self.vertexAttributeSize);
        
        NSUInteger index = 0;

        for (NSString *vertex in totalVertexList) {
            // Find the vertex attributes that we're setting
            void *vertexAttribute = (void*)(self.vertexAttributes + (index * self.vertexAttributeSize));
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

            if (_hasTexCoords) {
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
            
            if (_hasNormals) {
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
        for (IPaWavefrontGroup* group in groups) {
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
    }
    return self;
        
}

-(NSArray*)groups
{
    return groups;
}
- (void)dealloc {
    
    if (self.vertexAttributes)
        free(self.vertexAttributes);
    if (vertexBuffer) {
        glDeleteBuffers(1, &vertexBuffer);
    }
    if (vertexArray) {
        glDeleteVertexArraysOES(1, &vertexArray);
    }

}
-(void)createBuffer
{
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.vertexAttributeSize * self.vertexAttributeCount, self.vertexAttributes, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, self.vertexAttributeSize, 0);
    size_t dataOffset = sizeof(GLfloat) * 3;
    if (_hasTexCoords) {
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, self.vertexAttributeSize, (void*)dataOffset);
        dataOffset += sizeof(GLfloat) * 2;
    }
    if (_hasNormals) {
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, self.vertexAttributeSize, (void*)dataOffset);
        
    }
    glBindVertexArrayOES(0);
    

    for (IPaWavefrontGroup* group in groups) {
        [group createBuffer];
    }
    
}
-(void)bindTexturesWithGLKTextureLoader
{
    NSArray *allMaterial = [self.materials allValues];
    for (IPaWavefrontMaterial* material in allMaterial) {
        [material bindTextureWithGLKTextureLoader];
    }
}
-(void)bindBuffer
{
    if (vertexArray) {
        glBindVertexArrayOES(vertexArray);
    }
}
-(void)renderWithGLKBaseEffect:(GLKBaseEffect*)glkEffect
{
    [self bindBuffer];
    glkEffect.light0.enabled = GL_TRUE;
    for (IPaWavefrontGroup *group in groups) {
        [group renderWithGLKBaseEffect:glkEffect];
    }

}
@end
