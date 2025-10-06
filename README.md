# Self-Guided Setup

This repository contains the project code for the 15-minute self-guided [Build with Agentforce Vibes](https://bit.ly/4gVbiBD) workshop.

## Prerequisites

Before you begin, ensure you have:

- A Salesforce account (Developer Edition recommended)
- Node.js v20.x or later
- Git installed on your machine

## Clone the GitHub repository

1. Clone the workshop repository to your local machine:

```bash
git clone https://github.com/charlesw-salesforce/enterprise-vibe-coding.git
cd enterprise-vibe-coding
```

## Set up your development environment

In this workshop, you'll use Visual Studio Code and the Salesforce CLI to build and deploy your todo app with Agentforce Vibes.

### Step 1: Install Node.js

If you already have Node.js v20.x or later installed, you can skip this step.

1. Download and install Node.js v20.x (LTS) from the [Node.js website](https://nodejs.org/).
2. Verify the installation by running:
   ```bash
   node --version
   ```

### Step 2: Install the Salesforce CLI

If you already have the Salesforce CLI installed, there's no need to reinstall it.

1. Install the CLI from the [Salesforce CLI downloads page](https://developer.salesforce.com/tools/salesforcecli).
2. Confirm the CLI is properly installed and on the latest version by running:
   ```bash
   sf update
   ```

### Step 3: Install Visual Studio Code

If you already have Visual Studio Code installed, there's no need to reinstall it.

1. Download and install the latest version of [Visual Studio Code](https://code.visualstudio.com/Download) for your operating system.
2. Launch Visual Studio Code.
3. On the left toolbar, click the **Extensions** icon.
4. Search for **Salesforce Extension Pack (Expanded)** and click **Install**.

Java is optional for this workshop but may be needed for certain CLI features. If you need it, download from [Adoptium](https://adoptium.net/) or [Oracle](https://www.oracle.com/java/technologies/javase-downloads.html).

## Sign up for a Salesforce account

If you don't already have a Salesforce Developer Edition account, create one:

1. Go to the [Salesforce Developer Edition sign-up page](https://developer.salesforce.com/signup).
2. Fill in the required information and submit the form.
3. Check your email for the verification link and activate your account.
4. Log in to your new Developer Edition org.

## Set up and authenticate a Dev Hub

A Dev Hub is required to create and manage scratch orgs for development.

### Step 1: Enable Dev Hub

1. Log in to your Salesforce Developer Edition org.
2. Click the **Setup** gear icon in the top right.
3. In the Quick Find box, type **Dev Hub** and select **Dev Hub**.
4. Click **Enable Dev Hub**.
5. (Optional but recommended) Enable **Source Tracking** to track changes in scratch orgs.

For detailed instructions, see the [Enable Dev Hub documentation](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm).

### Step 2: Authorize your Dev Hub

1. Open Visual Studio Code in your project directory.
2. Open the command palette (press `⌘ + Shift + P` on Mac or `Ctrl + Shift + P on Windows/Linux).
3. Search for **SFDX: Authorize an Org**.
4. Select **Production** as the login URL (Developer Edition uses production login).
5. Enter **`devhub`** for the org alias and press **Return**.
6. Complete the login in the browser window that opens.

## Create a scratch org (optional but encouraged)

Scratch orgs are temporary Salesforce environments ideal for development and testing. Using scratch orgs is an enterprise best practice.

### Create and set as default

1. In VS Code, open the command palette (`⌘ + Shift + P` on Mac or `Ctrl + Shift + P` on Windows/Linux).
2. Search for **SFDX: Create a Default Scratch Org**.
3. Press **Return** to accept the default project scratch org definition.
4. Enter an alias like **`vibe-scratch`** for your scratch org.
5. Select **7 days** for the duration.

Alternatively, use the command line:

```bash
sf org create scratch -f config/project-scratch-def.json -a vibe-scratch -d -y 7
```

### Open your scratch org

```bash
sf org open -o vibe-scratch
```

For more details, see the [Create Scratch Orgs documentation](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_create_scratch_org.htm).

If you prefer not to use a scratch org, you can deploy directly to your Developer Edition org. Simply authorize it with an alias like `dev-edition` and use it as your target org throughout the workshop.

## Verify your setup

Before proceeding to the workshop, confirm:

- [ ] Salesforce CLI is installed and updated (`sf --version`)
- [ ] VS Code with Salesforce Extension Pack (Expanded) is installed
- [ ] Node.js v20.x or later is installed (`node --version`)
- [ ] Dev Hub is enabled and authenticated
- [ ] Scratch org is created (or Developer Edition org is authorized)
- [ ] Repository is cloned and opened in VS Code

## Troubleshooting

### CLI not recognized

If the `sf` command is not recognized:

- Restart your terminal/command prompt
- Verify the CLI is in your system PATH
- Reinstall the CLI from the [downloads page](https://developer.salesforce.com/tools/salesforcecli)

### Authorization fails

If you can't authorize your org:

- Ensure you're using the correct login URL (Production for Developer Edition)
- Check that you're entering the correct credentials
- Clear your browser cache and try again
- Try using: `sf org login web -a devhub`

### Scratch org creation fails

If scratch org creation fails:

- Verify Dev Hub is enabled in your org
- Confirm you're authenticated to the Dev Hub: `sf org list`
- Check that the Dev Hub org has the `(D)` indicator (default Dev Hub)
- Ensure your Dev Hub org has available scratch org licenses

### Node version mismatch

If you see Node version errors:

- This workshop requires Node.js v20.x or later
- Download the latest LTS version from [nodejs.org](https://nodejs.org/)
- Verify the version with `node --version`

## Next steps

You're all set! Head to Build with Agentforce Vibes [Overview](https://bit.ly/4gVbiBD) page to begin your journey with enterprise vibe coding.
