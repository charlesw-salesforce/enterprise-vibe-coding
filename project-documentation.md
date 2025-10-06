# Todo App Project Documentation

This document provides comprehensive information about the Todo app project structure and requirements. It's designed to give an AI agent sufficient context to build the application without needing to read each individual file in the project.

## Project Overview

The Todo app is a simple "hello world" Salesforce application consisting of:

1. A custom object (`Todo__c`) for storing todo items
2. An Apex controller (`TodoController.cls`) for backend logic
3. A Lightning Web Component (`todoManager`) for the user interface

## File Structure

```
force-app/main/default/
├── applications/
│   └── Todo_Manager.app-meta.xml      # App definition
├── classes/
│   ├── TodoController.cls             # Apex controller (currently empty)
│   └── TodoController.cls-meta.xml    # Apex class metadata
├── flexipages/
│   └── Todo_Manager_Home.flexipage-meta.xml  # Home page configuration
├── layouts/
│   └── Todo__c-Todo Layout.layout-meta.xml   # Object layout
├── lwc/
│   └── todoManager/                   # LWC component
│       ├── todoManager.html           # HTML template (currently empty)
│       ├── todoManager.js             # JavaScript controller (minimal boilerplate)
│       └── todoManager.js-meta.xml    # Component metadata
├── objects/
│   └── Todo__c/                       # Todo custom object
│       ├── Todo__c.object-meta.xml    # Object metadata
│       └── fields/                    # Custom fields
│           ├── Description__c.field-meta.xml
│           ├── Due_Date__c.field-meta.xml
│           ├── Priority__c.field-meta.xml
│           └── Status__c.field-meta.xml
├── permissionsets/
│   └── Todo_Manager_Full_Access.permissionset-meta.xml  # Permissions
└── tabs/
    ├── Todo__c.tab-meta.xml           # Object tab
    └── Todo_Manager_Home.tab-meta.xml # Home tab
```

## Custom Object: Todo\_\_c

The Todo\_\_c object is already created with the following fields:

### Standard Fields

- **Name**: Auto-number field with format "TODO-{0000}"

### Custom Fields

- **Description\_\_c**: Text Area field for todo item details
- **Due_Date\_\_c**: Date field for the deadline
- **Priority\_\_c**: Picklist with values "Low", "Medium" (default), "High"
- **Status\_\_c**: Picklist with values "Not Started" (default), "In Progress", "Completed"

**Important**: All custom fields are configured as NOT required to prevent validation issues.

## Application Configuration

### Todo Manager App

- **API Name**: Todo_Manager
- **Type**: Lightning application
- **Navigation**: Standard navigation
- **Tabs**: Todo_Manager_Home, Todo\_\_c
- **Brand Color**: #0070D2 (Salesforce blue)

### Flexipage Configuration

- **Name**: Todo_Manager_Home
- **Type**: App Page
- **Template**: flexipage:defaultAppHomeTemplate
- **Component**: todoManager (placed in main region)

### Permission Set

- **API Name**: Todo_Manager_Full_Access
- **Object Permissions**: Full CRUD access to Todo\_\_c
- **Field Permissions**: Read/Edit access to all Todo\_\_c fields
- **Class Access**: Access to TodoController
- **Tab Visibility**: Todo_Manager_Home and Todo\_\_c tabs visible

## Required Implementation

### Apex Controller (TodoController.cls)

The Apex controller should be implemented with these specifications:

1. **Class Definition**:
   - Must use `with sharing` keyword
   - Must be placed inside the existing `TodoController` class
   - All methods must include clear JavaDoc comments

2. **Required Methods**:
   - Method(s) to retrieve todo records from the database
   - Method(s) to create new todo records
   - Method(s) to update existing todo records
   - Method(s) to delete todo records
   - Any methods used with `@wire` must include `@AuraEnabled(cacheable=true)`

3. **Best Practices**:
   - Implement proper error handling with try/catch blocks
   - Use SOQL queries with dynamic sorting where applicable
   - Throw AuraHandledException for user-friendly error messages
   - Do NOT use hardcoded IDs
   - Do NOT use System.debug() statements

### Lightning Web Component (todoManager)

The LWC component should be implemented with these specifications:

1. **Current State**:
   - **HTML Template**: Currently empty `<template> </template>`
   - **JavaScript Controller**: Minimal boilerplate with LightningElement import
   - **Metadata**: Configured for lightning**AppPage, lightning**HomePage, lightning\_\_RecordPage

2. **Technical Requirements**:
   - Use `@wire` service to call Apex methods
   - Wire functions must handle both `data` and `error` states
   - Use optional chaining (e.g., `this.data?.records`) to prevent runtime errors
   - Use `refreshApex` for refreshing data after modifications
   - Initialize arrays as empty `[]` in error/undefined cases to prevent template rendering failures
   - Use `lightning-formatted-date-time` for date formatting

3. **Functional Requirements**:
   - Form for creating new todos (Description, Due Date, Priority)
   - List view of existing todos with all field data
   - Sorting and filtering capabilities
   - Edit functionality for existing todos
   - Delete functionality with confirmation
   - Status update capability (mark as complete/incomplete)
   - Proper loading states and error handling
   - Toast notifications for user feedback

4. **UI Guidelines**:
   - Use Salesforce Lightning Design System (SLDS)
   - Implement responsive design
   - Use appropriate Lightning base components
   - Follow accessibility best practices

## Development Guidelines

1. **Apex Development**:
   - Add all logic within the existing `TodoController` class
   - Methods for wire adapters must use `@AuraEnabled(cacheable=true)`
   - Non-cacheable methods should use `@AuraEnabled`
   - Follow standard Apex best practices and coding conventions
   - Use proper exception handling patterns

2. **LWC Development**:
   - Import necessary modules (wire, track, refreshApex, etc.)
   - Structure component with clear separation of concerns
   - Use modern JavaScript ES6+ features
   - Follow LWC best practices for event handling and data management
   - Implement proper lifecycle management

## Deployment Process

When ready to deploy:

1. Use the Salesforce MCP deploy tool with these parameters:
   - `sourceDir`: ["force-app/main/default/objects", "force-app/main/default/classes", "force-app/main/default/lwc"]
   - `usernameOrAlias`: Target org alias
   - `directory`: Current project directory

2. The deployment will include:
   - Updated TodoController.cls with new functionality
   - Updated todoManager LWC with complete implementation
   - All existing metadata files (no changes needed)

## Testing and Preview

After deployment:

1. Assign the Todo_Manager_Full_Access permission set to test users
2. Access the Todo Manager app through the App Launcher
3. Test CRUD operations through the todoManager component
4. Verify sorting, filtering, and status update functionality

## Integration Points

1. **Component Usage**:
   - The todoManager component is configured to work on App Pages, Home Pages, and Record Pages
   - Currently placed on the Todo_Manager_Home flexipage

2. **App Navigation**:
   - Todo Manager app includes both the component home page and the standard Todo object tab
   - Users can switch between the custom component view and standard Salesforce object management

3. **Data Model**:
   - The Todo\_\_c object supports all standard Salesforce features (reports, workflows, etc.)
   - Custom fields are properly configured for UI interaction

This document provides all the necessary context for an AI agent to implement the TodoController.cls Apex class and the todoManager Lightning Web Component without requiring access to each individual file in the project.
