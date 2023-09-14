FROM python:3.11.5-alpine3.18

RUN apk add texlive texlive-luatex texlive-dvi xdvik texmf-dist-most
RUN apk add ncurses
RUN TERM=linux luaotfload-tool --update --force --log=stdout

WORKDIR /pnrg

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY ./build.sh .

CMD ["sh", "./build.sh"]