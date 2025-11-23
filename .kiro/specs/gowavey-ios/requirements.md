# GoWavey iOS SDK - Requirements

## Overview
The GoWavey iOS SDK is a native Swift library that enables iOS applications to integrate gamification features including activity tracking, trophy case display, and badge management with Lottie animations.

## User Stories

### US-1: SDK Initialization
**As an** iOS developer integrating GoWavey  
**I want to** initialize the SDK with authentication credentials  
**So that** I can authenticate API requests and track user activities

**Acceptance Criteria:**
- SDK accepts authToken and memberId in initializer
- SDK validates required parameters are provided
- SDK creates composition root with dependencies
- SDK configures API client with authentication
- SDK is thread-safe for concurrent access

### US-2: Activity Tracking
**As an** iOS developer  
**I want to** track user activities  
**So that** I can trigger rewards based on user behavior

**Acceptance Criteria:**
- SDK provides updateActivity method accepting Activity struct
- Activity includes id (String) and value (Int)
- SDK makes POST request to /activities/process endpoint
- SDK returns UpdateActivityResponse with message and badges
- SDK uses async/await for asynchronous operations
- SDK returns Combine publisher for reactive programming
- SDK handles network errors gracefully

### US-3: Trophy Case Display
**As an** iOS developer  
**I want to** display a trophy case UI  
**So that** users can see their achievements

**Acceptance Criteria:**
- SDK provides TrophyCaseView SwiftUI component
- TrophyCaseView accepts trophy case id
- TrophyCaseView fetches trophy data from API
- TrophyCaseView displays badges in configurable grid layout
- TrophyCaseView supports custom background colors (black, gray, white)
- TrophyCaseView shows loading state during fetch
- TrophyCaseView shows error state on failure
- TrophyCaseView supports badge tap callbacks

### US-4: Trophy Case Data Retrieval
**As an** iOS developer  
**I want to** retrieve trophy case data programmatically  
**So that** I can build custom UI or process trophy data

**Acceptance Criteria:**
- SDK provides getTrophyCase method accepting id
- SDK makes GET request to /trophies endpoint
- SDK returns TrophyCase with backgroundColor, countInRow, and badges
- SDK uses async/await for asynchronous operations
- SDK returns Combine publisher for reactive programming
- SDK handles network errors gracefully

### US-5: Badge Display with Animations
**As an** iOS developer  
**I want to** display badges with Lottie animations  
**So that** users have engaging visual feedback for achievements

**Acceptance Criteria:**
- SDK includes Lottie dependency for animations
- SDK bundles animation JSON files (animation1-6.json)
- Badge entity includes animationName field
- SDK provides BadgeView component for displaying badges
- BadgeView loads badge icon from URL
- BadgeView shows achieved/unachieved state (opacity)
- BadgeView displays badge name and description
- BadgeView supports Lottie animations when specified

### US-6: Clean Architecture
**As an** iOS developer maintaining the SDK  
**I want to** follow clean architecture principles  
**So that** the codebase is maintainable and testable

**Acceptance Criteria:**
- SDK separates concerns into layers (UI, Domain, Data)
- Domain layer contains entities and use cases
- Data layer handles API communication and DTOs
- UI layer contains SwiftUI views and view models
- Dependencies flow inward (UI → Domain ← Data)
- Use cases define protocols for testability
- Composition root manages dependency injection

### US-7: Dependency Injection
**As an** iOS developer  
**I want to** use dependency injection  
**So that** components are loosely coupled and testable

**Acceptance Criteria:**
- SDK uses @Injected property wrapper for dependencies
- SDK provides SDKCompositionRoot for dependency creation
- Composition root creates and registers all dependencies
- Dependencies are resolved at runtime
- SDK supports testing with mock dependencies

### US-8: Swift Package Manager Support
**As an** iOS developer  
**I want to** install the SDK via Swift Package Manager  
**So that** I can manage it as a standard dependency

**Acceptance Criteria:**
- SDK provides Package.swift manifest
- SDK specifies iOS 15+ minimum deployment target
- SDK declares Lottie dependency
- SDK includes resource bundle for animations
- SDK builds successfully with SPM
- SDK can be added to Xcode projects via SPM

### US-9: CocoaPods Support
**As an** iOS developer  
**I want to** install the SDK via CocoaPods  
**So that** I can use it in CocoaPods-based projects

**Acceptance Criteria:**
- SDK provides .podspec file
- Podspec specifies version, authors, license
- Podspec declares Lottie dependency (~> 4.4.0)
- Podspec includes source files and resources
- SDK installs successfully via CocoaPods
- SDK works in CocoaPods-based projects

### US-10: Combine Integration
**As an** iOS developer  
**I want to** use Combine publishers  
**So that** I can integrate with reactive Swift code

**Acceptance Criteria:**
- SDK methods return AnyPublisher<T, Error>
- Publishers emit success values or errors
- Publishers work with Combine operators
- Publishers support cancellation
- SDK handles async/await to Combine bridging

### US-11: SwiftUI Integration
**As an** iOS developer  
**I want to** use SwiftUI components  
**So that** I can integrate with modern iOS apps

**Acceptance Criteria:**
- SDK provides SwiftUI views (TrophyCaseView, BadgeView)
- Views follow SwiftUI best practices
- Views use @StateObject for view models
- Views support SwiftUI previews
- Views are composable and reusable
- Views handle loading and error states

### US-12: Error Handling
**As an** iOS developer  
**I want to** receive clear error information  
**So that** I can handle failures appropriately

**Acceptance Criteria:**
- SDK propagates network errors through publishers
- SDK shows error states in UI components
- SDK provides toast notifications for errors
- SDK logs errors for debugging
- SDK doesn't crash on API failures

### US-13: Async Image Loading
**As an** iOS developer  
**I want to** load badge images asynchronously  
**So that** UI remains responsive

**Acceptance Criteria:**
- SDK uses AsyncImage for badge icons
- Images load from badge iconUrl
- Loading shows progress indicator
- Failed loads show placeholder
- Images cache automatically
- Images don't block UI thread

### US-14: Customizable UI
**As an** iOS developer  
**I want to** customize trophy case appearance  
**So that** it matches my app's design

**Acceptance Criteria:**
- TrophyCaseView supports background color configuration
- TrophyCaseView adjusts text color based on background
- TrophyCaseView supports custom grid layout (countInRow)
- TrophyCaseView supports badge tap callbacks
- Badge opacity indicates achieved/unachieved state
- UI components are themeable

## Non-Functional Requirements

### Performance
- API calls should complete within reasonable timeouts
- UI should remain responsive during network operations
- Image loading should not block main thread
- Animations should run at 60fps
- Memory usage should be efficient

### Compatibility
- Supports iOS 15.0 and later
- Compatible with Swift 5.9+
- Works with SwiftUI and UIKit apps
- Supports both SPM and CocoaPods
- Compatible with Xcode 15+

### Security
- Transmits authToken securely via HTTPS
- Validates authentication on all API requests
- Doesn't store sensitive data locally
- Uses secure networking practices

### Maintainability
- Code follows Swift best practices
- Architecture is clean and layered
- Dependencies are injected and testable
- Code is documented with comments
- Follows semantic versioning

### Reliability
- Handles network failures gracefully
- Shows appropriate error states
- Doesn't crash on invalid data
- Recovers from transient failures
- Provides meaningful error messages

## Out of Scope
- Offline caching of trophy data
- Member initialization with deduplication (handled by backend)
- Analytics and tracking beyond activity updates
- Push notifications for achievements
- Social sharing of achievements
- Custom animation creation tools
