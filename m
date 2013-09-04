Return-Path: <erwan@enovance.com>
Message-ID: <52273BF5.90109@enovance.com>
Date: Wed, 04 Sep 2013 15:56:05 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: How to loop a timebased job
References: <522639CE.2030705@enovance.com> <20130903223727.GB31170@kernel.dk>
In-Reply-To: <20130903223727.GB31170@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 04/09/2013 00:37, Jens Axboe wrote:
> It should work, if it doesn't, I agree it's a bug. It's not certain 
> than anyone has considered this specific use case before. Feel free to 
> fix! Or I can take a look at it tomorrow. 
I think I found the issue but my main question is about priority.

If both time & loops are set, what shall be considered as the key 
element to stop the benchmark.

Today, time have the priority over loops as keep_running() returns if 
time_based while time is handled in do_io().

If I do remove this test in keep_running, the first of the two getting 
the limit will stop the job.
On one hand, we have timebased option to insure time over end of device.
Shall we put a loopbased on the other hand ?

My 2 cents,
Erwan


