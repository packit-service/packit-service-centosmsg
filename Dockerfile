FROM fedora:32

ENV LANG=en_US.UTF-8 \
    ANSIBLE_STDOUT_CALLBACK=debug \
    USER=packit \
    HOME=/home/packit \
    CA_CERTS=/secrets/centos-server-ca.cert \
    CERTFILE=/secrets/centos.cert

RUN dnf install -y ansible python3-pip

COPY files/install-deps.yaml /src/files/
RUN cd /src/ \
    && ansible-playbook -vv -c local -i localhost, files/install-deps.yaml \
    && dnf clean all

COPY setup.py setup.cfg files/recipe.yaml /src/

COPY .git /src/.git
COPY packit_service_centosmsg /src/packit_service_centosmsg/

RUN cd /src/ \
    && ansible-playbook -vv -c local -i localhost, recipe.yaml \
    && rm -rf /src/

CMD ["listen-to-centos-messaging"]
