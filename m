Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <5229EACA.7090009@kernel.dk>
References: <1378437152-11128-1-git-send-email-jcasse@chromium.org>
	<5229EACA.7090009@kernel.dk>
Date: Fri, 6 Sep 2013 10:15:51 -0700
Message-ID: <CANEJEGvywnoT5SeezgW=b-8dOATcG7HJgQ9RLgmO9XranFywqg@mail.gmail.com>
Subject: Re: [PATCH] Adds verify_only option.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Juan Casse <jcasse@chromium.org>, Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Sep 6, 2013 at 7:46 AM, Jens Axboe <axboe@kernel.dk> wrote:
...
>> +     if (o->verify_only) {
>> +             o->do_verify = 1;
>> +             o->verify = VERIFY_META;
>> +             strcpy(o->ioengine, "sync");
>> +     }
>
> Should be a clear warning sign! You are hard coding the verify type and
> the engine, why??

We don't need to replicate the workload for "verify_only" runs.  I was
looking for the simplest possible method to verify the data integrity
- goal is to test the HW, not the rest of the system/user space
threading models/etc.

Anyway, you are right. We don't need to override user specified
parameters. Any verify_type should work and "sync" is the default
ioengine:
    os/os.h:#define FIO_PREFERRED_ENGINE    "sync"

> Please take a look at how this is done for the experimental_verify. The
> writes are skipped much sooner and generically, there's no need to
> enforce any sort of specific IO engine or verify type.

Didn't know about that - Juan and I will look into it.

Thanks!
grant

