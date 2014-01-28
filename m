Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140128213014.GC31710@kernel.dk>
References: <1390942940-6886-1-git-send-email-grundler@chromium.org>
	<20140128213014.GC31710@kernel.dk>
Date: Tue, 28 Jan 2014 13:52:46 -0800
Message-ID: <CANEJEGvZ3xnkg+D8RwVcvHfTKtVCcm_YP_geskOZTC0UNBnGOA@mail.gmail.com>
Subject: Re: [PATCH] fio: consolidate rand_seed to uint64_t
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 28, 2014 at 1:30 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Tue, Jan 28 2014, Grant Grundler wrote:
>> csscope showed rand_seed was defined 4 times - each a different type.
>> While they are used differently, the places where they overlap
>> should reference the same type. This patch makes three of them the same
>> as suggested by Jens Axboe.
>
> Time for public shaming, as you did not even compile this patch!

No, I didn't. :)  I told you I didn't test it.

> I'll let you figure out the issue :-)

Oh man...harsh master :P

-       o->rand_seed = le32_to_cpu(top->rand_seed);
+       o->rand_seed = le64_to_cpu(top->rand_seed);

I saw this when reviewing the code but didn't realize "top" was the
packed version that got changed.

Resending V2

Compiled and lightly tested on x86, not ARM where I'm doing most of my
testing these days. :)

cheers,
grant

