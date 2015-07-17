Return-Path: <axboe@kernel.dk>
Message-ID: <55A912DB.8030306@kernel.dk>
Date: Fri, 17 Jul 2015 08:36:11 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: PATCH: Don't lose pending completions on exit in time- or size-based
 job with asynchronous I/O engine
References: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>
In-Reply-To: <CANvN+ekBVCAMge-A9dMTeOnXSJ7sZ9OdQ_ZMeqgcTsoa8J0bJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/17/2015 08:30 AM, Andrey Kuzmin wrote:
> Probably worth adding to do_verify() as well.

Might be better to ensure that they are reaped when we break out of the 
loop instead?

-- 
Jens Axboe


