local Time = {}


function Time.getTimePassed(past_time, current_time)
  local past = os.date("*t", past_time)
  local now = os.date("*t", current_time)

  local years = now.year - past.year
  local months = now.month - past.month
  local days = now.day - past.day

  if days < 0 then
    months = months - 1
    local prev_month_days = os.date("*t", os.time({
      year = now.year,
      month = now.month,
      day = 0
    })).day

    days = days + prev_month_days
  end

  if months < 0 then
    years = years - 1
    months = months + 12
  end

  return years, months, days
end

function Time.formatTime(model, now)
  local d, m, y = string.match(model.date, "(%d+)/(%d+)/(%d+)")
  local past_date = os.time({ year = y, month = m, day = d })

  local years, months, days = Time.getTimePassed(past_date, now)
  local time_string = ""

  if years == 0 and months == 0 and days == 0 then
    time_string = "added today."
  else
    local parts = {}
    if years > 0 then
      table.insert(parts, years .. (years == 1 and " year" or " years"))
    end
    if months > 0 then
      table.insert(parts, months .. (months == 1 and " month" or " months"))
    end
    if days > 0 then
      table.insert(parts, days .. (days == 1 and " day" or " days"))
    end

    if #parts == 1 then
      time_string = parts[1] .. " passed since."
    elseif #parts == 2 then
      time_string = parts[1] .. " and " .. parts[2] .. " passed since."
    else
      time_string = parts[1] .. ", " .. parts[2] .. ", and " .. parts[3] .. " passed since."
    end
  end

  return time_string
end

return Time
