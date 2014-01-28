Return-Path: <grundler@google.com>
MIME-Version: 1.0
Date: Tue, 28 Jan 2014 11:10:51 -0800
Message-ID: <CANEJEGu_qW7rBB75B-Xppy8X-_=+dy951H7DeJ+9phJ4L=LVWg@mail.gmail.com>
Subject: rand_seed declarations not consistent...is that ok?
From: Grant Grundler <grundler@google.com>
Content-Type: text/plain; charset=UTF-8
To: FIO_list <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

cscope tells me:
C symbol: rand_seed

  File             Function                  Line
0 ioengine.h       <global>                    59 unsigned long rand_seed;
1 options.c        <global>                  1660 .off1 =
                                                  td_var_offset(rand_seed),
2 thread_options.h <global>                   103 unsigned int rand_seed;
3 thread_options.h <global>                   327 uint32_t rand_seed;
4 verify.h         <global>                    34 uint64_t rand_seed;

Any reason we have 4 different declarations of the same name?
Thoughts on if/how this should be fixed?

Even if it's not wrong, it's definitely confusing.

thanks,
grant

