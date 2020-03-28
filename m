Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: add NVMe engine
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
 <51339d62-debc-5024-11fd-773574f3be6c@kernel.dk> <20200327190132.GA6316@avx2>
 <3d0d59af-5126-74ef-27c1-ffd97d7bec95@kernel.dk>
 <BY5PR04MB6689C30A00737A603DA12DEDFFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dadfda75-209b-2f10-6761-3814da33c28d@kernel.dk>
Date: Sat, 28 Mar 2020 07:41:35 -0600
MIME-Version: 1.0
In-Reply-To: <BY5PR04MB6689C30A00737A603DA12DEDFFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Keith Busch <Keith.Busch@wdc.com>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/27/20 3:58 PM, Keith Busch wrote:
> On 3/27/20 3:25 PM, Jens Axboe wrote:
>> On 3/27/20 1:01 PM, Alexey Dobriyan wrote:
>>> On Fri, Mar 27, 2020 at 08:47:08AM -0600, Jens Axboe wrote:
>>>> On 3/27/20 8:25 AM, Keith Busch wrote
>>>>> I'm not completely against fio providing an nvme ioengine, and libnvme
>>>>> could easily fit in, but I don't think that faithfully represents how
>>>>> these devices are actually used. The passthrough interface is not really
>>>>> our fast path, and being a synchronous interface is a bit limiting in
>>>>> testing device capabilities.
>>>> I guess my main question is what purpose it fills. Since it's not
>>>> a performant interface, it's not a benchmarking thing.
>>>> Hence it's for testing the feature? If so, would it be better to have in
>>>> nvme-cli or a standalone tool?
>>> This engine can easily create QD=NR_CPUS, it is not much but it is something.
>> Sure, just like any other sync engine can also be somewhat parallel if
>> you just run multiple threads/processes on it. I just don't want people
>> to get the idea that it's something that's useful for benchmarking. And
>> if it isn't, then what is the point?
>>
>> As I said, I'm not vehemently opposed to the idea of adding the engine,
>> because it is just a simple wrapper around the submit ioctl. But it'd be
>> nice to have some clear purpose behind it, justifying the inclusion.
> 
> 
> I think this is the nvme equivalent to the 'sg' ioengine using the 
> SG_IO ioctl. I don't think SG_IO is a good benchmarking interface
> either, but if it's useful for something I'm not considering, then I
> guess 'nvme' should have a similar justification.

True, and at least this one is easier to maintain, whereas the async
sg engine is a lot more complicated. My main worry is, as usual, that
to add a maintenance burden, justification needs to be there.

-- 
Jens Axboe


