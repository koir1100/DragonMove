//
//  Created by Sander Vispoel on 4/8/13.
//  Reviesed by Yonggu Choi on 16/6/13.
//

#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "GameOverLayer.h"
#import "GameBoard.h"
#import "Snake.h"

#define WALL_RIGHT      472.0
#define WALL_LEFT       4.0
#define WALL_TOP        312.0
#define WALL_BOTTOM     80.0

#define FIELD_WIDTH     472
#define FIELD_HEIGHT    240

#define COLLISION_WALL       1
#define COLLISION_CANDY      2
#define COLLISION_FAKE       3
#define COLLISION_MINUS      4
#define COLLISION_SPEED_SLOW 5
#define COLLISION_SPEED_FAST 6

#define TAG_HEAD        1

@implementation GameBoard

@synthesize maxPartTag=_maxPartTag, dpad=_dpad;
@synthesize maxEnemyTag=_maxEnemyTag;
@synthesize greenConcentration=_greenConcentration;
@synthesize message;
@synthesize checkItemEffect=_checkItemEffect;

#pragma mark - deallocs

-(void)dealloc
{
    [_fieldOpen release];
    _fieldOpen = nil;
    [_fieldTaken release];
    _fieldTaken = nil;
    
    [self unscheduleAllSelectors];
    [self stopAllActions];
    
    [super dealloc];
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    // targeted touch delegate가 layer에서 필요 없을 때 처리.
    
    [sae stopBackgroundMusic]; // 배경 음악 정지.
    [_tails removeAllChildrenWithCleanup:YES];
    [_candy removeAllChildrenWithCleanup:YES];
    // 꼬리와 캔디 삭제.
    
    [super onExit];
}

#pragma mark - initializers

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate
{
    return YES;
}

-(id)init
{
    if((self=[super init]))
    {
        sae = [SimpleAudioEngine sharedEngine];
        [sae preloadEffect:@"yummy.wav"];
        [sae preloadEffect:@"item.wav"];
        [sae preloadEffect:@"scream.wav"];
        // 효과음 재생을 위한 미리 읽어옴.
        
        CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"btn_pause.png" selectedImage:@"btn_pause_s.png" target:self selector:@selector(doClick:)];
        
        item1.tag = 1440;
        menu1 = [CCMenu menuWithItems:item1, nil];
        menu1.position = ccp(450, 300); // pause 버튼 위치 지정
        menu1.opacity = 150; // 투명도 조절
    
        [self addChild:menu1 z:1000];
        
        [self supportedInterfaceOrientations];
        [self shouldAutorotate];
        
        _tails = [CCNode node];
        [self addChild:_tails];
        // 꼬리를 담기 위한 빈 노드 node 할당 및 삽입.
        
        _enemy = [CCNode node];
        [self addChild:_enemy];
        // 적을 담기 위한 빈 노드 node 할당 및 삽입.
        
        _candy = [[CCSprite alloc] initWithFile:@"item_candy.png"];
        [self addChild:_candy];
        _fakeCandy = [[CCSprite alloc] initWithFile:@"item_candy.png"];
        _fakeCandy.opacity = 0;
        [self addChild:_fakeCandy];
        _removeTail = [[CCSprite alloc] initWithFile:@"item_minus.png"];
        _removeTail.opacity = 0;
        [self addChild:_removeTail];
        _speedSlow = [[CCSprite alloc] initWithFile:@"item_slow.png"];
        _speedSlow.opacity = 0;
        [self addChild:_speedSlow];
        _speedFast = [[CCSprite alloc] initWithFile:@"item_fast.png"];
        _speedFast.opacity = 0;
        [self addChild:_speedFast];
        // 아이템 삽입.
        
        _interface = [[InterfaceLayer alloc] init];
        [_interface setPlayerScorePositionX:64.0 Y:32.0];
        [self addChild:_interface];
        // InterfaceLayer의 객체 _interface 할당, 이를 이용하여 점수 출력.
        
        _dpad = [[CCSprite alloc] initWithFile:@"d-pad.png"];
        _dpad.position = ccp( (480 - (64/2)) - 8, (64/2) );
        // screen height - dpad's height(also width) divided by 2, - 8px correction.
        _dpad.tag = 1;
        [self addChild:_dpad];
        // direction pad(방향 전환을 위한 패드) 생성, 위치 지정, 태그값 지정한 후 self에 삽입.
        
        self.message = [MessageNode node];
		[self addChild:self.message z:1200 tag:500];
        // MessageNode의 객체 _node 할당, 이를 이용하여 게임 진행에 필요한 메시지 출력.
        
        _checkItemEffect = 0; // 아이템 효과가 적용되지 않도록 초기화.
        
        // saves open and taken field spots
        _fieldOpen = [[NSMutableArray alloc] init];
        _fieldTaken = [[NSMutableArray alloc] init];
        
        for (int x = 8; x <= FIELD_WIDTH; x += 8)
        {
            for (int y = 80; y <= FIELD_HEIGHT; y += 8)
            {
                [_fieldOpen addObject:[NSValue valueWithCGPoint:ccp(x,y)]];
                // 게임 영역을 채움.
            }
        }
        // 게임 영역이 열림
        
        // 가장 나중에 있는 태그값을 저장
        _maxPartTag = 0;
        _maxEnemyTag = 0;
    }
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    // 터치를 가능하게 해줌.
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    // 게임 시작.
    [self startGame];
}

