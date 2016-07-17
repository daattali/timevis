/*****************************************************************************/
/* Dean Attali 2016                                                          */
/* timelinevis                                                               */
/* Create timeline visualizations in R using htmlwidgets and vis.js          */
/*****************************************************************************/

// Check if an array contains an element
containsObject = function(obj, list) {
  if (list === null) return false;
  var i;
  for (i = 0; i < list.length; i++) {
    if (list[i] === obj) {
      return true;
    }
  }

  return false;
}

// http://visjs.org/docs/timeline/

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
          if (typeof x.listen === "string") {
            x.listen = [x.listen];
          }
          if (containsObject("selected", x.listen)) {
            timeline.on('select', function (properties) {
              Shiny.onInputChange(
                elementId + "_selected",
                properties.items
              );
            });
          }
          if (containsObject("window", x.listen)) {
            timeline.on('rangechanged', function (properties) {
              var timelineWindow = timeline.getWindow();
              Shiny.onInputChange(
                elementId + "_window",
                [timelineWindow.start, timelineWindow.end]
              );
            });
          }
          if (containsObject("data", x.listen)) {
            timeline.itemsData.on('*', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_data" + ":timelinevisDF",
                timeline.itemsData.get()
              );
            });
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
      zoom : function(percentage) {
        var range = timeline.getWindow();
        var interval = range.end - range.start;

        timeline.setWindow({
          start : range.start.valueOf() - interval * percentage,
          end :   range.end.valueOf()   + interval * percentage
        });
      }
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
        el.timeline.itemsData.add(message.data);
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
        el.timeline.itemsData.add(message.data);
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
