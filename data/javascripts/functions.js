/**
 * Takes a DOM javascript heading, parses the nodename and
 * returns the heading’s level. If not passed a heading,
 * returns 0.
 */
function heading_level(heading){
    return parseInt(heading.nodeName.substring(1));
}

/**
 * Call without an argument. Recursively scans for headings
 * in the document an generates a nested <ul> to be used as
 * a table of contents (ToC).
 */
function generate_toc(heading){
    var list = "";

    /* If no heading is provided, this is the initial call.
     * Grab the toplevel object and find all toplevel headings,
     * calling the function again recursively. */
    if (heading == undefined){
        list += "<ul class=\"toc\">\n";
        $("h2").each(function(index){
            list += generate_toc($(this));
        });
        list += "</ul>\n";

        return list;
    }
    else // Add this heading to the current <ul>
        list += "<li>" + "<a href=\"#" + heading.attr("id") + "\">" + heading.text() + "</a>";

    /* Find all "deeper" heading siblings. If an equal or higher-order
     * heading is found, abort the iteration and let the parent function
     * call handle it. */
    var sublist = "<ul>\n"
    heading.nextAll("h2, h3, h4, h5, h6").each(function(index){ // Level-1 headings are ignored, there should be only one, and that’s the page title
        if (heading_level(this) <= heading_level(heading.get(0)))
            return false;
        else
            sublist += generate_toc($(this));
    });
    sublist += "</ul>\n"

    // Ignore empty sublists
    if (sublist != "<ul>\n</ul>\n")
        list += sublist;

    list += "</li>\n";

    return list;
}

/**
 * Event handler for the resize event on the browser window,
 * also called when the site loads (see the <script> tag at
 * the bottom of the layout template file). It adjusts the
 * height of the sidebar to the correct proportions instead
 * of its default wild guess of 95% percent of the browser
 * height.
 */
function handle_resize(){
    $("#sidebar").height($(window).height() - 8); /* 4px top margin, 4px bottom margin */
}
