Return-Path: <axboe@kernel.dk>
Message-ID: <54333D02.8040702@kernel.dk>
Date: Mon, 06 Oct 2014 19:08:18 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio exits with 0 with some bad job files
References: <54331757.8000000@cran.org.uk> <54333B40.8010800@kernel.dk>
In-Reply-To: <54333B40.8010800@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-06 19:00, Jens Axboe wrote:
> On 2014-10-06 16:27, Bruce Cran wrote:
>> If you run fio with --parse-only and a job file such as
>> examples/tiobench-example.fio that's had the semi-colons removed from
>> the first two lines, fio prints an error message but still exits with 0:
>>
>> % ./fio examples/tiobench-example.fio --parse-only
>> fio: option <tiobench like setup, add more fX files between the
>> stonewalls to> outside of [] job section
>> % echo $?
>> 0
>> %
>>
>> I'd have expected it to exit with a non-zero value.
>
> Not too surprising, don't think any of that was really audited. But a
> bug, of course, will look at fixing that up. Is it consistent across any
> error, or did you just notice this particular one?

That particular one was a silly one, affected the non parse-only as 
well. It ended up erroring out on no jobs being defined, so this 
improves the behavior for that too.

http://git.kernel.dk/?p=fio.git;a=commit;h=0e9c21a29431e43cd73c83c13271ee6e94fe1328


-- 
Jens Axboe


