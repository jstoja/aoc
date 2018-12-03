require_relative 'lib/aoc'

require "minitest/autorun"

class TestCaptcha1 < Minitest::Test
  def test_1
    assert_equal 3, solve_captcha("1122")
  end
  def test_2
    assert_equal 4, solve_captcha("1111")
  end
  def test_3
    assert_equal 0, solve_captcha("1234")
  end
  def test_4
    assert_equal 9, solve_captcha("91212129")
  end
end

class TestCaptchaHelpers < Minitest::Test
  def test_circular_peek1
    assert_equal 2, circular_peek(1, 1, "1212")
  end
  def test_circular_peek2
    assert_equal 1, circular_peek(1, 4, "1212")
  end
  def test_circular_peek3
    assert_equal 1, circular_peek(2, 3, "1212")
  end
end

class TestCaptcha2 < Minitest::Test
  def test_1
    assert_equal 6, solve_captcha2("1212")
  end
  def test_2
    assert_equal 0, solve_captcha2("1221")
  end
  def test_3
    assert_equal 4, solve_captcha2("123425")
  end
  def test_4
    assert_equal 12, solve_captcha2("123123")
  end
  def test_5
    assert_equal 4, solve_captcha2("12131415")
  end
end
