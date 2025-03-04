#!/usr/bin/python -u
import argparse
import json
import os
import sys

import requests

open_router_api_key = os.environ.get("OPEN_ROUTER_API_KEY")
if open_router_api_key is None:
    print("Open router api not provided. export OPEN_ROUTER_API_KEY=your_key")
    exit(0)


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
    question_prefix = "you are the assistant of a senior backend developer. Be concise please, unless told otherwise. "
    headers = {
        "Authorization": f"Bearer {open_router_api_key}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": question_prefix + question}],
        "stream": True,
    }
    buffer = ""
    with requests.post(url, headers=headers, json=payload, stream=True) as r:
        for chunk in r.iter_content(chunk_size=1024, decode_unicode=True):
            buffer += chunk
            while True:
                try:
                    # Find the next complete SSE line
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
                        except json.JSONDecodeError:
                            pass
                except Exception:
                    break


def parse_arguments():
    parser = argparse.ArgumentParser()
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
        help="file containing a question",
        default=os.path.expandvars("${HOME}/.config/ai-cli/question.txt"),
    )
    args = parser.parse_args()
    return args


def read_question(file: str) -> str:
    with open(file, "r") as f:
        question = f.read()
    return question


if __name__ == "__main__":
    args = parse_arguments()
    file = args.file
    print(f"file: {file}")
    question = args.question
    if question is None:
        question = read_question(file)
    model = args.model
    model = select_model(model)
    print(f"Model: {model}")
    print(f"Question: {question}")
    print("Response:")
    ai_cli(question, model)
    print()
