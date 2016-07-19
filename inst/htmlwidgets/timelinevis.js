/*****************************************************************************/
/* Dean Attali 2016                                                          */
/* timelinevis                                                               */
/* Create timeline visualizations in R using htmlwidgets and vis.js          */
/*****************************************************************************/

HTMLWidgets.widget({

  name : 'timelinevis',

  type : 'output',

  factory : function(el, width, height) {

    var elementId = el.id;
    var container = document.getElementById(elementId);
    var timeline = new vis.Timeline(container, [], {});

    return {

      renderValue: function(x) {
        // alias this
        var that = this;

        // attach the timeline object to the DOM
        container.timeline = timeline;

        // set the data items
        timeline.itemsData.add(x.items);
        timeline.fit({ animation : false });
        that.zoom(0.2, false);

        // Show and initialize the zoom buttons
        if (x.showZoom) {
          var zoomMenu = container.getElementsByClassName("zoom-menu")[0];
          zoomMenu.className += " show-zoom";
          zoomMenu.getElementsByClassName("zoom-in")[0]
            .onclick = function(ev) { that.zoom(-0.2); };
          zoomMenu.getElementsByClassName("zoom-out")[0]
            .onclick = function(ev) { that.zoom(0.2); };
        }

        // set listeners to events the user wants to know about
        if (HTMLWidgets.shinyMode){
          if (x.getSelected) {
            timeline.on('select', function (properties) {
              Shiny.onInputChange(
                elementId + "_selected",
                properties.items
              );
            });
            // Also send the initial data when the widget starts
            Shiny.onInputChange(
              elementId + "_selected",
              timeline.getSelection()
            );
          }
          if (x.getWindow) {
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
          }
          if (x.getData) {
            timeline.itemsData.on('*', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_data" + ":timelinevisDF",
                timeline.itemsData.get()
              );
            });
            Shiny.onInputChange(
              elementId + "_data" + ":timelinevisDF",
              timeline.itemsData.get()
            );
          }
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
      zoom : function(percentage, animation) {
        if (typeof animation === "undefined") {
          animation = true;
        }
        var range = timeline.getWindow();
        var interval = range.end - range.start;

        timeline.setWindow({
          start   : range.start.valueOf() - interval * percentage,
          end     : range.end.valueOf()   + interval * percentage,
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
    "timelinevis:addItem", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.itemsData.add(message.data);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:addItems", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        var items = message.data;
        el.timeline.itemsData.add(items);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:removeItem", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.itemsData.remove(message.itemId);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:addCustomTime", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.addCustomTime(message.time, message.itemId);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:removeCustomTime", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.removeCustomTime(message.itemId);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:fitWindow", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.fit(message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:centerTime", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.moveTo(message.time, message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:setItems", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.itemsData.clear();
        var items = message.data;
        el.timeline.itemsData.add(items);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:setOptions", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.setOptions(message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:setSelection", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.setSelection(message.itemId, message.options);
      }
  });

  Shiny.addCustomMessageHandler(
    "timelinevis:setWindow", function(message) {
      var el = document.getElementById(message.id);
      if (el) {
        el.timeline.setWindow(message.start, message.end, message.options);
      }
  });

}
