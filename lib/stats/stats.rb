FnordMetric.namespace :alice do

  gauge :requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Total requests per hour"

  gauge :machine_requests_per_day,
    :tick  => 1.day.to_i,
    :title => "Machine requests per day",
    :three_dimensional => true

  gauge :router_requests_per_day,
    :tick  => 1.day.to_i,
    :title => "Router requests per day",
    :three_dimensional => true

  gauge :passer_requests_per_day,
    :tick  => 1.day.to_i,
    :title => "Passer requests per day",
    :three_dimensional => true

  gauge :application_requests_per_day,
    :tick  => 1.day.to_i,
    :title => "Application requests per day",
    :three_dimensional => true

  gauge :process_requests_per_day,
    :tick  => 1.day.to_i,
    :title => "Process requests per day",
    :three_dimensional => true

  gauge :instance_requests_per_day,
    :tick  => 1.day.to_i,
    :title => "Instance requests per day",
    :three_dimensional => true

  event(:request) do
    incr :requests_per_hour

    if data[:machine]
      incr_field :machine_requests_per_day, "#{data[:machine]}"
    end

    if data[:router]
      incr_field :router_requests_per_day, "#{data[:router]}"
    end

    if data[:passer]
      incr_field :passer_requests_per_day, "#{data[:passer]}"
    end

    if data[:application]
      incr_field :application_requests_per_day, "#{data[:application]}"
    end

    if data[:application] and data[:process]
      incr_field :process_requests_per_day, "#{data[:application]}|#{data[:process]}"
    end

    if data[:application] and data[:process] and data[:instance]
      incr_field :instance_requests_per_day, "#{data[:application]}|#{data[:process]}:#{data[:instance]}"
    end
  end

  widget 'Overview', {
    :title           => "Requests per hour",
    :type            => :timeline,
    :gauges          => :requests_per_hour,
    :include_current => true,
    :autoupdate      => 5
  }

  widget 'Overview', {
    :title           => "Requests per machine",
    :type            => :toplist,
    :gauges          => :machine_requests_per_day,
    :include_current => true,
    :autoupdate      => 5,
    :width           => 33
  }

  widget 'Overview', {
    :title           => "Requests per router",
    :type            => :toplist,
    :gauges          => :router_requests_per_day,
    :include_current => true,
    :autoupdate      => 5,
    :width           => 33
  }

  widget 'Overview', {
    :title           => "Requests per passer",
    :type            => :toplist,
    :gauges          => :passer_requests_per_day,
    :include_current => true,
    :autoupdate      => 5,
    :width           => 34
  }

  widget 'Overview', {
    :title           => "Requests per application",
    :type            => :toplist,
    :gauges          => :application_requests_per_day,
    :include_current => true,
    :autoupdate      => 5
  }
  widget 'Overview', {
    :title           => "Requests per process",
    :type            => :toplist,
    :gauges          => :process_requests_per_day,
    :include_current => true,
    :autoupdate      => 5,
    :width           => 50
  }
  widget 'Overview', {
    :title           => "Requests per instance",
    :type            => :toplist,
    :gauges          => :instance_requests_per_day,
    :include_current => true,
    :autoupdate      => 5,
    :width           => 50
  }

end
