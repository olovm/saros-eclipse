FROM fedora:37
# Set a useful default locale
RUN echo "export LANG=en_US.UTF-8" > /opt/export_LANG.sh
RUN echo "export LANGUAGE=en_US.UTF-8" >> /opt/export_LANG.sh
RUN echo "export LC_ALL=en_US.UTF-8" >> /opt/export_LANG.sh
ENV BASH_ENV=/opt/export_LANG.sh \
    ENV=/opt/export_LANG.sh \
    PROMPT_COMMAND="source /opt/export_LANG.sh"
    
# Set the locale
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8
#ENV LC_CTYPE en_US.UTF-8
#ENV LANGUAGE en_US.UTF-8
#RUN localedef -f UTF-8 -i en_US en_US.UTF-8
#RUN localedef --verbose --force -i en_US -f en_US.UTF-8
#RUN locale
#RUN localedef -v -c -i en_US -f en_US.UTF-8 || true

ARG user
ARG userid
ARG dockergroupid

RUN groupadd -r docker -g$dockergroupid && useradd -d "/home/$user" -u $userid -U -G docker -m -s /bin/bash $user

RUN dnf clean all && \
  dnf install \
  glibc-langpack-en \
  google-noto-sans-runic* \
  google-noto-sans-math-fonts \
  google-noto-sans-arabic* \
  firefox \
  webkit2gtk3 \
  wget \
  telnet \
  nano \
  lsof \
  tar \
  unzip \
  less \
  htop \
  docker \
  java-11-openjdk java-11-openjdk-devel \
  java-17-openjdk java-17-openjdk-devel \
  java-latest-openjdk java-latest-openjdk-devel \ 
  java-latest-openjdk-javadoc java-latest-openjdk-javadoc-zip \
  java-latest-openjdk-src \
  postgresql \
  maven \
  git \ 
  nodejs \
  bindfs \
  fuse \
  npm -y && \
  dnf clean all
  
RUN wget -O - https://ftp.acc.umu.se/mirror/eclipse.org/oomph/epp/2022-06/R/eclipse-inst-linux64.tar.gz | tar zxf - -C /home/$user

COPY ./entrypoint.sh /home/$user/
RUN chmod a+x /home/$user/entrypoint.sh

RUN touch /home/$user/.gitconfig

RUN chown $user:$user /home/$user -R

RUN wget -O - https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.17%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.17_8.tar.gz  | tar zxf - -C /opt/
RUN wget -q -O tmp.zip https://services.gradle.org/distributions/gradle-7.5.1-bin.zip && unzip tmp.zip -d /opt/ && rm tmp.zip -f
#ENV PATH="${PATH}:/opt/gradle-7.5.1/bin"
RUN wget -q -O tmp.zip https://services.gradle.org/distributions/gradle-6.5.1-bin.zip && unzip tmp.zip -d /opt/ && rm tmp.zip -f
ENV PATH="${PATH}:/opt/gradle-6.5.1/bin"
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk/bin/java 4
RUN alternatives --set java /usr/lib/jvm/java-11-openjdk/bin/java

RUN chown $user:$user /opt/ -R

RUN npm install -g karma-cli

USER $user

CMD  /home/$user/entrypoint.sh
