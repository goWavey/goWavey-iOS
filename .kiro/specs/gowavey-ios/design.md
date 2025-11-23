# GoWavey iOS SDK - Design

## Architecture Overview

The SDK follows Clean Architecture principles with three distinct layers:

```
┌─────────────────────────────────────────┐
│           UI Layer (SwiftUI)            │
│  TrophyCaseView, BadgeView, ViewModels  │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Domain Layer (Business)        │
│   Entities, Use Cases, Protocols        │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│        Data Layer (Infrastructure)      │
│   API, Networking, DTOs, Providers      │
└─────────────────────────────────────────┘
```

**Dependency Rule:** Dependencies point inward. UI depends on Domain, Data depends on Domain, but Domain depends on nothing.

## Core Components

### 1. RewardSDK (Public API)

**Location:** `RewardSDK.swift`

**Responsibilities:**
- Main entry point for SDK consumers
- SDK initialization with authentication
- Exposes public API methods

**Interface:**
```swift
public final class RewardSDK {
    public init(authToken: String, memberId: String)
    public func updateActivity(_ activity: Activity) async -> AnyPublisher<UpdateActivityResponse, Error>
}
```

**Implementation Details:**
- Creates SDKCompositionRoot with auth credentials
- Initializes dependency injection container
- Delegates to UpdateActivity for activity tracking
- Thread-safe singleton pattern

### 2. UpdateActivity (Activity Tracking)

**Location:** `UpdateActivity.swift`

**Responsibilities:**
- Activity tracking coordination
- Delegates to UpdateActivityUseCase

**Interface:**
```swift
public final class UpdateActivity {
    public func updateActivity(_ activity: Activity) async -> AnyPublisher<UpdateActivityResponse, Error>
}
```

**Dependencies:**
- `@Injected var updateActivityUseCase: UpdateActivityUseCase`

### 3. Domain Layer

#### Entities

**Activity** (`DomainLayer/Entities/Activity.swift`)
```swift
public struct Activity {
    let id: String
    let value: Int
}
```

**Badge** (`DomainLayer/Entities/Badge.swift`)
```swift
public struct Badge: Identifiable, Hashable {
    public let id: String
    let name: String
    let description: String
    let iconUrl: String
    let isAchieved: Bool
    let animationName: String?
}
```

**TrophyCase** (`DomainLayer/Entities/TrophyCase.swift`)
```swift
struct TrophyCase {
    let backgroundColor: String
    let countInRow: Int
    var trophies: [Badge]
}
```

**Reward** (`DomainLayer/Entities/Reward.swift`)
```swift
struct Reward {
    let id: String
    let name: String
    let description: String
    let iconUrl: String
}
```

#### Use Cases

**UpdateActivityUseCase** (`DomainLayer/UseCases/UpdateActivityUseCase.swift`)
```swift
protocol UpdateActivityUseCase {
    func updateActivity(_ activity: Activity) async -> AnyPublisher<UpdateActivityResponse, Error>
}

public struct UpdateActivityResponse {
    public var message: String
    public var badges: [Badge]?
}
```

**GetTrophyCaseUseCase** (`DomainLayer/UseCases/GetTrophyCaseUseCase.swift`)
```swift
protocol GetTrophyCaseUseCase {
    func getTrophyCase(id: String) async -> AnyPublisher<TrophyCase, Error>
}
```

### 4. Data Layer

#### API Endpoints

**APIEndpoints** (`DataLayer/API/APIEndpoints.swift`)
```swift
enum APIEndpoints {
    static func updateActivity(_ activity: Activity, authentication: Authentication) -> Endpoint<UpdateActivityDTO>
    static func getTrophyCase(id: String, authentication: Authentication) -> Endpoint<TrophyCaseDTO>
}
```

**EndpointRoute** (`DataLayer/API/EndpointRoutes.swift`)
```swift
enum EndpointRoute {
    case updateUserActivity  // "activities/process"
    case trophyCase          // "trophies"
    
    var path: String
}
```

#### Endpoint Configuration

