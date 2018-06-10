//
//  MixpanelTracker.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Stanwood GmbH (www.stanwood.io)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import Mixpanel

open class MixpanelTracker: Tracker {

    var parameterMapper: ParameterMapper?

    init(builder: MixpanelBuilder) {
        super.init(builder: builder)
        
        super.checkKey()
        
        if StanwoodAnalytics.trackingEnabled() == true {
            start()
        }
    }
    
    open override func start() {
        Mixpanel.initialize(token: key!)
        Mixpanel.mainInstance().loggingEnabled = loggingEnabled
    }

    override open func track(trackingParameters: TrackingParameters) {

        var properties: [String:String] = [:]
        properties["EventName"] = trackingParameters.eventName

        if let name = trackingParameters.name {
            properties["Name"] = name
        }

        if let itemId = trackingParameters.itemId {
            properties["ItemId"] = itemId
        }

        if let contentType = trackingParameters.contentType {
            properties["ContentType"] = contentType
        }

        if let category = trackingParameters.category {
            properties["Category"] = category
        }

        if let description = trackingParameters.description {
            properties["Description"] = description
        }
        
        trackingParameters.customParameters.forEach { (arg) in
            let (key, value) = arg
            properties[key] = value as? String
        }

        Mixpanel.mainInstance().track(event: trackingParameters.eventName, properties: properties)
    }
    
    override open func setTracking(enable: Bool) {
        Mixpanel.mainInstance().loggingEnabled = enable
        
        if enable == true {
            Mixpanel.mainInstance().optInTracking()
        } else {
            Mixpanel.mainInstance().optOutTracking()
        }
    }

    /**

     Track the error using logEvent and the UserInfo dictionary.

     */

    override open func track(error: NSError) {
        // Not tracking errors
    }

    override open func track(trackerKeys: TrackerKeys) {

        for (key,value) in trackerKeys.customKeys {
            if key == StanwoodAnalytics.Keys.screenName {
                if let screenName = value as? String {
                    Mixpanel.mainInstance().track(event: key, properties: [key: screenName])
                }
            } else if key == StanwoodAnalytics.Keys.identifier {
                if let userId = value as? String {
                    Mixpanel.mainInstance().identify(distinctId: userId)
                }
            } else if key == StanwoodAnalytics.Keys.email {
                if let userEmail = value as? String {
                    Mixpanel.mainInstance().people.set(property: "$email", to: userEmail)
                }
            } else {
                
                if let anyValue = value as? MixpanelType {
                    Mixpanel.mainInstance().people.set(property: key, to: anyValue)
                } else {
                    print("StanwoodAnalytics Error: Unsupported value for key (" + String(describing: key) + ") in TrackerKeys")
                }
            }
        }
    }

    open class MixpanelBuilder: Tracker.Builder {

        var parameterMapper: ParameterMapper?

        public override init(context: UIApplication, key: String?) {
            super.init(context: context, key: key)
        }

        open func add(mapper: ParameterMapper) -> MixpanelBuilder {
            parameterMapper = mapper
            return self
        }

        open override func build() -> MixpanelTracker {
            return MixpanelTracker(builder: self)
        }
    }
}
