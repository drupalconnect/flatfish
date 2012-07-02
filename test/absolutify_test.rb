require 'test/unit'
require 'flatfish'

class AbsolutifyTests < Test::Unit::TestCase

  def setup
    @cd = "http://soe.stanford.edu/current_students/chinaprogram/"
  end

  def test_relative
    tst = Flatfish::Url.absolutify("../images/test.png", @cd)
    assert_equal("http://soe.stanford.edu/current_students/images/test.png", tst)
  end

  def test_double_relative
    tst = Flatfish::Url.absolutify("../../images/test.png", @cd)
    assert_equal("http://soe.stanford.edu/images/test.png", tst)
  end

  def test_absolute
    tst = Flatfish::Url.absolutify("http://soe.stanford.edu/images/test.png", @cd)
    assert_equal("http://soe.stanford.edu/images/test.png", tst)
  end

  def test_broken_root
    tst = Flatfish::Url.absolutify("../../../../images/test.png", @cd)
    assert_equal("http://soe.stanford.edu/images/test.png", tst)
  end

  def test_same_dir
    tst = Flatfish::Url.absolutify("test.png", @cd)
    assert_equal("http://soe.stanford.edu/current_students/chinaprogram/test.png", tst)
  end

end
