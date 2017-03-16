Return-Path: <axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Subject: fio: forcing file /dev/nvme0n1 size to 4286578688
Message-ID: <838dc940-5a0b-fda7-2610-615e3a700c3c@kernel.dk>
Date: Thu, 16 Mar 2017 14:24:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi,

Commit c4aa2d08 adds this warning message, which triggers all the time
when used with block devices and no size being set. Why are we logging
this message?

-- 
Jens Axboe