-(void)doClick:(id)sender
{
    // 태그 값을 받아서 pause(tag값 1440), resume(tag값 1541) 동작.
    CCMenuItem *item = (CCMenuItem *)sender;
    
    if(item.tag == 1440)
    {
        [[CCDirector sharedDirector] pause];
        [self removeChild:menu1 cleanup:YES];
        
        CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"btn_resume.png" selectedImage:@"btn_resume_s.png" target:self selector:@selector(doClick:)];
        
        item2.tag = 1541;
        menu2 = [CCMenu menuWithItems:item2, nil];
        menu2.position = ccp(450, 300);
        menu2.opacity = 150;
        
        [self addChild:menu2 z:1000];
    }
    
    if(item.tag == 1541)
    {
        [[CCDirector sharedDirector] resume];
        [self removeChild:menu2 cleanup:YES];
        
        CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"btn_pause.png" selectedImage:@"btn_pause_s.png" target:self selector:@selector(doClick:)];
        
        item1.tag = 1440;
        menu1 = [CCMenu menuWithItems:item1, nil];
        menu1.position = ccp(450, 300);
        menu1.opacity = 150;
        
        [self addChild:menu1 z:1000];
    }
}

-(void)startGame
{
    // 게임 시작 함수.
    if ([[_tails children] count] > 0)
    {
        _maxPartTag = 0;
        [_interface setPlayerScore:0];
        [_interface setPlayerScorePositionX:64 Y:32];
    }
    
    [self setupSnake]; // 뱀을 설정
    [self placeCandy]; // 사탕 지정
    
    [self schedule:@selector(gameTick:) interval:0.1f];
    // 0.1초 간격으로 gameTick 함수를 불러옴.
}

-(void)gameOver
{  
    [self unscheduleAllSelectors];
    [self stopAllActions];
    // 게임을 종료시킴.
    
    CCScene *gameOverScene = [GameOverLayer sceneGameOver:_interface];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
    // 게임 종료 장면으로 replaceScene 함.
}

#pragma mark - world stuff

-(void)removeFromFieldOpen:(Snake *)snake
{
    for (NSValue *value in _fieldOpen)
    {
        // 게임 영역을 채운 좌표값들(객체를 구조체화 한 NSValue)이 반복문 조건.
        CGPoint pos = [value CGPointValue];
        // 구조체 중 좌표값을 담고 있는 멤버 변수를 좌표를 담는 pos에 할당.
        
        if (CGPointEqualToPoint(pos, snake.position))
        {
            [_fieldOpen removeObject:value];
            break;
            // 뱀의 위치와 게임 영역 좌표가 서로 같으면 게임 영역의 좌표 중에서 value를 제거.
            // 충돌을 방지하고자 나열하기를 중단함.
        }
    }
}

-(void)addToFieldTaken:(Snake *)snake
{
    CGPoint pos = snake.position;
    // 인자로 snake 객체를 가져와 위치를 pos에 할당
    [_fieldTaken addObject:[NSValue valueWithCGPoint:pos]];
    // 좌표 pos 값을 NSValue를 이용하여 게임 영역에 가져감.
}

#pragma mark - Snake Stuff

-(void)setupSnake
{
    _greenConcentration = 255;
    for (int i = 0; i < 8; i++)
    {
        [self performSelector:@selector(addSnakePartToField:) withObject:_greenConcentration];
        _greenConcentration -= 5;
    }
    // 게임 영역에 초기 설정된 뱀을 추가.
}

