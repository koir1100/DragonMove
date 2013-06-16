//
//  Snake.h
//
//  Created by Sander Vispoel on 4/8/13.
//  Revised by Yonggu Choi on 16/6/13.
//
//

#import "CCSprite.h"

#define SNAKE_WIDTH     8.0
#define SNAKE_HEIGHT    8.0

#define MOVE_RIGHT      1
#define MOVE_LEFT       3
#define MOVE_UP         2
#define MOVE_DOWN       4


@interface Snake : CCSprite
{
    int _directionFlag; // 가리키는 flag 값
    
    NSMutableArray *_arrayChangePoint; // 좌표 변경할 때 필요한 배열
    NSMutableArray *_arrayDirectionFlags; // 방향 flag 배열
}

@property (nonatomic, assign) int directionFlag;
@property (assign) NSMutableArray *arrayDirectionFlags;
@property (assign) NSMutableArray *arrayChangePoint;

// direction flag
-(void)addDirectionFlag:(int)flag;
-(void)removeDirectionFlagAtIndex:(int)i;
-(int)getDirectionFlagAtIndex:(int)i;
-(int)getDirectionFlagsCount;

// change point
-(void)addChangePoint:(CGPoint)point;
-(void)removeChangePointAtIndex:(int)i;
-(CGPoint)getChangePointAtIndex:(int)i;
-(int)getChangePointsCount;

@end
