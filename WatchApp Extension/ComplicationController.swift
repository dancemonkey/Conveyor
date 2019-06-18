//
//  ComplicationController.swift
//  delete me WatchKit Extension
//
//  Created by Drew Lanning on 6/12/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
  
  // MARK: - Timeline Configuration
  
  func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
    handler([])
  }
  
  func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    handler(Date())
  }
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    handler(Date())
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    handler(.showOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    var entry: CLKComplicationTimelineEntry?
    switch complication.family {
    case .circularSmall:
      let template = CLKComplicationTemplateCircularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: "\(WatchStore.shared.tasksDueToday())")
      template.tintColor = ColorStyles.primary
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .modularSmall:
      let template = CLKComplicationTemplateModularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: "\(WatchStore.shared.tasksDueToday())")
      template.tintColor = ColorStyles.primary
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .modularLarge:
      let template = CLKComplicationTemplateModularLargeStandardBody()
      template.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "watchModularLargeStandard")!)
      if let nextThreeTasks = WatchStore.shared.topThreeTasksDue() {
        template.headerTextProvider = CLKSimpleTextProvider(text: nextThreeTasks[0].title)
        if nextThreeTasks[0].priority {
          template.headerTextProvider.tintColor = ColorStyles.accent
        }
        if nextThreeTasks.count > 1 {
          template.body1TextProvider = CLKSimpleTextProvider(text: nextThreeTasks[1].title)
          if nextThreeTasks[1].priority {
            template.body1TextProvider.tintColor = ColorStyles.accent
          }
        } else {
          template.body1TextProvider = CLKSimpleTextProvider(text: "")
        }
        if nextThreeTasks.count > 2 {
          template.body2TextProvider = CLKSimpleTextProvider(text: nextThreeTasks[2].title)
          if nextThreeTasks[2].priority {
            template.body2TextProvider?.tintColor = ColorStyles.accent
          }
        }
      } else {
        template.headerTextProvider = CLKSimpleTextProvider(text: "All done!")
        template.body1TextProvider = CLKSimpleTextProvider(text: "Great job today!")
      }
      template.tintColor = ColorStyles.primary
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .utilitarianSmall:
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      let text = "due: \(WatchStore.shared.tasksDueToday())"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "watchUtilSmall")!)
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .graphicRectangular:
      let template = CLKComplicationTemplateGraphicRectangularStandardBody()