-(void)addSnakePartToField:(int)greenColor
{
    // 뱀의 객체 new를 할당.
    Snake *new = [[Snake alloc] init];
    [new setColor:ccc3(8, greenColor, 147)];

    // CCNode에 new를 빈 노드 _tails에 추가.
    [_tails addChild:new];
    
    // 객체 new의 태그값을 가장 나중에 있는 태그값에 1을 부여.
    new.tag = _maxPartTag+1;
    _maxPartTag = new.tag;
    // 이 태그값을 게임 영역에 가장 나중에 있는 태그값으로 할당.
    
    // 게임 영역에 뱀의 첫 부분인 머리를 삽입하고 정지됨.
    if (new.tag == TAG_HEAD)
    {
        new.position = ccp(64, 96);
        // 왼쪽 하단부에 뱀 객체 new 설정
        return;
    }
    
    CGFloat x;
    CGFloat y;
    
    Snake *tail = (Snake *)[_tails getChildByTag:(new.tag -1)];
    /* 뱀의 객체 tail을 선언하여 노드 _tails에 있는 여러 객체 중에 뱀의 객체 new의 태그값에 1을 뺀 것을 뱀의 꼬리로 할당. */

    // 새로운 부분에 위치되도록, 'switch - case문'을 통해 방향을 설정.
    switch (tail.directionFlag)
    // 조건 : 꼬리의 방향 flag값(1은 오른쪽, 3은 왼쪽, 2는 위쪽, 4는 아래쪽).
    {
        case MOVE_RIGHT:
        {
            x = tail.position.x - SNAKE_WIDTH;
            y = tail.position.y;
            break;
        }
            
        case MOVE_LEFT:
        {
            x = tail.position.x + SNAKE_WIDTH;
            y = tail.position.y;
            break;
        }
        
        case MOVE_UP:
        {
            x = tail.position.x;
            y = tail.position.y - SNAKE_HEIGHT;
            break;
        }
            
        case MOVE_DOWN:
        {
            x = tail.position.x;
            y = tail.position.y + SNAKE_HEIGHT;
            break;
        }
            
        default:
            break;
    }

    // 가장 나중의 부분(꼬리)의 현재의 방향 flag값을 뱀의 객체 new의 방향 flag에 전달.
    new.directionFlag = tail.directionFlag;
    
    // 배열을 상속받음.
    // 방향 flag값과 좌표 변경에 필요한 배열은 서로 유사함.
    for (int i = 0; i < [tail getDirectionFlagsCount]; i++)
    {
        // 방향 Flag
        [new addDirectionFlag:[tail getDirectionFlagAtIndex:i]];
        // 변경할 좌표값도 마찬가지.
        [new addChangePoint:[tail getChangePointAtIndex:i]];
    }

    // 그리고 마침내, 게임 영역에 객체 new를 위치.
    new.position = ccp(x,y);
}

-(void)minusSnakePartToField
{
    // 뱀의 객체 new를 할당.
    Snake *new = [[Snake alloc] init];
    
    // 노드 _tails에 있는 뱀의 꼬리를 제거.
    if(_maxPartTag > 2)
    {
        [_tails removeChildByTag:_maxPartTag cleanup:YES];
        [self.message showMessage:SNAKE_MINUS_MESSAGE];
        
        // 객체 new의 태그값을 가장 나중에 있는 태그값에 1을 뺌.
        // 이 태그값을 게임 영역에 가장 나중에 있는 태그값으로 할당.
        new.tag = _maxPartTag-1;
        _maxPartTag = new.tag;
    }
    else if(_maxPartTag == 2)
    {
        // 뱀의 꼬리의 태그가 2인 경우 제거할 수 없도록 함.
        [self.message showMessage:INEFFECTIVE_ITEM_MESSAGE];
        return;
    }
    
    CGFloat x;
    CGFloat y;
    
    Snake *tail = (Snake *)[_tails getChildByTag:(new.tag -1)];
    /* 뱀의 객체 tail을 선언하여 노드 _tails에 있는 여러 객체 중에
     뱀의 객체 new의 태그값에 1을 뺀 것을 뱀의 꼬리로 할당. */
    
    // 새로운 부분에 위치되도록, 'switch - case문'을 통해 방향을 설정.
    switch (tail.directionFlag)
    // 조건 : 꼬리의 방향 flag값(1은 오른쪽, 3은 왼쪽, 2는 위쪽, 4는 아래쪽).
    {
        case MOVE_RIGHT:
        {
            x = tail.position.x - SNAKE_WIDTH;
            y = tail.position.y;
            break;
        }
            
        case MOVE_LEFT:
        {
            x = tail.position.x + SNAKE_WIDTH;
            y = tail.position.y;
            break;
        }
            
        case MOVE_UP:
        {
            x = tail.position.x;
            y = tail.position.y - SNAKE_HEIGHT;
            break;
        }
            
        case MOVE_DOWN:
        {
            x = tail.position.x;
            y = tail.position.y + SNAKE_HEIGHT;
            break;
        }
            
        default:
            break;
    }
    
    // 가장 나중의 부분(꼬리)의 현재의 방향 flag값을 뱀의 객체 new의 방향 flag에 전달.
    new.directionFlag = tail.directionFlag;
    
    // 배열을 상속받음.
    // 방향 flag값과 좌표 변경에 필요한 배열은 서로 유사함.
    for (int i = 0; i < [tail getDirectionFlagsCount]; i++)
    {
        // 방향 Flag
        [new addDirectionFlag:[tail getDirectionFlagAtIndex:i]];
        // 변경할 좌표값도 마찬가지.
        [new addChangePoint:[tail getChangePointAtIndex:i]];
    }
    
    // 그리고 마침내, 게임 영역에 객체 new를 위치.
    new.position = ccp(x,y);
}

