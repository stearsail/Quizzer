# Quizzer - Quiz Generator App
## Description
This project is a mobile application that provides functionality for generating multiple-choice questions based on the content of a PDF file. 
The application leverages a Python backend to utilize advanced natural language processing (NLP) capabilities using the OpenAI GPT-3.5-turbo model and the LangChain framework to generate contextually accurate questions.

## Features
Flutter framework: The frontend of the application is built using Flutter framework. This provides an intuitive user interface for uploading PDFs and retrieving generated questions in multiple-choice format.
FastAPI: The Flutter app communicates with the Python backend using FastAPI endpoints. These endpoints handle the text extraction and question generation processes, ensuring seamless data retrieval from the model.

## Usage example
### Uploading a PDF file:
![Upload PDF](https://github.com/stearsail/Quizzer/blob/main/ragbot_app/readme_gifs/upload_file.gif)

### Selecting a number of questions for the quiz to be generated:
![Select number of questions](https://github.com/stearsail/Quizzer/blob/main/ragbot_app/readme_gifs/select_nr_questions.gif)

### Solve the generated quiz:
<img src="https://github.com/stearsail/Quizzer/blob/main/ragbot_app/readme_gifs/answer_questions.gif" width="250" height="250"/>

### View results:
![View results](https://github.com/stearsail/Quizzer/blob/main/ragbot_app/readme_gifs/view_quiz.gif)
