Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: Zoned block device regression test 11
Message-ID: <a6d3d008-3a44-9d42-2c0c-b26ca9d92d3a@acm.org>
Date: Tue, 21 Aug 2018 17:10:30 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: mikelley@microsoft.com
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

Hello Michael,

If I run the fio code from https://github.com/bvanassche/fio against 
Linux kernel v4.18 as follows:

./fio/t/zbd/run-tests-against-zoned-nullb

then all tests except test number 11 pass. If I revert your axmap 
patches however then test 11 passes. I think this means that your axmap 
patches introduced a regression in the axmap code. Can you have a look 
at this?

Thanks,

Bart.

