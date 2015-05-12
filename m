Return-Path: <axboe@kernel.dk>
Message-ID: <55521D16.4070706@kernel.dk>
Date: Tue, 12 May 2015 11:32:38 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net> <542B5632.8030404@kernel.dk> <542B784F.5090405@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC85F9@G4W3202.americas.hpqcorp.net> <542CA321.5090608@kernel.dk> <542CA44D.1030700@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CCAA76@G4W3202.americas.hpqcorp.net> <542D9A26.6060204@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295A858295@G9W0745.americas.hpqcorp.net> <551EDAD7.3050803@kernel.dk>
In-Reply-To: <551EDAD7.3050803@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On 04/03/2015 02:24 PM, Jens Axboe wrote:
> On 04/03/2015 12:13 PM, Elliott, Robert (Server Storage) wrote:
>>
>>
>>> -----Original Message-----
>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>>> Behalf Of Jens Axboe
>>> Sent: Thursday, October 2, 2014 1:32 PM
>>> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
>>> Cc: Sitsofe Wheeler; Jon Tango
>>> Subject: Re: linux /dev and normal files
>>>
>>> On 10/02/2014 12:21 PM, Elliott, Robert (Server Storage) wrote:
>>>>>>> It might be better to continue to attempt to run the
>>>>>>> other jobs.
>>>>>>
>>>>>> We should just go for the simpler create/nocreate solution, I prefer
>>>>>> that. This is too involved, and it's hard to get all the cases right
>>>>>> since there are a bunch of different ways that files are added. Which
>>>>>> was why this patch only focused on filename=, since that is the one
>>> that
>>>>>> is the most interesting. But it still isn't pretty. If we add the
>>>>>> allow_file_create option, it's basically a two-liner change in a few
>>>>>> places to not use O_CREAT.
>>>>>
>>>>> That took roughly 4 minutes... Does this work? Set allow_file_create=0
>>>>> to disallow creating new files.
>> ...
>>>
>>> OK, let me test that, will spin a new one.
>>
>> I don't think this ever got added.
>
> It didn't... Did you re-test? No reason we can't get it added, I'll look
> into it start next week.

Robert, I added this. Can you check current -git and see if it behaves 
as expected for you?

-- 
Jens Axboe


