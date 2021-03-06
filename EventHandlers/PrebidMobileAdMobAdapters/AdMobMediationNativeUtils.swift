/*   Copyright 2018-2021 Prebid.org, Inc.
 
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
 
  http://www.apache.org/licenses/LICENSE-2.0
 
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */

import Foundation
import PrebidMobile
import GoogleMobileAds

@objcMembers
public class AdMobMediationNativeUtils: NSObject, PrebidMediationDelegate {
    
    public let gadRequest: GADRequest
    
    private var eventExtras: [AnyHashable: Any]?
    
    public init(gadRequest: GADRequest) {
        self.gadRequest = gadRequest
        super.init()
    }
    
    public func setUpAdObject(configId: String,
                              configIdKey: String,
                              targetingInfo: [String : String],
                              extrasObject: Any?,
                              extrasObjectKey: String) -> Bool {
        
        eventExtras = AdMobUtils.buildExtras(configId: configId,
                                             configIdKey: configIdKey,
                                             extrasObject: extrasObject,
                                             extrasObjectKey: extrasObjectKey)
        
        gadRequest.keywords = AdMobUtils.buildKeywords(existingKeywords: gadRequest.keywords, targetingInfo: targetingInfo)
        
        return true
    }
    
    public func cleanUpAdObject() {
        guard let gadKeywords = gadRequest.keywords as? [String] else {
            return
        }
        gadRequest.keywords = AdMobUtils.removeHBKeywordsFrom(gadKeywords)
        eventExtras = nil
    }
    
    public func getAdView() -> UIView? {
        return nil
    }
    
    public func getEventExtras() -> [AnyHashable: Any]? {
        return eventExtras
    }
    
    public static func findNative(_ extras: [AnyHashable : Any],
                                  completion: @escaping (Result<PrebidMediatedUnifiedNativeAd, Error>) -> Void) {
        guard let response = extras[PBMMediationAdNativeResponseKey] as? [String: AnyObject] else {
            let error = PBMError.error(description: "The bid response dictionary is absent in the extras")
            completion(.failure(error))
            return
        }
        
        guard let cacheId = response[PrebidLocalCacheIdKey] as? String else {
            let error = PBMError.error(description: "No cache id in bid response dictionary")
            completion(.failure(error))
            return
        }
        
        guard let nativeAd = NativeAd.create(cacheId: cacheId) else {
            let error = AdMobAdaptersError.noAd
            completion(.failure(error))
            return
        }
        
        let admobUnifiedAd = PrebidMediatedUnifiedNativeAd(nativeAd: nativeAd)
        completion(.success(admobUnifiedAd))
    }
}
