require 'time'

timeline = {}
re = '\[(.*)\]\ (.*)'
re_begins = 'Guard\ #(\d+)'
re_sleep = 'asleep'

File.foreach('input.txt') do |line|
  matches = line.chomp.match(re).to_a[1..-1]
  timeline[matches[0]] = matches[1]
end

curr_id = 0
time_fmt = '%Y-%m-%d %H:%M'
sleep_times = {}
t1 = nil
t2 = nil

timeline.sort.to_h.each_pair do |time, event|
  begins = event.match(re_begins)
  sleep = event.match(re_sleep)

  unless begins.nil?
    curr_id = begins[1]
    sleep_times[curr_id] = Array.new(60, 0) if sleep_times[curr_id].nil?
    next
  end
  unless sleep.nil?
    t1 = Time.strptime(time, time_fmt).min
    next
  end

  t2 = Time.strptime(time, time_fmt).min
  diff = t2 - t1
  diff.times do |i|
    sleep_times[curr_id][t1 + i] += 1
  end
end

max_id = 0
max_sleep = 0

sleep_times.each do |id, scheds|
  m = scheds.sum
  if m > max_sleep
    max_sleep = m
    max_id = id
  end
end

max_min = sleep_times[max_id].find_index(sleep_times[max_id].max)
pp max_id.to_i * max_min
