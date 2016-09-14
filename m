Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <8ba8ee1d-f07a-4619-278a-3526e82262e0@kernel.dk>
References: <CABtFm2WPnKVVBVPU0N97ipX=RTAVK7Tz0nJUNtAmS9chLw3nHw@mail.gmail.com>
 <56C4D7D4.4020904@kernel.dk> <CABtFm2UabELu776EVnrwVUgrfeWcjkM=W1irhxF6L_o-QdTDLg@mail.gmail.com>
 <CANWz5fhXDTu=zKLtHuoecVWcMzvditqs6AqHK-Y-RfsJscJ=GA@mail.gmail.com>
 <43640b9a-b49c-eee8-ef6a-66333a649930@kernel.dk> <8ba8ee1d-f07a-4619-278a-3526e82262e0@kernel.dk>
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Wed, 14 Sep 2016 17:25:54 +0800
Message-ID: <CABtFm2XzkHXQ809eFa98gtpeknf08UzFiKzx-r_NXEg=xRk9Ww@mail.gmail.com>
Subject: Re: client/server mode fails with Assertion `client->eta_in_flight =
 eta' failed
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Worley <worleys@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I have stated the workload and seems to be working fine for the last
one hour. If i hit the issue i will let you know.

# fio --version
fio-2.13-95-g308d

# fio --client=client1 --remote-config=/root/fio_randrw_8k.fio
--client=client2 --remote-config=/root/fio_randrw_8k.fio

<client1> Starting 24 processes
<client2> Starting 24 processes
Jobs: 48 (f=48): [m(24)] [2.0% done] [687.5M/687.8M/0K /s]
[85.1K/85.1K/0 iops] [eta 02d:23h:15m:22s]

One question though, related to the number of jobs. I stated 24 jobs
on each client which should total to 48. But the job info shows only
m(24). I have asked the same query using another thread
http://www.spinics.net/lists/fio/msg04604.html.

Thanks for the great support.

--
Srinivasa R Chamarthy


On Tue, Sep 13, 2016 at 11:09 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/13/2016 09:04 AM, Jens Axboe wrote:
>>
>> On 08/30/2016 09:28 AM, Chris Worley wrote:
>>>
>>> Was there ever a solution?  I'm seeing this a lot on v2.9.
>>
>>
>> Chris/Srinivasa, can you try the below patch? Looks like we're racing
>> sometimes on the ETA command. And if we don't find a reply tag, we
>> already decremented the ETA count, so we should just ignore it.
>
>
> I committed this fix, so you can just update to current -git to get it.
>
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

