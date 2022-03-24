#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class RepList < Scraped::HTML
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  field :members do
    member_entries.map { |ul| fragment(ul => Rep) }.reject(&:empty?).map(&:to_h)
  end

  private

  def member_entries
    noko.xpath('//table[contains(., "Sénateurs")]//tr[td]//td[position() = 2 or position() = 5]//a')
  end

  class Rep < Scraped::HTML
    def empty?
      noko.text.to_s.empty?
    end

    field :item do
      noko.attr('wikidata')
    end

    field :name do
      noko.text
    end

    field :region do
      region_node.attr('wikidata')
    end

    field :regionLabel do
      region_node.text
    end

    field :party do
      party_node.attr('wikidata') unless party_node == region_node
    end

    field :partyLabel do
      party_node.text unless party_node == region_node
    end

    private

    def region_node
      noko.xpath('ancestor::tr[1]').css('td a').first
    end

    def party_node
      noko.xpath('preceding::td[1]').css('a').first
    end
  end
end



url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: RepList).csv
