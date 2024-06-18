//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 12.06.24.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "webViewViewController") as! WebViewViewController
        let presenterSpy = WebViewPresenterSpy()
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest2() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "webViewViewController") as! WebViewViewController
        let presenterSpy = WebViewPresenterSpy()
        let viewControllerSpy = WebViewViewControllerSpy()
        viewController.presenter = presenterSpy
        presenterSpy.view = viewControllerSpy
        
        _ = viewController.view
        
        XCTAssertTrue(viewControllerSpy.loadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString: String = url!.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        
        //given
        let authHelper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        
        //when
        let url = urlComponents.url!
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}

final class ProfilePresenterTests: XCTestCase {
    func testLoadProfileI() {
        
        // Given
        let mockPresenter = MockProfilePresenter()
        let viewcontroller = MockProfileViewController()
        viewcontroller.presenter = mockPresenter
        
        // When
        viewcontroller.viewDidLoad()
        
        //Then
        XCTAssertTrue(mockPresenter.viewDidLoadCalled)
    }
    
    func testLogutProfile() {
        //Given
        let presenter = MockProfilePresenter()
        
        //When
        presenter.LogoutProfile()
        
        //Then
        XCTAssertTrue(presenter.logoutService.logoutCalled)

    }

    func testUpdateAvatar() {
        // Given
        let mockPresenter = MockProfilePresenter()
        let viewcontroller = MockProfileViewController()
        viewcontroller.presenter = mockPresenter
        mockPresenter.view = viewcontroller
        
        //When
        mockPresenter.updateAvatar()
        
        //Then
        XCTAssertNotNil(viewcontroller.profileAvatar)
    }
}

final class ImageListPresenterTests: XCTestCase {
    func testViewDidLoadVC() {
        //Given
        let presenter = ImageListPresenterSpy()
        let viewcontroller = ImagesListVCSpy()
        presenter.view = viewcontroller
        viewcontroller.presenter = presenter
        
        //When
        viewcontroller.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewDidLoadPresenterFirst() {
        //Given
        let presenter = ImageListPresenterSpy()
        let imageListService = ImageListServiceSpy()
        presenter.imageListService = imageListService
        
        //When
        presenter.imageListService!.fetchPhotosNextPage()
        
        //Then
        XCTAssertFalse(imageListService.photos.isEmpty)
    }
    
    func testViewDidLoadPresenterSecond() {
        //Given
        let presenter = ImageListPresenterSpy()
        let imageListService = ImageListServiceSpy()
        presenter.imageListService = imageListService
        
        //When
        presenter.imageListService!.fetchPhotosNextPage()
        presenter.mockphotos = imageListService.photos
        
        //Then
        XCTAssertFalse(presenter.mockphotos.isEmpty)
    }
    
    func testConfigCell() {
        //Given
        let presenter = ImageListPresenterSpy()
        let cell = ImagesListCell()
        
        //When
        presenter.configCell(for: cell, with: IndexPath())
        
        //Then
        XCTAssertTrue(presenter.cellDidConfig)
        
    }
    
}

