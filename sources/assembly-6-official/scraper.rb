#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    REMAPEXTRA = {
      'Benoué North NUDP'          => 'NUDP Nord',
      'Centre -RDPC'               => 'RDPC Centre',
      'Littoral RDPC'              => 'RDPC Littoral',
      'Nord-Ouest SDF'             => 'SDF Nord-Ouest',
      'Nord-ouest SDF'             => 'SDF Nord-ouest',
      'Nyong et Kellé,Centre, UPC' => 'UPC Centre',
      'west SDF'                   => 'SDF West',
    }.freeze

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
      'UPC'   => 'Q1860584',
      'CPDM'  => 'Q953447',
    }.freeze

    AREA = {
      'adamaoua'     => 'Q351514',
      'adamawa'      => 'Q351514',
      'centre'       => 'Q739951',
      'est'          => 'Q845168',
      'east'         => 'Q845168',
      'extreme nord' => 'Q823976',
      'extrême nord' => 'Q823976',
      'extême nord'  => 'Q823976',
      'far nord'     => 'Q823976',
      'far north'    => 'Q823976',
      'littoral'     => 'Q845172',
      'littotal'     => 'Q845172',
      'nord'         => 'Q502341',
      'nord ouest'   => 'Q823946',
      'ouest'        => 'Q165784',
      'west'         => 'Q165784',
      'sud'          => 'Q857122',
      'south'        => 'Q857122',
      'sud ouest'    => 'Q607499',
      'south west'   => 'Q607499',
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
      AREA[areaLabel.downcase]
    end

    field :areaLabel do
      extra.drop(1).join(' ').tidy
    end

    def position; end

    private

    def extra_raw
      noko.css('h3.team-title').last.text.tidy
    end

    def extra
      REMAPEXTRA.fetch(extra_raw, extra_raw).split(/[ \-]/).map(&:tidy)
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
