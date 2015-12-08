Return-Path: <axboe@kernel.dk>
Subject: Re: RBD client cache
References: <CADr68WZZqpVAeS-EuUgc5eOz=XoyrcCWCTymx58WBEAger442A@mail.gmail.com>
 <564E318C.3060602@kernel.dk> <1448553070.29391.3.camel@x-ion.de>
 <56587F75.80800@kernel.dk>
 <CADr68WbHebJQHm+am3XP8e1EC32wZZAwPBf7PA5OBvS6+5nuKQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5666F1FE.8060700@kernel.dk>
Date: Tue, 8 Dec 2015 08:06:38 -0700
MIME-Version: 1.0
In-Reply-To: <CADr68WbHebJQHm+am3XP8e1EC32wZZAwPBf7PA5OBvS6+5nuKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Rosenboom <j.rosenboom@x-ion.de>, Fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/08/2015 06:41 AM, Jens Rosenboom wrote:
> 2015-11-27 17:06 GMT+01:00 Jens Axboe <axboe@kernel.dk>:
>> On 11/26/2015 08:51 AM, Jens Rosenboom wrote:
>>>
>>>   From dbd950891a43a7104bce5ec935cd992c7e2b27ff Mon Sep 17 00:00:00 2001
>>> From: Jens Rosenboom <j.rosenboom@x-ion.de>
>>> Date: Thu, 26 Nov 2015 16:27:49 +0100
>>> Subject: [PATCH] Add an option to flush RBD after opening
>>>
>>> With recent Ceph releases the default value for
>>>
>>> rbd cache writethrough until flush
>>>
>>> has been changed to true, so the librbd client cache will stay in
>>> writethrough mode for fio.
>>>
>>> This patch adds an option to perform an rbd_flush() call after opening
>>> the RBD, causing the client cache to activate writeback mode.
>>>
>>> Signed-off-by: Jens Rosenboom <j.rosenboom@x-ion.de>
>>> ---
>>>
>>> This works in my test enviroment and boosts 4k randwrites at iodepth=1
>>> from 100 to 6000.
>>> Still it would probably be good if other people could test this, too.
>>>
>>>
>>>    engines/rbd.c | 18 ++++++++++++++++++
>>>    1 file changed, 18 insertions(+)
>>>
>>> diff --git a/engines/rbd.c b/engines/rbd.c
>>> index 2be9b55..b3efedf 100644
>>> --- a/engines/rbd.c
>>> +++ b/engines/rbd.c
>>> @@ -30,6 +30,7 @@ struct rbd_options {
>>>          char *pool_name;
>>>          char *client_name;
>>>          int busy_poll;
>>> +       int flush_on_open;
>>>    };
>>>
>>>    static struct fio_option options[] = {
>>> @@ -71,6 +72,16 @@ static struct fio_option options[] = {
>>>                  .group          = FIO_OPT_G_RBD,
>>>          },
>>>          {
>>> +               .name           = "flush_on_open",
>>> +               .lname          = "Flush on open",
>>> +               .type           = FIO_OPT_BOOL,
>>> +               .help           = "Flush on opening the RBD to activate
>>> client cache",
>>> +               .off1           = offsetof(struct rbd_options,
>>> flush_on_open),
>>> +               .def            = "0",
>>> +               .category       = FIO_OPT_C_ENGINE,
>>> +               .group          = FIO_OPT_G_RBD,
>>> +       },
>>> +       {
>>>                  .name = NULL,
>>>          },
>>>    };
>>> @@ -140,6 +151,13 @@ static int _fio_rbd_connect(struct thread_data *td)
>>>                  log_err("rbd_open failed.\n");
>>>                  goto failed_open;
>>>          }
>>> +       if (o->flush_on_open) {
>>> +               r = rbd_flush(rbd->image);
>>> +               if (r < 0) {
>>> +                       log_err("rbd_flush failed.\n");
>>> +                       goto failed_open;
>>> +               }
>>> +       }
>>>          return 0;
>>
>>
>> Looks good, but we should probably limit this to td_write() being true, and
>> not do this for read-only opens.
>
> I'm not sure that it will be helpful to make this option more
> complicated in behaviour and documentation. I agree that currently it
> will only be useful for write jobs, but it should not do any harm for
> others. And maybe in the future the behaviour of librbd will also
> change for read operations, rather than having to add yet another flag
> then, I'd vote for KISS.

I'm all for KISS, but issuing a flush on a read-only opened device is 
not a great idea, period. And since the flush-to-enable-write-cache only 
has an effect on writes, we should only do it for writes.

We should also rename the option to "write_cache_enable" or something 
like that, flush_on_open tells us what a horrible interface rbd is, not 
what the option actually does. The fact that this is the control 
interface for write caching should not be imposed on the user, since 
it's crazy. When you do that rename, the fact that it should only have 
an effect on a writeable workload becomes more apparent.

-- 
Jens Axboe


