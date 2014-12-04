Return-Path: <axboe@kernel.dk>
Message-ID: <5480E314.4070206@kernel.dk>
Date: Thu, 04 Dec 2014 15:41:24 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Repeat given pattern with buffer_compress_percentage
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com> <547FCA1C.1000808@kernel.dk> <547FCBC7.20309@kernel.dk> <547FCDC0.3000005@kernel.dk> <CAGmU4NSC=7ZjjnieWxjFs8xqrVjY0gdMGWwJCTRogXKpUzBbcA@mail.gmail.com> <54807D4F.9080207@kernel.dk>
In-Reply-To: <54807D4F.9080207@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karthick Srinivasachary <karthick@pernixdata.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/04/2014 08:27 AM, Jens Axboe wrote:
> On 12/04/2014 12:53 AM, Karthick Srinivasachary wrote:
>> Hi Jens,
>>
>> Thanks for your response and quick fix.. Much appreciated.
>> Tried few things and saw couple issues, summarizing below. Please let
>> me know if I am missing something.
>>
>> 1. Looks like buffer_compress_percentage with verify option is not
>> giving expected compression percentage
>>
>> fio --name=global --rw=write --buffer_compress_percentage=50
>> --name=job1 --filename=/root/test1 --size=100m --refill_buffers
>> --verify=md5
>>
>> lz4 could compress fio data file
>>
>> lz4 /root/test1
>> Compressed 104857600 bytes into 104857715 bytes ==> 100.00%
>
> The verify buffers are filled differently. It will take a bit more code
> juggling to make that honor the buffer_pattern as a fill pattern. I'll
> take a look at it.

Try current -git, should do the right thing for this case now too. And 
it works for the buffer content regeneration, when corruption is 
detected and verify_dump=1 is set.

-- 
Jens Axboe


