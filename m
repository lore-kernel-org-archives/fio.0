Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
Date: Mon, 7 Apr 2014 12:26:02 -0500
Message-ID: <CAEyTGCdvCouz3O-ohfq-Cj9+0X4FkShmZg7gfzE4p+PwHuaDZA@mail.gmail.com>
Subject: --status-interval option doesn't work in 2.1.6.1 version
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Jens,


The --status-interval option used to work in 2.1.4 , but when I tried
this in 2.1.6.1 it doesnt work anymore.
below is the command I run,

fio --status-interval=10 FIO_Random.job > test_interval.txt

Any ideas?

Thanks,
Lakshmi

