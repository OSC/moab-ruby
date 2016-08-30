require 'open3'
require 'nokogiri'

module Moab
  # Object used for simplified communication with a moab scheduler server
  class Scheduler
    # The host of the Moab scheduler server
    # @example OSC's Oakley scheduler server
    #   my_conn.host #=> "oak-batch.osc.edu"
    # @return [String] the scheduler server host
    attr_reader :host

    # The path to the Moab client installation libraries
    # @example For Moab 9.0.0
    #   my_conn.lib.to_s #=> "/usr/local/moab/9.0.0/lib"
    # @return [Pathname] path to moab libraries
    attr_reader :lib

    # The path to the Moab client installation binaries
    # @example For Moab 9.0.0
    #   my_conn.bin.to_s #=> "/usr/local/moab/9.0.0/bin"
    # @return [Pathname] path to moab binaries
    attr_reader :bin

    # The path to the Moab home dir
    # @example
    #   my_conn.moabhomedir.to_s #=> "/var/spool/batch/moab"
    # @return [Pathname] path to moab home dir
    attr_reader :moabhomedir

    # @param host [#to_s] the moab scheduler server
    # @param lib [#to_s] path to moab installation libraries
    # @param bin [#to_s] path to moab installation binaries
    # @param moabhomedir [#to_s] path to moab home dir
    def initialize(host:, lib: "", bin: "", moabhomedir: ENV['MOABHOMEDIR'])
      @host        = host.to_s
      @lib         = Pathname.new(lib.to_s)
      @bin         = Pathname.new(bin.to_s)
      @moabhomedir = Pathname.new(moabhomedir.to_s)
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {host: host, lib: lib, bin: bin, moabhomedir: moabhomedir}
    end

    # The comparison operator
    # @param other [#to_h] object to compare against
    # @return [Boolean] whether objects are equivalent
    def ==(other)
      to_h == other.to_h
    end

    # Check whether objects are identical to each other
    # @param other [#to_h] object to compare against
    # @return [Boolean] whether objects are identical
    def eql?(other)
      self.class == other.class && self == other
    end

    # Generate a hash value for this object
    # @return [Fixnum] hash value of object
    def hash
      [self.class, to_h].hash
    end

    # Call a binary command from the moab client installation
    # @param cmd [#to_s] command run from command line
    # @param *args [Array<#to_s>] any number of arguments for command
    # @param env [#to_h] environment to run command under
    # @return [Nokogiri::Document] the xml output from command
    # @raise [CommandFailed] if command exits with nonzero exit code
    # @raise [InvalidCommand] if command does not exist
    def call(cmd, *args, env: {})
      cmd = bin.join(cmd.to_s).to_s
      args = ["--host=#{@host}", "--xml"] + args.map(&:to_s)
      env = {
        "LD_LIBRARY_PATH" => "#{lib}:#{ENV['LD_LIBRARY_PATH']}",
        "MOABHOMEDIR" => "#{moabhomedir}"
      }.merge(env.to_h)
      o, e, s = Open3.capture3(env, cmd, *args)
      s.success? ? Nokogiri::XML(o) : raise(CommandFailed, e)
    rescue Errno::ENOENT => e
      raise InvalidCommand, e.message
    end
  end
end
