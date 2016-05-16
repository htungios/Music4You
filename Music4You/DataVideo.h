//
//  DataVideo.h
//  Music4You
//
//  Created by BMXStudio03 on 2/16/16.
//  Copyright © 2016 Neo-Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataVideo : NSObject
@property (strong ,nonatomic) NSString *thumbnailVideo;
@property (strong ,nonatomic) NSString *titleVideo;
@property (strong ,nonatomic) NSString *idVideo;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;


@end
