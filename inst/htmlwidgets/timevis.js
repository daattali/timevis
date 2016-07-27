/*********************************************************************/
/* Dean Attali 2016                                                  */
/* timevis                                                           */
/* Create timeline visualizations in R using htmlwidgets and vis.js  */
/*********************************************************************/

HTMLWidgets.widget({

  name : 'timevis',

  type : 'output',

  factory : function(el, width, height) {

    var elementId = el.id;
    var container = document.getElementById(elementId);
    var timeline = new vis.Timeline(container, [], {});
    var initialized = false;

    return {

      renderValue: function(x) {
        // alias this
        var that = this;

        if (!initialized) {
          initialized = true;

          // attach the timeline object to the DOM
          container.timeline = timeline;

          // Set up the zoom button click listeners
          var zoomMenu = container.getElementsByClassName("zoom-menu")[0];
          zoomMenu.getElementsByClassName("zoom-in")[0]
            .onclick = function(ev) { that.zoomIn(x.zoomFactor); };
          zoomMenu.getElementsByClassName("zoom-out")[0]
            .onclick = function(ev) { that.zoomOut(x.zoomFactor); };

          // set listeners to events and pass data back to Shiny
          if (HTMLWidgets.shinyMode) {

            // Items have been manually selected
            timeline.on('select', function (properties) {
              Shiny.onInputChange(
                elementId + "_selected",
                properties.items
              );
            });
            Shiny.onInputChange(
              elementId + "_selected",
              timeline.getSelection()
            );

            // The range of the window has changes (by dragging or zooming)
            timeline.on('rangechanged', function (properties) {
              Shiny.onInputChange(
                elementId + "_window",
                [timeline.getWindow().start, timeline.getWindow().end]
              );
            });
            Shiny.onInputChange(
              elementId + "_window",
              [timeline.getWindow().start, timeline.getWindow().end]
            );

            // The data in the timeline has changed
            timeline.itemsData.on('*', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_data" + ":timevisDF",
                timeline.itemsData.get()
              );
            });
            Shiny.onInputChange(
              elementId + "_data" + ":timevisDF",
              timeline.itemsData.get()
            );

            // An item was added or removed, send back the list of IDs
            timeline.itemsData.on('add', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_ids",
                timeline.itemsData.getIds()
              );
            });
            timeline.itemsData.on('remove', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_ids",
                timeline.itemsData.getIds()
              );
            });
            Shiny.onInputChange(
              elementId + "_ids",
              timeline.itemsData.getIds()
            );
          }
        }

        // set the data items
        timeline.itemsData.clear();
        timeline.itemsData.add(x.items);

        // fit the items on the timeline
        if (x.fit) {
          timeline.fit({ animation : false });
        }

        // Show or hide the zoom button
        var zoomMenu = container.getElementsByClassName("zoom-menu")[0];
        if (x.showZoom) {
          zoomMenu.setAttribute("data-show-zoom", true);
        } else {
          zoomMenu.removeAttribute("data-show-zoom");
        }

        // set the custom configuration options
        if (Array === x.options.constructor) {
          x['options'] = {};
        }
        if (x['height'] !== null &&
            typeof x['options']['height'] === "undefined") {
          x['options']['height'] = x['height'];
        }
        timeline.setOptions(x.options);
      },

      resize : function(width, height) {
        // the timeline widget knows how to resize itself automatically
      },

      // zoom the timeline in/out
      // I had to work out the math on paper so that zooming in and then out
      // will exactly negate each other
      zoomIn : function(percentage, animation) {
        if (typeof animation === "undefined") {
          animation = true;
        }
        var range = timeline.getWindow();
        var start = range.start.valueOf();
        var end = range.end.valueOf();
        var interval = end - start;
        var newInterval = interval / (1 + percentage);
        var distance = (interval - newInterval) / 2;
        var newStart = start + distance;
        var newEnd = end - distance;

        timeline.setWindow({
          start   : newStart,
          end     : newEnd,
          animation : animation
        });
      },
      zoomOut : function(percentage, animation) {
        if (typeof animation === "undefined") {
          animation = true;
        }
        var range = timeline.getWindow();
        var start = range.start.valueOf();
        var end = range.end.valueOf();
        var interval = end - start;
        var newStart = start - interval * percentage / 2;
        var newEnd = end + interval * percentage / 2;

        timeline.setWindow({
          start   : newStart,
          end     : newEnd,
          animation : animation
        });
      },

      // export the timeline object for others to use if they want to
      timeline : timeline
    };
  }
});

// Attach message handlers if in shiny mode (these correspond to API)
if (HTMLWidgets.shinyMode){

  Shiny.addCustomMessageHandler(
    "timevis:addItem", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.itemsData.add(message.data);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:addItems", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        var items = message.data;
        el.timeline.itemsData.add(items);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:removeItem", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.itemsData.remove(message.itemId);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:addCustomTime", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.addCustomTime(message.time, message.itemId);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:removeCustomTime", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.removeCustomTime(message.itemId);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:fitWindow", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.fit(message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:centerTime", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.moveTo(message.time, message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:centerItem", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.focus(message.itemId, message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:setItems", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.itemsData.clear();
        var items = message.data;
        el.timeline.itemsData.add(items);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:setOptions", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.setOptions(message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:setSelection", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.setSelection(message.itemId, message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timevis:setWindow", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.setWindow(message.start, message.end, message.options);
      }
  });

}
