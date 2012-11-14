Return-Path: <emery@zion.americas.sgi.com>
Message-Id: <201211142130.qAELUrtO29392794@zion.americas.sgi.com>
From: emery@sgi.com
Subject: Re: All clients impatient 
In-reply-to: Your message of "Wed, 14 Nov 2012 13:57:40 MST."
             <50A405C4.50100@kernel.dk> 
Date: Wed, 14 Nov 2012 15:30:53 -0600
Sender: emery@zion.americas.sgi.com
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

emery@sgi.com:  Jens Axboe <axboe@kernel.dk>
In message <50A405C4.50100@kernel.dk>, Jens Axboe writes:
>On 2012-11-14 12:58, Jens Axboe wrote:
>> Should work without group_reporting as well with the below patch. Can
>> you confirm?
>
>Committed the patch, with a few modifications. So fio git should work
>for you now, regardless of whether group_reporting=1 is used or not. I
>suspect you want it on in any case, as you are only interested in the
>aggregate results for the clients.
>
>-- 
>Jens Axboe
>
>--
>To unsubscribe from this list: send the line "unsubscribe fio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

	I will probably run w/o group_reporting=1. I'm interested
in both the aggregate performance of the cluster filesystem(s), and
the deviation of the individual threads.

	Aggregate performance helps me quickly see whether I'm getting
the performance I expect from the filesystem or filesystems. W/o that
feature I might have to whip out a calculator. :-)

	Individual thread performance lets me know whether one or
more tape drives would be bandwidth starved, which can lead to 
excessive tape wear.

Scott Emery
emery@sgi.com

