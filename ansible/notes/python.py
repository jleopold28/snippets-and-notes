def firstRepeatedWord(s):
    words = s.replace(',',' ').replace(';',' ').replace(':',' ').replace('-',' ').split(' ')
    for word_check in words[::-1]:
        words.remove(word_check)
        for word in words:
            if word == word_check:
                return word
