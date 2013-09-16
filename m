Return-Path: <jcasse@google.com>
MIME-Version: 1.0
Sender: jcasse@google.com
In-Reply-To: <CAPet_23DaVAWzUZ4zpW9XCa54FAF=_zbhdSXh7dM4KjkRR7HWw@mail.gmail.com>
References: <1379102838-10185-1-git-send-email-jcasse@chromium.org>
	<EEF9E3C12F20174DA289A981D6CCA6C8324A3CBF95@MX44A.corp.emc.com>
	<CAPet_23DaVAWzUZ4zpW9XCa54FAF=_zbhdSXh7dM4KjkRR7HWw@mail.gmail.com>
Date: Mon, 16 Sep 2013 08:40:14 -0700
Message-ID: <CAPet_215v=q4tsMCYWSdtvgYMfPMtT987gVS+7QLeeWuxN43MQ@mail.gmail.com>
Subject: Re: [PATCH V2] Adds verify_only option.
From: Juan Casse <jcasse@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Grant Grundler <grundler@chromium.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

The fio job example attached to the previous email has
size=3D24k
bs=3D8k
readwrite=3Dwrite

You would expect fio to perform 3 writes, but instead it performs 4.
This is because the first io is kept in the queue and not counted as
completed io. The while-do construct in do_io() keeps going until
completed io >=3D size.

This behavior does not manifest itself when random_generator=3Dlfsr
because lfsr knows when to stop generating numbers, and when trying to
obtain the next io inside the while loop, get_io_u(td) returns NULL
and breaks out of the loop.

The behavior does not manifest itself either when norandommap is not
specified, that is, we use a random map, which ensures that all blocks
are hit. Once all the blocks are hit, no more io are issued and the
while loop stops.

The tests that I have run using ioengine=3Dsync do not accumulate io in
the queue even though iodepth=3D2.

Regards,
Juan

On Mon, Sep 16, 2013 at 7:52 AM, Juan Casse <jcasse@chromium.org> wrote:
> Hi Konstantin,
>
> I use the same code already in fio for stopping. The do_dry_run() uses
> the same while-do construct as in do_io().
> After the do_dry_run() completes, the do_verify() will verify the io
> units that where logged using log_io_piece().
>
> On a related subject:
> I found an unexpected behavior with the current version (2.1.2) of fio
> when specifying an iodepth > 1 (with a random workload and libaio io
> engine and the default random generator and not using a random map).
> An example job that produces the behavior is attached.
> When a job like that is run, do_io() will perform extra io in the
> amount of the extra io that was allowed to accumulate in the queue. In
> other words, if iodepth=3D2, fio will do 1 extra io.
> I will send a different patch for this.
>
> Regards,
> Juan
>
> On Fri, Sep 13, 2013 at 10:53 PM, Ruvinsky, Konstantin
> <Konstantin.Ruvinsky@emc.com> wrote:
>> Hi Juan,
>>
>> I removed the second question - understood what you meant.
>>
>> Regards
>> Konstantin
>>
>> -----Original Message-----
>> From: Ruvinsky, Konstantin
>> Sent: Saturday, September 14, 2013 8:34 AM
>> To: 'Juan Casse'; 'fio@vger.kernel.org'
>> Subject: RE: [PATCH V2] Adds verify_only option.
>>
>> Hi Juan,
>>
>> Two questions:
>> 1. How fio knows where is the last block (where to stop verification run=
)? Please let me know if I understand it correctly: because lfsr runs witho=
ut duplicated blocks then number of iterations is device_size/block_size.
>> 2. You wrote: "The verify_only option performs only verification (reads =
performed in do_verify()) and no read or write workload". But for verificat=
ion, even if you made dry run till the end, you need to read. I don't follo=
w.
>>
>> Regards
>> Konstantin
>>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Be=
half Of Juan Casse
>> Sent: Friday, September 13, 2013 11:07 PM
>> To: Jens Axboe
>> Cc: Grant Grundler; fio@vger.kernel.org; Juan Casse
>> Subject: [PATCH V2] Adds verify_only option.
>>
>> The verify_only option performs only verification (reads performed in do=
_verify()) and no read or write workload. The goal is to verify previously =
written meta data quickly and be able to detect stale data.
>> Without this option, fio does not detect stale data from previous fio ru=
ns---only data corruption of "misplaced" data.
>>
>> This option replays the specified write workload sequence in order to co=
mpute the "generation number" (using numberio field) for each block header =
that was written in a previous fio run. The numberio field is used to detec=
t stale data. do_verify() checks numberio only in the last iteration, after=
 the correct numberio for each block has been computed.

