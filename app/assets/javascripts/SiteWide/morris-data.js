// Morris.js Charts sample data for SB Admin template

$(function() {

  if ( $( ".morris-donut-chart" ).length && $( ".morris-donut-chart" ).children().length == 0) {
    // Donut Chart
    Morris.Donut({
        element: 'morris-donut-chart',
        colors: ["green", "blue", "red"],
        data: [{
            label: "Hibernia",
            value: $(".realm_total_rps").data("hibernia-total-rps")
        }, {
            label: "Midgard",
            value: $(".realm_total_rps").data("midgard-total-rps")
        }, {
            label: "Albion",
            value: $(".realm_total_rps").data("albion-total-rps")
        }],
        resize: true
    });
  }
});
