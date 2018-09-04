require 'responders'

module Refinery
  module Calendar
    class EventsController < ::ApplicationController
      before_action :find_page, except: :archive

      respond_to :html

      def index
        @events = Event.upcoming.order(starts_at: :desc)

        present @page
      end

      def month
        params[:start_date] = Date.today.to_s if (params[:start_date] == 'current')

        @start_date = Date.parse(params[:start_date]).beginning_of_month
        @end_date   = Date.parse(params[:start_date]).end_of_month
        @events     = Event.bewteen(@start_date, @end_date)

        @page = ::Refinery::Page.where(link_url: '/calendar/events/month/current').first || find_page
        present @page
      end

      def show
        @event = Event.friendly.find(params[:id])

        present @page
      end

      def archive
        @events = Event.archive.order(starts_at: :desc)
        render template: 'refinery/calendar/events/index'
      end

      protected

      def find_page
        @page = ::Refinery::Page.find_by!(link_url: '/calendar/events')
      end

    end
  end
end
