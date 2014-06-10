Return-Path: <axboe@kernel.dk>
Message-ID: <53966794.6080102@kernel.dk>
Date: Mon, 09 Jun 2014 20:04:04 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: build from cmake
References: <CAKO35LNYsNNzcPqJKiiZ12As698qAo1QOs4piZw=-dB_rrHvyg@mail.gmail.com>
In-Reply-To: <CAKO35LNYsNNzcPqJKiiZ12As698qAo1QOs4piZw=-dB_rrHvyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: George Dowding <gdowding@nutanix.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-06-09 14:51, George Dowding wrote:
> I spent a few hours on this. Might save someone else some time.
>
> I'm working in a larger project that uses cmake for its builds. cmake
> supports adding external projects using the ExternalProject_Add
> function.
>
> But, there is some issue in the fio Makefile that causes a problem
> when run from cmake. I could never reproduce it from the command line.
>
> I was able to get the build to happen by changing the implicit rule
> .c.o to use pattern notation. Not sure if this will work in all cases
> or has other side effects.
>
> Without this change, I was getting this error.
>
> make[4]: *** No rule to make target `gettime.o', needed by `fio'.  Stop.

It seems to work for me (your change), and it should be correct. 
Unfortunately I'm not much of a Makefile expert... So would be nice if 
others could chime in.

-- 
Jens Axboe


