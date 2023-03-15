### Now for a little internet optimism

# Template README
This is a template repository specifically for open-source app maintainers, with code (at_app), contributing guides, and packages. You can fork this repo to launch your open-source project. See (github.com/atsign-foundation/privatefit) as an example open-source project built on the atPlatform. This template was created by Sahil Mehta (Sahil-Mehta881), based on an archetype repo developed by Chris Swan (cpswan).


## Setting up Your Repo
1. Create a new repository from this template (click the "Use this template" button in the top right of the repo).
2. Clone your new repo to your local device.
3. If you haven't already, install Dart (https://dart.dev/get-dart) and Flutter (https://docs.flutter.dev/get-started/install).
4. Set up app starter code for your project (see Setting up Template Code).

## Setting up Template Code
Atsign has created app starter code (`at_app` - developed by Xavier Chanthavong) for new projects. Proceed these steps to generate this code in your repository. See this page for more details (https://pub.dev/packages/at_app/example)
1. On your local terminal, `cd` into your repository's directory
2. Activate the latest version of at_app: `dart pub global activate at_app`
3. If you receive this error message (`Warning: Pub installs executables into $HOME/.pub-cache/bin, which is not on your path.`), then run the following command in your terminal, then re-run step #2: `export PATH="$PATH":"$HOME/.pub-cache/bin"`
4. Generate starter code in the current directory: `at_app create .`



## Checklist for your README

### App Overview
Start with an overview of your app. Open with intent - we welcome contributions - we want pull requests and to hear about issues.

### Who is this for?
The README should be addressed to somebody who's never seen this before.
But also don't assume that they're a novice.

### How to Contribute
This is where you give developers and designers guidance on how they can contribute to code. Normally, the repo should have issues for developers to work on and submit pull requests for.

### Clarify Installation & Dependencies
Are there specific installation requirements for open source developers to contribute to your project? As a minimum, apps on the atPlatform require installation of Flutter and Dart. 

## Why The atPlatform
If you are building your app on the atPlatform, provide a description for developers on why you are using this technology. See some of our other projects (Priv@teFit: https://github.com/atsign-foundation/privatefit) for an example of this.

### Writing

Does the writing flow, with proper grammar and correct spelling?

### Links

Are the links to external resources correct?
Are the links to other parts of the project correct
(beware stuff carried over from previous repos where the
project might have lived during earlier development)?


### Acknowledgement/Attribution

Have we correctly acknowledged the work of others (and their Trademarks etc.)
where appropriate (per the conditions of their LICENSE?

### LICENSE

Which LICENSE are we using?  
Is the LICENSE(.md) file present?  
Does it have the correct dates, legal entities etc.?

## Maintainers

Who created this?  

Do they have complete GitHub profiles?  

How can they be contacted?  

Who is going to respond to pull requests?  
