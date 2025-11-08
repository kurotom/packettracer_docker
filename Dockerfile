FROM ubuntu:latest

ENV CURRENT_USER=ubuntu

# update and dependencies
RUN apt-get update \
	&& apt-get install -y xfce4 \
		xfce4-goodies \
		tightvncserver \
		tigervnc-standalone-server \
		tigervnc-common \
		dbus-x11 \
		sudo \
		less \
		wget \
		libxkbcommon-x11-0 \
		libxcb-xinerama0 \
		libxcb-cursor0 \
		libglu1-mesa \
		libnss3 \
		libasound2t64 \
		libpulse0

RUN echo "$CURRENT_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# gets firefox 64 en-US
RUN wget -O firefox.tar.xz "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" \
	&& tar xJf firefox.tar.xz -C /opt/ \
	&& ln -s /opt/firefox/firefox /usr/local/bin/firefox \
	&& rm firefox.tar.xz

# sets default firefox
RUN update-alternatives --install /usr/bin/x-www-browser x-www-browser /opt/firefox/firefox 100

RUN mkdir -p /home/$CURRENT_USER/.vnc /home/$CURRENT_USER/Desktop/packettracer

RUN mkdir -p /home/$CURRENT_USER/.local/share/applications/

RUN echo '[Desktop Entry]\n\
Version=1.0\n\
Name=Cisco Packet Tracer\n\
Comment=Network Simulation Tool\n\
Exec=/opt/pt/packettracer.AppImage\n\
Terminal=false\n\
Type=Application\n\
Categories=Education;Network;\n\
StartupNotify=true\n' > /home/$CURRENT_USER/.local/share/applications/packettracer.desktop \
	&& cp -v /home/$CURRENT_USER/.local/share/applications/packettracer.desktop /home/$CURRENT_USER/Desktop/ \
	&& chmod +x /home/$CURRENT_USER/.local/share/applications/packettracer.desktop /home/$CURRENT_USER/Desktop/ 

RUN echo "#!/bin/bash\nxrdb $HOME/.Xresources\n/usr/bin/startxfce4 &" > /home/$CURRENT_USER/.vnc/xstartup

RUN chmod +x /home/$CURRENT_USER/.vnc/xstartup

RUN echo "$CURRENT_USER" | vncpasswd -f > /home/$CURRENT_USER/.vnc/passwd \
	&& chmod 600 /home/$CURRENT_USER/.vnc/passwd

EXPOSE 5901

RUN chown -R $CURRENT_USER:$CURRENT_USER /home/$CURRENT_USER

# user ubuntu
USER $CURRENT_USER

WORKDIR /home/$CURRENT_USER

CMD ["bash", "-lc", "vncserver :1 -geometry 1366x768 -depth 24 -localhost no -xstartup /usr/bin/startxfce4 && tail -f /dev/null"]

