Return-Path: <axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Subject: Revert of 1d1b65dc17c39f43dbe9d66062ca61fc3e90ddfc
Message-ID: <e0584921-2c98-b9af-e31e-780f929631b9@kernel.dk>
Date: Fri, 7 Sep 2018 13:21:27 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Luis,

I reverted this commit today, it breaks the normal use case
which is:

$ ./fio --server
$ ./fio --minimal --client=bla job.fio

since no output is generated at all. I don't have much time
to look at it right now, would be great if you could.

Thanks,
-- 
Jens Axboe