**Endpoint** (`DataLayer/API/Endpoint.swift`)
- Generic endpoint configuration
- HTTP method (GET, POST, PUT, DELETE)
- Body parameters, query parameters
- Authentication handling
- Response type mapping

**APIRequest** (`DataLayer/API/APIRequest.swift`)
- HTTP request execution
- URLSession integration
- Response parsing
- Error handling

**DefaultRequestAuthenticator** (`DataLayer/API/DefaultRequestAuthenticator.swift`)
- Adds Authorization header with authToken
- Injects memberId into requests

#### DTOs (Data Transfer Objects)

**Location:** `DataLayer/DTOs/`

- `UpdateActivityDTO`: Maps to UpdateActivityResponse
- `TrophyCaseDTO`: Maps to TrophyCase
- DTOs handle JSON serialization/deserialization
- DTOs convert to domain entities

#### Providers

**Location:** `DataLayer/Providers/`

- Implement use case protocols
- Bridge between API and domain layer
- Handle DTO to entity mapping
- Manage async/await to Combine conversion

### 5. UI Layer

#### TrophyCaseView

**Location:** `UILayer/TrophyCase/TrophyCaseView.swift`

**Responsibilities:**
- Display trophy case grid
- Handle loading and error states
- Support badge tap interactions
- Customize appearance

**Interface:**
```swift
public struct TrophyCaseView: View {
    public init(id: String, onBadgeTap: ((Badge) -> Void)? = nil)
    public var body: some View
}
```

**Features:**
- LazyVGrid layout with configurable columns
- Background color customization (black, gray, white)
- Adaptive text color based on background
- Loading state with LoaderView
- Error state with ContentUnavailableView
- Toast notifications for errors
- Badge tap gesture handling

**State Management:**
```swift
@StateObject var viewModel = ViewModel()
```

#### TrophyCaseViewModel

**Location:** `UILayer/TrophyCase/TrophyCaseViewModel.swift`

**Responsibilities:**
- Fetch trophy case data
- Manage loading/error states
- Expose data to view

**State:**
- `trophyCase: TrophyCase?`
- `isLoading: Bool`
- `hasFailed: Bool`
- `hasAttemptedFetch: Bool`
- `toast: Toast?`

**Methods:**
```swift
func getTrophyCase(id: String) async
```

#### BadgeView

**Location:** `UILayer/BadgeView.swift`

**Responsibilities:**
- Display individual badge
- Show achieved/unachieved state
- Load badge icon asynchronously

**Features:**
- AsyncImage for icon loading
- Opacity based on achievement status
- Badge name display
- Lottie animation support

#### TrophyCaseBadgeView

**Location:** Embedded in `TrophyCaseView.swift`

**Responsibilities:**
- Badge display within trophy case grid
- Consistent sizing and layout

**Layout:**
- Fixed width: UIScreen.main.bounds.width/3
- Fixed height: 120
- Icon: 50x50
- Opacity: 1.0 (achieved) or 0.2 (unachieved)

### 6. Composition Root

**SDKCompositionRoot** (`CompositionRoot/SDKCompositionRoot.swift`)

**Responsibilities:**
- Dependency injection container
- Create and register dependencies
- Manage object lifecycle

**Initialization:**
```swift
init(authToken: String, memberId: String)
func createDependencies()
```

**Registered Dependencies:**
- API client with authentication
- Use case implementations
- Providers
- Network layer components

**Injected Property Wrapper** (`CompositionRoot/Injected.swift`)

```swift
@propertyWrapper
struct Injected<T> {
    var wrappedValue: T {
        // Resolve dependency from container
    }
}
```

## Data Flow

### Activity Update Flow