#pragma mark - EnemySnake Stuff

-(void)setupEnemy
{
    // 적의 태그(dot의 개수)를 0으로 초기화 함.
    _maxEnemyTag = 0;
    int Random = arc4random() % 270 + 80;
    // 임의의 높이값을 지정.
    int randomDirection = arc4random() % 100;
    // 임의의 방향을 지정하고자 0부터 99까지 임의의 값 할당.
    
    for (int i = 0; i < 8; i++)
        [self performSelector:@selector(addEnemyPartToField:direction:) withObject:Random withObject:randomDirection];
    // 게임 영역에 적을 추가.
}

-(void)addEnemyPartToField:(int)positionRandom direction:(int)direction
{
    Snake *Enemy = [[Snake alloc] init];
    
    [Enemy setColor:ccc3(155, 0, 0)];
    // CCNode에 Enemy를 _enemy에 추가.
    [_enemy addChild:Enemy z:1000];
    
    // 적의 dot 개수를 증가하는 부분.
    Enemy.tag = _maxEnemyTag;
    Enemy.tag = _maxEnemyTag + 1;
    _maxEnemyTag = Enemy.tag;
    
    positionRandom -= Enemy.contentSize.height;
    // 적의 높이의 길이를 임의의 높이값에 빼서 게임 영역안에 위치하도록 지정.
    
    // 게임 영역에 뱀의 첫 부분인 머리를 삽입하고 정지됨.
    if (Enemy.tag == TAG_HEAD)
    {
        Enemy.position = ccp(FIELD_WIDTH/2, positionRandom);
        // width는 중앙에, 높이는 임의의 값에 뱀 객체 Enemy 설정
        return;
    }
    
    CGFloat x;
    CGFloat y;
    
    Snake *enemyTail = (Snake *)[_enemy getChildByTag:(Enemy.tag -1)];
    /* 뱀의 객체 enemyTail을 선언하여 노드 _enemy에 있는 여러 객체 중에 적의 객체 Enemy의 태그값에 1을 뺀 것을 뱀의 꼬리로 할당. */
    
    // 새로운 부분에 위치되도록, 'switch - case문'을 통해 방향(0부터 49까지는 오른쪽, 50부터 99까지는 왼쪽)을 설정.
    
    if( direction > 50 )
        enemyTail.directionFlag = MOVE_RIGHT;
    else
        enemyTail.directionFlag = MOVE_LEFT;
    
    switch ( enemyTail.directionFlag )
    // 조건 : 꼬리의 방향 flag값(1은 오른쪽, 3은 왼쪽).
    {
        case MOVE_RIGHT:
        {
            x = enemyTail.position.x - SNAKE_WIDTH;
            y = enemyTail.position.y;
            break;
        }
            
        case MOVE_LEFT:
        {
            x = enemyTail.position.x + SNAKE_WIDTH;
            y = enemyTail.position.y;
            break;
        }
            
        default:
            break;
    }
    
    // 가장 나중의 부분(꼬리)의 현재의 방향 flag값을 뱀의 객체 Enemy의 방향 flag에 전달.
    Enemy.directionFlag = enemyTail.directionFlag;
    
    // 그리고 마침내, 게임 영역에 객체 Enemy를 위치.
    Enemy.position = ccp(x, y);
}

-(void)moveEnemy
{
    for (Snake *s in [_enemy children])
    {
        if ((s.position.x > FIELD_WIDTH + s.contentSize.width/2) || (s.position.x < s.contentSize.width/2))
            [_enemy removeAllChildrenWithCleanup:YES];
        
        CGFloat x = s.position.x;
        CGFloat y = s.position.y;
        // NSLog(@"장애물 뱀의 y좌표 : %f", y);
        
        // 노드 _enemy에 있는 뱀의 좌표를 계속 가져오는 반복문으로, 여러 좌표 중 하나에 위치해 있다면 방향 flag를 변경해야 함.
        
        switch (s.directionFlag)
        {
            case MOVE_RIGHT:
            {
                x += SNAKE_WIDTH;
                break;
            }
            case MOVE_LEFT:
            {
                x -= SNAKE_WIDTH;
                break;
            }
            default:
                // MOVE_RIGHT
                x += SNAKE_WIDTH;
                break;
        }
        // Snake의 객체 s의 위치 지정.
        s.position = ccp(x,y);
    }
}

#pragma mark - Item Stuff

