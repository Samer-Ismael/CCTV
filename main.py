import cv2
from flask import Flask, Response, render_template_string

app = Flask(__name__)

def generate_frames(camera_index=0):
    """
    Generator function that captures frames from the specified camera index
    and yields them as JPEG-encoded byte streams.
    
    :param camera_index: Index of the camera to capture from (default is 0)
    :return: Yields byte streams of JPEG-encoded frames
    """
    camera = cv2.VideoCapture(camera_index)

    if not camera.isOpened():
        raise RuntimeError(f"Could not start camera with index {camera_index}")

    while True:
        success, frame = camera.read()
        if not success:
            break

        ret, buffer = cv2.imencode('.jpg', frame)
        if not ret:
            break

        frame_bytes = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

    camera.release()

@app.route('/')
def index():
    """
    Home page route. Displays the video feed.
    """
    return render_template_string('''
        <!doctype html>
        <html lang="en">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
          </head>
          <body>
            <img src="{{ url_for('video_feed') }}" width="640" height="480">
          </body>
        </html>
    ''')

@app.route('/camera')
def video_feed():
    """
    Video streaming route. Put this in the src attribute of an img tag.
    """
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)