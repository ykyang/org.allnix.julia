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
    
import re
import numpy as np

def learn_rule_based_tokenization():
    
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

    
    vocab = sorted(set(tokens))
    print("vocab size = {}".format(len(vocab)))
    print(' '.join(vocab))

import spacy

def learn_spacy(): # 2.3.3
    

    text = ("Trust me, though, the words were on their way, and when "
            "they arrived, Liesel would hold them in her hands like "
            "the clouds, and she would wring them out, like the rain.")
    texts = [text]
    texts.append("There's no such thing as survival of the fittest. "
                 "Survival of the most adequate, maybe.")


    #spacy.cli.download('en_core_web_sm') # Only need to run once?
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
import scipy
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from tabulate import tabulate

def learn_clumping_characters(): # 2.4.1    
    texts = [] # Store 2 strings
    texts.append("Trust me, though, the words were on their way, and when "
            "they arrived, Liesel would hold them in her hands like "
            "the clouds, and she would wring them out, like the rain.")
    texts.append("There's no such thing as survival of the fittest. "
                 "Survival of the most adequate, maybe.")
    assert len(texts) == 2

    vectorizer = CountVectorizer(
        #ngram_range=(1,1), # for 1-gram
        ngram_range=(1,2),
        analyzer='char'
    )
    vectorizer.fit(texts)
    # Vocabularies from 2 stings
    vocab = vectorizer.get_feature_names_out()
    assert len(vocab) == 148
    #print(vocab)

    vectors = vectorizer.transform(texts)
    assert isinstance(vectors, scipy.sparse.csr.csr_matrix)
    assert vectors.shape == (2,148) # 1 row for each string
    
    # Show vocab in df
    # Show sum of total occurance
    df = pd.DataFrame(vectors.todense(), columns=vocab)
    #print(df)
    # Change index column to the first 8-char of the strings
    df.index = [t[:8] + '...' for t in texts]
    #print(df)
    df = df.T # transpose
    #print(df)
    df['total'] = df.T.sum() # total vocab from 2 strings
    #print(df)
    #print(df.sort_values('total').tail())

    # Show 2-gram only
    # Create a column that is the number of gram
    df['n'] = [len(token) for token in vocab]
    # Filter by > 1-gram
    #print(df[df['n']>1].sort_values('total').tail())


    return df





#learn_simplest_tokenizer()
#learn_rule_based_tokenization()
#learn_spacy()
df = learn_clumping_characters()
#print(df.style)
