Return-Path: <axboe@kernel.dk>
Message-ID: <542C0DC8.30409@kernel.dk>
Date: Wed, 01 Oct 2014 08:20:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net>	<542B52B3.5060908@kernel.dk>	<94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net>	<542B5632.8030404@kernel.dk>	<542B784F.5090405@kernel.dk> <CALjAwxgcY+37VT1DQB+J4HxciMkJPy97qAhwG25aLLOCC2Nb4A@mail.gmail.com>
In-Reply-To: <CALjAwxgcY+37VT1DQB+J4HxciMkJPy97qAhwG25aLLOCC2Nb4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On 2014-10-01 01:36, Sitsofe Wheeler wrote:
> On 1 October 2014 04:43, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-09-30 19:17, Jens Axboe wrote:
>>>
>>> On 2014-09-30 19:12, Elliott, Robert (Server Storage) wrote:
>>>>
>>>>> -----Original Message-----
>>>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>>>>>
>>>>> I'd much rather keep fio ignorant of any "special" directories, even if
>>>>> it means that sometimes you do potentially run into issues like the
>>>>> above, where you specify a block device that does not exist.
>>>>
>>>> How about an option in the script:
>>>> direct=2   file must exist and be a block device, otherwise skip it
>>>
>>> Might be a bit nasty to overload direct= like that. But I'd be open to
>>> adding an option that says must_be_bdev or something, which can be a
>>> bool as well.
>>
>> So for your case, you'd set
>>
>> filetype=bdev
>
> How about a create parameter which defaults to create=1 giving the
> current behaviour and create=0 where the job fails if the file doesn't
> already exist? It won't catch as much but should be portable.

Agree, that will be both easier to maintain and probably just as useful 
as the more expanded options. Lets call it 'allow_file_create'.

-- 
Jens Axboe


