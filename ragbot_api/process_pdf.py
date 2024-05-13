import fitz, pathlib, re, os, openai
import pdfplumber
import json
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI 

from langchain_text_splitters import RecursiveCharacterTextSplitter

openai_api_key = os.getenv('OPENAI_API_KEY')

if openai_api_key is None:
    raise ValueError("OPENAI_API_KEY env variable is not set.")

PROMPT_TEMPLATE = '''You are a multiple-choice question generator. You generate a single question based on a scientific text.
If the text has no relevant information to base a question on, return an empty JSON.
The output should be of the following format:

{{
"questionText": ,
"choices": [
    {{
    "choiceId": "a",
    "choiceText":
    }},
    {{
    "choiceId": "b",
    "choiceText":
    }},
    {{
    "choiceId": "c",
    "choiceText":
    }},
],
"correctAnswer" :
}}

Example: 

Input : 
Paris is the capital and most populous city of France. With an official estimated population of 2,102,650 residents as of 1 January 2023 in an area of more than 105 km2, Paris is the fourth-most populated city in the European Union and the 30th most densely populated city in the world in 2022.

Output: 
{{
"questionText": "What is the capital of France?",
"choices": [
    {{
    "choiceId": "a",
    "choiceText": "Paris"
    }},
    {{
    "choiceId": "b",
    "choiceText": "Madrid"
    }},
    {{
    "choiceId": "c",
    "choiceText": "Berlin"
    }},
    {{
    "choiceId": "d",
    "choiceText": "London"
    }}
],
"correctAnswer": "a"
}}

Input: {context}
Output: 
'''

prompt = PromptTemplate.from_template(template=PROMPT_TEMPLATE)

#initialize model
model = ChatOpenAI(
    model='gpt-3.5-turbo',
    openai_api_key = openai_api_key,
    
)

chain = prompt | model

async def process_text(file):

    # Using pdfplumber to open and read PDF file in-memory
    with pdfplumber.open(file.file) as pdf:
        text = ''
        # Extract text from each page
        for page in pdf.pages:
            text += page.extract_text() + "\n"  # Adding a newline character after each page's text

    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size = len(text)/25,
        chunk_overlap = 150,
        length_function = len,
        is_separator_regex=False,
    )

    texts = text_splitter.create_documents([text])
    
    questions = []

    
    # questions.append(json.loads(await get_question(texts[0])))
    c = 0

    for text in texts:
        if(c==5):
            break
        else:
            question = json.loads(await get_question(text))
            print(question)
            questions.append(question)
            c+=1


    questions_json = json.dumps(questions)

    return questions_json

async def get_question(text):
    output = chain.invoke({"context" : text})
    return output.content # return without metadata


# context = "Bitcoin is the first decentralized cryptocurrency. Nodes in the peer-to-peer bitcoin network verify transactions through cryptography and record them in a public distributed ledger, called a blockchain, without central oversight"

# output = chain.invoke({"context" : context})
# json_question = json.loads(output.content)
# print(json_question["questionText"])
# print(output)
# print(len(text))
# print(len(texts))
# for doc in enumerate(texts, start=0):
#     print("\n",doc[1].page_content.encode("utf-8"))

