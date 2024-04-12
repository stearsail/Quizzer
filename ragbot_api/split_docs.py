import fitz, pathlib, re, os, openai
from langchain_text_splitters import RecursiveCharacterTextSplitter

# openai_api_key = os.getenv('OPENAI_API_KEY')

# if openai_api_key is None:
#     raise ValueError("OPENAI_API_KEY env variable is not set.")


def extract_text(pdf_path):
    with fitz.open(pdf_path) as doc:
        text = "\n".join(page.get_text() for page in doc)
    return text

text = extract_text('ragbot_api/pdf_documents/bitcoin.pdf')

with open('ragbot_api/pdf_documents/output.txt', 'w', encoding='utf-8') as f:
    f.write(text)

with open('ragbot_api/pdf_documents/output.txt', 'r', encoding='utf-8') as f:
    document = f.read()


text_splitter = RecursiveCharacterTextSplitter(
    chunk_size = len(text)/25,
    chunk_overlap = 150,
    length_function = len,
    is_separator_regex=False,
)

texts = text_splitter.create_documents([document])

print(len(text))
print(len(texts))
for doc in enumerate(texts, start=0):
    print("\n",doc[1].page_content.encode("utf-8"))

# def identify_chapters(text):
#     pattern = re.compile(r'(?m)^(?:(\d+(?:\.\d+)*)\s*(.*?))?\n(.*?)(?=\n\d+(?:\.\d+)*|$)')

#     for i, match in enumerate(pattern.finditer(text), start = 1):
#         section_number, title, content = match.groups()
#         title = title.strip() if title else f"Section{section_number}"
#         filename = f"ragbot_api/pdf_documents/section_{i}_{title}.txt"

#         with open(filename, 'w', encoding='utf-8') as file:
#             if title:
#                 file.write(f"{section_number} {title}\n\n")
#             file.write(content.strip())


# chapters = identify_chapters(text)

