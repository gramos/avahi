require 'test_helper'
require 'avahi/address'
require 'avahi/record'

class AddressTest < Test::Unit::TestCase
  def setup
    @randname      = "%s.local" % SecureRandom.hex
    @randon_cname  = "%s.#{@randname}" % SecureRandom.hex
    @localhost     = "127.0.0.1".freeze
  end

  def test_address_publishing
    addr = Avahi::Address.new(@randname, @localhost)
    assert_not_match libc_resolver_output, /#{Regexp.quote(@localhost)}/

    addr.publish
    assert_match libc_resolver_output, /#{Regexp.quote(@localhost)}/
  end

  def test_cname_publishing
    cname = Avahi::Record.new(@randon_cname, @localhost)
    cname.publish
    assert_not_match libc_resolver_output(@randon_cname), /#{Regexp.quote(@localhost)}/
  end

  def libc_resolver_output(name = @randname)
    cmd = "ping -c1 #{name} 2>/dev/null"
    `#{cmd}`
  end
end
