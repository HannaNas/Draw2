//
//  Tools.m
//  Draw2
//
//  Created by Hanna Schneider on 10/23/12.
//
//

#import "Tools.h"

#import "Constants.h"
#import "Dot.h"

@implementation Tools

#pragma mark -
#pragma dots Tools

/*
 * Returns a the distance between dot1 and dot2
 *
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The distance
 */
+(CGFloat)distanceBetweenPoint:(Dot *)dot1 andPoint:(Dot *)dot2{
    
    CGFloat dx =dot2.x -dot2.x;
    CGFloat dy =dot1.y -dot2.y;
    CGFloat distance = sqrtf((dx*dx)+(dy*dy));
    return distance;
}
    
/*
 * Returns a Dot that has a constant distance from dot1 and it is in the
 * the line from dot1 to dot2
 *
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The dot
 */
+(Dot *)dotInConstantDistanceFromDot:(Dot *)dot1 toDot:(Dot *)dot2 {

    Dot *resultDot = [[Dot alloc] init];
    
    CGFloat dx = dot2.x - dot1.x;
    CGFloat dy = dot2.y - dot1.y;
    
    CGFloat absDx = fabsf(dx);
    CGFloat absDy = fabsf(dy);

    
    CGFloat normVector = sqrtf(absDx*absDx + absDy*absDy);
    
    resultDot.x = dot1.x + SAMPLING_DISTANCE * (1.0f/normVector)*dx;
    resultDot.y = dot1.y + SAMPLING_DISTANCE * (1.0f/normVector)*dy;

    return resultDot;

}

@end

