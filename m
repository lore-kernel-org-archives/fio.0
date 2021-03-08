Return-Path: <axboe@kernel.dk>
Subject: Re: [Question] A question about t/io_uring.c
References: <CAKvRR0TG4L3NqNiOMyh2zb0tA7vfuc_L8kU5ropGrY3fJm5GAg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <dbf38577-2932-ad2a-941f-6b4ed2edbbac@kernel.dk>
Date: Mon, 8 Mar 2021 15:27:20 -0700
MIME-Version: 1.0
In-Reply-To: <CAKvRR0TG4L3NqNiOMyh2zb0tA7vfuc_L8kU5ropGrY3fJm5GAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Hongwei Qin <glqinhongwei@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2/21/21 4:09 AM, Hongwei Qin wrote:
> Hi,
> 
> I found two implementation details in t/io_uring.c quite interesting.
> Both are in the prep_more_ios() function.
> 
> 1.
> reading the sq ring head is not protected using something like
> READ_ONCE() or smp_read_acquire().
> According to https://www.kernel.org/doc/Documentation/memory-barriers.txt
> ```
> It _must_not_ be assumed that the compiler will do what you want
> with memory references that are not protected by READ_ONCE() and
> WRITE_ONCE().  Without them, the compiler is within its rights to
> do all sorts of "creative" transformations, which are covered in
> the COMPILER BARRIER section.
> ```
> 
> Is it possible that the modifications to the sqe using init_io() get
> reordered prior to reading the sq ring head?

I had to fix another bug in there related to SQPOLL, and I updated the
rest to do the proper atomic load acquire and store releases. So the
current version in git should be proper. Doesn't really matter on x86,
but it does on other archs.


> 2.
> Writing to the sq ring tail is not protected using something like
> smp_store_release.
> Even according to the article "Efficient IO with io_uring", adding an
> sqe should be like:
> ```
> write_barrier();
> sqring->tail = tail;
> write_barrier();
> ```
> However, the first write barrier is missing in the t/io_uring.c
> Is it possible that the memory stores get reordered?

It's because the documentation needs updating, there's no risk of
reordering of the sqe and the tail update. Hence only one store release
is needed for this case.

-- 
Jens Axboe


