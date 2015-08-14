Return-Path: <axboe@kernel.dk>
Message-ID: <55CE0DA9.6050204@kernel.dk>
Date: Fri, 14 Aug 2015 09:47:53 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: server mode and verify_dump
References: <CALjAwxh7sx3OHw9Gb=gBwet+YqpJNNDzZusNZK7X7bGK0Z06pQ@mail.gmail.com>
In-Reply-To: <CALjAwxh7sx3OHw9Gb=gBwet+YqpJNNDzZusNZK7X7bGK0Z06pQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 08/03/2015 03:12 PM, Sitsofe Wheeler wrote:
> Hi,
>
> I've noticed that when running fio in server mode it's not possible to
> get a dump of using verify_dump when a verify mismatch occurs. Is it
> possible to add a mode where the server process saves the mismatch
> files to its current working directory for inspection later?

That sounds like an oversight. To save time, can you let me know how you 
are invoking fio and with what job file? Should not be that hard to 
fixup, it should just work.

-- 
Jens Axboe


