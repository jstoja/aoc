require 'pp'

def passphrase_valid(passphrase)
	spl = passphrase.split(' ')
	spl.uniq.size == spl.size
end

def passphrases_valid_count(passphrases)
	passphrases.split("\n").map {|p| passphrase_valid(p) }.count(true)
end
