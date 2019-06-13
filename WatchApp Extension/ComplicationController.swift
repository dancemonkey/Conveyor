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
//    handler([.forward, .backward])
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
      let template = CLKComplicationTemplateModularLargeTallBody()
      template.headerTextProvider = CLKSimpleTextProvider(text: "Conveyor Today")
      template.bodyTextProvider = CLKSimpleTextProvider(text: "due: \(WatchStore.shared.tasksDueToday())")
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
      template.headerTextProvider = CLKSimpleTextProvider(text: "Conveyor Today")
      template.body1TextProvider = CLKSimpleTextProvider(text: "Due: \(WatchStore.shared.tasksDueToday())")
      template.tintColor = ColorStyles.primary
      let text = WatchStore.shared.nextTaskDue()?.title ?? "All done!"
      template.body2TextProvider = CLKSimpleTextProvider(text: "\(text)")
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .graphicCircular:
      let template = CLKComplicationTemplateGraphicCircularImage()
      template.imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "watchUtilSmall")!)
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
//    case .extraLarge:
//    case .graphicCorner:
//    case .graphicBezel:
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
      let template = CLKComplicationTemplateModularLargeTallBody()
      template.headerTextProvider = CLKSimpleTextProvider(text: "Today")
      template.bodyTextProvider = CLKSimpleTextProvider(text: "due: 6")
      handler(template)
    case .utilitarianSmall:
      let template = CLKComplicationTemplateUtilitarianSmallFlat()
      let text = "Walk the dog"
      template.textProvider = CLKSimpleTextProvider(text: "\(text)")
      template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "watchUtilSmall")!)
      handler(template)
    case .graphicRectangular:
      let template = CLKComplicationTemplateGraphicRectangularStandardBody()
      template.headerImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "watchUtilSmall")!)
      template.headerTextProvider = CLKSimpleTextProvider(text: "Conveyor Today")
      template.body1TextProvider = CLKSimpleTextProvider(text: "due: 3")
      let text = "Walk the dog"
      template.body2TextProvider = CLKSimpleTextProvider(text: "\(text)")
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
    default:
      handler(nil)
    }
  }
  
}
