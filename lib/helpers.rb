include Nanoc::Helpers::Rendering
include Nanoc::Helpers::ChildParent

def time_and_place_for item
    result = ""
    if not timestr_for(item).empty?
        result += timestr_for(item)
        if item[:eventlocation]
            result += ", "
        end
    end
    if item[:eventlocation]
        result += item[:eventlocation]
    end
    return result
end

def timestr_for item
    result = ""
    if item[:eventdate].hour == 0 && item[:eventdate].min == 0 && item[:eventdate].sec == 0
        return results
    end
    if item[:eventdate].min == 0
        result += item[:eventdate].hour.to_s
    else
        result += item[:eventdate].strftime("%H:%M")
    end
    if item[:eventend]
        result += " - "
        if item[:eventend].min == 0
            result += item[:eventend].hour.to_s
        else
            result += item[:eventend].strftime("%H:%M")
        end
    end
    result += " Uhr"

    return result
end

def ical_vtimezone
    ical_str = "BEGIN:VTIMEZONE\n"
    ical_str += "TZID:Europe/Berlin\n"
    ical_str += "X-LIC-LOCATION:Europe/Berlin\n"
    ical_str += "BEGIN:DAYLIGHT\n"
    ical_str += "TZOFFSETFROM:+0100\n"
    ical_str += "TZOFFSETTO:+0200\n"
    ical_str += "TZNAME:CEST\n"
    ical_str += "DTSTART:19700329T020000\n"
    ical_str += "RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\n"
    ical_str += "END:DAYLIGHT\n"
    ical_str += "BEGIN:STANDARD\n"
    ical_str += "TZOFFSETFROM:+0200\n"
    ical_str += "TZOFFSETTO:+0100\n"
    ical_str += "TZNAME:CET\n"
    ical_str += "DTSTART:19701025T030000\n"
    ical_str += "RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\n"
    ical_str += "END:STANDARD\n"
    ical_str += "END:VTIMEZONE\n"
    return ical_str
end

def ical_calendar_for item
    if not item[:eventdate]
        raise "Tried to create ical for an item that is not an event."
    end
    ical_str = "BEGIN:VCALENDAR\n"
    ical_str += "VERSION:2.0\n"
    ical_str += "PRODID:poly-bs.de\n"
    ical_str += ical_vtimezone
    ical_str += ical_event_for(item)
    ical_str += "END:VCALENDAR\n"
    return ical_str
end

def ical_event_for item
    if not item[:eventdate]
        raise "Tried to create ical for an item that is not an event."
    end

    ical_time_format = "%Y%m%dT%H%M%S"

    ical_str = "BEGIN:VEVENT\n"
    ical_str += "UID:" + "de.poly-bs." + item.path[1..-2] + "\n"
    ical_str += "DTSTAMP;TZID=Europe/Berlin:" + item[:published].strftime(ical_time_format) + "\n"
    ical_str += "ORGANIZER;CN=Polyamorie-Stammtisch Braunschweig:MAILTO:kontakt@poly-bs.de\n"
    ical_str += "DTSTART;TZID=Europe/Berlin:" + item[:eventdate].strftime(ical_time_format) + "\n"

    ical_str += "DTEND;TZID=Europe/Berlin:"
    if not item[:eventend]
        default_eventend = item[:eventdate] + 1/8r # plus 3 hours (1/8 of a day)
        ical_str += default_eventend.strftime(ical_time_format) + "\n" 
    else
        ical_str += item[:eventend].strftime(ical_time_format) + "\n"
    end

    ical_str += "SUMMARY:" + item[:eventname] + "\n"

    description = item[:subtitle] + "\\n\\n" + domain[0..-2] + item.path
    ical_str += "DESCRIPTION:" + description + "\n"

    if item[:eventlocation]
        ical_str += "LOCATION:" + item[:eventlocation] + "\n"
    end
    ical_str += "URL:" + domain[0..-2] + item.path + "event.ics\n"
    ical_str += "END:VEVENT\n"
    
    return ical_str
end

def calendar_events # all events that should appear in the ical calendar feed
    @items.find_all("/**/*").select{|i| i[:eventdate] && i[:eventdate].year >= 2023}.sort_by{|i| i[:eventdate].jd}
