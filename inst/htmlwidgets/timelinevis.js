HTMLWidgets.widget({

  name: 'timelinevis',

  type: 'output',

  factory: function(el, width, height) {

    var container = document.getElementById(el.id);
    var timeline = new vis.Timeline(container, [], {});

    return {

      renderValue: function(x) {

        var items = x.items;
        var options = {};
        timeline.setOptions(options);
        timeline.setItems(items);
        timeline.fit({ animation : false });
      },

      resize: function(width, height) {
        // the timeline widget knows how to resize itself automatically
      },

      timeline: timeline

    };
  }
});
