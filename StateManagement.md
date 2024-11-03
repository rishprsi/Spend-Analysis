# Different States in iOS
The following are the states of an app on iOS:

-   **Not running/unattached**: When the app has not been tapped yet.

-   **Foreground Inactive/Resign Active**: When the user initially taps on the app to bring it from inactive state.

-   **Foreground Active**: When the app is ready for user interaction and state changes from the user.

-   **Background**: When the user moves away from the app and the app is not in the foreground.

-   **Suspended**: When the app is in the background and no background activities are happening. The app is moved to suspended state.


## States to consider for my app

-   **Not running/unattached**: When the app has not been tapped yet.

-   **Foreground Inactive/Resign Active**:
    - Why: Whenever in this state the app needs to load data from disk to memory to resume user view.
    - What: I need to load initial states into active memory, for the user to interact with.

-   **Foreground Active**: 
    - Why: Any important updates by the user need to be saved to state.
    - What: Save the confirmed user made changes to state for further use.

-   **Background**:
    - Why: Any updates left unsaved by the user need to be saved to be resumed when the user continues activity.
    - What: Save unsaved user chagnes to state so that they can be loaded when it comes back to foreground even if the app is suspeneded.

-   **Suspended**:
    - Why: The app will stop actively working in suspended mode. So need to gracefully exit all current activities.
    - What: Free up used memory, close views gracefully and save any final changes needed for when the app is loaded again.