```
User calls updateActivity(Activity)
    ↓
RewardSDK.updateActivity()
    ↓
UpdateActivity.updateActivity()
    ↓
UpdateActivityUseCase.updateActivity()
    ↓
Provider makes API request
    ↓
APIEndpoints.updateActivity()
    ↓
Endpoint<UpdateActivityDTO> created
    ↓
APIRequest executes HTTP POST
    ↓
POST /activities/process
    Body: { activityId, value }
    Headers: { Authorization: authToken }
    ↓
Backend processes activity
    ↓
Response: UpdateActivityDTO
    ↓
Map DTO to UpdateActivityResponse
    ↓
Return AnyPublisher<UpdateActivityResponse, Error>
    ↓
User receives badges earned
```

### Trophy Case Display Flow

```
User adds TrophyCaseView(id: "trophy-id")
    ↓
View appears
    ↓
ViewModel.getTrophyCase(id:) called
    ↓
GetTrophyCaseUseCase.getTrophyCase()
    ↓
Provider makes API request
    ↓
APIEndpoints.getTrophyCase()
    ↓
Endpoint<TrophyCaseDTO> created
    ↓
APIRequest executes HTTP GET
    ↓
GET /trophies?trophyId={id}
    Headers: { Authorization: authToken }
    ↓
Backend returns trophy data
    ↓
Response: TrophyCaseDTO
    ↓
Map DTO to TrophyCase
    ↓
ViewModel updates state
    ↓
View re-renders with trophy data
    ↓
LazyVGrid displays badges
    ↓
AsyncImage loads badge icons
```

## API Integration

### Base URL
Configured in API layer (not exposed in public API)

### Authentication
All requests include Authorization header:
```
Authorization: {authToken}
```

### Endpoints

**POST /activities/process**
- Request Body: `{ "activityId": String, "value": Int }`
- Response: `{ "message": String, "badges": [Badge]? }`
- Purpose: Track user activity and receive earned badges

**GET /trophies**
- Query Parameters: `trophyId={id}`
- Response: `{ "backgroundColor": String, "countInRow": Int, "trophies": [Badge] }`
- Purpose: Retrieve trophy case configuration and badges

### Error Handling

**Network Errors:**
- Connection failures
- Timeout errors
- Invalid responses

**API Errors:**
- 401 Unauthorized
- 404 Not Found
- 500 Server Error

**Error Propagation:**
- Errors flow through Combine publishers
- UI layer catches errors and shows error states
- Toast notifications for user feedback

## Dependency Management

### Swift Package Manager

**Package.swift:**
```swift
let package = Package(
    name: "GoWaveySDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "GoWaveySDK", targets: ["GoWaveySDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "4.0.1"))
    ],
    targets: [
        .target(
            name: "GoWaveySDK",
            dependencies: [.product(name: "Lottie", package: "lottie-ios")],
            resources: [.process("Resources")]
        )
    ]
)
```

### CocoaPods

**GoWaveySDK.podspec:**
```ruby
Pod::Spec.new do |spec|
  spec.name                  = "GoWaveySDK"
  spec.version               = "1.0.3"
  spec.platform              = :ios, "15.0"
  spec.swift_version         = "5.3"
  spec.dependency            'lottie-ios', '~> 4.4.0'
  spec.source_files          = 'GoWaveySDK/Sources/GoWaveySDK/**/*.swift'
  spec.resource_bundles      = {
    'GoWaveySDKResources' => ['GoWaveySDK/Sources/GoWaveySDK/Resources/*.json']
  }
end
```

## Resources

### Lottie Animations

**Location:** `Sources/GoWaveySDK/Resources/`

**Files:**
- `animation1.json` - Animation for badge type 1
- `animation2.json` - Animation for badge type 2
- `animation3.json` - Animation for badge type 3
- `animation4.json` - Animation for badge type 4
- `animation5.json` - Animation for badge type 5
- `animation6.json` - Animation for badge type 6

**Usage:**
- Badge entity includes `animationName` field
- UI layer loads animation by name
- Lottie renders animation on badge display

## Correctness Properties

### CP-1: SDK Initialization (US-1)
**Property:** SDK must initialize with valid credentials
- GIVEN authToken and memberId
- WHEN RewardSDK is initialized
- THEN composition root creates dependencies successfully

