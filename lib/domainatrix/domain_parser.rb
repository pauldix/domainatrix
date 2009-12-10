module Domainatrix
  class DomainParser
    attr_reader :tlds

    def initialize(file_name)
      @tlds = {}
      read_dat_file(file_name)
    end

    def read_dat_file(file_name)
      File.readlines(file_name).each do |line|
        line = line.strip
        unless line.start_with? "//" || line.empty?
          parts = line.split(".").reverse

          sub_hash = @tlds
          parts.each do |part|
            sub_hash = (sub_hash[part] ||= {})
          end
        end
      end
    end
  end
end