-(void)placeCandy
{
    int randPos = 0;
    // 임의의 위치를 저장하는 변수 0.
    
    for (NSValue *value in _fieldTaken)
        [_fieldOpen addObject:value];
        /* 게임 영역에 있는 NSValue의 객체 value 안에 있는
         첫 번째 좌표값을 추가. */
    
    // 그리고 나서 취한 모든 점들을 제거
    [_fieldTaken removeAllObjects];
    
    // 마지막으로서, 새롭게 취한 점을 채움.
    for (Snake *s in [_tails children])
    {
        [self addToFieldTaken:s];
        /* 노드 _tails의 객체들 중에 뱀의 객체 s에
         게임 영역에 취하도록 삽입. */
        [self removeFromFieldOpen:s];
        /* 게임 영역에 삽입하도록 연 뱀의 객체 s를 제거. */
    }
    
    // 열려진 게임 영역의 배열에 임의의 위치를 할당
    randPos = arc4random() % [_fieldOpen count];
    
    // 게임 영역 배열의 임의의 위치의 좌표값으로 사탕의 위치를 지정함.
    _candy.position = [[_fieldOpen objectAtIndex:randPos] CGPointValue];
}

-(void)placeFakeCandy
{
    int randPos = 0;
    // 임의의 위치를 저장하는 변수 0.
    
    for (NSValue *value in _fieldTaken)
        [_fieldOpen addObject:value];
        /* 게임 영역에 있는 NSValue의 객체 value 안에 있는
         첫 번째 좌표값을 추가. */
    
    // 그리고 나서 취한 모든 점들을 제거
    [_fieldTaken removeAllObjects];
    
    // 마지막으로서, 새롭게 취한 점을 채움.
    for (Snake *s in [_tails children])
    {
        [self addToFieldTaken:s];
        /* 노드 _tails의 객체들 중에 뱀의 객체 s에
         게임 영역에 취하도록 삽입. */
        [self removeFromFieldOpen:s];
        /* 게임 영역에 삽입하도록 연 뱀의 객체 s를 제거. */
    }
    
    // 열려진 게임 영역의 배열에 임의의 위치를 할당
    randPos = arc4random() % [_fieldOpen count];
    
    _fakeCandy.opacity = 255;
    
    // 게임 영역 배열의 임의의 위치의 좌표값으로 가짜 사탕의 위치를 지정함.
    _fakeCandy.position = [[_fieldOpen objectAtIndex:randPos] CGPointValue];
}

-(void)addItems:dt
{
    int ran = arc4random() % 10;
    // 0부터 9까지의 임의의 값을 받음.
    
    if( (ran % 2) == 0 )
        // 짝수인 경우 거짓 사탕을 놓음.
        [self placeFakeCandy];
    else
        // 홀수인 경우 아이템을 놓음.
        [self placeAddItems];
}

-(void)placeAddItems
{
    int randPos = 0;
    int randChoice = arc4random() % 4 + 1;
    // 임의의 아이템이 나오는 변수
    
    for (NSValue *value in _fieldTaken)
    {
        [_fieldOpen addObject:value];
        /* 게임 영역에 있는 NSValue의 객체 value 안에 있는
         첫 번째 좌표값을 추가. */
    }
    
    // 그리고 나서 취한 모든 점들을 제거
    [_fieldTaken removeAllObjects];
    
    // 마지막으로서, 새롭게 취한 점을 채움.
    for (Snake *s in [_tails children])
    {
        [self addToFieldTaken:s];
        /* 노드 _tails의 객체들 중에 뱀의 객체 s에
         게임 영역에 취하도록 삽입. */
        [self removeFromFieldOpen:s];
        /* 게임 영역에 삽입하도록 연 뱀의 객체 s를 제거. */
    }
    
    // 열려진 게임 영역의 배열에 임의의 위치를 할당
    randPos = arc4random() % [_fieldOpen count];
    
    // 게임 영역 배열의 임의의 위치의 좌표값으로 아이템의 위치를 지정함.
    if( randChoice == 1 )
    {
        _removeTail.opacity = 255;
        _removeTail.position = [[_fieldOpen objectAtIndex:randPos] CGPointValue];
    }
    
    if( randChoice == 2 )
    {
        _speedSlow.opacity = 255;
        _speedSlow.position = [[_fieldOpen objectAtIndex:randPos] CGPointValue];
    }
    
    if( randChoice == 3 )
    {
        _speedFast.opacity = 255;
        _speedFast.position = [[_fieldOpen objectAtIndex:randPos] CGPointValue];
    }
}

-(void)RestoreSpeed
// 속도를 원래대로 복구하는 함수.
{
    [self unschedule:@selector(gameTick:)];
    [self schedule:@selector(gameTick:) interval:[_interface getLevelSpeed]];
    _checkItemEffect = 0;
}

-(void)changeDirectionPoint:(int)directionFlag coords:(CGPoint)coords from:(Snake *)head
{
    /* 오직 뱀의 머리 부분의 정보만 필요하다. 뱀의 머리의 정보는
     이 메소드를 통해 변경된다. 다른 부분은 gameTick:에서 변경된다. */
    
    // 노드 _tails에 방향 flag와 변경할 좌표값을 추가한다.
    for (Snake *s in [_tails children])
    {
        /* 머리 부분에는 어느 것도 추가할 필요가 없다.
        이는 직접 우리가 조종할 수 있다. */
        
        if (s.tag == TAG_HEAD)
            continue;
        
        [s addDirectionFlag:directionFlag];
        [s addChangePoint:coords];
    }
    
    // 방향 flag은 뱀의 머리의 방향 flag으로 즉시 바꿈.
    head.directionFlag = directionFlag;
}

