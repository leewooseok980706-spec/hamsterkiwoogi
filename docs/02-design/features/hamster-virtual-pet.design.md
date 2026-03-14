# Design: 버추얼 햄스터 육성 앱

> Plan 참조: `docs/01-plan/features/hamster-virtual-pet.plan.md`
> 작성일: 2026-03-14

---

## 1. 화면 구조 (Navigation)

```
App
├── SplashScreen              — 로딩 + 인증 상태 확인
├── AuthScreen                — Google / Apple 로그인
├── OnboardingScreen          — 첫 실행: 햄스터 이름 짓기
└── MainShell (BottomNavBar)
    ├── HomeTab               — 햄스터 메인 화면 (핵심)
    ├── RoomTab               — 집 꾸미기
    └── ProfileTab            — 유저 정보 & 설정
```

---

## 2. 화면별 UI 설계

### 2.1 HomeTab — 메인 화면

```
┌─────────────────────────────────┐
│  [프로필 아이콘]  햄스터 키우기 [설정]│  ← 반투명 오버레이
│                                 │
│  배고픔 ████████░░              │  ← 상단 스탯 오버레이
│  행복도 ██████░░░░              │
│  체력   █████████░              │
│                                 │
│       🐹 햄스터 애니메이션       │  ← 전체 화면 100%
│       (배경 포함 풀스크린)        │
│                                 │
│  ┌──────────────────────────┐  │
│  │ 모찌야 뭐해?        [전송] │  │  ← 채팅 입력창 (하단 오버레이)
│  └──────────────────────────┘  │
│       💬 배고파요!            │  ← 머리 위에서 팝! 위로 떠오르며 사라짐
│          ↑                   │
│       🐹 햄스터              │
│  ┌──────────────────────────┐│
│  │ 모찌야 뭐해?        [전송] ││  ← 채팅 입력창
│  └──────────────────────────┘│
└─────────────────────────────────┘
```

> 햄스터 + 배경이 전체 화면을 채우고, UI는 Stack 오버레이로 구성.
> 하단 버튼 제거 → 텍스트 채팅창으로 대화.
> 말풍선은 햄스터 머리 바로 위에서 팝! 하고 나타난 뒤 위로 떠오르며 서서히 사라짐 (float + fade out).
> Flutter: `AnimatedOpacity` + `SlideTransition` 조합으로 구현.

**채팅 인터랙션 설계:**
| 입력 키워드 | 햄스터 반응 | 스탯 변화 |
|------------|-----------|----------|
| 밥, 먹이, 배고파 | 🍎 "냠냠!" + 먹는 애니메이션 | 배고픔 +30 |
| 놀자, 심심해 | 🎮 "같이 놀아요!" + 뛰는 애니메이션 | 행복도 +25 |
| 쓰다듬, 귀여워 | 😊 "좋아요~" + 눈 감는 애니메이션 | 행복도 +15 |
| 안녕, 왔어 | 💬 "기다렸어요!" + 귀 쫑긋 | 행복도 +10 |
| (기타 입력) | 💭 "..." + 고개 갸웃 애니메이션 | 변화 없음 |

**인터랙션 방식: 채팅 입력창**
- 하단 텍스트 필드에 자유롭게 입력 → 햄스터가 말풍선으로 응답
- 키워드 매칭으로 스탯 변화 및 애니메이션 트리거
- 채팅 히스토리는 화면에 쌓이지 않고 말풍선만 표시 (심플 UX 유지)

---

### 2.2 RoomTab — 집 꾸미기

```
┌─────────────────────────────────┐
│  [←] 집 꾸미기              [저장]│
├─────────────────────────────────┤
│                                 │
│   ┌───────────────────────┐    │
│   │   [배경 이미지]        │    │
│   │  [가구1] [가구2]       │    │
│   │       🐹              │    │
│   └───────────────────────┘    │
│                                 │
├─────────────────────────────────┤
│  [배경] [가구] [바닥] [소품]     │  ← 카테고리 탭
├─────────────────────────────────┤
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐   │
│  │  │ │  │ │  │ │  │ │  │   │  ← 아이템 그리드
│  └──┘ └──┘ └──┘ └──┘ └──┘   │
│  ┌──┐ ┌──┐ ┌──┐              │
│  │  │ │  │ │  │              │
│  └──┘ └──┘ └──┘              │
└─────────────────────────────────┘
```

**아이템 카테고리:**
- 배경: 기본방, 들판, 우주, 해변, 숲
- 가구: 침대, 쳇바퀴, 모래목욕통, 먹이통, 장난감
- 바닥: 나무, 타일, 잔디, 모래
- 소품: 화분, 별, 구름, 무지개

---

### 2.3 AuthScreen

```
┌─────────────────────────────────┐
│                                 │
│         🐹 햄스터 홈            │
│       귀여운 친구를 만나세요      │
│                                 │
│                                 │
│   ┌─────────────────────────┐  │
│   │  G  Google로 계속하기   │  │
│   └─────────────────────────┘  │
│   ┌─────────────────────────┐  │
│   │   Apple로 계속하기      │  │
│   └─────────────────────────┘  │
│                                 │
└─────────────────────────────────┘
```

