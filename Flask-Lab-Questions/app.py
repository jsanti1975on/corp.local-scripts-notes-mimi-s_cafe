from flask import Flask, render_template, request, session, redirect, url_for
from questions import QUESTIONS
from datetime import datetime

app = Flask(__name__)
app.secret_key = "CyberRangeSecretKey"

LOG_FILE = "scores.log"


def log_score():
    student_name = session.get("student_name", "Unknown")
    score = session.get("score", 0)
    total = len(QUESTIONS)

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    line = (
        f"{timestamp} | "
        f"Student: {student_name} | "
        f"Score: {score}/{total}\n"
    )

    with open(LOG_FILE, "a", encoding="utf-8") as file:
        file.write(line)


@app.route("/", methods=["GET", "POST"])
def index():

    if "current_question" not in session:
        session["current_question"] = 0
        session["score"] = 0
        session["score_logged"] = False

    current = session["current_question"]

    if current >= len(QUESTIONS):

        if not session.get("score_logged"):
            log_score()
            session["score_logged"] = True

        return redirect(url_for("complete"))

    question = QUESTIONS[current]

    result = None

    if request.method == "POST":

        answer = request.form.get(
            "answer",
            ""
        ).strip().lower()

        correct_answer = question["answer"].strip().lower()

        if answer == correct_answer:

            session["score"] += 1
            session["feedback"] = "Correct!"

        else:

            session["feedback"] = "Sorry, Incorrect"

        session["current_question"] += 1

        return redirect(url_for("feedback"))

    progress = int(
        (current / len(QUESTIONS)) * 100
    )

    return render_template(
        "index.html",
        question=question,
        result=result,
        progress=progress,
        current=current + 1,
        total=len(QUESTIONS)
    )


@app.route("/feedback")
def feedback():

    message = session.get(
        "feedback",
        "Answer Submitted"
    )

    return render_template(
        "feedback.html",
        message=message
    )


@app.route("/complete")
def complete():

    score = session.get("score", 0)

    return render_template(
        "complete.html",
        score=score,
        total=len(QUESTIONS)
    )


@app.route("/reset")
def reset():

    session.clear()

    return redirect(url_for("index"))


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )
