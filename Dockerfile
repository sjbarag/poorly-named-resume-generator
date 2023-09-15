FROM python:3.11.5-alpine3.18

RUN apk add texlive texlive-luatex texlive-dvi xdvik texmf-dist-most ncurses make
RUN TERM=linux luaotfload-tool --update --force --log=stdout

WORKDIR /pnrg

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY Makefile .

CMD ["make"]