# Use this to load this file for the first time
#   import learn_nlp
#
# Use the following statements to load/reload this file 
#   import importlib
#   importlib.reload(learn_nlp)

# print('Hello World!')

from os.path import join

def write_table(df, filename):
    f = open(filename, 'w')
    n = f.write(df.to_string())
    f.close()

    return n


def learn_simplest_tokenizer(texts): # 2.3.1
    text = texts[0]
    tokens = text.split()
    
    #['Trust', 'me,', 'though,', 'the', 'words', 'were', 'on', 'their']
    print(tokens[:8])
    
import re
import numpy as np

def learn_rule_based_tokenization(texts): # 2.3.2
    
    pattern = r'\w+(?:\'\w+)?|[^\w\s]'
    # text = ("Trust me, though, the words were on their way, and when "
    #         "they arrived, Liesel would hold them in her hands like "
    #         "the clouds, and she would wring them out, like the rain.")
    # texts = [text]
    # #print(text)
    # texts.append("There's no such thing as survival of the fittest. "
    #  "Survival of the most adequate, maybe.")
    tokens = list(re.findall(pattern, texts[1]))
    #print(texts[1])
    print(tokens[:8])
    print(tokens[8:16])
    print(tokens[16:])
    print("token size = {}".format(len(tokens)))

    
    vocab = sorted(set(tokens))
    print("vocab size = {}".format(len(vocab)))
    print(' '.join(vocab))

import spacy

def learn_spacy(texts): # 2.3.3
    #spacy.cli.download('en_core_web_sm') # Only need to run once?
    nlp = spacy.load('en_core_web_sm')
    doc = nlp(texts[1])
    #print(type(doc))
    tokens = [tok.text for tok in doc]
    #print(tokens)

    #from spacy import displacy
    #print(type(doc.sents)) # generator
    #sentence = list(doc.sents)[0]
    #displacy.serve(sentence, style='dep')
    #!firefox 127.0.0.1:5000

    return tokens


## 2.4 Wordpiece tokenizers

# Outside the function so completion would work
import scipy
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
#from tabulate import tabulate

def learn_clumping_characters(texts): # 2.4.1    
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

    write_table(df, join('output', 'clumping_characters.txt'))    

    return df

## 2.5 Vectors of tokens

## 2.5.1 One-hot Vectors
def learn_one_hot_vectors(texts):
    pattern = r'\w+(?:\'\w+)?|[^\w\s]'
    tokens = list(re.findall(pattern, texts[1]))
    vocab = sorted(set(tokens))
    #vocab_size = len(vocab)
    
    onehot_vectors = np.zeros((len(tokens),len(vocab)), int)
    for i,word in enumerate(tokens):
        onehot_vectors[i, vocab.index(word)] = 1
    

    df_onehot = pd.DataFrame(onehot_vectors, columns=vocab)
    # df_one_hot.shape = (18, 15)
    #print('df_one_hot.shape = {}'.format(df_onehot.shape))
    write_table(df_onehot.iloc[:,:8].replace(0, ''), join('output', 'one_hot_vectors.txt'))


## 2.5.2 BOW (Bag-of-Words) Vectors
def learn_bag_of_words(texts):
    pattern = r'\w+(?:\'\w+)?|[^\w\s]'
    text = texts[0]
    bow = sorted(set(re.findall(pattern, text)))
    print(bow[:9])
    print(bow[9:19])
    print(bow[19:27])

## 2.5.3 Dot product
def learn_dot_product(texts):
    # Dot product
    v1 = np.array([1,2,3])
    v2 = np.array([2,3,4])

    Ans = v1.dot(v2)
    #print(Ans) # 20

    Ans = v1 * v2
    #print(Ans) # [ 2  6 12]
    #print(Ans.sum()) # 20

    # PennTreebank tokenizer
    from nltk.tokenize import TreebankWordTokenizer
    tokenizer = TreebankWordTokenizer()
    print(texts[2])
    tokens = tokenizer.tokenize(texts[2])
    print(tokens[:8])
    print(tokens[8:16])
    print(tokens[16:])

## 2.6 Challenging tokens
def learn_challenging_tokens(text):
    import jieba
    seg_list = jieba.cut(text, cut_all=True)
    print('Full Mode: ' + '/'.join(seg_list))
    seg_list = jieba.cut(text)
    print('Accurate Mode: ' + '/'.join(seg_list))
    seg_list = jieba.cut_for_search(text)
    print('Search Engine Mode: ', '/'.join(seg_list))

    from jieba import posseg
    words = posseg.cut(text)
    # jieba.enable_paddle()
    # words = posseg.cut(text, use_paddle=True)
    # for word,flag in words:
    #     print(f'{word<5} {flag}')
    
    # paddlepaddle does not support Python-3.8
    # Use spaCy instead
    #spacy.cli.download("zh_core_web_sm")
    nlp = spacy.load("zh_core_web_sm")
    doc = nlp(text)
    for token in doc:
        print(token.text, token.pos_)

    

texts = [] # Store 2 strings
texts.append(
    "Trust me, though, the words were on their way, and when "
    "they arrived, Liesel would hold them in her hands like "
    "the clouds, and she would wring them out, like the rain."
)
texts.append(
    "There's no such thing as survival of the fittest. "
    "Survival of the most adequate, maybe."
)


# learn_simplest_tokenizer(texts)
# learn_rule_based_tokenization(texts)
# learn_spacy(texts)
# df = learn_clumping_characters(texts)
# learn_one_hot_vectors(texts)
# write_table(df, join('output', 'clumping_characters.txt'))
# learn_bag_of_words(texts)

texts.append(
"""
If conscience and empathy were impediments to the advancement of
self-interest, then we would have evolved to be amoral sociopaths.
"""    
)

#learn_dot_product(texts)
text = "西安是一座举世闻名的文化古城"
text = "西安是一座舉世聞名的文化古城"
learn_challenging_tokens(text)


#print(df.style)
