import fitz, pathlib, re, os, openai
from langchain_text_splitters import RecursiveCharacterTextSplitter

# openai_api_key = os.getenv('OPENAI_API_KEY')

# if openai_api_key is None:
#     raise ValueError("OPENAI_API_KEY env variable is not set.")


# def extract_text(pdf_path):
#     with fitz.open(pdf_path) as doc:
#         text = "\n".join(page.get_text() for page in doc)
#     return text

# text = extract_text('ragbot_api/pdf_documents/bitcoin.pdf')

# with open('ragbot_api/pdf_documents/output.txt', 'w', encoding='utf-8') as f:
#     f.write(text)

# with open('ragbot_api/pdf_documents/output.txt', 'r', encoding='utf-8') as f:
#     document = f.read()


# text_splitter = RecursiveCharacterTextSplitter(
#     chunk_size = len(text)/25,
#     chunk_overlap = 150,
#     length_function = len,
#     is_separator_regex=False,
# )

# texts = text_splitter.create_documents([document])

# print(len(text))
# print(len(texts))
# for doc in enumerate(texts, start=0):
#     print("\n",doc[1].page_content.encode("utf-8"))

