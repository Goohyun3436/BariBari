//
//  BariBariWidget.swift
//  BariBariWidget
//
//  Created by Goo on 4/24/25.
//

import WidgetKit
import SwiftUI
import MobileCoreServices
import RealmSwift

struct CourseEntry: TimelineEntry {
    let date: Date
    let course: CourseThumbnail?
    var url: URL? {
        guard let course,
              let folder = course.folder,
              let folderID = folder._id,
              let courseID = course._id
        else { return nil }
        
        return URL(string: "\(C.appUrlScheme)://storage/\(folderID)/course?id=\(courseID)")
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CourseEntry {
        return CourseEntry(date: Date(), course: CourseThumbnail(image: nil, title: "잠수교 밤바리", address: "서울 서초구 반포동"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CourseEntry) -> ()) {
        completion(placeholder(in: context))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let course = RealmRepository.shared.fetchRandomCourse()
        let entry = CourseEntry(date: Date(), course: course)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
        completion(timeline)
    }
}

@available(iOS 17.0, *)
struct BariBariWidgetEntryView: View {
    let entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        if let course = entry.course {
            switch family {
            case .systemSmall:
                BariBariSmallWidgetView(course: course, widgetURL: entry.url)
            case .systemMedium:
                BariBariMediumWidgetView(course: course, widgetURL: entry.url)
            default:
                Text("지원되지 않는 크기입니다.")
            }
        } else {
            placeholder()
        }
    }
    
    private func placeholder() -> some View {
        Text(C.noneCourseFolder)
            .font(.caption)
            .foregroundStyle(.gray)
            .containerBackground(Color.black.opacity(0.7), for: .widget)
    }
}

struct ImageBackground: View {
    var imageData: Data?
    
    var body: some View {
        if let imageData, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .clipped()
        } else {
            Color.black.opacity(0.7)
        }
    }
}

struct BackgroundWithLogo: View {
    var imageData: Data?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ImageBackground(imageData: imageData)
                    .overlay(Color.black.opacity(0.4))
                
                Image("AppIcon_black_removed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .position(x: geo.size.width - 22, y: 22)
            }
        }
    }
}

@available(iOS 17.0, *)
struct BariBariSmallWidgetView: View {
    let course: CourseThumbnail
    let widgetURL: URL?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(course.date)
                .font(.system(size: 10))
                .bold()
                .foregroundStyle(.white)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(.white)
                    Text(course.address)
                        .font(.system(size: 10))
                        .bold()
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            BackgroundWithLogo(imageData: course.image)
        }
        .widgetURL(widgetURL)
    }
}

@available(iOS 17.0, *)
struct BariBariMediumWidgetView: View {
    let course: CourseThumbnail
    let widgetURL: URL?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(course.date)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.callout)
                        .bold()
                        .foregroundStyle(.white)
                    HStack(spacing: 4) {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.white)
                        Text(course.address)
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            BackgroundWithLogo(imageData: course.image)
        }
        .widgetURL(widgetURL)
    }
}

struct BariBariWidget: Widget {
    let kind: String = C.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BariBariWidgetEntryView(entry: entry)
            } else {
                Text("iOS 17 이상에서만 지원됩니다.")
            }
        }
        .configurationDisplayName("바리바리")
        .description("라이딩 코스 추억")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
