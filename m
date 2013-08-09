Return-Path: <jiahua@gmail.com>
MIME-Version: 1.0
Reply-To: jiahua@gmail.com
In-Reply-To: <52040589.2050803@kernel.dk>
References: <CA+S_sg4sVwquhtxLpmjQQXiNOBya+6vF0mSbyWZG_Q1YtbPPCA@mail.gmail.com>
	<CA+S_sg4ROD-+qdBKz9VMwMcOn4OrpOTBh9sF=gQEbfT54HZCXw@mail.gmail.com>
	<52040589.2050803@kernel.dk>
Date: Fri, 9 Aug 2013 11:19:13 -0700
Message-ID: <CA+S_sg79AHmGPHZC9A4=z=1i7LjXuxQh2mY5FcCdiKE_JqVURg@mail.gmail.com>
Subject: Re: How to control the number of random I/O's acrossing the whole file/device?
From: Jiahua <jiahua@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I have a 1TB disk and try to do a fixed number, say 1000, random 4KB
I/O's cross the whole disk. If I use size=4MB, I can only touch the
first 4MB range of the disk instead of the whole disk range. If I set
size as 1TB, it will do much more than 1000 I/O's and run too long. As
for time_based, it is not ideal since I cannot control the I/O number
precisely.

On Thu, Aug 8, 2013 at 1:54 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/07/2013 12:57 PM, Jiahua wrote:
>> Sorry to bother you again! Can anyone shed some light here? Or can you
>> give a pointer into the code where I should look at to implement the
>> feature I want?
>>
>> Thanks,
>> Jiahua
>>
>> On Tue, Aug 6, 2013 at 4:19 PM, Jiahua <jiahua@gmail.com> wrote:
>>> Hi all,
>>>
>>> What I want is to touch a file/device randomly but up to a given
>>> number of times. I tried the "size=" option but it also limits the
>>> file size. Is there a way to do that instead of time_based, which is
>>> approximate to my requirement?
>
> Not sure what you as asking here. size= will generally specify the
> region that fio will operate on. If you want to touch it multiple times,
> you could do time_based and/or loops. The region will still be governed
> by size= (or default to the existing total size of the file/device, if
> not given).
>
> --
> Jens Axboe
>

