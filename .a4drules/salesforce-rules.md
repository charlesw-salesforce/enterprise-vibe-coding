## Project Rules

Always use API version 65.0.

### 1. Custom Object (`Todo__c`) Rules

- The object's API name **must** be `Todo__c`.
- **Crucially, no custom fields can be marked as required.** This is to ensure the component can be deployed and tested easily without validation rule conflicts.

---

### 2. Apex Controller (`TodoController.cls`) Rules

- Your code **must** be placed inside the existing `TodoController` class.
- Use `with sharing` on the class definition.
- Include clear JavaDoc comments for every method.
- Methods used with `@wire` must include `@AuraEnabled(cacheable=true)` - without `cacheable=true`, `@wire` cannot retrieve data.

---

### 3. Lightning Web Component (`todoManager`) Rules

- Use the `@wire` service to call Apex methods. Your wire function must handle both `data` and `error`.
- Use optional chaining (e.g., `this.data?.records`) to prevent runtime errors.
- Follow modern JavaScript best practices.
- Use `refreshApex` to refresh todos retrieved using the `@wire` service.
- Always initialize arrays as empty `[]` in `@wire` error/undefined cases to prevent template rendering failures.
- Use `lightning-formatted-date-time` to show formatted dates.

---

### 4. Deployment Process

- Await instruction from the user before attempting to deploy metadata.
- Deploy files using the `sf-deploy-metadata` tool.
- The `sourceDir` parameter must include the paths for `objects`, `classes`, and `lwc`. For example:
- You can find the current metadata alias in current-org.txt.
  ```json
  {
    "sourceDir": [
      "force-app/main/default/objects",
      "force-app/main/default/classes",
      "force-app/main/default/lwc"
    ],
    "usernameOrAlias": "[TARGET_ORG_ALIAS]",
    "directory": "[CURRENT_PROJECT_DIRECTORY]"
  }
  ```

---

### 5. Previewing the App

- Await instruction from the user before attempting to open the app in local dev mode
- You can find the current metadata alias in current-org.txt
- If the user asks to preview the app or run it in local dev mode, run this terminal command:

`sf lightning dev app --target-org "$ALIAS" --name="Todo Manager" --device-type desktop`

- If the output of this command instructs the user to open a URL in the browser, output the link and notify the user to click it to see the app in local dev mode.
- If the command fails, install the local dev plugin with:

`sf plugins install @salesforce/plugin-lightning-dev@latest`

### 6. Previewing individual Lightning Web Components

- If the user asks to preview a Lightning web component, run this terminal command:

`sf lightning dev component --target-org "$ALIAS" --name="$COMPONENT_NAME"`

**Creating components that work in Lightning Dev mode requires special considerations:**

- **Avoid Lightning Base Components with Module Dependencies**: Components like `lightning-card`, `lightning-button-icon`, and others that require module imports may not work in local dev mode. Use basic HTML with SLDS classes instead.

- **Use SLDS Classes Directly**: Replace Lightning base components with equivalent SLDS markup:
  - Instead of `<lightning-card>`, use `<div class="slds-card">`
  - Instead of `<lightning-button>`, use `<button class="slds-button">`
  - Apply SLDS utility classes for spacing: `slds-m-around_medium`, `slds-p-horizontal_small`

- **Avoid External Asset References**: Don't reference Salesforce standard assets like `/assets/icons/standard-sprite/svg/symbols.svg` as they're not available in local dev mode.

- **Keep Component Structure Simple**: Focus on core functionality and basic styling. Complex Lightning base components often have dependencies that aren't resolved locally.

- **Handle Port Conflicts**: If port 3000 is in use, kill existing processes with `lsof -ti:3000 | xargs kill -9` before starting dev mode.

- **Test in Both Environments**: Components working in dev mode should also be tested when deployed to ensure compatibility in both local and org environments.

---

### 7. Resetting the environment

- When the user asks you to reset the demo, run this terminal command:
  `./bin/demo-reset.sh`

- You must only run this command when explicitly asked to do so.

### Helpful tips

- If you run into issues running `sf lightning` commands, install the latest version of the plugin with `sf plugins install @salesforce/plugin-lightning-dev@latest`
- **Wait** to deploy the metadata and preview the app until specifically instructed.

### General Prohibited Actions

- **Do not** create any files or metadata other than the `Todo__c` object and its two fields.
- **Do not** write Apex tests.
- **Do not** use hardcoded IDs or `System.debug()` statements.
- **Do not** run `./bin/demo-reset.sh` without permission.
- **Do not** create any other files, tabs, apps, or permissions.
