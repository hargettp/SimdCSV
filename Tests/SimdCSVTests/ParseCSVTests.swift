//
//  ParseCSVTests.swift
//  
//
//  Created by Andreas Dreyer Hysing on 12/04/2020.
//


#if !os(watchOS)
import XCTest
@testable import SimdCSV

final class ParseCSVTests: XCTestCase {
    func testShrinkToFit() {
        // Arrange
        let indexes = Array<UInt32>(repeating: 0, count: 128)
        let indexEnds = Array<UInt32>(repeating: 0, count: 128)
        var parseCSV = ParseCSV.init(indexEnds: indexEnds, indices:indexes, numberOfIndexes: 2)

        // Act
        parseCSV.shrinkToFit()

        // Assert
        XCTAssertEqual(2, parseCSV.indices.count)
    }

    func testShrinkToFit_InputIsHardCase() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        result.csv.shrinkToFit()
    }

    func test_getCellRemoveQuotes() {
        let simdCSV = SimdCSV()
        let text = "\"Tyler, The Creator\",1991\r\n" +
                 "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell = result.csv.getCellRemoveQuotes(idx: 0)

        XCTAssertEqual("Tyler, The Creator", cell)
    }

    func test_getCellRemoveQuotes_InputLacksQuotes() {
        let simdCSV = SimdCSV()
        let text = "\"Tyler, The Creator\",1991\r\n" +
                 "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell = result.csv.getCellRemoveQuotes(idx: 1)

        XCTAssertEqual("1991", cell)
    }

    func test_getCell() {
        let simdCSV = SimdCSV()
        let text = "\"Tyler, The Creator\",1991\r\n" +
                 "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell = result.csv.getCell(idx: 0)

        XCTAssertEqual("\"Tyler, The Creator\"", cell)
    }

    func test_getCell_row_column() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell1 = result.csv.getCell(row: 0, col: 1);

        XCTAssertEqual("Year of birth", cell1)

        let cell2 = result.csv.getCell(row: 2, col: 0);

        XCTAssertEqual("Roxanne Shanté", cell2)
    }

    func test_getCellRemoveQuotes_row_column() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)

        let cell1 = result.csv.getCellRemoveQuotes(row: 1, col: 0);

        XCTAssertEqual("Tyler, The Creator", cell1)

        let cell2 = result.csv.getCellRemoveQuotes(row: 4, col: 0);

        XCTAssertEqual("Royce da 5'9\"\"", cell2)

        let cell3 = result.csv.getCellRemoveQuotes(row: 2, col: 1);

        XCTAssertEqual("1970", cell3)
    }

    func test_getRow() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)
        let actual = result.csv.getRow(row: 2)
        XCTAssertEqual(["Roxanne Shanté","1970"], actual)
    }

    func test_fetchRow() {
        let simdCSV = SimdCSV()
        let text = "Hip Hop Musician,Year of birth\r\n" +
                   "\"Tyler, The Creator\",1991\r\n" +
                   "Roxanne Shanté,1970\r\n" +
                   "Roy Woods,1996\r\n" +
                   "\"Royce da 5'9\"\"\",1977\r\n" +
                   "                                                        "
        let data = text.data(using: .utf8)!
        let result = simdCSV.loadCSVData64BitPadded(csv: data, CRLF: true)
        var actual = Array(repeating: "", count: Int(result.csv.numberOfColumns))
        result.csv.fetchRow(row: 2, cells: &actual)
        XCTAssertEqual(["Roxanne Shanté","1970"], actual)
    }
}

#endif
