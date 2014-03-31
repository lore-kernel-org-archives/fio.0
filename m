Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
Date: Mon, 31 Mar 2014 18:14:25 -0500
Message-ID: <CAEyTGCctx79HSrK-_Nmqn7e04+OcDdzpt9Yw+w0bk_SCeQOYAg@mail.gmail.com>
Subject: FIO replay error on 2.1.6.1 - err=22/file:engines/sync.c:67,
 func=xfer, error=Invalid argument
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Jens,
I tried replaying like 91 blkparse binary files using fio 2.1.6.1 on
RHEL 7. I get the below error , any idea what is the reason?


Starting 91 processes
fio: pid=9134, err=22/file:engines/sync.c:67, func=xfer, error=Invalid argument
fio: pid=9092, err=22/file:engines/sync.c:67, func=xfer, error=Invalid argument
fio: pid=9053, err=22/file:engines/sync.c:67, func=xfer, error=Invalid argument
fio: pid=9127, err=22/file:engines/sync.c:67, func=xfer, error=Invalid argument
fio: pid=9079, err=22/file:engines/sync.c:67, func=xfer, error=Invalid argument
fio: first direct IO errored. File system may not support direct IO,
or iomem_align= is bad.
fio: pid=9044, err=22/file:engines/sync.c:67, func=xfer, error=Invalid argument
xfer, error=Invalid argument

Please help,
Thanks
Lakshmi

