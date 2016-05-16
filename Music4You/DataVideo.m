//
//  DataVideo.m
//  Music4You
//
//  Created by BMXStudio03 on 2/16/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import "DataVideo.h"

@implementation DataVideo

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.thumbnailVideo forKey:@"thumbnailVideo"];
    [encoder encodeObject:self.titleVideo forKey:@"titleVideo"];
    [encoder encodeObject:self.idVideo forKey:@"idVideo"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.thumbnailVideo = [decoder decodeObjectForKey:@"thumbnailVideo"];
        self.titleVideo = [decoder decodeObjectForKey:@"titleVideo"];
        self.idVideo = [decoder decodeObjectForKey:@"idVideo"];
    }
    return self;
 
}
@end
