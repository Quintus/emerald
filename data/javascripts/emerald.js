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

    // The function for showing/hiding a method’s sourcecode.
    $("p.show-source a").click(function(event){
        $(this).parent().next().toggle("slow");

        if ($(this).text() == "[Show source]")
            $(this).text("[Hide source]");
        else
            $(this).text("[Show source]");

        return false;
    });

    // The function that displays the ¶ sign when hovering
    // over a heading (except level-1 headings).
    $("h2, h3, h4, h5, h6").hover(
        function(event){
            $(this).append('<a class="para" href="' + window.location.pathname + '#' + $(this).attr('id') + '">&nbsp;¶</a>');
        },
        function(event){
            $(this).find("a:last").remove();
        }
    );

    $("form#search p input").keyup(function(event){
        term = new RegExp($(this).val(), "i");

        // Method index
        $("div#method-index ul li, div#class-index ul li").each(function(index){
            var result = $(this).text().match(term);
            if (result)
                $(this).show();
            else
                $(this).hide();
        });
    });
});
