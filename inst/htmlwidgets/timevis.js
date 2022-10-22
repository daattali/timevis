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

      renderValue: function(opts) {
        // alias this
        var that = this;

        if (!initialized) {
          initialized = true;

          // attach the widget to the DOM
          container.widget = that;

          // Set up the zoom button click listeners
          var zoomMenu = container.getElementsByClassName("zoom-menu")[0];
          zoomMenu.getElementsByClassName("zoom-in")[0]
            .onclick = function(ev) { that.zoomInTimevis(opts.zoomFactor); };
          zoomMenu.getElementsByClassName("zoom-out")[0]
            .onclick = function(ev) { that.zoomOutTimevis(opts.zoomFactor); };

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

            // Visible items have changed
            var sendShinyVisible = function() {
              Shiny.onInputChange(
                elementId + "_visible",
                timeline.getVisibleItems()
              );
            };
            timeline.on('rangechanged', sendShinyVisible);
            timeline.itemsData.on('add', sendShinyVisible);
            timeline.itemsData.on('remove', sendShinyVisible);
            setTimeout(sendShinyVisible, 0);
          }
        }

        // set the custom configuration options
        if (Array === opts.options.constructor) {
          opts['options'] = {};
        }
        if (opts['height'] !== null &&
            typeof opts['options']['height'] === "undefined") {
          opts['options']['height'] = opts['height'];
        }
        if (opts['timezone'] !== null) {
          opts['options']['moment'] = function(date) {
            return vis.moment(date).utcOffset(opts['timezone']);
          };
        }
        timeline.setOptions(opts.options);

        // set the data items and groups
        timeline.itemsData.clear();
        timeline.itemsData.add(opts.items);
        timeline.setGroups(opts.groups);

        // fit the items on the timeline
        if (opts.fit) {
          timeline.fit({ animation : false });
        }

        // Show or hide the zoom button
        var zoomMenu = container.getElementsByClassName("zoom-menu")[0];
        if (opts.showZoom) {
          zoomMenu.setAttribute("data-show-zoom", true);
        } else {
          zoomMenu.removeAttribute("data-show-zoom");
        }

        // Now that the timeline is initialized, call any outstanding API
        // functions that the user wantd to run on the timeline before it was
        // ready
        var numApiCalls = opts['api'].length;
        for (var i = 0; i < numApiCalls; i++) {
          var call = opts['api'][i];
          var method = call.method;
          delete call['method'];
          try {
            that[method](call);
          } catch(err) {}
        }
      },

      resize : function(width, height) {
        // the timeline widget knows how to resize itself automatically
      },

      // zoom the timeline in/out
      // I had to work out the math on paper so that zooming in and then out
      // will exactly negate each other
      zoomInTimevis : function(percentage, animation) {
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
      zoomOutTimevis : function(percentage, animation) {
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
      timeline : timeline,

      /* API functions that manipulate a timeline's data */
      addItem : function(params) {
        timeline.itemsData.add(params.data);
      },
      addItems : function(params) {
        timeline.itemsData.add(params.data);
      },
      removeItem : function(params) {
        timeline.itemsData.remove(params.itemId);
      },
      addCustomTime : function(params) {
        timeline.addCustomTime(params.time, params.itemId);
      },
      removeCustomTime : function(params) {
        timeline.removeCustomTime(params.itemId);
      },
      setCustomTime : function(params) {
        timeline.setCustomTime(params.time, params.itemId);
      },
      setCurrentTime : function(params) {
        timeline.setCurrentTime(params.time);
      },
      fitWindow : function(params) {
        timeline.fit(params.options);
      },
      centerTime : function(params) {
        timeline.moveTo(params.time, params.options);
      },
      centerItem : function(params) {
         if (typeof params.options === 'undefined') {
          params.options = { 'zoom' : false };
        } else if (typeof params.options.zoom === 'undefined') {
          params.options.zoom = false;
        }
        timeline.focus(params.itemId, params.options);
      },
      setItems : function(params) {
        timeline.itemsData.clear();
        timeline.itemsData.add(params.data);
      },
      setGroups : function(params) {
        timeline.setGroups(params.data);
      },
      setOptions : function(params) {
        timeline.setOptions(params.options);
      },
      setSelection : function(params) {
        timeline.setSelection(params.itemId, params.options);
        if (HTMLWidgets.shinyMode) {
          Shiny.onInputChange(
            elementId + "_selected",
            params.itemId
          );
        }
      },
      setWindow : function(params) {
        timeline.setWindow(params.start, params.end, params.options);
      },
      zoomIn : function(params) {
        timeline.zoomIn(params.percent, { animation : params.animation });
      },
      zoomOut : function(params) {
        timeline.zoomOut(params.percent, { animation : params.animation });
      },
    };
  }
});

// Attach message handlers if in shiny mode (these correspond to API)
if (HTMLWidgets.shinyMode) {
  var fxns =
    ['addItem', 'addItems', 'removeItem', 'addCustomTime', 'removeCustomTime',
     'fitWindow', 'centerTime', 'centerItem', 'setItems', 'setGroups',
     'setOptions', 'setSelection', 'setWindow', 'setCustomTime', 'setCurrentTime',
     'zoomIn', 'zoomOut'];

  var addShinyHandler = function(fxn) {
    return function() {
      Shiny.addCustomMessageHandler(
        "timevis:" + fxn, function(message) {
          var el = document.getElementById(message.id);
          if (el) {
            delete message['id'];
            el.widget[fxn](message);
          }
        }
      );
    }
  };

  for (var i = 0; i < fxns.length; i++) {
    addShinyHandler(fxns[i])();
  }
}
