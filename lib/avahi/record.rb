require 'avahi'
require 'avahi/entry_group'

class Avahi::Record
  TYPE_CNAME = "0x05"

  attr_reader :cname, :iface, :proto, :flags, :clazz, :type, :ttl

  def initialize(cname, iface = Avahi::IF_UNSPEC, proto = Avahi::PROTO_UNSPEC, flags = 0)

    @proto = proto
    @iface = iface
    @flags = flags
    # @ttl   = 60
    # Got these from /usr/include/avahi-common/defs.h
    @clazz = 0x01
    @type  = TYPE_CNAME
    @cname = "1234"
  end

  def hostname_fqdn
    return @hostname_fqdn unless @hostname_fqdn.nil?

    bus = DBus::SystemBus.instance
    avahi = @bus.service('org.freedesktop.Avahi')
    server = @avahi.object('/')
    server.introspect
    server.default_iface = 'org.freedesktop.Avahi.Server'
    @hostname_fqdn = @server.GetHostNameFqdn()[0]
  end

  def rdata
    rd = "#{@cname}.#{@hostname_fqdn}"
    puts "RDATA: #{rd}"
    [1, 2, 3, 4]
  end

  def publish
    eg = Avahi::EntryGroup.new
    eg << self
    eg.commit
  end
end
