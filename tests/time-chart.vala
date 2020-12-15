//EXPERIMENTAL
private void register_time_chart() {

    Test.add_func("/LiveChart/TimeChart/serie/add_value#should_update_bounds_when_adding_a_value", () => {
        //given
        var chart = new LiveChart.TimeChart();
        var serie = new LiveChart.LineSerie("TEST");
        
        chart.add_serie(serie);
        
        //when //then
        assert_false(chart.config.y_axis.get_bounds().has_upper());

        //when
        serie.add(100.0);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

    Test.add_func("/LiveChart/TimeChart#Export", () => {
        //given
        var window = new Gtk.Window();
        var chart = new LiveChart.TimeChart();
        window.add(chart);
        window.show();
        window.resize(50, 50);
        chart.show_all();
 
        //when
        try {
            chart.to_png("export.png");
        } catch (Error e) {
            assert_not_reached() ;
        }
        
        //then
        File file = File.new_for_path("export.png");
        assert(true == file.query_exists());
    });

    Test.add_func("/LiveChart/TimeChart#ExportWhenNotRealized", () => {
        //given
        var chart = new LiveChart.TimeChart();

        //when //then
        try {
            chart.to_png("export.png");
            assert_not_reached();
        } catch (Error e) {
            assert(e is LiveChart.ChartError.EXPORT_ERROR);
        }
    });

    Test.add_func("/LiveChart/TimeChart/add_unaware_timestamp_collection", () => {
        //given
        var chart = new LiveChart.TimeChart();
        var serie = new LiveChart.LineSerie("TEST");

        var unaware_timestamp_collection = new Gee.ArrayList<double?>();
        unaware_timestamp_collection.add(5);
        unaware_timestamp_collection.add(10);
        unaware_timestamp_collection.add(15);

        var timespan_between_value = 5000;

        //when
        var now = GLib.get_real_time() / 1000;
        chart.add_unaware_timestamp_collection(serie, unaware_timestamp_collection, timespan_between_value);

        //then
        assert(serie.get_values().size == 3);
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);

        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });

    Test.add_func("/LiveChart/TimeChart/serie/add_value_by_index", () => {
        //given
        var chart = new LiveChart.TimeChart();
        var serie = new LiveChart.LineSerie("TEST");
        
        chart.add_serie(serie);
        
        //when
        try {
            chart.series[0].add(100);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().get(0).value == 100);
    });

    Test.add_func("/LiveChart/TimeChart/add_unaware_timestamp_collection_by_index", () => {
        //given
        var chart = new LiveChart.TimeChart();
        var serie = new LiveChart.LineSerie("TEST");
        
        chart.add_serie(serie);
        
        var unaware_timestamp_collection = new Gee.ArrayList<double?>();
        unaware_timestamp_collection.add(5);
        unaware_timestamp_collection.add(10);
        unaware_timestamp_collection.add(15);

        var timespan_between_value = 5000;

        //when
        var now = GLib.get_real_time() / 1000;
        try {
            chart.add_unaware_timestamp_collection_by_index(0, unaware_timestamp_collection, timespan_between_value);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 3);
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);

        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });   

    Test.add_func("/LiveChart/TimeChart/#ShouldNotCrashWhenRevealingAChartWithoutAnyValueAdded", () => {
        //given
        var chart = new LiveChart.TimeChart();
        chart.add_serie(new LiveChart.LineSerie("Test"));
       
        //when
        //then
        Timeout.add(1000, () => {
            Gtk.main_quit();
            return false;
        });
        Gtk.main();
    });

        Test.add_func("/LiveChart/TimeChart/background#main_color_should_be_accessible_even_if_deprected", () => {
        //given
        var chart = new LiveChart.TimeChart();

        //when
        chart.background.main_color = {1, 1, 1, 1};
       
        //then
        //ok
        
    });
}