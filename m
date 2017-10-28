Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 28 Oct 2017 21:50:35 +0100
Message-ID: <CALjAwxgm+_X0iVkZaPPGiVhu1MRMV0D4__yuvZ+=nY_cGgxvVg@mail.gmail.com>
Subject: http://git.kernel.dk/?p=fio.git;a=summary returns 500 error
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Over in http://www.bbc.co.uk/blogs/internet/entries/ce3eff16-228f-49a0-8d4e-d1a013e4895f
which is a blog on the BBC website the author tries to link to
http://git.kernel.dk/?p=fio.git;a=summary but the page is returning
this:

500 - Internal Server Error
________________________________
Insecure $ENV{PATH} while running setuid at
/usr/share/gitweb/index.cgi line 775.

This link to fio is also popular among packages - see
https://repology.org/metapackage/fio/packages .

-- 
Sitsofe | http://sucs.org/~sits/

