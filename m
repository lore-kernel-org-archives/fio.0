Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] don't change direct I/O xfer size during initial layout
 setup
References: <20170904152317.6065-1-tkusumi@tuxera.com>
 <CALjAwxhADLVViWBc2WyDsK5LOByV39f3X2Fs5qxsTC+ExBED1A@mail.gmail.com>
 <CAHndrBkUMYUG-e6dqk9NsBBt7fJkHMH2M70-v9LrQ=K-KiFhtw@mail.gmail.com>
 <CALjAwxgnm7c+64kW7Y+-e36qPg8nYR_7n-=htuL5Pb6FQUPT8g@mail.gmail.com>
 <CAHndrBn0bdfC0kT5cg7TnGE3X6=SAaxCMCf9zORvx8zOxdnObw@mail.gmail.com>
 <21362e1f-e266-9b49-ba62-6ca8d705e7c9@kernel.dk>
 <CAHndrBk6BKQW-YdBzK7=i2VFuuBKu+nT-Uj-9X0BH8w+Nq=g=w@mail.gmail.com>
 <c645b819-a5bf-1dae-cb39-caee7fd434c1@kernel.dk>
 <CALjAwxgW3GDdmVMrDrXM=8dktWZgFJ2pZ5V3Enjv+OZn6R5NRQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <185cfb09-b1f7-bab4-1991-810dce580db6@kernel.dk>
Date: Tue, 5 Sep 2017 13:45:59 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxgW3GDdmVMrDrXM=8dktWZgFJ2pZ5V3Enjv+OZn6R5NRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Tomohiro Kusumi <tkusumi@tuxera.com>, weiping zhang <zhangweiping@didichuxing.com>
List-ID: <fio@vger.kernel.org>

On 09/05/2017 01:00 PM, Sitsofe Wheeler wrote:
> On 5 September 2017 at 15:58, Jens Axboe <axboe@kernel.dk> wrote:
>> On 09/05/2017 08:54 AM, Tomohiro Kusumi wrote:
>>> I think I've made three fixes over the original two commits.
>>>
>>> 1. non O_DIRECT dio support -> committed -> now reverted
>>> 2. segfault on fio_memfree() -> committed -> now reverted
>>> 3. this one
>>>
>>> As far as I've seen this is it.
>>
>> Right, just checked (and reverted) and it's 5 changes all in
>> all for the change, not including the parent to this email,
>> which would have made it 6 in all. The original change from Weiping
>> clearly wasn't well tested or thought through, so it's better
>> to just kill it all and do it cleanly from scratch instead.
> 
> Unfortunately it's been a problem magnetic with stacks of extra
> conditions turning up and corner cases to stumble over (see
> https://github.com/sitsofe/fio/commit/8fed4ccc87e39144643b1e32caddd882e6197e58
> for yet another case that was going to need fixing).
> 
>> That said, I'm not even convinced we need this change. Logically
>> it makes sense, but there's really nothing wrong with doing
>> a buffered layout + cache kill as we have been doing since
>> the dawn of time in fio.
> 
> One of the benefits was that it stopped
> 
> rm -f /tmp/fiofile; ./fio --loops=10 --filename /tmp/fiofile --bs=4k \
>  --size=1M --direct=1 --name=go
> 
> reporting cached speeds on macOS (a platform where invalidation
> doesn't work). The sad thing is that the change wound up slowing
> layout right down because the I/O is potentially done in such small
> sizes. With the problems it attracted it need a re-think if it's to
> avoid attracting a never ending stream of workarounds.

Slowing down layout for everyone is a much larger issue (and a
regression), whereas the lack of cache invalidation on a 2nd tier
platform is much less interesting. Of the two, I know what I'd pick.

It'd be nice if we can get everything working nicely. Honestly, it's not
rocket science (at all) to use O_DIRECT for layouts. The performance
issue is the biggest hurdle, the only thing we can do there is use a
larger block size and hope it closes enough of the gap.

-- 
Jens Axboe


