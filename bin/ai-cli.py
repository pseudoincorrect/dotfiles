#!/usr/bin/python -u
import argparse
import json
import os
import subprocess
import tempfile

import requests

open_router_api_key = os.environ.get("OPEN_ROUTER_API_KEY")
if open_router_api_key is None:
    print("Open router api not provided. export OPEN_ROUTER_API_KEY=your_key")
    exit(0)


def get_config_path():
    path = os.path.expandvars("$HOME/.config/aicli")
    if not os.path.exists(path):
        os.makedirs(path)
    return path


def select_model(model: str) -> str:
    if model == "claude":
        return "anthropic/claude-3.7-sonnet:beta"
    if model == "openai":
        return "openai/gpt-4o"
    if model == "codestral":
        return "mistralai/codestral-2501"
    return model


def ai_cli(question: str, model: str):
    url = "https://openrouter.ai/api/v1/chat/completions"
    attitude = "you are the assistant of a senior backend developer. Be concise please, unless told otherwise. "
    headers = {
        "Authorization": f"Bearer {open_router_api_key}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": model,
        "messages": [
            {"role": "user", "content": attitude},
            {"role": "user", "content": question},
        ],
        "stream": True,
    }
    buffer = ""
    response = ""
    with requests.post(url, headers=headers, json=payload, stream=True) as r:
        for chunk in r.iter_content(chunk_size=1024, decode_unicode=True):
            buffer += chunk
            while True:
                try:
                    line_end = buffer.find("\n")
                    if line_end == -1:
                        break
                    line = buffer[:line_end].strip()
                    buffer = buffer[line_end + 1 :]
                    if line.startswith("data: "):
                        data = line[6:]
                        if data == "[DONE]":
                            break
                        try:
                            data_obj = json.loads(data)
                            content = data_obj["choices"][0]["delta"].get("content")
                            if content:
                                print(content, end="", flush=True)
                                response += content
                        except json.JSONDecodeError:
                            pass
                except Exception:
                    break
    return response


def parse_arguments():
    parser = argparse.ArgumentParser(
        """aicli --model "openai" --question "what is the meaning of life ?"
       aicli --file "path_to_a_file_with_a_question_within"
       aicli --editor


       aicli is a command line interface to interact with your chosen AI assistant.
       (currently only a single history is supported)
        """
    )
    parser.add_argument(
        "-m",
        "--model",
        help="AI assistant model: claude, openai, codestral, or the real name gotten from open-router",
        default="claude",
    )
    parser.add_argument("-q", "--question", help="question to as to the AI assistant")
    parser.add_argument(
        "-f",
        "--file",
        help="read a question from a file",
        default=f"{get_config_path()}/question.txt",
    )
    parser.add_argument(
        "-e", "--editor", action="store_true", help="open $EDITOR to enter a question"
    )
    parser.add_argument(
        "-hc",
        "--history-clean",
        action="store_true",
        help="clean history of previous message (conversation context) return without asking question to the llm even if question is provided",
    )
    parser.add_argument(
        "-hn",
        "--history-no",
        action="store_true",
        help="ask a question to the llm without the history of the previous messages",
    )
    parser.add_argument(
        "-hp",
        "--history-print",
        action="store_true",
        help="print the conversation history",
    )
    args = parser.parse_args()
    return args


def read_question_from_file(file: str) -> str:
    if not os.path.exists(file):
        print(
            f"file {file} does not exitst. create it and write your question into it first."
        )
        exit(0)
    with open(file, "r") as f:
        question = f.read()
    return question


def read_question_from_editor() -> str:
    editor = os.environ.get("EDITOR")
    if not editor:
        if os.name == "nt":
            editor = "notepad.exe"
        else:
            editor = "vi"
    with tempfile.NamedTemporaryFile(
        suffix=".txt", delete=False, mode="w+"
    ) as temp_file:
        temp_filename = temp_file.name
        try:
            subprocess.run([editor, temp_filename], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error launching editor: {e}")
            return ""
        temp_file.close()
        try:
            with open(temp_filename, "r") as f:
                edited_text = f.read()
        except IOError as e:
            print(f"Error reading temp file after close: {e}")
            return ""
        try:
            os.remove(temp_filename)
        except OSError as e:
            print(f"Error deleting temporary file: {e}")
        return edited_text


def choose_question(argument, file, editor) -> str:
    if argument:
        return argument
    if editor:
        return read_question_from_editor()
    if file:
        return read_question_from_file(file)
    print("no question provided, use -q, -f or -e")
    exit(0)


def get_history_path():
    pass


def history_print():
    pass


if __name__ == "__main__":
    args = parse_arguments()
    question = choose_question(args.question, args.file, args.editor)
    model = args.model
    model = select_model(model)
    print(f"Model: {model}")
    print(f"Question: {question}")
    print("Response:")
    response = ai_cli(question, model)
    print()
