# shootingGame

프로세싱 기말 과제 미니 프로젝트 "슈팅 게임"

그냥 온라인 백업 및 공유용

개발 : 현창민


# 프로세싱 프로젝트 (슈팅 게임) RoadMap

플레이어 비행기 스프라이트 제작 √

목숨 구현 (5개) √
- 적기 하나가 아래로 내려올때마다 목숨 1개 차감 √
- 설정된 목숨이 0이 되면 게임 오버 √

게임 오버 화면 √
- 게임 멈추고 최종 점수 및 기타 정보 표시 √

게임 배경 음악 추가 √
- Gradius II Burning Heat Remix(IWBTB 음원) √

게임 재시작 구현 √
- 게임 재시작 버튼 'R'키로 변경 √
- 게임 재시작시 게임 정보 초기화 √

점수 구현 √
- 적기 처치시마다 기본 100+@점 추가 √
- 난이도 상승에 따라 추가 점수 부여 √

시간 경과에 따른 난이도 상승 구현 √
- 적기 증가 √
- 적기 속도 증가 √
- 적기 크기(피격 판정) 감소 

미사일 구현
- 우클릭 누르면 미사일 발사 √
- 미사일 개수 구현 √
- 폭발 일으켜서 적기 전멸 √
- 폭발 이펙트 추가

적기 스프라이트 제작

아이템 (HP, Missile, Option) 구현
- 적기 처치 시 확률적으로 아이템 드랍
- 아이템 획득
- 아이템 효과 구현
1. HP Up : 체력 증가 (최대 5개)
2. Missile Up : 미사일 증가 (최대 5개)
3. Option Up : 공격 가능한 추가 기체 생성 (최대 5개)

배경 이펙트 추가

효과음 추가

난이도 추가
- 게임 시작 시 마우스로 난이도 설정 후 본 게임 시작
- Noobie Mode : 초기 목숨 5개, 초기 미사일 3개, 시작 난이도 낮음, 획득 점수 낮음
- Average Mode : 초기 목숨 4개, 초기 미사일 2개, 시작 난이도 보통, 획득 점수 보통
- Pro Mode : 초기 목숨 3개, 초기 미사일 1개, 시작 난이도 높음, 획득 점수 높음

최적화 및 테스트



# Known Issues

- 게임오버시 화면에 적기, 폭발 이펙트, 레이저 등이 남음
- 가끔 파괴된 적기가 화면 끝에서 생성되지 않고 화면 중간에서 재생성
