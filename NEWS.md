# Unreleased version

- Simplify documentation and augment with more examples
- List-columns may now be passed to `timevis()`, to support `nestedGroups` and any other parameters that may require nested lists (#11)
- Support `subgroupStack = TRUE` option (#117)
- Don't use local images in demo app (#118)

# timevis 2.0.0 (2021-12-20)

- **BREAKING CHANGE** Upgrade to visjs-Timeline version 7.4.9 which includes many new features and performance improvements. You may notice some small differences in behaviour when upgrading as the new version includes 5 years of developments. (#50)
  - One of the major differences is that previously when a config option (such as `editable=TRUE`) was set on an existing timeline, the option would apply retroactively to all existing items. In the new version, existing items don't change and only new items will inherit the new options.
  - You may also notice a difference in the way that editable items "snap" to the timeline when you modify their time. You can control the snapping behaviour, for example to only allow items to snap to round hours you can use `options = list(editable = TRUE, snap = htmlwidgets::JS("function (date, scale, step) { var hour = 60 * 60 * 1000; return Math.round(date / hour) * hour; }"))`
- Add documentation about `id` parameter (#103)

# timevis 1.0.0 (2020-09-15)

- **BREAKING CHANGE** API functions now work in shiny modules without having to specify the namespace. This means that if you previously explicitly used a namespace when calling API functions, you need to remove the namespace function (#90)
- Add `timezone` parameter to `timevis()` - supports showing the timeline in a different timezone than your local machine (#67)
- Add `setCustomTime()` and `setCurrentTime()` functions (#20)
- Add `<timeline>_visible` Shiny input that sends the items that are currently visible in the timeline to Shiny as an input (#22)
- Fixed bug: using `setSelection()` did not trigger the Shiny selected input (#82)
- Add documentation about how to add custom style to timevis (#45)
- Add documentation about how to use BCE dates (#99)
- Add documentation tab to the demo app

# timevis 0.5 (2019-01-16)

- `tibble`s converted to `data.frame`s (Fixes issue #53, @muschellij2).
- added documentation for how to extend the timevis object in JavaScript
- added an option to not load the javascript dependencies (#25)
- Fix issue #47: Leading whitespace when getting selected item Id as a string
- Show correct timezone in demo app
- Add demo advanced data `timevisData` and `timevisDataGroups`

# timevis 0.4 (2016-09-16)

### Bug fixes

- timevis and visNetwork can work together in the same app (the bug is fixed on timevis' end, so it will only work if a timevis widget is defined before a visNetwork one until visNetwork also fix the bug) (#11)
- re-defining the data input handler does not cause a warning 

# timevis 0.3 (2016-08-29)

#### Misc

- Added VignetteBuilder field to DESCRIPTION file as per CRAN's request

# timevis 0.2 (2016-08-24)

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

# timevis 0.1 (2016-07-25)

Initial CRAN release
