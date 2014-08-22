Return-Path: <axboe@kernel.dk>
Message-ID: <53F7942C.9030709@kernel.dk>
Date: Fri, 22 Aug 2014 14:04:12 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: buffer_pattern usage question
References: <3DB5F5EE-7D4F-487B-B757-BAD37D041DEB@datrium.com> <53F760AB.9060908@kernel.dk>
In-Reply-To: <53F760AB.9060908@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Surendar Chandra <surendar@datrium.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-08-22 10:24, Jens Axboe wrote:
> On 2014-08-21 20:01, Surendar Chandra wrote:
>> Could you please help me with this setup
>>
>>     filename=fio-data
>>     size=4k
>>     rw=write
>>     buffer_pattern="HELLO"
>>
>> The output still continues to be pseudo random. I even tried
>> buffer_pattern=0xDEADBEEF and other params.
>
> It's not going to take a string, it needs to be a decimal of hexidecimal
> number. I added some code to error out if it fails parsing this now.
>
> buffer_pattern=0xDEADBEEF should work, and does for me:
>
> axboe@lenny:/home/axboe/git/fio $ hexdump fio-data
> 0000000 beef dead beef dead beef dead beef dead
> *
> 0001000

I added the string support now as well, it was pretty trivial.


-- 
Jens Axboe


