Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:32948 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750754AbcLUKjz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2016 05:39:55 -0500
Received: by mail-ua0-f196.google.com with SMTP id y22so1783215uay.0
        for <fio@vger.kernel.org>; Wed, 21 Dec 2016 02:39:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB0169B59A50990EE98783E56FAB930@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20161220235638.35477-1-elliott@hpe.com> <20161220235638.35477-2-elliott@hpe.com>
 <CALjAwxjFu6o4Eb+Vn4MEzKiRMYyLvYmWh6NEXQziNTYgWRh5hw@mail.gmail.com> <DF4PR84MB0169B59A50990EE98783E56FAB930@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 21 Dec 2016 10:39:54 +0000
Message-ID: <CALjAwxjMdcEVMLqe01-c2OPYbCEE-0ahSoLV-wtttCeA+n8N4w@mail.gmail.com>
Subject: Re: [PATCH 2/2] pmemblk: Clarify fsize is in MiB not MB
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 21 December 2016 at 07:57, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>> >   *   When specifying the filename, if the block pool file does not
>> already
>> > - *   exist, then the pmemblk engine can create the pool file if
>> you specify
>> > + *   exist, then the pmemblk engine creates the pool file if you
>> specify
>> >   *   the block and file sizes.  BSIZE is the block size in bytes.
>> > - *   FSIZEMB is the pool file size in MB.
>> > + *   FSIZEMiB is the pool file size in MiB.
>>
>> It might be safer to explicitly say "in megabytes" rather than "in
>> MiB" here because of fio's infamous reversal of the terms M(B)/MiB
>> (https://github.com/axboe/fio/issues/103 ). Can the user explicitly
>> specify units as is done elsewhere in fio?
>
> "mega" is still the SI power of 10 prefix; mebi would be the IEC
> power of 2 prefix.

OK.

> I'm working on a big patch set to clean up the units throughout the
> whole codebase, and hope to post it tomorrow.
>
> For inputs (e.g., parameters in .fio files), kb_base=1000 will
> cause it to use proper units and kb_base=1024 (the default) will
> continue to use wrong units (for compatibility).  I'm guessing that
> kb_base=1000 has little use so far (there are several bugs making
> it pretty unusable right now) so we can take it over for this
> purpose.

Perhaps it would be better to phase out kb_base and just introduce
something like iec_mode instead (perhaps with an alias iecly_correct
to provide snark for those who love powers of 10 sizes)? That way
anyone depending on the buggy kb_base behaviour would at least be
forced to look up the new option when it disappeared.

> For outputs, proper units will always be displayed onscreen,
> sometimes with both side-by-side.
>
> The terse and json output formats are not changed - they'll
> continue to report KiB/s values (without units).
>
> Example text output:
>
> Jobs: 576 (f=576), 549MiB/s-80.5GiB/s: [w(288),r(288)] [0.0% done] [r=33200MiB/s,w=25544MiB/s,t=0KiB/s] [r=8499k,w=6539k,t=0 iops] [eta 06h:59m:53s]
> ...
> drive_0: (groupid=0, jobs=36): err= 0: pid=54154: Tue Dec 20 08:17:35 2016
>   write: io=75.7TiB, bw=3145MiB/s (3298MB/s), iops=805k, runt=25200023msec
>     clat percentiles (usec):
>      |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
>      | 30.00th=[    0], 40.00th=[    0], 50.00th=[    0], 60.00th=[    0],
>      | 70.00th=[    0], 80.00th=[    0], 90.00th=[    0], 95.00th=[    0],
>      | 99.00th=[    0], 99.50th=[    0], 99.90th=[    0], 99.95th=[    0],
>      | 99.99th=[    0]
>   cpu          : usr=1.80%, sys=10.70%, ctx=32257714, majf=0, minf=5992
>   IO depths    : 1=15.3%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=15.3%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=15.3%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total r=0,w=20290240440,t=0, short r=0,w=0,t=0, dropped r=0,w=0,t=0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> ...
> Run status group 0 (all jobs):
>    READ: io=837GiB (899GB), aggrbw=31.9GiB/s (34.2GB/s), minbw=31.9GiB/s (34.2GB/s), maxbw=31.9GiB/s (34.2GB/s), mint=26287msec, maxt=26287msec
>   WRITE: io=640GiB (687GB), aggrbw=24.4GiB/s (26.2GB/s), minbw=24.4GiB/s (26.2GB/s), maxbw=24.4GiB/s (26.2GB/s), mint=26300msec, maxt=26300msec

Agh... From my perspective fio's interactive output is wide enough as
it stands - it already typically exceeds 80 columns and causes
wrapping until I make the terminal is wider with moderate speed
read/write workloads. The other problem is that people really do
scrape fio's "normal" output today... I know, I know, it's not stable,
use terse/json or etc but it happens. See
https://www.youtube.com/watch?v=vm1GJMp0QN4#t=17m48s for a Brendan
Gregg fio output parsing war story (punchline is at
https://youtu.be/vm1GJMp0QN4?t=1308 ). Perhaps you only get this new
output in iec_mode? I have to admit showing both the SI unit and the
binary unit forms is the way GNU tools like dd wound up going in the
end.

The SI storage unit wars haven't generated winners - only people who
are confused what the numbers mean and who are angry the units aren't
what they want.

-- 
Sitsofe | http://sucs.org/~sits/
