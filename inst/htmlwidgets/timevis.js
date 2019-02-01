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
    var vistime = new vis.Timeline(container, [], {});
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
            .onclick = function(ev) { that.zoomIn(opts.zoomFactor); };
          zoomMenu.getElementsByClassName("zoom-out")[0]
            .onclick = function(ev) { that.zoomOut(opts.zoomFactor); };

          // set listeners to events and pass data back to Shiny
          if (HTMLWidgets.shinyMode) {

            // Items have been manually selected
            vistime.on('select', function (properties) {
              Shiny.onInputChange(
                elementId + "_selected",
                properties.items
              );
            });
            Shiny.onInputChange(
              elementId + "_selected",
              vistime.getSelection()
            );

            // The range of the window has changes (by dragging or zooming)
            vistime.on('rangechanged', function (properties) {
              Shiny.onInputChange(
                elementId + "_window",
                [vistime.getWindow().start, vistime.getWindow().end]
              );
            });
            Shiny.onInputChange(
              elementId + "_window",
              [vistime.getWindow().start, vistime.getWindow().end]
            );

            // The data in the timeline has changed
            vistime.itemsData.on('*', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_data" + ":timevisDF",
                vistime.itemsData.get()
              );
            });
            Shiny.onInputChange(
              elementId + "_data" + ":timevisDF",
              vistime.itemsData.get()
            );

            // An item was added or removed, send back the list of IDs
            vistime.itemsData.on('add', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_ids",
                vistime.itemsData.getIds()
              );
            });
            vistime.itemsData.on('remove', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_ids",
                vistime.itemsData.getIds()
              );
            });
            Shiny.onInputChange(
              elementId + "_ids",
              vistime.itemsData.getIds()
            );
          }
        }

        // set the data items and groups
        vistime.itemsData.clear();
        vistime.itemsData.add(opts.items);
        vistime.setGroups(opts.groups);

        // fit the items on the timeline
        if (opts.fit) {
          vistime.fit({ animation : false });
        }

        // Show or hide the zoom button
        var zoomMenu = container.getElementsByClassName("zoom-menu")[0];
        if (opts.showZoom) {
          zoomMenu.setAttribute("data-show-zoom", true);
        } else {
          zoomMenu.removeAttribute("data-show-zoom");
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
        vistime.setOptions(opts.options);

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
      zoomIn : function(percentage, animation) {
        if (typeof animation === "undefined") {
          animation = true;
        }
        var range = vistime.getWindow();
        var start = range.start.valueOf();
        var end = range.end.valueOf();
        var interval = end - start;
        var newInterval = interval / (1 + percentage);
        var distance = (interval - newInterval) / 2;
        var newStart = start + distance;
        var newEnd = end - distance;

        vistime.setWindow({
          start   : newStart,
          end     : newEnd,
          animation : animation
        });
      },
      zoomOut : function(percentage, animation) {
        if (typeof animation === "undefined") {
          animation = true;
        }
        var range = vistime.getWindow();
        var start = range.start.valueOf();
        var end = range.end.valueOf();
        var interval = end - start;
        var newStart = start - interval * percentage / 2;
        var newEnd = end + interval * percentage / 2;

        vistime.setWindow({
          start   : newStart,
          end     : newEnd,
          animation : animation
        });
      },

      // export the timeline object for others to use if they want to
      vistime : vistime,

      /* API functions that manipulate a timeline's data */
      addItem : function(params) {
        vistime.itemsData.add(params.data);
      },
      addItems : function(params) {
        vistime.itemsData.add(params.data);
      },
      removeItem : function(params) {
        vistime.itemsData.remove(params.itemId);
      },
      addCustomTime : function(params) {
        vistime.addCustomTime(params.time, params.itemId);
      },
      removeCustomTime : function(params) {
        vistime.removeCustomTime(params.itemId);
      },
      setCustomTime : function(params) {
        vistime.setCustomTime(params.time, params.itemId);
      },
      setCurrentTime : function(params) {
        vistime.setCurrentTime(params.time);
      },
      fitWindow : function(params) {
        vistime.fit(params.options);
      },
      centerTime : function(params) {
        vistime.moveTo(params.time, params.options);
      },
      centerItem : function(params) {
        vistime.focus(params.itemId, params.options);
      },
      setItems : function(params) {
        vistime.itemsData.clear();
        vistime.itemsData.add(params.data);
      },
      setGroups : function(params) {
        vistime.groupsData.clear();
        vistime.groupsData.add(params.data);
      },
      setOptions : function(params) {
        vistime.setOptions(params.options);
      },
      setSelection : function(params) {
        vistime.setSelection(params.itemId, params.options);
      },
      setWindow : function(params) {
        vistime.setWindow(params.start, params.end, params.options);
      }
    };
  }
});

// Attach message handlers if in shiny mode (these correspond to API)
if (HTMLWidgets.shinyMode) {
  var fxns =
    ['addItem', 'addItems', 'removeItem', 'addCustomTime', 'removeCustomTime',
     'fitWindow', 'centerTime', 'centerItem', 'setItems', 'setGroups',
     'setOptions', 'setSelection', 'setWindow', 'setCustomTime', 'setCurrentTime'];

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