-(int)collisionCheck:(CGPoint)pos DirectionFlag:(int)flag For:(Snake *)head
// snake의 객체 head를 위한 충돌 체크함수, 인자로 좌표값, 방향 flag값
{
    CGFloat candyX = _candy.position.x;
    CGFloat candyY = _candy.position.y;
    
    CGFloat fakeCandyX = _fakeCandy.position.x;
    CGFloat fakeCandyY = _fakeCandy.position.y;
    
    CGFloat item1X = _removeTail.position.x;
    CGFloat item1Y = _removeTail.position.y;
    CGFloat item2X = _speedSlow.position.x;
    CGFloat item2Y = _speedSlow.position.y;
    CGFloat item3X = _speedFast.position.x;
    CGFloat item3Y = _speedFast.position.y;
    
    // snake tail
    CGFloat tailX;
    CGFloat tailY;
    
    int hasCollided = 0;
    
    // 뱀의 모든 부분을 살펴봄.
    for (Snake *s in [_tails children])
    {
        // 머리 그 자체로는 충돌할 수 없으므로 반복문을 넘김.
        if (s.tag == head.tag)
            continue;
        
        // 뱀의 꼬리 좌표값
        tailX = s.position.x;
        tailY = s.position.y;
        
        CGFloat nextX;
        CGFloat nextY;
        
        /* 향하고 있는 방향을 살펴봄. 다음 과정이 유효한지 아닌지 결정.
         유효하지 않은 경우 true(1; COLLISION_WALL)을 반환. */
        
        switch (flag)
        {
            case MOVE_RIGHT:
            {
                nextX = pos.x + SNAKE_WIDTH;
                nextY = pos.y;
                
                if (nextX > WALL_RIGHT)
                    hasCollided = true;
                break;
            }
            case MOVE_LEFT:
            {
                nextX = pos.x - SNAKE_WIDTH;
                nextY = pos.y;

                if (nextX < WALL_LEFT)
                    hasCollided = true;
                break;
            }
            case MOVE_UP:
            {
                nextX = pos.x;
                nextY = pos.y + SNAKE_HEIGHT;

                if (nextY > WALL_TOP)
                    hasCollided = true;
                break;
            }
            case MOVE_DOWN:
            {
                nextX = pos.x;
                nextY = pos.y - SNAKE_HEIGHT;

                if (nextY < WALL_BOTTOM)
                    hasCollided = true;
                break;
            }
            default:
                break;
        }
        
        for(CCSprite *Enemy in [_enemy children])
        {
            if(CGRectIntersectsRect([Enemy boundingBox], [s boundingBox]))
            {
                hasCollided = COLLISION_WALL;
                break;
            }
        }
        
        // 벽 체크
        if ((nextX == tailX && nextY == tailY))
            hasCollided = COLLISION_WALL;
        /* 뱀의 좌표와 머리가 향하고 있는 좌표가 같다면
         벽에 부딪친 것과 동일하게 취급. */

        if (nextX == candyX && nextY == candyY)
            hasCollided = COLLISION_CANDY;
        /* 사탕의 좌표값과 머리가 향하고 있는 좌표와 비교하여
         사탕을 먹은 경우 충돌된 변수를 '사탕 충돌(2)'로 반환. */
        
        if (nextX == fakeCandyX && nextY == fakeCandyY)
            hasCollided = COLLISION_FAKE;
        if (nextX == item1X && nextY == item1Y)
            hasCollided = COLLISION_MINUS;
        if (nextX == item2X && nextY == item2Y)
            hasCollided = COLLISION_SPEED_SLOW;
        if (nextX == item3X && nextY == item3Y)
            hasCollided = COLLISION_SPEED_FAST;
        // 각각의 좌표값과 머리가 향하고 있는 좌표를 비교하여 해당 아이템을 먹은 경우 먹은 아이템 종류를 결과로 반환.
    }
    
    return hasCollided; 
}

