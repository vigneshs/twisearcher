// Place all the behaviors and hooks related to the matching contoller here.
// All this logic will automatically be available in application.j

$(document).ready(function() {
    clearResults();

    $("#searchButton").click(clearResults);

    $("#searchButton, #showMoreButton").click(search);

    hideOverlay();

    $.ajaxPrefilter(function(options, _, jqXHR) {
        displayOverlay();
        disableSearchButton();
        jqXHR.complete(function() {
            hideOverlay();
            enableSearchButton();
        });
    });
;
})

var maxTweetId;
var tweets = new Object;

function search(event) {
    event.preventDefault();
    var request = $.ajax({
        type: "GET",
        contentType: "application/json",
        dataType: "json",
        url: generateSearchUrl()
    });

    request.done(function(data) {
        displayResults(data);
    });

    request.fail(function(data) {
        alert(data.responseText);
    });
}

function displayResults(data) {
    if(data.next_max_id && data.next_max_id != maxTweetId) {
        accumulateTweets(data.tweets);
        displayTweets();
        plotGraph();
        setupForEarlierResults(data.next_max_id);
    }
    else {
        $("#showMore").hide();
        alert("No more tweets to show!");
    }
}

function accumulateTweets(newTweets) {
    if(Object.keys(tweets).length == 0)
        tweets = newTweets;
    else {
        for(var slot in newTweets) {
            tweets[slot] = tweets[slot].concat(newTweets[slot]);
        }
    }
}

function displayTweets() {
    for(var slot in tweets) {
        if(tweets[slot].length > 0)
            displayTweetsInSlot(slot, tweets[slot]);
    }
    $("#accordion").accordion({ 
        header: "h3",
        heightStyle: "content",
        collapsible: true
    });
}

function displayTweetsInSlot(slot, tweets) {
    var html = "";
    for (var i = 0; i < tweets.length; i++) {
        html += '<div id="' + tweets[i].id + '" class="tweet left">' + tweets[i].text + '</div>';
    }
    $("#tweets_" + slot).html(html).show();
    $("#slot_" + slot).show();
}

function getSlotwiseTweetCount(groupedTweets) {
    var tweetCounts = new Array();
    for(var slot in groupedTweets)
        if(groupedTweets[slot].length > 0)
            tweetCounts[slot.replace(/_/g, ' ')] = groupedTweets[slot].length;
    return tweetCounts;
}

function plotGraph() {
    var slotwiseCounts = getSlotwiseTweetCount(tweets);
    var categories = new Array();
    var tweetCounts = new Array();

    for(var slot in slotwiseCounts){
        categories.push(slot);
        tweetCounts.push(slotwiseCounts[slot]);
    }

    $("#barGraph").highcharts({
        chart: { type: 'column' },
        title: { text: 'Tweets over time' },
        xAxis: { categories: categories },
        yAxis: { title: { text: 'Tweets' } },
        series: [{
            name: 'Number of Tweets',
            data: tweetCounts
        }]
    })
}

function setupForEarlierResults(nextMaxId) {
    maxTweetId = nextMaxId;
    if(maxTweetId)
        $("#showMore").show();
    else
        $("#showMore").hide();
}

function generateSearchUrl(){
    var query = $("#query").val();
    var url = "search.js?query=" + escape(query);
    if(maxTweetId)
        url = url + "&max_id=" + maxTweetId;
    return url;
}

function clearResults() {
    tweets = new Object;
    maxTweetId = null;
    $(".timeSlotContent").html("");
    $(".timeSlotHeader, .timeSlotContent, #showMore").hide();
}

function displayOverlay() {
    var elem = $("#results");
    var position = elem.position();
    var top = position.top;
    var left = position.left;
    var width = elem.width();
    var height = elem.height();

    $("#overlay").css({
        position: 'absolute',
        'z-index': 9999,
        top: top,
        left: left,
        width: width,
        height: height
    }).show();
}

function hideOverlay() {
    $("#overlay").hide();
}

function disableSearchButton() {
    $("#searchButton").attr("disabled", "disabled");
}

function enableSearchButton() {
    $("#searchButton").removeAttr("disabled");
}