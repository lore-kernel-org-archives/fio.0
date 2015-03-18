Return-Path: <andrey.o.kudryavtsev@intel.com>
From: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>
Subject: Re: REPORT: High CPU utilization since 2.2.5
Date: Wed, 18 Mar 2015 12:33:42 +0000
Message-ID: <D12F19CB.1D6B7%andrey.o.kudryavtsev@intel.com>
References: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
 <CALjAwxgWEZFHZNgpZvHgak4-bfQQqE9A9Gtu_e2JGcQ_xaovQA@mail.gmail.com>
 <D1235F6C.1BF40%andrey.o.kudryavtsev@intel.com> <55085347.5060702@kernel.dk>
In-Reply-To: <55085347.5060702@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1251"
Content-ID: <BEFE34016C2CD94D90D8362203EC5168@intel.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: andrey.o.kudryavtsev@intel.com
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Thank you, I=92ll do that.

--=20
Andrey Kudryavtsev,
SSD Solution Architect
Intel Corp.=20
inet: 83564353
work: +1-916-356-4353
mobile: +1-916-221-2281




On 3/17/15, 4:16 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 03/09/2015 04:07 PM, Kudryavtsev, Andrey O wrote:
>> Thank you for the advise,
>> Utilization is coming from fio threads, reported I/O is similar to
>>iostat.
>> Disabling all latency reporting works and returns the CPU utilization
>>back
>> to normal. Unfortunately this workaround doesn=92t work for me, I=92m us=
ing
>> latency monitoring a lot for my tests.
>>
>> I did some more research,
>> 	With latency reporting enabled I=92m get=E5ing 350k IOPS instead of 450=
k.
>> 	With gdot_disable=3D1 back to normal 450k
>> 	With disable_slat=3D1 only it gets 420k
>> 	disable_clat=3D1 doesn=92t make any difference and the performace is st=
ill
>> low 350k.
>>
>> Please, advise.
>
>Please run a git bisect, as suggested. This will help pinpoint what
>commit made it worse for you. Should be pretty easy to do, since you can
>reproduce quickly and easily. You mentioned that 2.1.14 works, and that
>2.2.5 is broken. So do:
>
>$ git bisect start
>$ git bisect good fio-2.1.14
>$ git bisect bad fio-2.2.5
>
>Now for each iteration, do:
>
>$ make clean && make -j20
>$ ./fio <jobfile>
>
>if the result is slow, do:
>
>$ git bisect bad
>
>and if the result is fast, do:
>
>$ git bisect good
>
>Then go back to the make clean && make and rerun your test case. Repeat
>this until you've bisected your way to the problematic commit, git will
>tell you when it's done.
>
>--=20
>Jens Axboe
>