-(void)gameTick:(ccTime)dt
{
    // 뱀을 통해 반복 작용하기 전에 맞았는가에 대해 모든 것을 확인.
    Snake *head = (Snake *)[_tails getChildByTag:TAG_HEAD];
    // Snake의 객체 head에 노드 _tails에 뱀의 머리 부분으로 할당.
    
    int colCheck = [self collisionCheck:head.position DirectionFlag:head.directionFlag For:head];
    
    // collisionCheck 함수를 통해 반환값이 '사탕 충돌'에 해당되면 점수를 증가시키고 뱀의 길이를 길게 함.
    if (colCheck == COLLISION_CANDY)
    {
        [sae playEffect:@"yummy.wav"];
        [_interface addScore:10];
        [self.message showMessage:SCORE_PLUS_MESSAGE];
        _greenConcentration -= 5;
        
        [self performSelector:@selector(addSnakePartToField:) withObject:_greenConcentration];
        [self placeCandy];
        
        if( [_interface getPlayerScore] > 30 )
        {
            [self unschedule:@selector(gameTick:)];
            if (!_checkItemEffect)
                [_interface controlLevelSpeed:0.99f];
            [self schedule:@selector(gameTick:) interval:[_interface getLevelSpeed]];
            [self schedule:@selector(addItems:) interval:1];
            // 새로운 사탕을 놓음
        }
        
        if( [_interface getPlayerScore] >= 70 )
        {
            [self unschedule:@selector(gameTick:)];
            if (!_checkItemEffect)
                [_interface controlLevelSpeed:0.97f];
            [self schedule:@selector(gameTick:) interval:[_interface getLevelSpeed]];
            
            [self.message showMessage:WARNING_MESSAGE];
            [self scheduleOnce:@selector(setupEnemy) delay:2.0f];
            [self schedule:@selector(moveEnemy) interval:0.1f];
            // 경고한 이후 2초 후, 적이 생성되도록 함.
        }
    }
    
    // collisionCheck 함수를 통해 반환값이 '거짓 사탕'에 해당되면 점수를 5점 감점시킴.
    else if (colCheck == COLLISION_FAKE)
    {
        if(_fakeCandy.opacity == 255)
        {
            [sae playEffect:@"item.wav"];
            id fadeOut = [CCFadeOut actionWithDuration:0.5f];
            id delay = [CCDelayTime actionWithDuration:1];
            delay = [CCSequence actions:fadeOut, delay, nil];
            [_interface addScore: -5];
            [self.message showMessage:FAKE_CANDY_MESSAGE];
            [_fakeCandy runAction:delay];
            _fakeCandy.opacity = 0;
        }
    }

    // collisionCheck 함수를 통해 반환값이 '꼬리 제거'에 해당되면 뱀의 꼬리를 제거함.
    else if (colCheck == COLLISION_MINUS)
    {
        if(_removeTail.opacity == 255)
        {
            [sae playEffect:@"item.wav"];
            id fadeOut = [CCFadeOut actionWithDuration:0.5f];
            id delay = [CCDelayTime actionWithDuration:1];
            delay = [CCSequence actions:fadeOut, delay, nil];
            
            [self performSelector:@selector(minusSnakePartToField) withObject:nil ];
            _greenConcentration += 5;
            
            [_removeTail runAction:delay];
            _removeTail.opacity = 0;
        }
    }

    // collisionCheck 함수를 통해 반환값이 '속도 감소'에 해당되면 8초 동안 뱀의 속도를 초기 속도로 놓음.
    else if (colCheck == COLLISION_SPEED_SLOW)
    {
        if(_speedSlow.opacity == 255)
        {
            [sae playEffect:@"item.wav"];
            id fadeOut = [CCFadeOut actionWithDuration:0.5f];
            id delay = [CCDelayTime actionWithDuration:1];
            delay = [CCSequence actions:fadeOut, delay, nil];
            
            _checkItemEffect = 1; // 속도 감소가 적용되고 있음을 나타냄.
            [_interface slowLevelSpeed:[_interface getLevelSpeed]];
            [self unschedule:@selector(gameTick:)];
            [self schedule:@selector(gameTick:) interval:[_interface getLevelSpeed]];
            [_interface setLevelSpeed:[_interface getRestoreLevelSpeed]];
            
            id delayTime = [CCDelayTime actionWithDuration:8.0f];
            id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(RestoreSpeed)];
            id restoreSpeed = [CCSequence actions:delayTime, callBack, nil];
            
            [self runAction:restoreSpeed];
            
            [_speedSlow runAction:delay];
            _speedSlow.opacity = 0;
        }
    }

    // collisionCheck 함수를 통해 반환값이 '속도 빠름'에 해당되면 급작스럽게 뱀의 속도가 빨라진 후 원래대로 돌아감.
    else if (colCheck == COLLISION_SPEED_FAST)
    {
        if(_speedFast.opacity == 255)
        {
            [sae playEffect:@"item.wav"];
            id fadeOut = [CCFadeOut actionWithDuration:0.5f];
            id delay = [CCDelayTime actionWithDuration:1];
            delay = [CCSequence actions:fadeOut, delay, nil];
            
            if ( _checkItemEffect ) // 속도 감소 아이템이 적용받고 있는 경우 이 아이템의 효과를 무력화 시킴.
                [self.message showMessage:INEFFECTIVE_ITEM_MESSAGE];
            
            else
            {
                [_interface fastLevelSpeed:[_interface getLevelSpeed]];
                [self unschedule:@selector(gameTick:)];
                [self schedule:@selector(gameTick:) interval:[_interface getLevelSpeed]];
                
                [_interface setLevelSpeed:[_interface getRestoreLevelSpeed]];
            }
            
            id delayTime = [CCDelayTime actionWithDuration:0.5f];
            id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(RestoreSpeed)];
            id restoreSpeed = [CCSequence actions:delayTime, callBack, nil];
            
            [self runAction:restoreSpeed];
            
            [_speedFast runAction:delay];
            _speedFast.opacity = 0;
        }
    }
    
    // collisionCheck 함수를 통해 반환값이 '벽 충돌'에 해당되면 게임을 중단시킴.
    else if (colCheck == COLLISION_WALL)
    {
        [sae playEffect:@"scream.wav"];
        [self gameOver];
        return;
    }
    
    for (Snake *s in [_tails children])
    {
        CGFloat x = s.position.x;
        CGFloat y = s.position.y;
        
        // 노드 _tails에 있는 뱀의 좌표를 계속 가져오는 반복문으로, 여러 좌표 중 하나에 위치해 있다면 방향 flag를 변경해야 함.
        for (int i = 0; i < [s getDirectionFlagsCount]; i++)
        {
            CGPoint changeDirectionXY = [s getChangePointAtIndex:i];
            // 방향 flag 배열의 원소의 개수를 가져와서 반복 횟수 i보다 작을 경우 좌표 변경을 위한 배열의 i번째 원소에 좌표 변경을 위한 좌표값을 할당.
            
            if (s.position.x == changeDirectionXY.x &&
                s.position.y == changeDirectionXY.y)
            {
                // 방향 flag 값을 설정. 좌표 변경과 방향 flag는 서로 유사.
                s.directionFlag = [s getDirectionFlagAtIndex:i];
                // 사용되었던 좌표는 제거.
                [s removeDirectionFlagAtIndex:i];
                [s removeChangePointAtIndex:i];
                // 변경할 좌표를 찾았기 때문에 탈출.
                break;
            }
        }
        
        // 방향 flag를 통해 움직임을 결정
        switch (s.directionFlag)
        {
            case MOVE_RIGHT:
            {
                x += SNAKE_WIDTH;
                break;
            }
            case MOVE_LEFT:
            {
                x -= SNAKE_WIDTH;
                break;
            }
            case MOVE_UP:
            {
                y += SNAKE_HEIGHT;
                break;
            }
            case MOVE_DOWN:
            {
                y -= SNAKE_HEIGHT;
                break;
            }
            default:
                // MOVE_RIGHT
                x += SNAKE_WIDTH;
                break;
        }
    
        // Snake의 객체 s의 위치 지정.
        s.position = ccp(x,y);
    }
}