### CP-2: Activity Tracking (US-2)
**Property:** Activity updates must reach backend
- GIVEN valid Activity with id and value
- WHEN updateActivity is called
- THEN POST request is made to /activities/process

### CP-3: Trophy Case Loading (US-3, US-4)
**Property:** Trophy case must load and display correctly
- GIVEN valid trophy case id
- WHEN TrophyCaseView appears
- THEN GET request fetches trophy data and displays grid

### CP-4: Badge Achievement State (US-5)
**Property:** Badge appearance must reflect achievement status
- GIVEN badge with isAchieved flag
- WHEN badge is displayed
- THEN opacity is 1.0 if achieved, 0.2 if not

### CP-5: Async Image Loading (US-13)
**Property:** Badge icons must load asynchronously
- GIVEN badge with iconUrl
- WHEN badge is displayed
- THEN AsyncImage loads without blocking UI

### CP-6: Error State Display (US-12)
**Property:** Errors must be shown to user
- GIVEN API request fails
- WHEN error occurs
- THEN UI shows error state and toast notification

### CP-7: Dependency Injection (US-7)
**Property:** Dependencies must be injected correctly
- GIVEN @Injected property wrapper
- WHEN dependency is accessed
- THEN composition root provides instance

### CP-8: Combine Publisher (US-10)
**Property:** Methods must return Combine publishers
- GIVEN async operation
- WHEN method is called
- THEN AnyPublisher<T, Error> is returned

### CP-9: SwiftUI State Management (US-11)
**Property:** Views must update when state changes
- GIVEN @StateObject view model
- WHEN view model state changes
- THEN view re-renders automatically

### CP-10: Resource Bundling (US-5)
**Property:** Animation resources must be accessible
- GIVEN animation JSON files in Resources/
- WHEN SDK is built
- THEN resources are included in bundle

## Testing Strategy

### Unit Tests

**Domain Layer:**
- Entity initialization and properties
- Use case protocol conformance

**Data Layer:**
- DTO to entity mapping
- Endpoint configuration
- Request authentication

**UI Layer:**
- View model state management
- Badge display logic
- Color calculations

### Integration Tests

**API Integration:**
- Mock network responses
- Test request/response flow
- Error handling scenarios

**Dependency Injection:**
- Test dependency resolution
- Mock dependencies for testing

### UI Tests

**SwiftUI Previews:**
- Visual verification of components
- Different states (loading, error, success)
- Various configurations

**Snapshot Tests:**
- Trophy case layouts
- Badge appearances
- Color themes

## Performance Considerations

### Network Efficiency
- Single API call per operation
- Efficient JSON parsing
- Request cancellation support

### UI Performance
- LazyVGrid for efficient rendering
- AsyncImage for non-blocking loads
- Lottie animations at 60fps
- Minimal view re-renders

### Memory Management
- Weak references where appropriate
- Proper Combine subscription cleanup
- Image caching via AsyncImage
- Resource bundle optimization

## Security Considerations

### Authentication
- AuthToken transmitted via HTTPS only
- Token stored securely by host app
- No local token persistence in SDK

### Data Privacy
- No PII stored locally
- MemberId managed by host app
- API responses don't contain sensitive data

### Network Security
- HTTPS for all API communication
- Certificate pinning (optional, host app responsibility)
- Request validation

## Build and Distribution

### Build Process
1. Swift compilation
2. Resource bundling
3. Framework generation
4. SPM/CocoaPods packaging

### Versioning
- Semantic versioning (MAJOR.MINOR.PATCH)
- Current version: 1.0.3
- Git tags for releases

### Distribution Channels
- Swift Package Manager (GitHub)
- CocoaPods (Specs repo)
- Manual framework integration

## Migration and Compatibility

### iOS Version Support
- Minimum: iOS 15.0
- Recommended: iOS 16.0+
- SwiftUI features require iOS 15+

### Swift Version
- Minimum: Swift 5.3
- Recommended: Swift 5.9+

### Backward Compatibility
- Maintain public API stability
- Deprecate before removing features
- Provide migration guides for breaking changes
