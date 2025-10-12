## Project Rules

- Always use API version 65.0.
- You can always find the current org alias in current-org.txt

### 1. Custom Object (`Todo__c`) Rules

- The object's API name **must** be `Todo__c`.
- **Crucially, no custom fields can be marked as required.** This is to ensure the component can be deployed and tested easily without validation rule conflicts.

---

### 2. Apex Controller (`TodoController.cls`) Rules

- Your code **must** be placed inside the existing `TodoController` class.
- Use `with sharing` on the class definition.
- Include clear JavaDoc comments for every method with proper `@param` and `@return` documentation.
- Methods used with `@wire` must include `@AuraEnabled(cacheable=true)` - without `cacheable=true`, `@wire` cannot retrieve data.
- Use `Database.insert()`, `Database.update()`, and `Database.delete()` with `false` parameter for partial success handling.
- Implement comprehensive SOQL queries selecting all relevant fields including system fields (Id, Name, CreatedDate, LastModifiedDate).
- Use proper sorting: `ORDER BY Due_Date__c ASC NULLS LAST, Priority__c DESC, CreatedDate DESC`.
- Set default values for Status ('Not Started') and Priority ('Medium') when creating records.
- Use `Schema.DescribeFieldResult` to dynamically retrieve picklist values for better maintainability.
- Return full record objects after create/update operations for immediate UI updates.
- Aggregate multiple database errors into single exception messages for better user experience.
- Use try/catch blocks with `AuraHandledException` for all user-facing error messages.

---

### 3. Lightning Web Component (`todoManager`) Rules

- Use the `@wire` service to call Apex methods. Your wire function must handle both `data` and `error`.
- Use optional chaining (e.g., `this.data?.records`) to prevent runtime errors.
- Follow modern JavaScript best practices including ES6+ features, destructuring, and arrow functions.
- Use `refreshApex` to refresh todos retrieved using the `@wire` service.
- Always initialize arrays as empty `[]` in `@wire` error/undefined cases to prevent template rendering failures.
- Use `lightning-formatted-date-time` to show formatted dates.
- Do not put expressions in data-bindings in the HTML template.
- Import all necessary modules: `track`, `wire`, `ShowToastEvent`, `refreshApex`.
- Implement comprehensive state management for loading states and form data
- Implement proper form validation and user feedback mechanisms
- Implement responsive design with SLDS grid system and utility classes
- Use proper event delegation and error handling for all async operations.
- You do not need `@track` decorator for reactive properties that need to trigger re-renders.

---

### 4. Deployment Process

- Deploy files using the `sf-deploy-metadata` tool.
- The `sourceDir` parameter must include the paths for `objects` and `lwc`. For example:
- You can find the current metadata alias in current-org.txt.
  ```json
  {
    "sourceDir": [
      "force-app/main/default/classes",
      "force-app/main/default/lwc"
    ],
    "usernameOrAlias": "[TARGET_ORG_ALIAS]",
    "directory": "[CURRENT_PROJECT_DIRECTORY]"
  }
  ```

---

### 5. Previewing the App

- If the user asks to preview the app or run it in local dev mode, run this terminal command:

`sf lightning dev app --target-org "$ALIAS" --name="Todo Manager" --device-type desktop`

- If the output of this command instructs the user to open a URL in the browser, output the link and notify the user to click it to see the app in local dev mode.
- If the command fails, install the local dev plugin with:

`sf plugins install @salesforce/plugin-lightning-dev@latest`

---

### 6. Resetting the environment

- When the user asks you to reset the demo, run this terminal command:
  `./bin/demo-reset.sh`

- You must only run this command when explicitly asked to do so.

### Helpful tips

- If you run into issues running `sf lightning` commands, install the latest version of the plugin with `sf plugins install @salesforce/plugin-lightning-dev@latest`
- **Wait** to deploy the metadata and preview the app until specifically instructed
- You **must** deploy the appropriate LWC metadata before previewing it using the `sf lightning dev` commands
- If you can't deploy with metadata after trying twice, use the Salesforce CLI `sf` commands

### General Prohibited Actions

- **Do not** create any files or metadata other than the `Todo__c` object and its fields.
- **Do not** write Apex tests.
- **Do not** use hardcoded IDs or `System.debug()` statements.
- **Do not** run `./bin/demo-reset.sh` without permission.
- **Do not** create any other files, tabs, apps, or permissions.
- **Do not** attempt to update or write to the Todo\_\_c.Name field.
- **Do not** implement inline event handlers in HTML templates - use proper event delegation.
- **Do not** use `System.debug()` or console.log statements in production code.
