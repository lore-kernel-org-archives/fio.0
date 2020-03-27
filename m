Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: add NVMe engine
References: <20200326204406.GA29597@avx2>
 <CO2PR04MB2343805A950787DBA0BA18E9E7CC0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200327061439.GA2745@avx2>
 <BY5PR04MB6689C6836C345348D8BFFC46FFCC0@BY5PR04MB6689.namprd04.prod.outlook.com>
 <51339d62-debc-5024-11fd-773574f3be6c@kernel.dk> <20200327190132.GA6316@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3d0d59af-5126-74ef-27c1-ffd97d7bec95@kernel.dk>
Date: Fri, 27 Mar 2020 15:25:03 -0600
MIME-Version: 1.0
In-Reply-To: <20200327190132.GA6316@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Keith Busch <Keith.Busch@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/27/20 1:01 PM, Alexey Dobriyan wrote:
> On Fri, Mar 27, 2020 at 08:47:08AM -0600, Jens Axboe wrote:
>> On 3/27/20 8:25 AM, Keith Busch wrote:
>>> On 3/27/20 12:14 AM, Alexey Dobriyan wrote:
>>>> On Fri, Mar 27, 2020 at 12:56:00AM +0000, Damien Le Moal wrote:
>>>>>
>>>>> On 2020/03/27 5:44, Alexey Dobriyan wrote:
>>>>>> Add simple iodepth=1 NVMe engine:
>>>>>>
>>>>>> 	ioengine=nvme
>>>>>>
>>>>>> It works via standard Linux NVMe ioctls.
>>>>> Keith is working on splitting up nvmecli into the cli part and libnvme which
>>>>> uses the kernel ioctl iinterface for NVMe command passthrough. So I think it may
>>>>> be better to implement ioengine=libnvme using Keith libnvme library. That will
>>>>> remove the need to define all the NVMe command stuff here.
>>>> Sure. It is just standalone file you can send to colleagues and forget.
>>>> Similar to how header-only C++ libraries work.
>>>>
>>>>>> It will be used for testing upcoming ZNS stuff.
>>>
>>>
>>>
>>> I'm not completely against fio providing an nvme ioengine, and libnvme
>>> could easily fit in, but I don't think that faithfully represents how
>>> these devices are actually used. The passthrough interface is not really
>>> our fast path, and being a synchronous interface is a bit limiting in
>>> testing device capabilities.
>>
>> I guess my main question is what purpose it fills. Since it's not
>> a performant interface, it's not a benchmarking thing.
>> Hence it's for testing the feature? If so, would it be better to have in
>> nvme-cli or a standalone tool?
> 
> This engine can easily create QD=NR_CPUS, it is not much but it is something.

Sure, just like any other sync engine can also be somewhat parallel if
you just run multiple threads/processes on it. I just don't want people
to get the idea that it's something that's useful for benchmarking. And
if it isn't, then what is the point?

As I said, I'm not vehemently opposed to the idea of adding the engine,
because it is just a simple wrapper around the submit ioctl. But it'd be
nice to have some clear purpose behind it, justifying the inclusion.

-- 
Jens Axboe


