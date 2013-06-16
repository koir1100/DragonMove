//
//  Snake.m
//
//  Created by Sander Vispoel on 4/8/13.
//  Revised by Yonggu Choi on 6/16/13.
//
//

#import "cocos2d.h"
#import "Snake.h"

@implementation Snake

@synthesize directionFlag=_directionFlag, arrayDirectionFlags=_arrayDirectionFlags, arrayChangePoint=_arrayChangePoint;

-(void)dealloc
{
    [[self arrayChangePoint] removeAllObjects];
    // 좌표 변경 배열의 원소값들을 모두 삭제.
    [[self arrayDirectionFlags] removeAllObjects];
    // 방향 flag 배열의 원소값들을 모두 삭제.

    [super dealloc];
}

-(id)init
{
    if((self=[super init])) {
        
        _directionFlag = MOVE_RIGHT;
        // default로 처음 방향 flag은 오른쪽으로 이동.
        
        _arrayDirectionFlags = [[NSMutableArray alloc] init];
        // 방향 flag의 배열 선언
        _arrayChangePoint = [[NSMutableArray alloc] init];
        // 좌표 변경을 위한 배열 선언
        
        [self initWithFile:@"dot.png"]; // 점들로 뱀을 표현
    }
    
    return self;
}

#pragma mark - DirectionFlag

-(void)addDirectionFlag:(int)flag
{
    [_arrayDirectionFlags addObject:[NSNumber numberWithInt:flag]];
    // flag 값을 방향 flag 배열에 저장.
    // 오른쪽은 1, 왼쪽은 3, 위쪽은 2, 아래쪽은 4.
}

-(void)removeDirectionFlagAtIndex:(int)i
{
    [_arrayDirectionFlags removeObjectAtIndex:i];
    // 방향 flag 배열에 저장된 flag 값을 제거.
}

-(int)getDirectionFlagAtIndex:(int)i
{
    return [[_arrayDirectionFlags objectAtIndex:i] integerValue];
    // 방향 flag 배열의 i번째에 있는 원소에 있는 정수값을 반환.
}

-(int)getDirectionFlagsCount
{
    return [_arrayDirectionFlags count];
    // 방향 flag 배열의 원소값을 반환.
}

#pragma mark - ChangePoint

-(void)addChangePoint:(CGPoint)point
{
    [_arrayChangePoint addObject:[NSNumber valueWithCGPoint:point]];
    // 함수 바깥에 있는 좌표값으로 좌표를 변경하는 배열에 삽입.
}

-(void)removeChangePointAtIndex:(int)i
{
    [_arrayChangePoint removeObjectAtIndex:i];
    // 좌표 변경하는 배열의 i번째 원소에 있는 좌표값을 삭제.
}

-(CGPoint)getChangePointAtIndex:(int)i
{
    return [[_arrayChangePoint objectAtIndex:i] CGPointValue];
    // 좌표 변경 배열의 i번째에 있는 원소의 좌표값을 반환.
}

-(int)getChangePointsCount
{
    return [_arrayChangePoint count];
    // 좌표 변경 배열의 원소값을 반환.
}

@end