---

### 2.4 OnboardingScreen — 이름 짓기

```
┌─────────────────────────────────┐
│                                 │
│    새 친구가 찾아왔어요! 🐹      │
│                                 │
│     [ 햄스터 애니메이션 ]        │
│                                 │
│    이름을 지어주세요             │
│   ┌─────────────────────────┐  │
│   │  모찌                   │  │
│   └─────────────────────────┘  │
│                                 │
│   ┌─────────────────────────┐  │
│   │       시작하기!          │  │
│   └─────────────────────────┘  │
└─────────────────────────────────┘
```

---

## 3. 컴포넌트 구조 (Flutter)

```
lib/
├── main.dart
├── app.dart                      — MaterialApp, 라우팅, 테마
│
├── core/
│   ├── router/
│   │   └── app_router.dart       — GoRouter 라우팅 정의
│   ├── theme/
│   │   └── app_theme.dart        — 색상, 폰트, 테마
│   └── constants/
│       └── game_constants.dart   — 스탯 감소율, 최댓값 등
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart     — Supabase Auth 연동
│   │   ├── domain/
│   │   │   └── auth_state.dart
│   │   └── presentation/
│   │       ├── auth_screen.dart
│   │       └── auth_provider.dart       — Riverpod
│   │
│   ├── hamster/
│   │   ├── data/
│   │   │   └── hamster_repository.dart  — Supabase DB + Hive
│   │   ├── domain/
│   │   │   ├── hamster_model.dart       — 햄스터 데이터 모델
│   │   │   └── hamster_engine.dart      — 스탯 계산 로직
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       ├── hamster_widget.dart      — 애니메이션 뷰
│   │       ├── stat_bar_widget.dart     — 스탯 게이지
│   │       ├── action_buttons_widget.dart
│   │       └── hamster_provider.dart    — Riverpod
│   │
│   ├── room/
│   │   ├── data/
│   │   │   └── room_repository.dart     — 아이템 저장/로드
│   │   ├── domain/
│   │   │   └── room_item_model.dart
│   │   └── presentation/
│   │       ├── room_screen.dart
│   │       ├── room_preview_widget.dart
│   │       ├── item_grid_widget.dart
│   │       └── room_provider.dart
│   │
│   └── profile/
│       └── presentation/
│           └── profile_screen.dart
│
├── shared/
│   ├── widgets/
│   │   └── loading_widget.dart
│   └── services/
│       ├── supabase_service.dart        — Supabase 초기화
│       └── hive_service.dart            — 로컬 캐시 초기화
│
└── assets/
    ├── animations/                      — .riv 파일
    ├── images/                          — 배경, 가구 이미지
    └── fonts/
```

---

## 4. 상태 관리 설계 (Riverpod)

### 주요 Provider

```dart
// 인증 상태
authStateProvider: StateNotifierProvider<AuthNotifier, AuthState>
  - AuthState: unauthenticated | authenticated | loading

// 햄스터 상태
hamsterProvider: StateNotifierProvider<HamsterNotifier, HamsterState>
  - HamsterState: { name, hunger, happiness, health, level, lastFedAt }

// 방 꾸미기 상태
roomProvider: StateNotifierProvider<RoomNotifier, RoomState>
  - RoomState: { equippedBackground, equippedFurniture[], ownedItems[] }

// 타이머 (스탯 자동 감소)
statTimerProvider: StreamProvider<void>
  - 1분마다 스탯 감소 트리거
```

### 스탯 감소 로직 (HamsterEngine)

```dart
// game_constants.dart
const kHungerDecayPerHour = 5.0;   // 시간당 배고픔 감소
const kHealthDecayPerHour = 2.0;   // 시간당 체력 감소
const kHappinessDecayPerHour = 3.0; // 시간당 행복도 감소

// 오프라인 시간 계산
int elapsedHours = DateTime.now().difference(lastFedAt).inHours;
double newHunger = max(0, hunger - kHungerDecayPerHour * elapsedHours);
```

---

## 5. DB 스키마 (Supabase PostgreSQL)

### hamsters 테이블
```sql
CREATE TABLE hamsters (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL DEFAULT '햄스터',
  hunger      INTEGER NOT NULL DEFAULT 80 CHECK (hunger BETWEEN 0 AND 100),
  happiness   INTEGER NOT NULL DEFAULT 80 CHECK (happiness BETWEEN 0 AND 100),
  health      INTEGER NOT NULL DEFAULT 100 CHECK (health BETWEEN 0 AND 100),
  level       INTEGER NOT NULL DEFAULT 1,
  last_fed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_synced_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS 정책
ALTER TABLE hamsters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "유저는 자신의 햄스터만 접근"
  ON hamsters FOR ALL
  USING (auth.uid() = user_id);
```

### items 테이블 (마스터 데이터)
```sql
CREATE TABLE items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  category    TEXT NOT NULL CHECK (category IN ('background','furniture','floor','prop')),
  image_url   TEXT,
  is_default  BOOLEAN DEFAULT false,   -- 기본 제공 아이템
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### user_items 테이블 (유저 보유 아이템)
```sql
CREATE TABLE user_items (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  item_id      UUID REFERENCES items(id),
  is_equipped  BOOLEAN DEFAULT false,
  acquired_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, item_id)
);

