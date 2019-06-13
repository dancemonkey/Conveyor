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
    // Call the handler with the current timeline entry
    print("getting timeline entry")
    var entry: CLKComplicationTimelineEntry?
    switch complication.family {
    case .circularSmall:
      let template = CLKComplicationTemplateCircularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: "\(WatchStore.shared.tasksDueToday())")
      entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
      handler(entry)
    case .modularSmall:
      let template = CLKComplicationTemplateModularSmallSimpleText()
      template.textProvider = CLKSimpleTextProvider(text: "\(WatchStore.shared.tasksDueToday())")
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
    default:
      handler(nil)
    }
  }
  
}
