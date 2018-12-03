def circular_peek(step, position, captcha)
  captcha[(position+step)%captcha.length-1].to_i
end

def solve_captcha_num(step, captcha)
  captcha.length.times.inject 0 do |acc, i|
    match = captcha[i].to_i.eql? circular_peek(step, i+1, captcha)
    acc + (match ? (captcha[i].to_i):0)
  end
end

def solve_captcha(captcha)
  solve_captcha_num 1, captcha
end

def solve_captcha2(captcha)
  solve_captcha_num (captcha.length/2), captcha
end
