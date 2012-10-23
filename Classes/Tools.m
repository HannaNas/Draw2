//
//  Tools.m
//  Draw2
//
//  Created by Hanna Schneider on 10/23/12.
//
//

#import "Tools.h"
#import "Dot.h"

@implementation Tools

#pragma mark -
#pragma dots Tools

+(CGFloat)distanceBetweenPoint:(Dot *)dot1 andPoint:(Dot *)dot2{
    
    CGFloat dx =dot2.x -dot2.x;
    CGFloat dy =dot1.y -dot2.y;
    CGFloat distance =sqrtf((dx*dx)+(dy*dy));
    return distance;
}
    
    
@end

