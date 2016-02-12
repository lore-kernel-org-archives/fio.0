Return-Path: <axboe@kernel.dk>
Subject: Re: Logging completed IOs only
References: <1499154031.27756078.1455294180577.JavaMail.zimbra@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56BE12F2.5050207@kernel.dk>
Date: Fri, 12 Feb 2016 10:14:26 -0700
MIME-Version: 1.0
In-Reply-To: <1499154031.27756078.1455294180577.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <evelu@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/12/2016 09:23 AM, Erwan Velu wrote:
> Hey,
>
> I was exchanging on the possibility to use fio to perform write test to a device and then check how does the device handled the power failure.
> I thought about using the verify options of it but I was shown that write_iolog does only log IOs that were sent to the device but not the one actually completed.
>
> What do you think about adding an option not to log the IO that were sent but completed ?
>
> That way it would be possible to track what was actually done at the time the log was written.

The verify trigger supports was intended for exactly that use case. 
Looks like that did not make it into the man page (I'll fix that), but 
read section 10 in the HOWTO for an introduction to how they work.

-- 
Jens Axboe


