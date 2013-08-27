Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <521CDBC2.8050705@kernel.dk>
References: <1377552162-31741-1-git-send-email-jcasse@chromium.org>
	<521CDBC2.8050705@kernel.dk>
Date: Tue, 27 Aug 2013 10:22:16 -0700
Message-ID: <CANEJEGvXJBaE8PU47-ZgHwmyKs8eUo9-Bg7yDPL8iZH-SoxfCw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds check for numberio during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Juan Casse <jcasse@chromium.org>, Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Aug 27, 2013 at 10:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
...
>> +data_integrity_check
>> +             If this option is given, fio will check the i/o number of
>> +             each block read back during the verification phase. Fio
>> +             checks numberio to detect stale blocks. Currently, this
>> +             option requires synchronous i/o, and equal-sized read and
>> +             write blocks. This option requires workloads that write data.
>
> I think this use case is just too narrow.

Jens.
This behavior should be standard behavior for the data integrity
checking. To debug data corruption problems we need to know if it's
stale data or corrupted data. Huge difference in how to track it down
and potential causes. I'm arguing it shouldn't even be an option.

> Why does it require sync IO and equal read/write sizes?
> Can't you just replay and re-generate and compare?

I think it's just limitations of this implementation and testing. In
principle I think you are right. Perhaps Juan can explain in more
detail.

cheers,
grant

