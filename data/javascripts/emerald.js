$(document).ready(function(){

    // The function for showing/hiding the complete file list
    $("a#toggle-all-files").click(function(event){
        $("li.code-file").toggle();

        if($(this).text() == "Show all")
            $(this).text("Hide extra");
        else
            $(this).text("Show all");

        return false;
    });

    $("p.show-source a").click(function(event){
        $(this).parent().next().toggle("slow");

        if ($(this).text() == "[Show source]")
            $(this).text("[Hide source]");
        else
            $(this).text("[Show source]");

        return false;
    });
});
