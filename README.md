timevis - Create interactive timeline visualizations in R
=========================================================

[![Build
Status](https://travis-ci.org/daattali/timevis.svg?branch=master)](https://travis-ci.org/daattali/timevis)
[![CRAN
version](http://www.r-pkg.org/badges/version/timevis)](https://cran.r-project.org/package=timevis)

`timevis` lets you create rich and *fully interactive* timeline
visualizations in R. Timelines can be included in Shiny apps and R
markdown documents, or viewed from the R console and RStudio Viewer.
`timevis` includes an extensive API to manipulate a timeline after
creation, and supports getting data out of the visualization into R.
This package is based on the [vis.js](http://visjs.org/) Timeline module
and the [htmlwidgets](http://www.htmlwidgets.org/) R package.

### Demo

[Click here](http://daattali.com/shiny/timevis-demo/) to view a live
interactive demo of `timevis`.

### Installation

`timevis` is available through both CRAN and GitHub:

To install the stable CRAN version:

    install.packages("timevis")

To install the latest development version from GitHub:

    install.packages("devtools")
    devtools::install_github("daattali/timevis")

### How to use

You can view a minimal timeline without any data by simply running

    library(timevis)
    timevis()

![Minimal timeline](inst/img/minimal.png)

You can add data to the timeline by supplying a data.frame

    data <- data.frame(
      id      = 1:4,
      content = c("Item one"  , "Item two"  ,"Ranged item", "Item four"),
      start   = c("2016-01-10", "2016-01-11", "2016-01-20", "2016-02-14 15:00:00"),
      end     = c(NA          ,           NA, "2016-02-04", NA)
    )

    timevis(data)

![Basic timeline](inst/img/basic.png)

Every item must have a `content` and a `start` variable. If the item is
a range rather than a single point in time, you can supply an `end` as
well. `id` is only required if you want to access or manipulate an item.
There are more variables that can be used in the data.frame -- they are
all documented in the help file for `?timevis()` under the **Data
format** section.

The content of an item can even include HTML, which makes it easy to
show any kind of data in a timeline, such as the matches of the 2014
World Cup:

![World cup timeline](inst/img/worldcup.png)

If you know some CSS, you can completely customize the look of the
timeline:

![Custom style timeline](inst/img/customstyle.png)

By default, a timeline will show the current date as a red vertical line
and will have zoom in/out buttons. You can supply many customization
options to `timevis()` in order to get it just right (see `?timevis()`
for details).

### Interactivity

The timeline lets the user interact with it seamlessly. You can click on
the zoom in/out buttons or drag the timeline left/right in order to move
to past/future dates.

If you set the `editable = TRUE` option, then the user will be able to
add new items by double clicking, modify items by dragging, and delete
items by selecting them.

### Groups

You can use the groups feature to group together multiple items into
different "buckets". When using groups, all items with the same group
are placed on one line. A vertical axis is displayed showing the group
names. Grouping items can be useful for a wide range of applications,
for example when showing availability of multiple people, rooms, or
other resources next to each other. You can also think of groups as
"adding a Y axis", if that helps.

Here is an example of a timeline that has three groups: "Library",
"Gym", and "Pool":

![Groups timeline](inst/img/groups.png)

In order to use groups, items in the data need to have group ids, and a
separate dataframe containing the group information needs to be
provided. More information about using groups and the groups dataframe
is available in the help file for `?timevis()` under the **Groups**
section.

### In a Shiny app

You can add a timeline to a Shiny app by adding `timevisOutput()` to the
UI and `renderTimevis(timevis())` to the server.

There are many functions that allow programmatic manipulation of a
timeline. For example, `addItem()` programmatically adds a new item,
`centerItem()` moves the timeline so that the given item is centered,
`setWindow()` sets the start and end dates of the timeline, and more
functions are available. Note that all these functions take the
timeline's ID as their first argument.

It is also possible to retrieve data from a timeline in a Shiny app.
When a timeline widget is created in a Shiny app, there are four pieces
of information that are always accessible as Shiny inputs. These inputs
have special names based on the timeline's id. Suppose that a timeline
is created with an `outputId` of **"mytime"**, then the following four
input variables will be available:

-   **input$mytime\_data** - will return a data.frame containing the
    data of the items in the timeline. The input is updated every time
    an item is modified, added, or removed.
-   **input$mytime\_ids** - will return the IDs (a vector) of all the
    items in the timeline. The input is updated every time an item is
    added or removed from the timeline.
-   **input$mytime\_selected** - will return the IDs (a vector) of the
    selected items in the timeline. The input is updated every time an
    item is selected or unselected by the user. Note that this will not
    get updated if an item is selected programmatically using the
    API functions.
-   **input$mytime\_window** - will return a 2-element vector containing
    the minimum and maximum dates currently visible in the timeline. The
    input is updated every time the viewable window of dates is updated
    (by zooming or moving the window).

You can view examples of many of the features supported by checking out
the [demo Shiny app](http://daattali.com/shiny/timevis-demo/). If you
want to see how those examples were created, the full code for the
examples is inside
[inst/example](https://github.com/daattali/timevis/tree/master/inst/example).
