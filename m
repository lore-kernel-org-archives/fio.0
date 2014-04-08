Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
Date: Tue, 8 Apr 2014 11:39:40 -0500
Message-ID: <CAEyTGCfDabxuWOXW_UWq76bmVYqNUELk9X3YqcVFe5gtCvOGwg@mail.gmail.com>
Subject: Qn on setting ioengine on Replay job
From: Lakshmi <sendtold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi Jens,

  Is it possible to set the ioengine and iodepth on a replay job?
Would it have any effect on the replay jobs? I tried setting as below,
but didnt see any change. So wanted to make sure if what I am doing is
valid.

[global]
replay_no_stall=1
ioengine=posixaio
buffered=0
iodepth=6

[job1]
read_iolog=/home/file_3080658.bin

==============================
Please let me know

Thanks,
Lakshmi