#pragma mark - Touch Stuff

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];

    // 방향을 터치하는 패드를 터치하지 않은 경우 무시함.
    CGRect dpadBox = _dpad.boundingBox;
    if (!CGRectContainsPoint(dpadBox, touchLocation))
        return YES;
    
    if (!_tails)
        return YES;

    // 뱀의 머리를 노드 _tails에 있는 뱀의 머리를 나타내는 매크로를 통해 가져옴.
    Snake *snakeHead = (Snake *)[_tails getChildByTag:TAG_HEAD];
    
    int dflag = MOVE_RIGHT;
    CGFloat tx = floor(touchLocation.x);
    CGFloat ty = floor(touchLocation.y);
    
    // dpad의 위치
    float dpad_midX = _dpad.position.x;
    float dpad_midY = _dpad.position.y;
    
    // DPAD LOGIC    
    if (ty >= dpad_midY)
    {
        if (tx >= dpad_midX)
        {
            // up / right
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN)
                dflag = MOVE_RIGHT;
            else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT)
                dflag = MOVE_UP;
            
        }
        else if (tx <= dpad_midX)
        {
            // up / left
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN)
                dflag = MOVE_LEFT;
            else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT)
                dflag = MOVE_UP;
        }
    }
    
    else if (ty <= dpad_midY)
    {
        if (tx >= dpad_midX)
        {
            // down / right
            if (snakeHead.directionFlag == MOVE_UP ||
                snakeHead.directionFlag == MOVE_DOWN)
                dflag = MOVE_RIGHT;
            else if (snakeHead.directionFlag == MOVE_LEFT ||
                       snakeHead.directionFlag == MOVE_RIGHT)
                dflag = MOVE_DOWN;
        }
        else if (tx <= dpad_midX)
        {
            // down / left
            if (snakeHead.directionFlag == MOVE_UP || snakeHead.directionFlag == MOVE_DOWN)
                dflag = MOVE_LEFT;
            else if (snakeHead.directionFlag == MOVE_LEFT || snakeHead.directionFlag == MOVE_RIGHT)
                dflag = MOVE_DOWN;
        }
    }
    
    // 뱀의 머리에게 새로운 정보를 전달
    [self changeDirectionPoint:dflag coords:snakeHead.position from:snakeHead];
    
    return YES;
}

@end
