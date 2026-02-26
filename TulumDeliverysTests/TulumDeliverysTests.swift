//
//  TulumDeliverysTests.swift
//  TulumDeliverysTests
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import XCTest
import Testing
@testable import TulumDeliverys

struct TulumDeliverysTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    // TransactionTests.swift
    func testAddTransactionSavesToDB() async throws {
        // A. Setup
        let mockDB = MockDataManager()
        let repo = Repository(remoteDataSource: RemoteDataSource(), localDataSource: mockDB) // Inject the Mock!
        
        // B. Act
        try await repo.addTransaction(items: [])
        
        // C. Assert
        let saved = await mockDB.didCallSave
        XCTAssertTrue(saved, "Repository should have called save on the DataManager")
        
        //let items: [Item] = try await mockDB.fetch(descriptor: FetchDescriptor())
        //XCTAssertEqual(items.count, 0)
    }

}
