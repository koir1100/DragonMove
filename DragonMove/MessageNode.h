/*
 This work is licensed under the Creative Commons Attribution-Share Alike 3.0 United States License. 
 To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/us/ or 
 send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 
 Jed Laudenslayer
 http://kwigbo.com
 
 */

// 게임 중에 나타나는 메시지 노드
// 콤보, 생명 감소 등의 정보를 보여준다
//

#import "cocos2d.h"

// 각 메시지의 상수 선언
enum{ 
	SCORE_PLUS_MESSAGE	= 0,
    FAKE_CANDY_MESSAGE  = 1,
    SNAKE_MINUS_MESSAGE = 2,
    INEFFECTIVE_ITEM_MESSAGE = 3,
    WARNING_MESSAGE = 4,
};

@interface MessageNode : CCNode
{
	CCLabelTTF *scorePlus;		// 점수 증가
    CCLabelTTF *scoreMinus;     // 점수 감소
    CCLabelTTF *snakeMinus;     // 뱀 길이 감소
    CCLabelTTF *ineffective;    // 효과 적용할 수 없음
    CCLabelTTF *warning;        // 경고
}

@property (nonatomic, retain) CCLabelTTF *scorePlus;
@property (nonatomic, retain) CCLabelTTF *scoreMinus;
@property (nonatomic, retain) CCLabelTTF *snakeMinus;
@property (nonatomic, retain) CCLabelTTF *ineffective;
@property (nonatomic, retain) CCLabelTTF *warning;

-(void)showMessage:(int)message;
-(void)showMessage:(int)message atPosition:(CGPoint)position;
-(id)scaledMoveAction:(CCLabelTTF *)sprite;

@end
