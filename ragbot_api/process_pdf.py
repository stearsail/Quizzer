import fitz, pathlib, re, os, openai
import pdfplumber
import json
from operator import itemgetter
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI 
from langchain_core.runnables import RunnableLambda, RunnablePassthrough
from langchain.memory import ConversationBufferWindowMemory
from langchain_text_splitters import RecursiveCharacterTextSplitter

openai_api_key = os.getenv('OPENAI_API_KEY')

if openai_api_key is None:
    raise ValueError("OPENAI_API_KEY env variable is not set.")

STOP_SEQUENCES = ["\nInput: ","\nOutput: "]
PROMPT_TEMPLATE = '''You are a multiple-choice question generator. You generate a single question based on a scientific text.
If the text has no relevant scientific information to base a question on, return an empty JSON.

{history}

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

Input: 
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
# memory = ConversationBufferWindowMemory(human_prefix="Input: ", ai_prefix="Output: ", k=1)

prompt = PromptTemplate.from_template(template=PROMPT_TEMPLATE)

#initialize model
model = ChatOpenAI(
    model='gpt-3.5-turbo',
    openai_api_key = openai_api_key,
    model_kwargs={"stop" : STOP_SEQUENCES}
)

chain = ({
    "context": RunnablePassthrough(),
    "history" : RunnablePassthrough()}
    | prompt | model)

async def determine_questions(file):
    
    # Using pdfplumber to open and read PDF file in-memory
    with pdfplumber.open(file.file) as pdf:
        text = ''
        # Extract text from each page
        for page in pdf.pages:
            text += page.extract_text() + "\n"  # Adding a newline character after each page's text

    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size = int(len(text)/25),
        chunk_overlap = 150,
        length_function = len,
        is_separator_regex=False,
    )

    texts = text_splitter.create_documents([text])
    return texts
    

async def process_text(texts, question_count):
    
    questions = []
    question_history = []
    question_history_string =''

    c = 0
    for text in texts:
        if c == question_count:
            break
        else:
            # print (f"~~~~~~~~~~~~~~~~~PROMPT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n {prompt}")
            # print(f"~~~~~~~~~~~~~~~~~~~~~~~~~MEMORY~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n{question_history_string}" )
            question_string = await get_question(text, question_history_string)
            # print(f"--------------------------------TEXT CONTENT----------------------------------------------\n{text}")
            # print(f"--------------------------------QUESTION--------------------------------------------------\nQuestion {c+1} JSON String: {question_string}")
            try:
                question_json = json.loads(question_string)
                # print(f"____________________________PARSED QUESTION_________________________________________________________ \nParsed Question {c+1}: {question_json} ")
                if not check_json(question_json):
                    continue
                # memory.save_context({"input": text.page_content}, {"output": question_str})
                if(len(question_history)==10):
                    question_history.pop(0)
                question_history.append(question_json['questionText']+"\n")
                questions.append(question_json)
                c += 1
                question_history_string = 'Avoid using the following questions:\n' + ''.join(question_history)
            except (json.JSONDecodeError, UnicodeDecodeError, UnicodeEncodeError) as e:
                # print(f"Error parsing question {c+1}: {e}")
                pass


    questions_json = json.dumps(questions)
    return questions_json

async def get_question(text, question_history_string):
    output = chain.invoke({"context" : text, "history" : question_history_string})
    return output.content # return without metadata

def check_json(jsonObject):        
    if(len(jsonObject) == 0):
        return False
    for _, value in jsonObject.items():
        if not value:
            return False
    return True

