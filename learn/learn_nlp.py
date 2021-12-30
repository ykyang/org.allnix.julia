# Use this to load this file for the first time
#   import learn_nlp
#
# Use the following statements to load/reload this file 
#   import importlib
#   importlib.reload(learn_nlp)

# print('Hello World!')

def learn_simplest_tokenizer(): # 2.3.1
    text = ("Trust me, though, the words were on their way, and when "
            "they arrived, Liesel would hold them in her hands like "
            "the clouds, and she would wring them out, like the rain.")
    tokens = text.split()
    
    #['Trust', 'me,', 'though,', 'the', 'words', 'were', 'on', 'their']
    print(tokens[:8])
    
def learn_rule_based_tokenization():
    import re
    pattern = r'\w+(?:\'\w+)?|[^\w\s]'
    text = ("Trust me, though, the words were on their way, and when "
            "they arrived, Liesel would hold them in her hands like "
            "the clouds, and she would wring them out, like the rain.")
    texts = [text]
    #print(text)
    texts.append("There's no such thing as survival of the fittest. "
                 "Survival of the most adequate, maybe.")
    tokens = list(re.findall(pattern, texts[-1]))
    #print(texts[-1])
    print(tokens[:8])
    print(tokens[8:16])
    print(tokens[16:])
    print("token size = {}".format(len(tokens)))

    import numpy as np
    vocab = sorted(set(tokens))
    print("vocab size = {}".format(len(vocab)))
    print(' '.join(vocab))

def learn_spacy(): # 2.3.3
    import spacy

    text = ("Trust me, though, the words were on their way, and when "
            "they arrived, Liesel would hold them in her hands like "
            "the clouds, and she would wring them out, like the rain.")
    texts = [text]
    texts.append("There's no such thing as survival of the fittest. "
                 "Survival of the most adequate, maybe.")


    #spacy.cli.download('en_core_web_sm')
    nlp = spacy.load('en_core_web_sm')
    doc = nlp(texts[-1])
    #print(type(doc))
    tokens = [tok.text for tok in doc]
    print(tokens)

    from spacy import displacy
    #print(type(doc.sents)) # generator
    sentence = list(doc.sents)[0]
    #displacy.serve(sentence, style='dep')
    #!firefox 127.0.0.1:5000

# Outside the function so completion would work
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer

def learn_clumping_characters(): # 2.4.1    
    vectorizer = CountVectorizer(ngram_range=(1,2), analyzer='char')





#learn_simplest_tokenizer()
#learn_rule_based_tokenization()
#learn_spacy()
learn_clumping_characters()
