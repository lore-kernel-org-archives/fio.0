Return-Path: <axboe@kernel.dk>
Subject: Re: client/server mode fails with Assertion `client->eta_in_flight =
 eta' failed
References: <CABtFm2WPnKVVBVPU0N97ipX=RTAVK7Tz0nJUNtAmS9chLw3nHw@mail.gmail.com>
 <56C4D7D4.4020904@kernel.dk>
 <CABtFm2UabELu776EVnrwVUgrfeWcjkM=W1irhxF6L_o-QdTDLg@mail.gmail.com>
 <CANWz5fhXDTu=zKLtHuoecVWcMzvditqs6AqHK-Y-RfsJscJ=GA@mail.gmail.com>
 <43640b9a-b49c-eee8-ef6a-66333a649930@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8ba8ee1d-f07a-4619-278a-3526e82262e0@kernel.dk>
Date: Tue, 13 Sep 2016 09:09:13 -0600
MIME-Version: 1.0
In-Reply-To: <43640b9a-b49c-eee8-ef6a-66333a649930@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Chris Worley <worleys@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 09/13/2016 09:04 AM, Jens Axboe wrote:
> On 08/30/2016 09:28 AM, Chris Worley wrote:
>> Was there ever a solution?  I'm seeing this a lot on v2.9.
>
> Chris/Srinivasa, can you try the below patch? Looks like we're racing
> sometimes on the ETA command. And if we don't find a reply tag, we
> already decremented the ETA count, so we should just ignore it.

I committed this fix, so you can just update to current -git to get it.

-- 
Jens Axboe


