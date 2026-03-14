# Plan: 버추얼 햄스터 육성 앱

---

## Executive Summary

| 관점 | 내용 |
|------|------|
| **Problem** | 실제 햄스터를 키우고 싶지만 키울 수 없는 사람들, 빈 시간에 간단히 즐길 수 있는 케주얼 게임을 원하는 유저 |
| **Solution** | Flutter + Supabase 기반의 버추얼 햄스터 육성 게임. 소셜 로그인으로 데이터 보존, 풍부한 애니메이션으로 생동감 있는 경험 제공 |
| **Functional UX Effect** | 매일 접속해 햄스터 상태를 확인하고, 먹이를 주고, 집을 꾸미는 2~3분 케주얼 루프 형성 |
| **Core Value** | 귀여운 햄스터와의 감정적 유대감 + 커스텀 꾸미기의 소유욕 자극 |

---

## 1. 프로젝트 개요

- **앱 이름**: 햄스터 키우기
- **플랫폼**: Flutter (iOS, Android, 추후 Web/Desktop)
- **백엔드**: Supabase (Auth + PostgreSQL + Storage)
- **로컬 캐시**: Hive
- **애니메이션**: Rive 또는 Lottie

---

## 2. 사용자 의도 발견 (Phase 1)

| 항목 | 내용 |
|------|------|
| **핵심 문제** | 실제 햄스터를 못 키우는 사람들을 위한 버추얼 육성 경험 |
| **타겟 유저** | 햄스터 애호가 + 케주얼 게이머 (두 그룹 동시 공략) |
| **성공 기준** | 매일 접속하고 싶은 중독성 + 2~3분으로 끝나는 간단한 조작성 |

---

## 3. 검토한 대안 (Phase 2)

| 접근법 | 장점 | 단점 | 결정 |
|--------|------|------|------|
| React Native + Expo | 빠른 개발, 앱스토어 배포 | 애니메이션 성능 제한 | ❌ |
| Next.js PWA | 배포 쉬움, 설치 불필요 | 푸시 알림 제한, 모바일 UX 부족 | ❌ |
| **Flutter** | 부드러운 애니메이션, 크로스플랫폼 | Dart 학습 필요 | ✅ **선택** |

**백엔드**: Firebase → **Supabase** 로 변경 (PostgreSQL 기반, 오픈소스)

---

## 4. YAGNI 검토 결과 (Phase 3)

### V1 포함 (필수)
- [x] 햄스터 기본 상태 (배고픔, 행복도, 체력)
- [x] 먹이 주기 (핵심 인터랙션)
- [x] 애니메이션 & 리액션
- [x] 집 꾸미기 / 커스텀 시스템 (배경, 가구, 아이템)
- [x] 소셜 로그인 (Google / Apple)
- [x] 클라우드 데이터 동기화 (Supabase)

### V2 이후 (보류)
- [ ] 미니게임 & 마니스 시스템
- [ ] 커뮤니티 (다른 유저 햄스터 구경/코디)
- [ ] 푸시 알림
- [ ] 코스튬 스토어 (유료 아이템)

---

## 5. 아키텍처 설계

### 전체 구조
```
Flutter App
├── Auth Layer         — Supabase Auth (Google / Apple Sign-In)
├── Hamster Engine     — 시간 기반 스탯 감소 로직
├── Animation Layer    — Rive / Lottie 애니메이션
├── Custom System      — 배경, 가구, 아이템 꾸미기
├── Local Cache        — Hive (오프라인 대응)
└── Cloud Sync         — Supabase (PostgreSQL + Storage)
```

### 데이터 흐름
```
유저 로그인 (Google/Apple)
    ↓
Supabase Auth 인증
    ↓
햄스터 상태 로드 (Supabase DB)
    ↓
로컬 Hive 캐시 저장
    ↓ ↑
앱 내 인터랙션 (먹이, 코디, 핸들)
    ↓
실시간 스탯 변화 계산
(시간 경과 → 배고픔/체력 감소)
    ↓
Supabase DB 동기화 (30분 주기 or 앱 종료 시)
```

### DB 스키마 (초안)

**users** — Supabase Auth 연동
```
id, email, created_at
```

**hamsters**
```
id, user_id, name, hunger(0-100), happiness(0-100),
health(0-100), level, last_fed_at, created_at
```

**custom_items**
```
id, user_id, item_type(background/furniture/accessory),
item_id, is_equipped, acquired_at
```

---

## 6. 핵심 게임루프

```
[앱 실행]
    ↓
시간 경과 계산 (마지막 접속 이후 경과 시간)
    ↓
스탯 감소 적용 (배고픔, 체력)
    ↓
햄스터 상태 애니메이션 / 말풍선으로 감정 표시
(행복 / 보통 / 배고픔 / 슬픔)
    ↓
유저 인터랙션 (먹이 주기 / 놀아주기 / 꾸미기)
    ↓
스탯 증가 + 리액션 애니메이션
    ↓
[앱 종료 또는 30분 후 Supabase 동기화]
```

---

## 7. 기술 스택

| 영역 | 기술 |
|------|------|
| 앱 프레임워크 | Flutter 3.x (Dart) |
| 상태 관리 | Riverpod |
| 애니메이션 | Rive (또는 Lottie) |
| 로컬 저장소 | Hive |
| 백엔드/DB | Supabase (PostgreSQL) |
| 인증 | Supabase Auth (Google, Apple) |
| 이미지 저장 | Supabase Storage |
| 배포 | App Store + Google Play |

---

## 8. 브레인스토밍 로그

| 단계 | 결정 | 이유 |
|------|------|------|
| Phase 1 | 버추얼 육성 앱 | 실제 햄스터 대체 경험 |
| Phase 1 | 햄스터 애호가 + 케주얼 게이머 동시 공략 | 두 그룹 니즈가 겹침 |
| Phase 2 | Flutter 선택 | 애니메이션 성능 우선 |
| Phase 2 | Firebase → Supabase 변경 | 오픈소스, PostgreSQL 유연성 |
| Phase 3 | 집 꾸미기 V1 포함 | 소유욕 자극 → 중독성 핵심 요소 |
| Phase 4 | 소셜 로그인 필수 | 데이터 분실 방지, 기기 변경 대응 |

---

## 9. 다음 단계

```
현재: Plan ✅
다음: /pdca design hamster-virtual-pet
      → 화면 설계, 컴포넌트 구조, DB 스키마 상세화
```
