Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140205171528.GF27534@kernel.dk>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
	<20140205171528.GF27534@kernel.dk>
Date: Wed, 5 Feb 2014 10:16:39 -0800
Message-ID: <CANEJEGsd8nau07m3ujwrSkwVGnGJmi2DszaJe792RP_F=6xpng@mail.gmail.com>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 5, 2014 at 9:15 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Mon, Feb 03 2014, Puthikorn Voravootivat wrote:
>> In verify phase, the rand_seed generated on replay does not match
>> the written rand_seed.
>>
>> Multiple problems are causing this:
>> 1. In verify phase fio does not set io_u->rand_seed to compare with
>>    hdr->rand_seed
>> 2. In randrw scenario, fio log is stored in red-black tree in "sorted by LBA"
>>    order.  Thus, it is imposible to replay the written order, or rather
>>    generate the seeds again in the same order.
>> 3. In write phase, the code currently will generate rand_seed, write data
>>    and log rand_seed. When queuedepth > 1, it's possible the writes complete
>>    in a different order than rand_seed was generated.  Thus when replaying
>>    the log, the generated rand_seed might not match what was written.
>> 4. verify_backlog option will start verification before all the data has been
>>    written and it make rand_seed replay code broken with current design.
>>
>> Proposed fixes:
>> 1. Use of existing verify_state to generate verify header.
>>    (and assumes this was the original intention of verify_state). And also
>>    adds code to replay rand_seed in verify phase.
>> 2. If verifysort option is not enabled, store the write log in a list instead
>>    of the red-black tree. Otherwise, don't attempt to verify the rand_seed
>>    in the header.
>> 3. In write phase,  generate rand_seed, log rand_seed, write data. I.e. log
>>    IO transactions in the order generated, not completed.
>> 4. Don't verify rand_seed when verify_backlog is enabled.
>
> Seems like a reasonable solution to it all. Thanks! I'll get this
> applied.

Awesome - I see that it's applied. Puthikorn has one more fix in
flight and I'm going to suggest something you'll probably reject in
another email.

cheers,
grant

