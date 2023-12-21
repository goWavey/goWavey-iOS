# Mobile SDK API

## Overview
This document outlines the entities and endpoints for the Mobile SDK focused on gamification features like badges, levels, progress tracking, and rewards.

## Entities

### Badge
- **Fields**: `id`, `name`, `description`, `criteria`, `iconUrl`, `type`, `level`
- **Description**: Represents different types of achievements users can earn.

### Reward
- **Fields**: `id`, `name`, `description`, `iconUrl`, `value`, `type`
- **Description**: Defines rewards that users can earn for completing specific activities.

### Trophy Case
- **Fields**: `userId`, `trophies`, `totalPoints`, `level`, `nextLevelThreshold`, `lastUpdated`
- **Description**: A collection of user's achievements and progress in the SDK.

## Endpoints

### Badges
- **GET /badges**: Retrieve all badges.
- **POST /badges**: Create a new badge.
- **Others**: Endpoints for specific badge operations.

### User Activity
- **POST /userActivity**: Record user's actions.
  - **Required Parameters**: `authToken`, `activityId`, `value`

## Authentication
Each request requires an `authToken` for secure access, injected when SDK is instantiated.

## Usage
The API supports functionalities for tracking user achievements, managing rewards, and customizing gamification elements within the mobile application.

---