ALTER TABLE user_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "유저는 자신의 아이템만 접근"
  ON user_items FOR ALL
  USING (auth.uid() = user_id);
```

---

## 6. 애니메이션 상태 설계 (Rive)

### 햄스터 상태별 애니메이션

| 상태 조건 | Rive State | 설명 |
|----------|-----------|------|
| hunger > 60 & happiness > 60 | `happy_idle` | 행복한 상태, 귀 흔들기 + 😊 말풍선 |
| hunger 30~60 | `normal_idle` | 평범한 상태, 느린 움직임 + 💭 말풍선 |
| hunger < 30 | `hungry_idle` | 배고픈 상태, 배 잡기 + 🍎 말풍선 |
| happiness < 30 | `sad_idle` | 슬픈 상태, 눈물 + 😢 말풍선 |
| health < 20 | `sick_idle` | 아픈 상태, 코 훌쩍 + 🤒 말풍선 |
| 먹이주기 트리거 | `eating` | 먹는 모션 (1.5초) |
| 놀아주기 트리거 | `playing` | 뛰어다니는 모션 (2초) |
| 쓰다듬기 트리거 | `petting` | 눈 감고 좋아하는 모션 (1.5초) |
| 말걸기 트리거 | `talking` | 귀 쫑긋, 말풍선 (1초) |

### 상태 결정 우선순위
```dart
HamsterAnimationState determineAnimation(HamsterState state) {
  if (state.health < 20) return HamsterAnimationState.sick;
  if (state.hunger < 30) return HamsterAnimationState.hungry;
  if (state.happiness < 30) return HamsterAnimationState.sad;
  if (state.hunger > 60 && state.happiness > 60) return HamsterAnimationState.happy;
  return HamsterAnimationState.normal;
}
```

---

## 7. Supabase 동기화 전략

```
로컬 우선 (Local-First) 방식

[인터랙션 발생]
    ↓
즉시 Hive 로컬 저장 (UI 반응성 보장)
    ↓
30분 주기 OR 앱 포그라운드→백그라운드 전환 시
    ↓
Supabase DB upsert (last_synced_at 업데이트)
    ↓
[앱 재실행 시]
    ↓
Supabase에서 최신 데이터 로드
    ↓
오프라인 경과 시간 계산 → 스탯 감소 적용
```

---

## 8. 기본 제공 아이템 (Seed Data)

| 카테고리 | 아이템 | 기본 장착 |
|----------|--------|----------|
| 배경 | 아늑한 방 | ✅ |
| 배경 | 들판 | - |
| 배경 | 우주 | - |
| 가구 | 쳇바퀴 | ✅ |
| 가구 | 나무 집 | ✅ |
| 가구 | 먹이통 | ✅ |
| 바닥 | 나무 바닥 | ✅ |
| 소품 | 해바라기 | - |

---

## 9. 구현 순서 (Do Phase 가이드)

```
Phase 1 — 프로젝트 셋업 (1일)
  [ ] Flutter 프로젝트 생성
  [ ] 의존성 추가 (supabase_flutter, hive, riverpod, go_router, rive)
  [ ] Supabase 프로젝트 생성 & 연결
  [ ] 폴더 구조 생성

Phase 2 — 인증 (1일)
  [ ] Supabase Auth 설정
  [ ] Google Sign-In 연동
  [ ] Apple Sign-In 연동
  [ ] AuthScreen UI

Phase 3 — 햄스터 엔진 (2일)
  [ ] DB 스키마 적용 (SQL 실행)
  [ ] HamsterModel, HamsterEngine 구현
  [ ] Hive 로컬 캐시 구현
  [ ] Riverpod Provider 연결

Phase 4 — 메인 화면 (2일)
  [ ] HomeScreen UI 구현
  [ ] Rive 애니메이션 연동
  [ ] 스탯 바 위젯
  [ ] 인터랙션 버튼 (먹이주기 등)

Phase 5 — 방 꾸미기 (2일)
  [ ] Seed 아이템 데이터 삽입
  [ ] RoomScreen UI
  [ ] 아이템 장착/해제 로직
  [ ] Supabase Storage 이미지 로드

Phase 6 — 동기화 & 마무리 (1일)
  [ ] 30분 주기 동기화 구현
  [ ] 오프라인 경과 시간 계산
  [ ] 온보딩 플로우
  [ ] QA & 버그 수정
```

---

## 10. 의존성 목록 (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  # 백엔드
  supabase_flutter: ^2.0.0
  # 로컬 캐시
  hive_flutter: ^1.1.0
  # 상태 관리
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  # 라우팅
  go_router: ^13.0.0
  # 애니메이션
  rive: ^0.12.0
  # 유틸
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  hive_generator: ^2.0.0
```

---

## 11. 다음 단계

```
현재: Design ✅
다음: /pdca do hamster-virtual-pet
      → 실제 구현 시작
```
