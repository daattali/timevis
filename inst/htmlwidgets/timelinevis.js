// http://visjs.org/docs/timeline/

HTMLWidgets.widget({

  name : 'timelinevis',

  type : 'output',

  factory : function(el, width, height) {

    var container = document.getElementById(el.id);
    var data = new vis.DataSet(); // http://visjs.org/docs/data/dataset.html
    var options = {
      editable : true
    };
    var timeline = new vis.Timeline(container, data, options);

    return {

      renderValue: function(x) {
        data.add(x.items);
        timeline.fit({ animation : false });
      },

      resize : function(width, height) {
        // the timeline widget knows how to resize itself automatically
      },

      timeline : timeline,
      data : data
    };
  }
});
