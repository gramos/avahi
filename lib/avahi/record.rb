require 'avahi'
require 'avahi/entry_group'

class Avahi::Record
  TYPE_CNAME = 0x05

  attr_reader :iface, :proto, :flags, :clazz, :type, :ttl

  def initialize(cname, iface = Avahi::IF_UNSPEC, proto = Avahi::PROTO_UNSPEC, flags = 0)

    @proto = proto
    @iface = iface
    @flags = flags
    @ttl   = 60

    # Got these from /usr/include/avahi-common/defs.h
    @clazz = 0x01
    @type  = TYPE_CNAME
    @cname = cname
  end

  def hostname_fqdn
    return @hostname_fqdn unless @hostname_fqdn.nil?

    bus    = DBus::SystemBus.instance
    avahi  = bus.service('org.freedesktop.Avahi')
    server = avahi.object('/')
    server.introspect
    server.default_iface = 'org.freedesktop.Avahi.Server'

    @hostname_fqdn = server.GetHostNameFqdn()[0]
  end

  def cname
    _cname = []
    @cname.split(".").each do |e|
      _cname << e.force_encoding("ascii")
    end

    _cname.join(".")
  end

  def rdata
    rd  = hostname_fqdn
    out = []

    rd.split(".").each do |e|
      out << e.size.chr
      out << e.force_encoding("ascii")
    end

    out.join + "\0"
  end

  def publish
    require 'debugger' ; debugger
    eg = Avahi::EntryGroup.new
    eg << self
    eg.commit
  end
end
