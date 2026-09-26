# todo_events_states

Package chứa tất cả các Events và States cho BLoCs trong Todo app:

## Todo
- Events: `TodoLoadRequested`, `TodoAdded`, `TodoUpdated`, `TodoDeleted`, `TodoToggled`, `TodoClearCompleted`, `TodoToggleAll`
- States: `TodoInitial`, `TodoLoading`, `TodoLoaded`, `TodoError`, `TodoOperationInProgress`, `TodoOperationSuccess`

## Filter
- Events: `FilterChanged`
- States: `FilterState`

## Search
- Events: `SearchQueryChanged`, `SearchQueryCleared`
- States: `SearchState`