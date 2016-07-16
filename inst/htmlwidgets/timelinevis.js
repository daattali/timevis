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
          if (HTMLWidgets.shinyMode) {
            zoomMenu.className += " shiny-mode";
          } else {
            zoomMenu.className += " no-shiny-mode";
          }
          zoomMenu.getElementsByClassName("zoom-in")[0]
            .onclick =function(ev) { that.zoom(-0.2); };
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
            // TODO due to a bug in shiny, this isn't sending the correct data
            timeline.itemsData.on('*', function (event, properties, senderId) {
              Shiny.onInputChange(
                elementId + "_data" + ":timelinevisDF",
                timeline.itemsData.get()
              );
            });
          }
        }

        // set the custom configuration options
        delete x['items'];
        delete x['showZoom'];
        delete x['listen'];
        if (x['height'] === null) {
          delete x['height'];
        }
        timeline.setOptions(x);
      },

      resize : function(width, height) {
        // the timeline widget knows how to resize itself automatically
      },

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

if (HTMLWidgets.shinyMode){
  //Shiny.addCustomMessageHandler();
}
