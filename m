Return-Path: <stefanha@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130126162818.GF15635@kernel.dk>
References: <20130125114236.GA26765@stefanha-thinkpad.redhat.com>
	<20130126162818.GF15635@kernel.dk>
Date: Sat, 26 Jan 2013 17:51:50 +0100
Message-ID: <CAJSP0QURHyhFGc3ZVo=TM16_VUY-pRqNMTOJcNwNGUoJCdoi0Q@mail.gmail.com>
Subject: Re: Why does 'direct' influence 'fsync'?
From: Stefan Hajnoczi <stefanha@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Asias He <asias@redhat.com>
List-ID: <fio@vger.kernel.org>

On Sat, Jan 26, 2013 at 5:28 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Jan 25 2013, Stefan Hajnoczi wrote:
>> Is there a way to flush the disk write cache when O_DIRECT is in use?
>>
>> It seems that direct=1 causes the fsync setting to be ignored.  Asias
>> writes:
>>
>> > The O_DIRECT do affect the flush behaviour. e.g
>> >
>> > guest$ fio --fsync=100 --direct=1
>> > No virtio_blk_handle_flush is observed on host side every 100 IOs
>> >
>> > guest$ fio --fsync=100 --direct=0
>> > virtio_blk_handle_flush is observed on host side every 100 IOs
>>
>> Am I missing a reason for this behavior?  To me it seems weird since you
>> could already use --fsync=0 --direct=1 if you want to guarantee that
>> fsync is not called.  I don't see a need to override the fsync setting.
>
> You are right, fio should not be double guessing options like that. If
> you ask for fsync, you should get fsync.
>
> Does the below work for you?

Yes, thanks!

Tested-by: Stefan Hajnoczi <stefanha@redhat.com>

