$:.push File.expand_path("../../lib", __FILE__)
require 'flatfish/url'
require 'uri'
require 'test/unit'

class URL_Tests < Test::Unit::TestCase

  def setup
    @cd = "http://example.com/test_dir1/test_dir2/"
  end

  def test_relative
    tst = Flatfish::Url.absolutify("../images/test.png", @cd)
    assert_equal("http://example.com/test_dir1/images/test.png", tst)
  end

  def test_double_relative
    tst = Flatfish::Url.absolutify("../../images/test.png", @cd)
    assert_equal("http://example.com/images/test.png", tst)
  end

  def test_absolute
    tst = Flatfish::Url.absolutify("http://example.com/images/test.png", @cd)
    assert_equal("http://example.com/images/test.png", tst)
  end

  def test_broken_root
    tst = Flatfish::Url.absolutify("../../../../images/test.png", @cd)
    assert_equal("http://example.com/images/test.png", tst)
  end

  def test_same_dir
    tst = Flatfish::Url.absolutify("test.png", @cd)
    assert_equal("http://example.com/test_dir1/test_dir2/test.png", tst)
  end

end
