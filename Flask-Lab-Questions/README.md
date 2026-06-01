# Cyber Range Workstation Assessment

## Overview

This project is a Flask-based cyber range assessment platform designed to evaluate a student's ability to gather information from a Windows workstation.

Students are presented with a series of workstation-related questions and must use built-in Windows tools such as Command Prompt, PowerShell, and system utilities to discover the answers.

Examples include:

* Determining the workstation hostname
* Identifying the logged-in user
* Finding the system IP address
* Identifying Active Directory domain membership
* Viewing operating system information
* Gathering network configuration details

The application is designed for classroom, training, and cyber range environments.

---

## Features

* Flask web interface
* Windows workstation-focused questions
* Configurable question bank
* One attempt per question
* Automatic progression through the lab
* Student scoring
* Completion page with final score
* Score logging to a local file
* Simple deployment on Linux or Windows

---

## Project Structure

```text
workstation-lab/
│
├── app.py
├── questions.py
├── requirements.txt
├── scores.log
│
├── templates/
│   ├── index.html
│   ├── feedback.html
│   └── complete.html
│
└── static/
    └── style.css
```

---

## Question Configuration

Questions are stored in:

```python
questions.py
```

Example:

```python
QUESTIONS = [
    {
        "id": 1,
        "question": "What is the hostname of the workstation you are using?",
        "hint": "Run: hostname",
        "answer": "WS-001"
    }
]
```

Answers are intentionally hardcoded to support controlled cyber range scenarios.

---

## Scoring

Each question receives a single submission attempt.

### Correct Answer

* Score increases by 1 point
* Student advances to next question

### Incorrect Answer

* No points awarded
* Student advances to next question

No retries are allowed.

---

## Score Logging

Upon completion, results are written to:

```text
scores.log
```

Example:

```text
2026-06-01 15:42:10 | Student: Unknown | Score: 8/10
```

This provides a simple audit trail for instructors.

---

## Installation

### Clone Repository <- Still in brainstorm mode

```bash
This is brainstorming
```

### Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

---

## Running the Application

```bash
python app.py
```

The application will start on:

```text
http://localhost:5000
```

Or from another workstation:

```text
http://SERVER-IP:5000
```

---

## Deployment Notes

This application was designed for use in cyber range and lab environments.

Recommended production deployment:

* Ubuntu Server
* Python Virtual Environment
* Gunicorn
* Nginx Reverse Proxy
* Systemd Service

---

## Future Enhancements

Potential future features include:

* Student login page
* SQLite score database
* Instructor dashboard
* Multiple assessment categories
* Randomized question order
* Time limits
* Flag-based scoring
* Exportable reports
* Active Directory integration
* Leaderboards

---

## Intended Use

This project is intended for:

* Cybersecurity training
* Workforce development programs
* Classroom instruction
* Cyber ranges
* Technical assessments
* Workstation enumeration exercises

The goal is to provide students with hands-on experience gathering information from enterprise Windows workstations using common administrative and investigative techniques.
