Return-Path: <erwan@enovance.com>
Message-ID: <51E5B4C6.9040705@enovance.com>
Date: Tue, 16 Jul 2013 23:01:58 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: Question about exec_string()
References: <51E4F3F6.3030808@enovance.com> <20130716205810.GM22392@kernel.dk>
In-Reply-To: <20130716205810.GM22392@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 16/07/2013 22:58, Jens Axboe wrote:
>
> I'll happily take a patch to include the output into the general logging
> :-). That's the way it should work.
That could be very verbose. Isn't that a problem ?
I though to split it to let user read it later if needed instead of 
flooding the current console.



