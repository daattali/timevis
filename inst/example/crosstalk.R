#devtools::install_github("rstudio/crosstalk")
library(crosstalk)
library(timevis)

sd <- SharedData$new(
  data.frame(
    id = 1:2,
    content = c("one", "two"),
    start = c("2016-01-10", "2016-01-12")
  ),
  group = "mygroup"
)

tv <- timevis(sd, showZoom = FALSE)

# prove crosstalk and timevis are now friends
###### control from the outside ####
htmlwidgets::onRender(
  tv,
"
// toggle selection between 1 and 2 every second
//  in a very messy way
function(el,x) {
  var sel = new crosstalk.SelectionHandle('mygroup');
  var toggler = ['1','2'];
  var state = false;

  sel.set(toggler[Number(state)]);
  setInterval(
    function() {
      state = !state;
      sel.set(toggler[Number(state)]);
    },
    1000
  )
}
"
)

###### control from outside btn ####
library(htmltools)

browsable(
  tagList(
    tags$button(id="btn-select","Select 1",onclick="selectOne()"),
    tags$button(id="btn-select","Clear Select",onclick="selectClear()"),
    tv,
    tags$script(
      HTML(
"
var sel = new crosstalk.SelectionHandle('mygroup');
function selectOne() {
  sel.set('1');
};
function selectClear() {
  sel.clear();
};
"
      )
    )
  )
)



###### react to select from timevis ####
# it seems select is causing crosstalk to fire change twice
#  will need to explore
#  for now will handle with very crude conditional
library(htmltools)

browsable(tagList(
  tags$p('select an item to see an old-school alert'),
  tv,
  tags$script(HTML(
"
var sel = new crosstalk.SelectionHandle('mygroup');
sel.on('change', function(val){
  // why is change getting fired twice ????????
  //  it seems like timeline is firing select twice
  if(!val.oldValue || val.oldValue[0] !== val.value[0]){
    alert('timevis selected ' + val.value.join(' '));
  }
});
"
  ))
))

