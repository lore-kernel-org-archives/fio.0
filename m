Return-Path: <sampath.rapaka@gmail.com>
MIME-Version: 1.0
In-Reply-To: <52010665.6080408@kernel.dk>
References: <CAJqT0iwmEvv5RXseLs+9XePax8wefj7xa9gdpwdfNZqzvQFEQQ@mail.gmail.com>
	<5200DF76.1020904@enovance.com>
	<CAJqT0iwDMhF=MzMgNxBvS6ML86MLHzo5ZU-gJztj1iaNrTEKLw@mail.gmail.com>
	<52010665.6080408@kernel.dk>
Date: Wed, 7 Aug 2013 14:32:53 +0530
Message-ID: <CAJqT0iy+vjDHKki8njZQBS+iQ=KvGRjga0Lza4oecB1SM6PJ0w@mail.gmail.com>
Subject: Re: Help : Facing this when i trigger FIO from command line :"fio:
 file hash not empty on exit"
From: sampath rapaka <sampath.rapaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: Erwan Velu <erwan@enovance.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Aug 6, 2013 at 7:51 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/06/2013 05:52 AM, sampath rapaka wrote:
>> On Tue, Aug 6, 2013 at 5:05 PM, Erwan Velu <erwan@enovance.com> wrote:
>>> On 06/08/2013 13:12, sampath rapaka wrote:
>>>>
>>>> There is something wrong in the command I have run ?
>>>>
>>> Can you mention the version of fio you are using ?
>>>
>>> Can you double check you didn't had an OOM message from the kernel ?
>> fio --version
>> fio-2.0.15
>>
>> I have not seen any Issues with Memory. I had run other fio test from
>> config file, It went smoothly.
>
> First try a make clean && make and see if it reproduces. If it does,
> then edit the Makefile and remove the -O3 in there. Then make clean &&
> make. Now do ulimit -c10000000000 and reproduce the issue. That should
> give you a core dump file. Then do:
>
> # gdb fio core
>
> and type 'bt' and send the full output here.
>
> --
> Jens Axboe
>
Thanks for the reply. Once I get a test machine i will try it and
update the back trace.

thanks
rapaka

