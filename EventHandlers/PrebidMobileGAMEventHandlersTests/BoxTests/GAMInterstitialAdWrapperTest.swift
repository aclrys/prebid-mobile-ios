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

import XCTest
import GoogleMobileAds
@testable import PrebidMobileGAMEventHandlers

class GAMInterstitialAdWrapperTest: XCTestCase {
    
    private class DummyDelegate: NSObject, GADFullScreenContentDelegate {
    }
    
    private class DummyEventDelegate: NSObject, GADAppEventDelegate {
    }
    
    func testProperties() {
        let propTests: [BasePropTest<GAMInterstitialAdWrapper>] = [
            RefProxyPropTest(keyPath: \.fullScreenContentDelegate, value: DummyDelegate()),
            RefProxyPropTest(keyPath: \.appEventDelegate, value: DummyEventDelegate()),
        ]
        
        guard let interstitial = GAMInterstitialAdWrapper(adUnitID: "/21808260008/prebid_oxb_html_interstitial") else {
            XCTFail()
            return
        }
                
        for nextTest in propTests {
            nextTest.run(object: interstitial)
        }
    }
}
