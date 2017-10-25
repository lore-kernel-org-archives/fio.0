Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: "nice" parameter bug (-19 to 20) and out of range message bug
Message-ID: <b7782a91-a5a0-458a-d931-768d13fdb4ac@bluestop.org>
Date: Wed, 25 Oct 2017 13:02:57 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

If I set the job parameter "nice" to -20 in Linux using FIO 3.1, I get 
the warning:

min value out of range: 18446744073709551596 (4294967277 min)

The error is clearly wrong, but in options.c the min and max values are 
also: 'nice' ranges from -20 to 19, whereas FIO allows -19 to 20.

-- 
Rebecca

