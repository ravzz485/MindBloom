import pandas as pd
import re
import nltk
from nltk.corpus import stopwords

nltk.download('stopwords')

df = pd.read_csv('../datasets/mental_health.csv')

stop_words = set(stopwords.words('english'))

def clean_text(text):
    text = str(text).lower()
    text = re.sub(r'[^a-z\s]', '', text)
    words = text.split()
    words = [w for w in words if w not in stop_words]
    return ' '.join(words)

df['cleaned_text'] = df['text'].apply(clean_text)
df = df.dropna(subset=['cleaned_text', 'label'])

print(df[['text', 'cleaned_text', 'label']].head())
print("Total rows after cleaning:", len(df))

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split

vectorizer = TfidfVectorizer(max_features=5000)
X = vectorizer.fit_transform(df['cleaned_text'])
y = df['label']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

print("Training samples:", X_train.shape[0])
print("Testing samples:", X_test.shape[0])

from sklearn.linear_model import LogisticRegression

model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

print("Model training complete!")

from sklearn.metrics import accuracy_score, classification_report

y_pred = model.predict(X_test)
print("Accuracy:", accuracy_score(y_test, y_pred))
print(classification_report(y_test, y_pred))

import joblib

joblib.dump(model, '../models/mental_health_model.pkl')
joblib.dump(vectorizer, '../models/tfidf_vectorizer.pkl')

print("Model and vectorizer saved successfully!")