Return-Path: <axboe@kernel.dk>
Subject: Re: No I/O performed by windowsaio/get_io_u: zero buflen
References: <CA+zhgFRR_SMf=CEhU8imgM+F_3hmGJV9+h_yU6qR9yQG6br48w@mail.gmail.com>
 <CALjAwxhGmEV=G21Vaw0rRgmLy4BFs2Yhqw4K5yNS2MXwGFvUtQ@mail.gmail.com>
 <CA+zhgFR1V4yKg+gf0QUcuZy47R=-CqyK+_jKVJS4WKDtRb77hQ@mail.gmail.com>
 <03bc8d3c-a8cb-fcbb-e7ff-f23a511f7908@kernel.dk>
 <33A4DA56-9857-4EA3-A1E0-259FD1C856C8@gmail.com>
 <e2f3fe8f-ef0b-2d92-7402-63681f9a9ffb@kernel.dk>
 <6A1733EC-082D-4884-8769-36853A46B75C@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bddbb1ff-bf1e-f4fe-0377-95d0a311c52c@kernel.dk>
Date: Sun, 16 Sep 2018 21:41:32 -0600
MIME-Version: 1.0
In-Reply-To: <6A1733EC-082D-4884-8769-36853A46B75C@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: smitha sunder <sundersmitha@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 9/16/18 9:34 PM, smitha sunder wrote:
> 
> 
>> On Sep 16, 2018, at 8:31 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> On 9/16/18 9:13 PM, smitha sunder wrote:
>>>
>>>
>>>>> On Sep 16, 2018, at 8:02 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>>> On 9/16/18 5:24 PM, smitha sunder wrote:
>>>>>>> On Sun, Sep 16, 2018 at 3:02 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>>>>> On Sat, 15 Sep 2018 at 23:14, smitha sunder <sundersmitha@gmail.com> wrote:
>>>>>>>
>>>>>>> Hello all,
>>>>>>>
>>>>>>> I have a 30TB drive and I am running into an issue with random writes.
>>>>>>> I went through this thread :
>>>>>>> https://www.spinics.net/lists/fio/msg06294.html that seems to be fixed
>>>>>>> already.
>>>>>>
>>>>>> I think that was something different regarding different blocksizes
>>>>>> per direction.
>>>>>>
>>>>>>> I see the same issue with random reads as well.
>>>>>>> So not sure what is the issue here in my case; any help is greatly appreciated.
>>>>>>>
>>>>>>>
>>>>>>> Read Capacity results:
>>>>>>>  Protection: prot_en=1, p_type=1, p_i_exponent=0 [type 2 protection]
>>>>>>>  Logical block provisioning: lbpme=1, lbprz=1
>>>>>>>  Last logical block address=58781073407 (0xdaf9fffff), Number of
>>>>>>> logical blocks=58781073408
>>>>>>>  Logical block length=512 bytes
>>>>>>>  Logical blocks per physical block exponent=3 [so physical block
>>>>>>> length=4096 bytes]
>>>>>>>  Lowest aligned logical block address=0
>>>>>>> Hence:
>>>>>>>  Device size: 30095909584896 bytes, 2.87017e+007 MiB, 30095.9 GB
>>>>>>>
>>>>>>>
>>>>>>> C:\Program Files (x86)\fio>fio --ioengine=windowsaio --group_reporting
>>>>>>> --direct=1 --size=100% --bs=4K --thread --filename=\\.\PhysicalDrive1
>>>>>>> --name=precond --rw=randwrite --iodepth=1 --numjobs=1
>>>>>>> --debug=io,random
>>>>>>
>>>>>> <snip>
>>>>>>
>>>>>>> io       3372  fill: io_u 0A458780:
>>>>>>> off=0x144365e7d000,len=0x0,ddir=1,file=\\.\PhysicalDrive1
>>>>>>> io       3372  get_io_u: zero buflen on 0A458780
>>>>>>> io       3372  get_io_u failed
>>>>>>> io       3372  drop page cache \\.\PhysicalDrive1
>>>>>>> random   3372  off rand 17311067694306724737
>>>>>>
>>>>>> That offset is crazy big - I'm sure it's bigger than a petabyte so my
>>>>>> guess is that something is overflowing. If you use --size=27g does the
>>>>>> job go through?
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> I don’t see this issue if I use bs=8K or I use ba=512,8K, etc.
>>>>>>
>>>>>> --
>>>>>> Sitsofe | http://sucs.org/~sits/
>>>>> Hi Sitsofe,
>>>>>
>>>>> Thanks for the reply!
>>>>>
>>>>> Yes; If I use --size=27G or if provide the exact size that the OS
>>>>> displays, then the job goes through.
>>>>
>>>> Are you running a 32-bit or 64-bit build of fio?
>>>>
>>>> -- 
>>>> Jens Axboe
>>>>
>>> 32 bit.
>>
>> I thought so. I see a few 32-bit issues with huge devices. One of them is
>> this one:
>>
>> http://git.kernel.dk/cgit/fio/commit/?id=604d3f5bd9f2b985568593c23f8292cbc7f4044c
>>
>> but I'm sure there are others, I'll try and reproduce and get this fixed.
>>
>> -- 
>> Jens Axboe
>>
> I see the same issue even with 64 bit fio build.

The difference is that an unsigned long on 64-bit windows builds is still
32-bit, whereas it's 64-bit on linux. So the easiest for me is to test on
32-bit linux, which _probably_ then hits the same thing...

-- 
Jens Axboe


