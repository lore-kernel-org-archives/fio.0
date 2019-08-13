Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 5/5] make test: Also run zbd tests
References: <20190813020136.15798-1-bvanassche@acm.org>
 <20190813020136.15798-6-bvanassche@acm.org>
 <CALjAwxjBiG9UsTfcB7zQohbtu7QofGhf3qvbi9T9TT-Kv=oeCw@mail.gmail.com>
 <aafcc9f9-67fc-10c8-1b6e-b9d8cd4621a3@acm.org>
 <CALjAwxi-NujdSFZPP48GZ=vovkmz43qyP1-8OzERJxJK0D3knQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <80f13ecd-34b1-c2c2-5802-da2a8058ab42@kernel.dk>
Date: Tue, 13 Aug 2019 14:22:55 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxi-NujdSFZPP48GZ=vovkmz43qyP1-8OzERJxJK0D3knQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, Bart Van Assche <bvanassche@acm.org>
Cc: fio <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 8/13/19 2:10 PM, Sitsofe Wheeler wrote:
> On Tue, 13 Aug 2019 at 16:06, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 8/12/19 9:39 PM, Sitsofe Wheeler wrote:
>>> On Tue, 13 Aug 2019 at 03:02, Bart Van Assche <bvanassche@acm.org> wrote:
>>>>    test: fio
>>>>           ./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
>>>> +       if modinfo null_blk >/dev/null 2>&1 &&                                 \
>>>> +               sudo modprobe null_blk &&                                      \
>>>> +               [ -e /sys/kernel/config/nullb ]; then                          \
>>>> +               git clone https://github.com/hgst/libzbc &&                    \
>>>> +               (cd libzbc &&                                                  \
>>>> +               ./autogen.sh &&                                                \
>>>> +               ./configure --prefix=/usr &&                                   \
>>>> +               make -j &&                                                     \
>>>> +               sudo make install) &&                                          \
>>>> +               sudo t/zbd/run-tests-against-regular-nullb &&                  \
>>>> +               if modinfo null_blk | grep -q '^parm:[[:blank:]]*zoned:'; then \
>>>> +                       sudo t/zbd/run-tests-against-zoned-nullb;              \
>>>> +               fi;                                                            \
>>>> +       fi
>>>>
>>>>    install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
>>>>           $(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
>>>>
>>>
>>> I don't feel comfortable trying to clone a repo, run sudo, installing
>>> stuff as root and loading a kernel module just because someone ran
>>> "make test". Maybe we should introduce another target for this?
>>
>> Hi Sitsofe,
>>
>> How about executing the new code only on Travis, e.g. by checking
>> whether the TRAVIS environment variable has been set?
> 
> That's a bit better but I still think we could introduce a test_travis
> target, have travis call that and run any extra commands we want...

I agree with that, but let's call it something like fulltest instead.
That gives travis/CI the option to run test and fulltest, where a
"normal" user would probably just do make test. If they do want
fulltest, then it's available to run.

-- 
Jens Axboe


