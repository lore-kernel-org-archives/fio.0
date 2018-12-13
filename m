Return-Path: <axboe@kernel.dk>
Subject: Re: Testing --blocksize_range
From: Jens Axboe <axboe@kernel.dk>
References: <DM5PR19MB1402B69B8FE2C5019A8926D1DBA70@DM5PR19MB1402.namprd19.prod.outlook.com>
 <CALjAwxgbUo+ij_=XHDt7ymO0fmk1FTQrMiOK5W6gbDKUoGVH9Q@mail.gmail.com>
 <18159862-e8f6-69ab-1b4c-f2d828716ec5@kernel.dk>
Message-ID: <e9fb7b51-4916-f8cb-0fa8-cfd55d131281@kernel.dk>
Date: Thu, 13 Dec 2018 09:11:59 -0700
MIME-Version: 1.0
In-Reply-To: <18159862-e8f6-69ab-1b4c-f2d828716ec5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, mohan@ertino.com
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/13/18 6:50 AM, Jens Axboe wrote:
> On 12/12/18 11:33 PM, Sitsofe Wheeler wrote:
>> Hi,
>>
>> On Wed, 12 Dec 2018 at 13:43, Mohan Mohan <mohan@ertino.com> wrote:
>>>
>>> I am testing fio with bs ranges 1k-10k 2k-10k 3k-10k 4k-10k 5k-10k 6k-10k.
>>>
>>> The test works fine for the below run:
>>> fio --name=App2 --size=10m --rw=read --blocksize_range=1k-10k
>>> # fio --name=App2 --size=10m --rw=read --blocksize_range=2k-10k
>>> # fio --name=App2 --size=10m --rw=read --blocksize_range=5k-10k
>>>
>>> But error throws on below runs
>>> # fio --name=App2 --size=10m --rw=read --blocksize_range=3k-10k
>>> # fio --name=App2 --size=10m --rw=read --blocksize_range=4k-10k
>>> # fio --name=App2 --size=10m --rw=read --blocksize_range=6k-10k
>>>
>>> App2: (g=0): rw=read, bs=(R) 3072B-10.0KiB, (W) 3072B-10.0KiB, (T) 3072B-10.0KiB, ioengine=psync, iodepth=1
>>> fio-3.12-17-g0fcbc0
>>> Starting 1 process
>>> *** Error in `fio': double free or corruption (!prev): 0x0000555f92a80a60 ***
>>> fio: pid=1468, got signal=6
>>
>> [snip]
>>
>>> I believe the expected test has run properly but why the error has thrown for the particular ranges.
>>
>> This is a real bug and it's occurring because the end of the range is
>> not a multiple of the start of the range (10k is a multiple of 1k but
>> 10k is not a multiple of 3k). I've reproduced it here:
> 
> Oops, I'll take a look at this one, thanks for reporting.

Pushed out a fix for this.

-- 
Jens Axboe


