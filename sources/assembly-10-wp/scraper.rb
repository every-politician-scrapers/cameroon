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
    noko.xpath('//table[contains(., "Circonscription")]//tr[td]')
  end

  class Rep < Scraped::HTML
    PARTY = {
      'RDPC' => 'Q953447',
      'UNDP' => 'Q6979097',
      'SDF'  => 'Q1470113',
      'PCRN' => 'Q97177912',
      'UDC'  => 'Q3550257',
      'FSNC' => 'Q111340112',
      'MDR'  => 'Q15195678',
      'UMS'  => 'Q111340117',
      'MRC'  => 'Q20982150',
    }.freeze

    def empty?
      noko.text =~ /Vacant/
    end

    field :item do
      name_link.attr('wikidata')
    end

    field :name do
      name_link.any? ? name_link.text.tidy : tds[0].text.tidy
    end

    field :party do
      PARTY.fetch(partyLabel, partyLabel)
    end

    field :partyLabel do
      tds[3].text.tidy rescue ''
    end

    private

    def tds
      noko.css('td')
    end

    def name_link
      tds[0].css('a')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: RepList).csv