//      template.headerImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "watchGraphicRectangularStandard")!)
      if let nextThreeTasks = WatchStore.shared.topThreeTasksDue() {
        template.headerTextProvider = CLKSimpleTextProvider(text: nextThreeTasks[0].title)
        if nextThreeTasks[0].priority {
          template.headerTextProvider.tintColor = ColorStyles.accent
        }
        if nextThreeTasks.count > 1 {
          template.body1TextProvider = CLKSimpleTextProvider(text: nextThreeTasks[1].title)
          if nextThreeTasks[1].priority {
            template.body1TextProvider.tintColor = ColorStyles.accent
          }
        } else {
          template.body1TextProvider = CLKSimpleTextProvider(text: "")
        }
        if nextThreeTasks.count > 2 {
          template.body2TextProvider = CLKSimpleTextProvider(text: nextThreeTasks[2].title)
          if nextThreeTasks[2].priority {
            template.body2TextProvider?.tintColor = ColorStyles.accent
          }
        }
      } else {
        template.headerTextProvider = CLKSimpleTextProvider(text: "All done!")
        template.body1TextProvider = CLKSimpleTextProvider(text: "Great job today!")
      }
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .graphicCircular:
      let template = CLKComplicationTemplateGraphicCircularImage()
      template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "xLargeComplication")!)
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .utilitarianLarge:
      let template = CLKComplicationTemplateUtilitarianLargeFlat()
      let text = WatchStore.shared.nextTaskDue()?.title ?? "All done!"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      template.tintColor = ColorStyles.primary
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .utilitarianSmallFlat:
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      template.textProvider = CLKSimpleTextProvider(text: "due: \(WatchStore.shared.tasksDueToday())")
      template.tintColor = ColorStyles.primary
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .extraLarge:
      let template = CLKComplicationTemplateExtraLargeStackImage()
      template.line1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "xLargeComplication")!)
      template.line2TextProvider = CLKSimpleTextProvider(text: "due: \(WatchStore.shared.tasksDueToday())")
      template.tintColor = ColorStyles.primary
      template.highlightLine2 = true
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .graphicCorner:
      let template = CLKComplicationTemplateGraphicCornerTextImage()
      template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "GraphicCornerComplication")!)
      template.textProvider = CLKSimpleTextProvider(text: "due: \(WatchStore.shared.tasksDueToday())")
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .graphicBezel:
      let template = CLKComplicationTemplateGraphicBezelCircularText()
      let circularTemplate = CLKComplicationTemplateGraphicCircularImage()
      circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "xLargeComplication")!)
      template.circularTemplate = circularTemplate
      let text = WatchStore.shared.nextTaskDue()?.title ?? "All done!"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    default:
      handler(nil)
    }
  }
  
  func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries prior to the given date
    handler(nil)
  }
  
  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after to the given date
    handler(nil)
  }
  
  // MARK: - Placeholder Templates
  
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    switch complication.family {
    case .circularSmall:
      let template = CLKComplicationTemplateCircularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: "6")
      handler(template)
    case .modularSmall:
      let template = CLKComplicationTemplateModularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: "6")
      handler(template)
    case .modularLarge:
      let template = CLKComplicationTemplateModularLargeStandardBody()
      template.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "watchModularLargeStandard")!)
      template.headerTextProvider = CLKSimpleTextProvider(text: "Take out the papers")
      template.body1TextProvider = CLKSimpleTextProvider(text: "Take out the trash")
      template.body2TextProvider = CLKSimpleTextProvider(text: "Get your spending cash")
      template.tintColor = ColorStyles.primary
      handler(template)
    case .utilitarianSmall:
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      let text = "Walk the dog"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "watchUtilSmall")!)
      handler(template)
    case .graphicRectangular:
      let template = CLKComplicationTemplateGraphicRectangularStandardBody()
//      template.headerImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "watchGraphicRectangularStandard")!)
      template.headerTextProvider = CLKSimpleTextProvider(text: "Take out the papers")
      template.body1TextProvider = CLKSimpleTextProvider(text: "Take out the trash")
      template.body2TextProvider = CLKSimpleTextProvider(text: "Get your spending cash")
      handler(template)
    case .graphicCircular:
      let template = CLKComplicationTemplateGraphicCircularImage()
      template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "watchUtilSmall")!)
      handler(template)
    case .utilitarianLarge:
      let template = CLKComplicationTemplateUtilitarianLargeFlat()
      let text = "Walk the dog"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      template.tintColor = ColorStyles.primary
      handler(template)
    case .utilitarianSmallFlat:
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      template.textProvider = CLKSimpleTextProvider(text: "due: 6")
      template.tintColor = ColorStyles.primary
      handler(template)
    case .extraLarge:
      let template = CLKComplicationTemplateExtraLargeStackImage()
      template.line1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "xLargeComplication")!)
      template.line2TextProvider = CLKSimpleTextProvider(text: "due: 6")
      template.tintColor = ColorStyles.primary
      template.highlightLine2 = true
      handler(template)
    case .graphicCorner:
      let template = CLKComplicationTemplateGraphicCornerTextImage()
      template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "GraphicCornerComplication")!)
      template.textProvider = CLKSimpleTextProvider(text: "due: 6")
      handler(template)
    case .graphicBezel:
      let template = CLKComplicationTemplateGraphicBezelCircularText()
      let circularTemplate = CLKComplicationTemplateGraphicCircularImage()
      circularTemplate.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "xLargeComplication")!)
      template.circularTemplate = circularTemplate
      let text = "Walk the cat"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      handler(template)
    default:
      handler(nil)
    }
  }
  
}
