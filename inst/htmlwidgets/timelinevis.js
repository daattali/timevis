// http://visjs.org/docs/timeline/

HTMLWidgets.widget({

  name : 'timelinevis',

  type : 'output',

  factory : function(el, width, height) {

    var container = document.getElementById(el.id);
    var data = new vis.DataSet(); // http://visjs.org/docs/data/dataset.html
    var timeline = new vis.Timeline(container, data, {});

    return {

      renderValue: function(x) {
        // alias this
        var that = this;

        data.add(x.items);
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
          zoomMenu.getElementsByClassName("zoom-in")[0].onclick = function(ev) { that.zoom(-0.2); };
          zoomMenu.getElementsByClassName("zoom-out")[0].onclick = function(ev) { that.zoom(0.2); };
        }

        delete x['items'];
        delete x['showZoom'];
console.log(x);
        timeline.setOptions(x);
      },

      resize : function(width, height) {
        // the timeline widget knows how to resize itself automatically
      },

      zoom : function(percentage) {
        console.log(percentage);
        var range = timeline.getWindow();
        var interval = range.end - range.start;

        timeline.setWindow({
          start : range.start.valueOf() - interval * percentage,
          end :   range.end.valueOf()   + interval * percentage
        });
      },

      timeline : timeline,
      data : data
    };
  }
});
