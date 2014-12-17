Return-Path: <axboe@kernel.dk>
Message-ID: <5491BCE7.2080703@kernel.dk>
Date: Wed, 17 Dec 2014 10:27:03 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio main thread got stuck over the weekend
References: <20140811154423.GE7486@beardog.cce.hp.com> <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk> <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net> <548BC55F.9020706@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net> <548F1C65.2070501@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net> <548F40A8.3010405@kernel.dk> <548F452D.7040401@kernel.dk> <548F495F.7090200@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F830@G4W3202.americas.hpqcorp.net> <5490B574.3000502@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402959410CC6@G4W3202.americas.hpqcorp.net> <549117EF.7030403@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B4029594217D4@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029594217D4@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/17/2014 09:48 AM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Tuesday, 16 December, 2014 11:43 PM
> ...
>>> (gdb) print td->tv_cache
>>> $51 = {tv_sec = 1099511, tv_usec = 641885}
>>                     ^^^^^^^
>>
>> This is the key. If this multiplication overflows:
>>
>> usecs = (t * inv_cycles_per_usec) / 16777216UL;
>>
>> then usecs is 2^64/2^24, which is 1099511627776. Divide that by 10^6 to
>> get seconds, and that is 1099511... I initially thought this was a buggy
>> backwards timer, but it's just this overflow. Fix:
>>
>> http://git.kernel.dk/?p=fio.git;a=commit;h=b3fa625b38a638cd1783e9fdcac1b95
>> 8e37e48fa
>
> Good find.  The 64-bit RDTSC won't wrap for over 10 years, but
> that multiplication must be stealing too many bits.
> fio --debug=time shows this:
> 	time     28459 inv_cycles_per_usec=8397

I added a second change that offsets the TSC by the initial value, so we 
should have the full 2^64 bit range available now. And yes, wrapping 
wont be a problem beyond that, it's a good chunk over 10 years and 
people _probably_ don't run jobs that long :-)

> Is anything in the linux kernel susceptible to a similar problem?

I haven't checked, I would assume the kernel would offset by the initial 
value as well.

> Anyway, I detached gdb and hit ^C to terminate fio, confirming that
> the 64-bit counters are working - it's reporting more than 4B IOs
> for devices now:
> * total IOs: 572,018,473,400
> * 15 devices: 37,703,868,929 (example)
> * (1 device (sdi) is lower, but fio gave up on it after IO errors)

Perfect! I'll cut 2.2.0 sometime this week, jfyi.

-- 
Jens Axboe


