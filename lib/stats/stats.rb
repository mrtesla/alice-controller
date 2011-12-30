FnordMetric.namespace :alice do

  gauge :requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Total requests per hour"

  gauge :router_requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Router requests per hour",
    :three_dimensional => true

  gauge :passer_requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Passer requests per hour",
    :three_dimensional => true

  gauge :application_requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Application requests per hour",
    :three_dimensional => true

  gauge :process_requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Process requests per hour",
    :three_dimensional => true

  gauge :instance_requests_per_hour,
    :tick  => 1.hour.to_i,
    :title => "Instance requests per hour",
    :three_dimensional => true

  event(:request) do
    incr :requests_per_hour

    if data[:router]
      incr_field :router_requests_per_hour, "#{data[:router]}"
    end

    if data[:passer]
      incr_field :passer_requests_per_hour, "#{data[:passer]}"
    end

    if data[:application]
      incr_field :application_requests_per_hour, "#{data[:application]}"
    end

    if data[:application] and data[:process]
      incr_field :process_requests_per_hour, "#{data[:application]}|#{data[:process]}"
    end

    if data[:application] and data[:process] and data[:instance]
      incr_field :instance_requests_per_hour, "#{data[:application]}|#{data[:process]}:#{data[:instance]}"
    end
  end

  widget 'Overview', {
    :title           => "Requests per hour",
    :type            => :timeline,
    :gauges          => :requests_per_hour,
    :include_current => true,
    :autoupdate      => 2
  }

  widget 'Overview', {
    :title           => "Requests per router",
    :type            => :toplist,
    :gauges          => :router_requests_per_hour,
    :include_current => true,
    :autoupdate      => 2,
    :width           => 50
  }

  widget 'Overview', {
    :title           => "Requests per passer",
    :type            => :toplist,
    :gauges          => :passer_requests_per_hour,
    :include_current => true,
    :autoupdate      => 2,
    :width           => 50
  }

  widget 'Overview', {
    :title           => "Requests per application",
    :type            => :toplist,
    :gauges          => :application_requests_per_hour,
    :include_current => true,
    :autoupdate      => 2
  }
  widget 'Overview', {
    :title           => "Requests per process",
    :type            => :toplist,
    :gauges          => :process_requests_per_hour,
    :include_current => true,
    :autoupdate      => 2,
    :width           => 50
  }
  widget 'Overview', {
    :title           => "Requests per instance",
    :type            => :toplist,
    :gauges          => :instance_requests_per_hour,
    :include_current => true,
    :autoupdate      => 2,
    :width           => 50
  }

end
