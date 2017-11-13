// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import BSK

class BSKSpec: QuickSpec {
    
    override func spec() {
        
        describe("BSK adapter") {
            
            let mockDelegate = MockDelegate()
            let adapter = BSKAdapter(delegate: mockDelegate)
            let card = PaymentCard(cardNumber: "1234 1234 1234 1234", cvv: "666",
                                   expiryMonth: 20, expiryYear: 20)
            let identifier = "ABCD1234"
            let testURLString = Constants.mbmBaseURL + Constants.mbmConfirmationPath + identifier
            var request: URLRequest?
            
            beforeEach {
                request = adapter.confirmationRequestForTransactionWith(id: identifier, from: card)
            }
            
            afterEach {
                request = nil
            }
            
            it("confirmation request should not be nil") {
                expect(request).toNot(beNil())
            }
            
            it("confirmation request should be HTTP POST") {
                expect(request?.httpMethod).to(match("(?i)POST"))
            }
            
            it("confirmation request should use correct URL") {
                expect(request?.url?.absoluteString) == testURLString
            }
            
            it("confirmation request should contain correct HTTP headers") {
                expect(request?.allHTTPHeaderFields) == Constants.headers
            }
            
            it("confirmation request should contain correct HTTP body") {
                expect(request?.httpBody.flatMap { String(data: $0, encoding: .utf8)}) == """
                CardDataInputForm%5Bpan%5D=1234 1234 1234 1234&CardDataInputForm%5Bcvv2%5D=666&CardDataInputForm%5Bmonth%5D=20&CardDataInputForm%5Byear%5D=20&CardDataInputForm%5Bholder%5D=Card Holder&CardDataInputForm%5Bphone%5D=79990000000
                """
            }
        }
    }
}
