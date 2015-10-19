Return-Path: <axboe@kernel.dk>
Subject: Re: Threading vs forking
References: <CAF+0mvnWjT5wMpCZzsC6oN_7eobbsqGXdvqdJLxO9M0HFTH9UA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <562500D9.2020900@kernel.dk>
Date: Mon, 19 Oct 2015 08:40:25 -0600
MIME-Version: 1.0
In-Reply-To: <CAF+0mvnWjT5wMpCZzsC6oN_7eobbsqGXdvqdJLxO9M0HFTH9UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/10/2015 09:57 PM, Matthew Eaton wrote:
> Hello fio group,
>
> I have been wondering is there any point in telling fio to use threads
> rather than forking on a linux platform? Is there any benefit?

Fio is no different than other programs in that regard. Benefits include 
cheaper switching between threads, downsides include things like shared 
mm that can hurt you a bit since the threads share the mmap_sem. From 
fio's point of view, the option is there so you can choose what best 
models the target application.


-- 
Jens Axboe