end

def events # events in the present and future
    blk = -> { @items.find_all("/**/*").select{|i| i[:eventdate] && i[:eventdate].jd >= Date::today.jd - 7}.sort_by{|i| i[:eventdate].jd} }
    if @items.frozen?
        @events ||= blk.call
    else
        blk.call
    end
end

def nextevents # the next 3 events
    blk = -> { @items.find_all("/**/*").select{|i| i[:eventdate] && i[:eventdate].jd >= Date::today.jd - 7}.sort_by{|i| i[:eventdate].jd}.take(3) }
    if @items.frozen?
        @nextevents ||= blk.call
    else
        blk.call
    end
end

def newsthings
    blk = -> { newest_first(@items.find_all("/**/*").select{|i| i[:news]}) }
    if @items.frozen?
        @newsthings ||= blk.call
    else
        blk.call
    end
end

def newestthings
    blk = -> { newest_first(@items.find_all("/**/*").select{|i| i[:news]}).take(3) }
    if @items.frozen?
        @newestthings ||= blk.call
    else
        blk.call
    end
end

def things
    blk = -> { newest_first(@items.find_all("/**/*").select{|i| i[:published]}) }
    if @items.frozen?
        @things ||= blk.call
    else
        blk.call
    end
end

def link_to item, text=nil
    text = item[:title] if text.nil?
    "<a href=\"#{link_for(item)}\">#{text}</a>"
end

def calculate_tags
    @items.select{|i| i[:tags]}.map{|i| i[:tags]}.flatten.uniq.sort
end

def tags
    calculate_tags
end

def menutext_for item
    menutext_breaking = if item[:menu]
        item[:menu]
    else
        item[:title]
    end
	menutext_breaking.gsub(" ", "&nbsp;").gsub("-", "&#x2011;")
end

def link_for item
    if item[:url]
        item[:url]
    else
        item.path
    end
end

def tags_for item, link=true
    item[:tags].map do |tag|
        if link
            "<a href=\"/news/##{tag}\">#{tag}</a>"
        else
            tag
        end
    end.join(", ")
end

def lang_for item
    if item[:tags] and item[:tags].include? "en"
        "en"
    else
        "de"
    end
end

def abstract_for item
    if item[:abstract]
        item[:abstract]
    elsif item[:subtitle]
        item[:subtitle]
    else
        content = item.raw_content.dup
        content.gsub!(/!\[([^\]]*)\]\([^)]*\)/,"") # remove images
        content.gsub!(/\[([^\]]*)\]\([^)]*\)/,"\\1") # replace links with link text
        content.gsub!(/[*"]/,"") # remove italic and bold markers and quotations
        content.strip!
        abstract = content[/^[[:print:]]{20,256}[.…!?:*]/] || item[:title]
    end
end

def thumbnail_for item
	thumbnail = if item[:thumbnail]
                    @items[item[:thumbnail]]
                else
					nil
				end

    if thumbnail && thumbnail.reps[:thumbnail]
        thumbnail.reps[:thumbnail].path
	else
		raise "error: could not find thumbnail rep of "+item.identifier.to_s
    end
end

def minithumbnail_for item
	thumbnail = if item[:thumbnail]
                    @items[item[:thumbnail]]
                else
					nil
				end

    if thumbnail && thumbnail.reps[:minithumbnail]
        thumbnail.reps[:minithumbnail].path
	else
		raise "error: could not find minithumbnail rep of "+item.identifier.to_s+" (thumbnail is "+item[:thumbnail]+")"
    end
end

def with_tag tag
    things.select do |item|
        item[:tags] and item[:tags].include? tag
    end
end

def domain
    "http://poly-bs.de/"
end

def box(items)
    ret = "<div class=\"boxes\">"
    items.each do |item|
        ret << render("/box.*", {:item => item})
    end
    ret << "</div>"
    ret
end

def eventbox(items)
    ret = "<div class=\"boxes\">"
    items.each do |item|
        ret << render("/eventbox.*", {:item => item})
    end
    ret << "</div>"
    ret
end

def newest_first(items)
    items.select{|i| i[:updated] || i[:published] }.sort_by{|i| i[:updated] || i[:published]}.reverse
end
