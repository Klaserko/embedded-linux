from http.server import SimpleHTTPRequestHandler, HTTPServer
import logging
import os

class MyRequestHandler(SimpleHTTPRequestHandler):

    def do_GET(self):
        try:
            drone_id = self.headers["User"]
            if drone_id is None:
                return
            # Call the parent class method to handle the GET request
            super().do_GET()
            # Log when download completes
            print(f"Download completed: {self.path} Username: {drone_id}")
            # Annotate the downloaded file with seconds epoch and the drone id
            if ".json" in self.path:
                os.system(f'/home/emli/camera_scripts/marked_downloaded.sh "{self.path}" {drone_id}')
        except ConnectionResetError as e:
            pass

def run_server(port=8080, directory='.'):
    logging.basicConfig(filename='downloads.log', level=logging.INFO)
    server_address = ('', port)
    os.chdir(directory)
    httpd = HTTPServer(server_address, MyRequestHandler)
    print(f"Server started on port {port}")
    httpd.serve_forever()

if __name__ == '__main__':
    run_server(directory='/home/emli/photos/')
