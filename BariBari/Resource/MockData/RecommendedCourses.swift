//
//  RecommendedCourses.swift
//  BariBari
//
//  Created by Goo on 4/7/25.
//

import Foundation

let recommendedCourses: [Course] = [
    Course(
        image: Data(),
        title: "서울 주변 당일 투어",
        content: "서울에서 시작하여 팔당댐, 양평을 거쳐 북악스카이웨이와 반포 한강공원을 연결하는 코스로, 자연의 평온함과 도시의 활기찬 에너지가 완벽하게 어우러진 약 140km의 루트입니다.",
        duration: 0,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "도착지",
            zone: "서울",
            coord: Coord(lat: 37.5126, lng: 126.9912)
        ),
        pins: [
            Pin(
                address: "출발지",
                zone: "서울",
                coord: Coord(lat: 37.5665, lng: 126.9780)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.5233, lng: 127.2503)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.4912, lng: 127.4877)
            ),
            Pin(
                address: "경유지",
                zone: "서울",
                coord: Coord(lat: 37.5926, lng: 126.9664)
            ),
            Pin(
                address: "도착지",
                zone: "서울",
                coord: Coord(lat: 37.5126, lng: 126.9912)
            )
        ]
    ),
    Course(
        image: Data(),
        title: "북악스카이웨이 라이딩 코스",
        content: "서울 도심에서 즐기는 최고의 스카이라인 뷰 코스. 북악산의 아름다운 경관과 서울 도심의 파노라마를 감상할 수 있는 라이딩 명소입니다. 도로변에는 경치 좋은 전망대가 있어 잠시 쉬어가기 좋습니다.",
        duration: 0,
        zone: "서울",
        date: "",
        destinationPin: Pin(
            address: "도착지",
            zone: "서울",
            coord: Coord(lat: 37.5926, lng: 126.9664)
        ),
        pins: [
            Pin(
                address: "출발지",
                zone: "서울",
                coord: Coord(lat: 37.5665, lng: 126.9780)
            ),
            Pin(
                address: "경유지",
                zone: "서울",
                coord: Coord(lat: 37.5889, lng: 126.9697)
            ),
            Pin(
                address: "도착지",
                zone: "서울",
                coord: Coord(lat: 37.5926, lng: 126.9664)
            )
        ]
    ),
    Course(
        image: Data(),
        title: "양평 드라이브 코스",
        content: "서울에서 가까운 양평으로 떠나는 상쾌한 라이딩 코스. 한강을 따라 이어지는 도로와 푸른 자연 경관이 일품입니다. 계획 없이 떠나 마음에 드는 카페에 들어가보는 즉흥 라이딩에 적합한 코스입니다.",
        duration: 0,
        zone: "경기",
        date: "",
        destinationPin: Pin(
            address: "도착지",
            zone: "경기",
            coord: Coord(lat: 37.4912, lng: 127.4877)
        ),
        pins: [
            Pin(
                address: "출발지",
                zone: "서울",
                coord: Coord(lat: 37.5665, lng: 126.9780)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.5233, lng: 127.2503)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.5450, lng: 127.3850)
            ),
            Pin(
                address: "도착지",
                zone: "경기",
                coord: Coord(lat: 37.4912, lng: 127.4877)
            )
        ]
    ),
    Course(
        image: Data(),
        title: "사운드밸리 라이딩 코스",
        content: "서울 근교의 인기 있는 오토바이 코스로, 곡선이 많고 산악 지형을 통과하는 다이나믹한 라이딩을 즐길 수 있습니다. 숙련된 라이더들에게 추천되는 코스로, 도로 상태가 좋고 경치도 훌륭합니다.",
        duration: 0,
        zone: "경기",
        date: "",
        destinationPin: Pin(
            address: "도착지",
            zone: "경기",
            coord: Coord(lat: 37.6853, lng: 127.1142)
        ),
        pins: [
            Pin(
                address: "출발지",
                zone: "경기",
                coord: Coord(lat: 37.6512, lng: 127.0837)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.6614, lng: 127.0952)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.6721, lng: 127.1058)
            ),
            Pin(
                address: "도착지",
                zone: "경기",
                coord: Coord(lat: 37.6853, lng: 127.1142)
            )
        ]
    ),
    Course(
        image: Data(),
        title: "팔당댐-두물머리 코스",
        content: "서울에서 출발하여 팔당댐과 두물머리를 거쳐 가는 아름다운 자연 경관 코스입니다. 한강과 남한강이 만나는 두물머리의 풍경이 특히 아름답고, 주변에 다양한 카페와 맛집이 있어 쉬어가기 좋습니다.",
        duration: 0,
        zone: "경기",
        date: "",
        destinationPin: Pin(
            address: "도착지",
            zone: "경기",
            coord: Coord(lat: 37.5303, lng: 127.3106)
        ),
        pins: [
            Pin(
                address: "출발지",
                zone: "서울",
                coord: Coord(lat: 37.5665, lng: 126.9780)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.5233, lng: 127.2503)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.5380, lng: 127.2850)
            ),
            Pin(
                address: "도착지",
                zone: "경기",
                coord: Coord(lat: 37.5303, lng: 127.3106)
            )
        ]
    ),
    Course(
        image: Data(),
        title: "남양주-가평 코스",
        content: "서울에서 출발하여 남양주를 거쳐 가평까지 이어지는 코스로, 북한강을 따라 달리는 상쾌한 라이딩을 즐길 수 있습니다. 중간에 자라섬과 청평호수 등 아름다운 경치를 감상할 수 있는 포인트가 많습니다.",
        duration: 0,
        zone: "경기",
        date: "",
        destinationPin: Pin(
            address: "도착지",
            zone: "경기",
            coord: Coord(lat: 37.8315, lng: 127.5142)
        ),
        pins: [
            Pin(
                address: "출발지",
                zone: "서울",
                coord: Coord(lat: 37.5665, lng: 126.9780)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.6359, lng: 127.2165)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.7249, lng: 127.4138)
            ),
            Pin(
                address: "경유지",
                zone: "경기",
                coord: Coord(lat: 37.7795, lng: 127.4941)
            ),
            Pin(
                address: "도착지",
                zone: "경기",
                coord: Coord(lat: 37.8315, lng: 127.5142)
            )
        ]
    )
]
