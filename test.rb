require 'minitest/autorun'
require './safe_load.rb'

Gem::SpecFetcher
Gem::Installer

class TestString < Minitest::Test
  def setup
    @dump = Marshal.dump("foo")
  end

  def test_foo
    assert_equal "\x04\bI\"\bfoo\x06:\x06ET", @dump
  end

  def test_load
    assert_equal "foo", Marshal.load(@dump)
  end

  def test_safe_load
    assert_equal "foo", Marshal.safe_load(@dump)
  end

end

class TestString2 < Minitest::Test
  def setup
    @dump = Marshal.dump("foo\bo:\x16Net")
  end

  def test_foo
    assert_equal "\x04\bI\"\x0Ffoo\bo:\x16Net\x06:\x06ET", @dump
  end

  def test_load
    assert_equal "foo\bo:\x16Net", Marshal.load(@dump)
  end

  def test_safe_load
    assert_equal "foo\bo:\x16Net", Marshal.safe_load(@dump)
  end

end

class TestObject < Minitest::Test
  def setup
    adapter = ::Net::WriteAdapter.new("dummy", :send)
    @dump = Marshal.dump(adapter)
  end

  def test_foo
    assert_equal "\x04\bo:\x16Net::WriteAdapter\a:\f@socketI\"\ndummy\x06:\x06ET:\x0F@method_id:\tsend", @dump
  end

  def test_load
    assert_instance_of ::Net::WriteAdapter, Marshal.load(@dump)
  end

  def test_safe_load
    assert_raises(TypeError) {
      Marshal.safe_load(@dump)
    }
  end

end

class TestJSON < Minitest::Test
  def setup
    @dump = Marshal.dump({"aa": "o:x:", "b": 22, "c": -20.2})
  end

  def test_foo
    assert_equal "\x04\b{\b:\aaaI\"\to:x:\x06:\x06ET:\x06bi\e:\x06cf\n-20.2", @dump
  end

  def test_load
    assert_equal ({"aa": "o:x:", "b": 22, "c": -20.2}), Marshal.load(@dump)
  end

  def test_safe_load
    assert_equal ({"aa": "o:x:", "b": 22, "c": -20.2}), Marshal.safe_load(@dump)
  end

end

class TestComplex  < Minitest::Test
  def setup
    adapter = ::Net::WriteAdapter.new("dummy", :send)
    @dump = Marshal.dump({"aa": adapter})
  end

  def test_foo
    assert_equal "\x04\b{\x06:\aaao:\x16Net::WriteAdapter\a:\f@socketI\"\ndummy\x06:\x06ET:\x0F@method_id:\tsend", @dump
  end

  def test_load
    assert_equal '{:aa=>#<Net::WriteAdapter socket="dummy">}', Marshal.load(@dump).inspect
  end

  def test_safe_load
    assert_raises(TypeError) {
      Marshal.safe_load(@dump)
    }
  end

end

class TestPermitted  < Minitest::Test
  def setup
    adapter = ::Net::WriteAdapter.new("dummy", :send)
    @dump = Marshal.dump({"aa": adapter})
  end

  def test_foo
    assert_equal "\x04\b{\x06:\aaao:\x16Net::WriteAdapter\a:\f@socketI\"\ndummy\x06:\x06ET:\x0F@method_id:\tsend", @dump
  end

  def test_load
    assert_equal '{:aa=>#<Net::WriteAdapter socket="dummy">}', Marshal.load(@dump).inspect
  end

  def test_safe_load
    assert_equal '{:aa=>#<Net::WriteAdapter socket="dummy">}', Marshal.safe_load(@dump, permitted_classes: [::Net::WriteAdapter]).inspect
  end

end
