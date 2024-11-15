# Summary of Project

*Spend analyzer is an expense management/planning app that gives the
user intuitive ways to log, plan and manage their expenses. The app will
also visualize the trends based on historical data and categorize
expenses that will provide the user a quick understanding of their
spending habits and remove unnecessary expenses from their budget. The
app focuses on user privacy with storing all user data on their own
device so that the user can be assured of their financial data privacy.*

# Project Analysis

## Value Proposition

These days with subscriptions, mortgages, loans and miscellaneous
expenses it's really difficult to keep track of your finances and budge
tracking. This applies mostly to people who earn and want to get a
better understanding of their spending. Around 50% of Americans are
living paycheck to paycheck, and some of them have hefty salaries. The
biggest causes cited for this are loans and ignorant/uneducated
spending.

## Primary Purpose

The app aims to provide tools to the user to properly log their
expenses, investments and make educated decisions on their spending
based on that understanding, with the security of storing data on user's
device.

## Target Audience

The target audience are people who are earning and finding it difficult
to keep track of their expenses and want to streamline the process to
improve savings and

## Success Criteria

When the user will be able to use the app as a one stop shop for their
budgetary planning and logging. This will be measured by user reviews
and feedback.

## Competitor Analysis

Spending Tracker -- Budget. Spending Tracker is quite a robust money
tracking/ budgetary app. But it extensively pushes its monetization
model on the users and doesn't store data locally. Giving less control
to the user on their financial data.

## Monetization Model

As the app focuses mostly on financial literacy and budget saving the
app will only have an upfront minimal cost of entry. In future the app
can be further monetized by providing users detailed finance reports in
formats like excel which can help the users with their taxes and
performing their own analysis.

# Initial Design

The MVP of this app would constitute:

-   **Expense Logging**: Users can input their expenses manually or via
    templates.

-   **Categorization**: Basic pre-defined categories like Food,
    Transportation.

-   **Trend Visualization**: Simple graphs to visualize spending trends.

-   **Budget Planning**: Basic tools to set budgets for different
    categories.

-   **Data Storage**: Local storage to ensure privacy.


## UI/UX Design

-   **Home Screen**: Overview of total expenses and budgets. Simple menu
    navigation for key functions.

-   **Expense Logging Interface:** Input fields for amount, category,
    date and notes, and an option to make it recurring.

-   **Categorization Page:** List of categories and options to add,
    edit, remove and analyze their spending.

-   **Trend Visualization Dashboard:** Simple line or bar charts showing
    monthly trends.

-   **Budget Planning Page:** Input for setting monthly budgets per
    category.

-   **Settings:** Options for user preferences, including data backup
    and export options.

## Technical Architecture

-   **Data Structures:**

    -   Expense Record: Object containing fields for amount, category,
        date and notes.

    -   Category: Object with category name and spending limit.

    -   User Settings: Object for any user preferences related to app
        behavior.

-   **Storage Considerations:** Use Core Data available for Swift UI.

-   **Dependencies on 3^rd^ party:** Research payment APIs for possible
    integrations.

# Challenges and Open Questions

Data migration: As the user data is going to be stored locally, there
has to be a mechanism for the user to export their data to an external#
device or possible cloud in an encrypted format. Will create exportable
packages, that the user can upload to cloud/external storage.

Data Encryption: As the financial data of the user is very sensitive
will have to keep the data in a secure format. Will look into data
encryption best practices.

Access to transactional data: Research needed on possible avenues to
automatically capture user transactions based on payment apps to reduce
the amount of times the users have to log their expenses manually. Will
research available APIs for integration.

More features: This app is using a limited set of features so need to
brainstorm on possible avenues of introducing unique features once the
MVP is done and the app matures.


# Optimizing data storage and retreival

As the data has to be retreived on a date basis both in budget section and expenses section:
Store data with data based indexing and sorting
Fetch data from storage based on date restrictions