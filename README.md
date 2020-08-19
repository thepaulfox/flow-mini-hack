## Replacing Trigger Logic with Flows
### Salesforce Summer ‘20 Mini Hacks
In Spring and Summer ‘20 Salesforce has made a number of enhancements to Flows with the purpose of giving you one place for logic that happens when saving records.

In this mini hack we’ll use some of the new features to migrate more logic from triggers to flows. 

Why would you want to move logic from triggers to flows? Well, in flows admins can make changes to the logic as the business needs. This frees developers up to work on more exciting things.

### The Challenge

Universal Containers gets a lot of Leads through their website. When a new Lead comes in to the website Queue, a trigger scores the lead, routes the lead via round robin to an available sales person, and notifies that person of the assignment.

Take the code in this repo and try to move as much of it as you can to flows. For the lead scoring logic, use invocable apex to call the lead scoring (and give the admin some inputs to customize it if you can). 

### Getting Started

1. Create a scratch org `sfdx force:org:create`
2. Deploy the contents of the repo `sfdx force:source:push`
3. Create or edit at least one user to have Available for Leads = True
4. Create a queue for web leads
5. Create a Lead and specify a Lead Source and then assign it to the queue to see routing and scoring working. 

### Resources

- [Summer '20 Flow Release Notes](https://releasenotes.docs.salesforce.com/en-us/summer20/release-notes/rn_forcecom_flow.htm)
- [Lightning Flow Developer Center](https://developer.salesforce.com/developer-centers/lightning-flow/)


