# timevis 0.4.0.x

- added documentation for how to extend the timevis object in JavaScript

# timevis 0.4 2016-09-16

### Bug fixes

- timevis and visNetwork can work together in the same app (the bug is fixed on timevis' end, so it will only work if a timevis widget is defined before a visNetwork one until visNetwork also fix the bug) (#11)
- re-defining the data input handler does not cause a warning 

# timevis 0.3

2016-08-29

#### Misc

- Added VignetteBuilder field to DESCRIPTION file as per CRAN's request

# timevis 0.2

2016-08-24

### Breaking changes

- added support for groups (#1) (parameter order for `timevis()` has changed)

### New features

- add `fit` param to `timevis()` that determines if to fit the items on the timeline by default or not
- timevis can now be included inside regular R markdown documents
- all the API functions can now work on timeline widgets that are not yet initialized, which means they can work in rmarkdown documents or in the console
- all the API functions can now work with pipes (`%>%` pipelines)
- the API functions can accept either an ID of a widget or a widget object. This is useful because now the API functions can either be called from the server of a Shiny app at any point, or they can be called directly using the widget when it is being initialized

### Bug fixes

- when re-rendering a timeline, the old data are not removed (#3)
- can now use a dataframe that results from merging/binding two dataframes as input (#7)
- zoom buttons show up when using a custom `shinytheme()` (#9)

### Misc

- removed the `getData` `getWindow` `getIds` `getSelected` parameters and instead just return that info always (#4)
- refactor and modularize Shiny app code
- UI improvements to Shiny app
- added source code to Shiny app
- added social media meta tags to Shiny app 
- add a lot of responsive CSS to make the app look well in smaller screens

# timevis 0.1

2016-07-25

Initial CRAN release
