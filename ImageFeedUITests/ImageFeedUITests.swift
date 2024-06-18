//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Илья Волощик on 18.06.24.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
        
        override func setUpWithError() throws {
            continueAfterFailure = false
            app.launchArguments = ["UITEST"]
            app.launch()
        }
        

    func testAuth() throws {
        //сценарий авторизации
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("Логин/почта")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Пароль")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
        
        func testFeed() throws {
            // тестируем сценарий ленты
            let tablesQuery = app.tables
            
            let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            cell.swipeUp()

            sleep(5)
            
            let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
            cellToLike.buttons["Like Button"].tap()
            sleep(5)
            
            cellToLike.buttons["Like Button"].tap()
            sleep(5)
            
            cellToLike.tap()
            sleep(5)
            
            let image = app.scrollViews.images.element(boundBy: 0)
           
            image.pinch(withScale: 3, velocity: 1)
           
            image.pinch(withScale: 0.5, velocity: -1)
            
            let navBackButtonWhiteButton = app.buttons["nav back button white"]
            navBackButtonWhiteButton.tap()
        }
        
        func testProfile() throws {
            // тестируем сценарий профиля
            sleep(3)
            app.tabBars.buttons.element(boundBy: 1).tap()
           
            XCTAssertTrue(app.staticTexts["Имя Фамилия"].exists)
            XCTAssertTrue(app.staticTexts["@псевдоним"].exists)
            
            app.buttons["logout button"].tap()
            
            app.alerts["Предупреждение"].scrollViews.otherElements.buttons["Да выйти"].tap()
        }
}
