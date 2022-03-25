#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    PARTY = {
      'RDPC'  => 'Q953447',
      'RDPD'  => 'Q953447', # presumed typo
      'RDPPC' => 'Q953447', # presumed typo
      'UNDP'  => 'Q6979097',
      'SDF'   => 'Q1470113',
      'PCRN'  => 'Q97177912',
      'UDC'   => 'Q3550257',
      'FSNC'  => 'Q111340112',
      'MDR'   => 'Q15195678',
      'UMS'   => 'Q111340117',
      'MRC'   => 'Q20982150',
    }.freeze

    AREA = {
      'ADAMAOUA'     => 'Q351514',
      'CENTRE'       => 'Q739951',
      'CENTREL'      => 'Q739951',
      'EST'          => 'Q845168',
      'EXTREME NORD' => 'Q823976',
      'LITTORAL'     => 'Q845172',
      'Littoral'     => 'Q845172',
      'NORD'         => 'Q502341',
      'NOR OUEST'    => 'Q823946',
      'NORD OUEST'   => 'Q823946',
      'OUEST'        => 'Q165784',
      'SUD'          => 'Q857122',
      'SUD  OUEST'   => 'Q607499',
      'SUD OUEST'    => 'Q607499',
    }.freeze

    field :item do
    end

    field :name do
      noko.css('h3').first.text.tidy
    end

    field :party do
      PARTY[partyLabel]
    end

    field :partyLabel do
      extra.first
    end

    field :area do
      AREA[areaLabel]
    end

    field :areaLabel do
      extra.drop(1).join(' ')
    end

    def position; end

    private

    def extra
      noko.css('h3.team-title').last.text.split(/[ \-]/).map(&:tidy)
    end
  end

  class Members
    def member_container
      noko.css('.our-team')
    end
  end
end

indir = Pathname.new 'mirror'
outdir = Pathname.new 'scraped'

indir.children.sort.each do |file|
  outfile = outdir + file.basename.sub_ext('.csv')
  outfile.write(EveryPoliticianScraper::FileData.new(file).csv)
end
