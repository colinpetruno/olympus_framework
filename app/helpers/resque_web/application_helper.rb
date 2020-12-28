module ResqueWeb
  module ApplicationHelper

    PER_PAGE = 20

    def tabs
      t = {'overview' => resque_web_overview_path,
       'working'  => resque_web_working_index_path,
       'failures' => resque_web_failures_path,
       'queues' => resque_web_queues_path,
       'workers' => resque_web_workers_path,
       'stats' => resque_web_stats_path
      }
      t
    end

    def tab(name,path)
      content_tag :li, link_to(name.capitalize, path), :class => current_tab?(name) ? "active" : nil
    end

    def current_tab
      params[:controller].gsub(/resque_web\//, "#{root_path}")
    end

    def current_tab?(name)
      request.path.starts_with? tabs[name.to_s]
    end

    attr_reader :subtabs

    def subtab(name)
      content_tag :li, link_to(name, "#{current_tab}/#{name}"), :class => current_subtab?(name) ? "current" : nil
    end

    def current_subtab?(name)
      params[:id] == name.to_s
    end

    def pagination(options = {})
      start    = options[:start] || 1
      per_page = options[:per_page] || PER_PAGE
      total    = options[:total] || 0
      return if total < per_page

      markup = ""
      if start - per_page >= 0
        markup << link_to(raw("&laquo; less"), params.permit!.merge(:start => start - per_page), :class => 'btn less')
      end

      if start + per_page <= total
        markup << link_to(raw("more &raquo;"), params.permit!.merge(:start => start + per_page), :class => 'btn more')
      end

      content_tag :p, raw(markup), :class => 'pagination'
    end

    def poll(polling=false)
      if polling
        text = "Last Updated: #{Time.now.strftime("%H:%M:%S")}".html_safe
      else
        text = "<a href='#{h(request.path)}' rel='poll'>Live Poll</a>".html_safe
      end
      content_tag :p, text, :class => 'poll'
    end
  end
end
