# PacketTracer container

I had to use Packet Tracer 9.0, but in an RPM environment, the solution was to use containers.

The container uses Ubuntu latest (24.04), xfce graphical environment, and vnc for remote desktop locally (not intended for use over the internet).

## Steps

1. Docker installed on your computer.

2. Install a VNC client, for example [tigervnc](https://tigervnc.org/).

3. Create a directory on the host computer (your computer) with the following structure:

   ```text
   share_directory/
   ├── packettracer
   └── pt
   ```

   The *share_directory* directory can have any name, but the internal directories *packettracer* (contains the EULA and packettracer-related files) and *pt* (contains the packettracer configuration, pkts, session, etc.) must have those names.

   In this directory (*share_directory*), you must place the PacketTracer *.deb* file that you download, because you will need to install it in the container.

4. Clone this project and change to the path of the downloaded project.

5. In the project directory, you must create a file named `.env`, which should only contain **`SHARE_DIRECTORY=/fullpath/to/share_directory`**.

6. Run the docker commands and wait for the process to finish:

   ```bash
   sudo docker build -t pt9:1.0 -f Dockerfile .
   sudo docker compose -f run.yml -p pt9 up -d
   ```

   You can change *pt9*, *pt9:1.0* to whatever you want.

7. Once it finishes without any problems, you can connect to the container using a VNC client with:

   * Ubuntu container: `127.0.0.1:5901`
   * User: `ubuntu`
   * Password: `ubuntu`

8. Once you are on the remote desktop, go to the shared directory and install PacketTracer using `sudo apt install -y ./PACKETTRACER.deb`.

   Once installed, run the Packet Tracer shortcut from the desktop.
