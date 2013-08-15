require 'test_helper'
require 'avahi/address'
require 'avahi/record'

class AddressTest < Test::Unit::TestCase
  def setup
    @randname      = "%s.local" % SecureRandom.hex
    @randon_cname  = "%s.#{@randname}" % SecureRandom.hex
    @localhost     = "127.0.0.1".freeze
  end

  def localhost_regex
    /#{Regexp.quote(@localhost)}/
  end

  def test_address_publishing
    addr = Avahi::Address.new(@randname, @localhost)
    assert_not_match ping_output, localhost_regex

    addr.publish
    assert_match ping_output, localhost_regex
  end

  def test_cname_publishing
    cname = Avahi::Record.new(@randon_cname)
    assert_not_match ping_output(@randon_cname), localhost_regex

    cname.publish
    assert_match ping_output(@randon_cname), localhost_regex
  end

  def ping_output(name = @randname)
    cmd = "ping -c1 #{name} 2>/dev/null"
    output = `#{cmd}`
    # puts output
    output
  end
end
