//
//  Created by Sander Vispoel on 4/8/13.
//  Reviesed by Yonggu Choi on 16/6/13.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "MessageNode.h"
#import "CCLayer.h"

@class Snake;

@interface GameBoard : CCLayer
{
    CCNode *_tails; // CCNode에 tail(꼬리)를 위한 빈 노드 선언.
    CCNode *_enemy; // CCNode에 적을 생성하기 위한 빈 노드 선언.
    
    SimpleAudioEngine *sae; // 배경 음악 및 효과음 처리
    
    CCMenu *menu1; // pause 버튼
    CCMenu *menu2; // resume 버튼
    
    CCSprite *_candy; // 사탕 스프라이트 이미지 선언.
    CCSprite *_fakeCandy; // 거짓 사탕 스프라이트 이미지 선언.
    CCSprite *_removeTail; // 꼬리를 제거하는데 필요로 하는 스프라이트.
    CCSprite *_speedSlow; // 속도를 늦추는데 필요한 스프라이트.
    CCSprite *_speedFast; // 속도를 빠르게 하는데 필요한 스프라이트.
    CCSprite *_Enemy; // 적 스프라이트
    InterfaceLayer *_interface;
    // 점수를 다루기 위한 InterfaceLayer의 객체 선언.
    
    NSMutableArray *_fieldOpen;
    // 게임 영역에 삽입하기 위해 미리 읽어들이는 배열
    NSMutableArray *_fieldTaken;
    // 게임 영역으로부터 가져오는 것을 배열의 원소에 할당.
    
    int _maxEnemyTag; // 적의 길이를 조정하는 데 필요하는 정수
    int _maxPartTag; // 움직이는 뱀의 길이를 조정하는데 필요하는 정수
    int _greenConcentration; // 그러데이션 효과를 적용하는데 필요하는 정수
    int _checkItemEffect; // 속도 아이템에서 효과가 겹치지 않도록 선언

    CCSprite *_dpad; // 방향 전환에 사용되는 패드
    
    MessageNode *message; // 아이템에 대한 효과를 나타내기 위한 메시지
}

@property (nonatomic, assign) int maxPartTag;
@property (nonatomic, assign) int maxEnemyTag;
@property (nonatomic, assign) int greenConcentration;
@property (nonatomic, assign) int checkItemEffect;
@property (readonly) CCSprite *dpad;
@property (nonatomic, retain) MessageNode *message;

-(void)onEnter; // 실행할 때
-(void)onExit; // 종료될 때

-(void)doClick:(id)sender; // pause 버튼과 resume 버튼을 작동하기 위한 함수

-(void)startGame; // 게임 시작 함수
-(void)gameOver; // 게임 종료 함수

-(void)removeFromFieldOpen:(Snake *)snake;
// 게임 영역에 존재한 뱀의 객체 좌표를 제거.
-(void)addToFieldTaken:(Snake *)snake;
// 게임 영역에 가지고 온 좌표값을 이용하여 좌표가 겹치지 않게 뱀을 삽입.

-(void)setupSnake; // 뱀 설정을 위한 함수
-(void)addSnakePartToField:(int)greenColor;
// 게임 영역에 뱀 부분(꼬리)을 삽입.
-(void)minusSnakePartToField;
// snake의 꼬리 부분을 자르는 함수

-(void)setupEnemy; // 적 설정을 위한 함수
-(void)addEnemyPartToField:(int)positionRandom direction:(int)direction;
// 게임 영역에 적을 삽입.
-(void)moveEnemy;
// 적이 움직이는 함수

-(void)placeCandy;
// 사탕 위치 설정.
-(void)placeFakeCandy;
// 가짜 사탕 위치 설정.
-(void)addItems:dt;
// 시간에 따른 사탕 삽입.
-(void)placeAddItems;
// 아이템을 게임 영역에 삽입하는 함수.
-(void)RestoreSpeed;
// (아이템의 효과에 의한) 빨라지거나 감소된 속도를 원래의 속도로 복구하는 함수.

-(void)changeDirectionPoint:(int)directionFlag coords:(CGPoint)coords from:(Snake *)head;
// 뱀의 머리 객체로부터 받은 좌표값을 통해 방향 flag값에 해당하는 방향으로 전환.
-(int)collisionCheck:(CGPoint)pos DirectionFlag:(int)flag For:(Snake *)head;
/* 뱀의 머리 객체로부터 좌표값을 통해 방향 flag을 이용하여 벽이나 아이템에 부딪친 것을 확인하여
 그에 따른 동작을 하게 정보를 제공하는 함수(hasCollided를 반환). */
-(void)gameTick:(ccTime)dt;
// 게임 로직이 진행되는 함수.

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;

@end
