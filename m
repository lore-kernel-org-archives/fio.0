Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Feb 2018 16:44:35 +0000
Message-ID: <CALjAwxj5ebGHWjDs5gOK+YXHSVa+4UCFQi-UGyygNn8W3YgeuA@mail.gmail.com>
Subject: zlib in Windows fio builds
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bluestop.org>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

I've noticed that cygwin/mingw actually package up a static zlib in
the form of mingw64-x86_64-zlib / mingw64-i686-zlib . Given this, can
we adjust the install instructions to suggest users grab those
packages and remove the custom zlib/contrib searching in the configure
script?

-- 
Sitsofe | http://sucs.org/~sits/

