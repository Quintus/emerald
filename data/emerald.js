$(document).ready(function(){
    $("a#toggle-all-files").click(function(event){
        $("li.code-file").toggle();

        link = $("a#toggle-all-files");
        if(link.text() == "Show all")
            link.text("Hide extra");
        else
            link.text("Show all");

        return false;
    });
});
