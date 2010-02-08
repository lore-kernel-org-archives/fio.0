Return-Path: <cjiazhuang@yahoo.com>
Message-ID: <157216.71006.qm@web80807.mail.mud.yahoo.com>
References: <600237.15205.qm@web80807.mail.mud.yahoo.com> <20100208221033.GW1025@kernel.dk>
Date: Mon, 8 Feb 2010 15:27:41 -0800 (PST)
From: charles zhuang <cjiazhuang@yahoo.com>
Subject: Re: libaio ioengine cause initiator crash
In-Reply-To: <20100208221033.GW1025@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> If stgt is restricted to page size transfers, then it should set the
hardware block size to that (which would then cause fio with 2k bs and
O_DIRECT to error out, instead of crash).

Hi Jens,
Block size is not an issue. I can use other ioengine (like sync) to run thru the test with bs=2k & under, only libaio ioengine has this problem. 
Besides, when I run fio with "--ioengine=sync" and "--iodepth=64", the initiator immediately crash. I know iodepth is only matter to aio type, but it shouldn't crash the kernel.

-- 
Jens Axboe


      

