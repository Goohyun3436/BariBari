//
//  RecommendedCourses.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import Foundation

let recommendedCourses: [Course] = [
    Course(
        image: nil,
        title: "서울 주변 당일 투어",
        content: "서울 도심을 따라 달리는 강변 라이딩 코스. 응봉산에서 시작해 뚝섬, 잠실, 봉은사를 지나 반포까지 이어지는 길은 도시의 풍경과 한강의 여유를 함께 느낄 수 있어요. 중간중간 쉬어가기 좋은 뷰 포인트도 많고, 가볍게 들를 수 있는 스팟들이 라이딩의 재미를 더해줍니다. 복잡한 일상 속에서 잠시 벗어나고 싶을 때, 부담 없이 즐기기 좋은 코스예요.",
        duration: 1,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "서울 송파구 신천동",
            zone: "서울",
            coord: Coord(lat: 37.5138593, lng: 127.1018578)
        ),
        pins: [
            Pin(
                address: "응봉산 팔각정",
                zone: "서울",
                coord: Coord(lat: 37.553164, lng: 127.033436)
            ),
            Pin(
                address: "뚝섬한강공원",
                zone: "서울",
                coord: Coord(lat: 37.5308205, lng: 127.0926268)
            ),
            Pin(
                address: "잠실역(잠실대교 푸드트럭)",
                zone: "서울",
                coord: Coord(lat: 37.5138593, lng: 127.1018578)
            ),
            Pin(
                address: "봉은사",
                zone: "서울",
                coord: Coord(lat: 37.5158257, lng: 127.0577345)
            )
        ]
    ),
    Course(
        image: nil,
        title: "북악스카이웨이 라이딩 코스",
        content: "서울 도심에서 즐기는 최고의 스카이라인 뷰 코스. 북악산의 아름다운 경관과 서울 도심의 파노라마를 감상할 수 있는 라이딩 명소입니다. 도로변에는 경치 좋은 전망대가 있어 잠시 쉬어가기 좋습니다.",
        duration: 1,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "서울 종로구 평창동",
            zone: "서울",
            coord: Coord(lat: 37.5981, lng: 127.0099)
        ),
        pins: [
            Pin(
                address: "창의문앞삼거리",
                zone: "서울",
                coord: Coord(lat: 37.5927086, lng: 126.9657956)
            ),
            Pin(
                address: "부암동",
                zone: "서울",
                coord: Coord(lat: 37.5937962, lng: 126.9678340)
            ),
            Pin(
                address: "북악스카이웨이",
                zone: "서울",
                coord: Coord(lat: 37.6009411, lng: 126.9768052)
            ),
            Pin(
                address: "정릉동",
                zone: "서울",
                coord: Coord(lat: 37.6063929, lng: 126.9869806)
            ),
            Pin(
                address: "정릉동",
                zone: "서울",
                coord: Coord(lat: 37.6014244, lng: 127.0010656)
            ),
            Pin(
                address: "돈암동",
                zone: "서울",
                coord: Coord(lat: 37.5966840, lng: 127.0061522)
            ),
            Pin(
                address: "정릉역",
                zone: "서울",
                coord: Coord(lat: 37.6018892, lng: 127.0126947)
            )
        ]
    ),
    Course(
        image: nil,
        title: "잠수교",
        content: "잠수교는 서울 도심을 가로지르는 대표적인 라이딩 명소입니다. 자동차, 오토바이, 자전거가 함께 오가는 도로라 긴장감도 있으면서 활기찬 분위기를 느낄 수 있어요. 특히 패닝샷 찍기 좋은 구간으로도 잘 알려져 있어서, 카메라를 챙겨 나오는 라이더 분들도 많습니다. 노을이 질 무렵에는 풍경이 정말 멋져서 잠시 속도를 늦추고 천천히 달리게 되기도 해요. 서울에서 스피드와 감성을 동시에 느끼고 싶다면, 잠수교는 꼭 한 번 달려보시길 추천드립니다.",
        duration: 1,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "서울 서초구 반포동",
            zone: "서울",
            coord: Coord(lat: 37.5145595, lng: 126.9979603)
        ),
        pins: [
            Pin(
                address: "잠수교북단지하보도",
                zone: "서울",
                coord: Coord(lat: 37.5209874, lng: 126.9937967)
            ),
            Pin(
                address: "고속터미널역",
                zone: "서울",
                coord: Coord(lat: 37.5043414, lng: 127.0010992)
            )
        ]
    ),
    Course(
        image: nil,
        title: "노들로",
        content: "노들로는 강변을 따라 시원하게 뻗은 직선 구간이 인상적인 라이딩 코스입니다. 도로 폭도 넓고 비교적 차량 흐름도 안정적이라, 초보 라이더분들도 부담 없이 달릴 수 있어요. 특히 한강을 옆에 두고 달리는 기분은 도심 속 스트레스를 날려주는 데 제격입니다. 야경도 예쁘고, 바람도 시원해서 낮보다 밤에 달리기 좋아하시는 분들도 많습니다.",
        duration: 1,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "서울 영등포구 당산동",
            zone: "서울",
            coord: Coord(lat: 37.4912, lng: 127.4877)
        ),
        pins: [
            Pin(
                address: "노들로(출발지)",
                zone: "서울",
                coord: Coord(lat: 37.5120956, lng: 126.9593401)
            ),
            Pin(
                address: "신길동",
                zone: "서울",
                coord: Coord(lat: 37.5181045, lng: 126.9172817)
            ),
            Pin(
                address: "당산동",
                zone: "경기",
                coord: Coord(lat: 37.5350467, lng: 126.9055648)
            ),
            Pin(
                address: "양화한강공원",
                zone: "경기",
                coord: Coord(lat: 37.5418668, lng: 126.8950179)
            ),
            Pin(
                address: "노들로(도착지)",
                zone: "경기",
                coord: Coord(lat: 37.5479235, lng: 126.8791821)
            )
        ]
    ),
    Course(
        image: nil,
        title: "소월로",
        content: "소월로는 남산을 감싸 안듯 돌아가는 구불구불한 도심 산책로 같은 코스입니다. 도로는 좁고 차량 통행도 많지 않아, 조용하게 달리기 좋습니다. 특히 이른 아침이나 해 질 녘에 오르면 서울 도심이 한눈에 내려다보이면서도, 나무 사이로 햇살이 스며드는 풍경이 멋집니다. 짧지만 분위기 있는 업힐 코스로도 유명해서 가볍게 오르막을 즐기시고 싶은 분들께도 잘 맞습니다. 남산 둘레길과도 연결되어 있어, 여유 있는 하루 라이딩 코스로 추천드릴 만한 곳입니다.",
        duration: 1,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "서울 용산구 후암동",
            zone: "서울",
            coord: Coord(lat: 37.5476983, lng: 126.9844247)
        ),
        pins: [
            Pin(
                address: "소월로(출발지)",
                zone: "서울",
                coord: Coord(lat: 37.5550255, lng: 126.9768229)
            ),
            Pin(
                address: "가을단풍길",
                zone: "서울",
                coord: Coord(lat: 37.5476983, lng: 126.9844247)
            ),
            Pin(
                address: "용암초등학교",
                zone: "서울",
                coord: Coord(lat: 37.5453090, lng: 126.9903899)
            ),
            Pin(
                address: "이태원동",
                zone: "서울",
                coord: Coord(lat: 37.5409234, lng: 126.9974418)
            ),
            Pin(
                address: "소월로(도착지)",
                zone: "서울",
                coord: Coord(lat: 37.5436361, lng: 127.0017782)
            )
        ]
    ),
    Course(
        image: nil,
        title: "서울 도심 라이딩",
        content: "서울 한복판을 관통하는 이 코스는 이수교차로에서 시작해 숙명여대, 시청역, 광화문을 지나며 도심의 다양한 풍경을 즐길 수 있습니다. 도심 속에 있지만 적당한 업다운과 넓은 도로가 조화를 이루어 편하게 달리기 좋고요, 중간중간 명소들이 있어 쉬어가기에도 좋습니다.",
        duration: 1,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "광화문",
            zone: "서울",
            coord: Coord(lat: 37.5754181, lng: 126.9759128)
        ),
        pins: [
            Pin(
                address: "이수교차로",
                zone: "서울",
                coord: Coord(lat: 37.4997371, lng: 126.9850174)
            ),
            Pin(
                address: "숙명여대",
                zone: "서울",
                coord: Coord(lat: 37.5422924, lng: 126.9729208)
            ),
            Pin(
                address: "시청역",
                zone: "서울",
                coord: Coord(lat: 37.5637969, lng: 126.9771104)
            ),
            Pin(
                address: "광화문",
                zone: "서울",
                coord: Coord(lat: 37.5754181, lng: 126.9759128)
            )
        ]
    ),
    Course(
        image: nil,
        title: "청평대교 - 남이섬 코스",
        content: "청평대교에서 남이섬까지 이어지는 코스는 자연 속에서 여유롭게 달릴 수 있는 대표적인 라이딩 루트입니다. 한적한 도로와 북한강을 따라 펼쳐지는 풍경이 어우러져, 달리는 내내 속도보다는 풍경에 더 눈이 가게 되실 거예요. 오르막이 살짝 있는 구간도 있지만, 전반적으로 부담 없이 즐기실 수 있고요. 도착지인 남이섬에서는 잠시 쉬어가며 경치도 즐기고 간단한 스낵도 챙길 수 있어 피크닉 라이딩 느낌으로도 딱 좋습니다. 서울 근교에서 하루 코스로 다녀오기 좋은 조용하고 그림 같은 길을 찾고 계신다면 추천드릴게요.",
        duration: 1,
        zone: "경기",
        date: "",
        destinationPin: Pin(
            address: "남이섬",
            zone: "강원 춘천시",
            coord: Coord(lat: 37.7947818, lng: 127.5200132)
        ),
        pins: [
            Pin(
                address: "청평대교",
                zone: "강원",
                coord: Coord(lat: 37.728239, lng: 127.4074504)
            ),
            Pin(
                address: "청평호",
                zone: "강원",
                coord: Coord(lat: 37.7104597, lng: 127.4871180)
            ),
            Pin(
                address: "가평빠지",
                zone: "강원",
                coord: Coord(lat: 37.7591007, lng: 127.5372000)
            ),
            Pin(
                address: "남이섬",
                zone: "강원",
                coord: Coord(lat: 37.7947818, lng: 127.5200132)
            ),
            Pin(
                address: "자라섬",
                zone: "강원",
                coord: Coord(lat: 37.8208949, lng: 127.5210701)
            )
        ]
    )
]
