# timevis 0.1.4

2016-07-31

- all the API functions can now work on timeline widgets that are not yet initialized, which means they can work in rmarkdown documents or in the console
- all the API functions can now work with pipes (`%>%` pipelines)
- the API functions can accept either an ID of a widget or a widget object. This is useful because now the API functions can either be called from the server of a Shiny app at any point, or they can be called directly using the widget when it is being initialized

# timevis 0.1.3

2016-07-27

- timevis can now be included inside regular R markdown documents
- add a lot of responsive CSS to make the app look well in smaller screens

# timevis 0.1.2

2016-07-26

- fix bug: When re-rendering a timeline, the old data are not removed (#3)
- removed the `getData` `getWindow` `getIds` `getSelected` parameters and instead just return that info always (#4)
- add `fit` param to `timevis()` that determines if to fit the items on the timeline by default or not
- **BREAKING CHANGE** added support for groups (#1) (parameter order for `timevis()` has changed)

# timevis 0.1.1

2016-07-25

- refactor and modularize Shiny app code
- UI improvements to Shiny app
- added source code to Shiny app
- added social media meta tags to Shiny app 

# timevis 0.1

2016-07-25

Initial CRAN release
