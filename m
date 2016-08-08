Return-Path: <axboe@kernel.dk>
Subject: Re: Recent changes (master)
References: <20160808120002.427E02C00A2@kernel.dk>
 <415126992.423440.1470663079681.JavaMail.zimbra@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f2b10ca9-1e6f-800e-62c0-019efbd9aed8@kernel.dk>
Date: Mon, 8 Aug 2016 07:47:23 -0600
MIME-Version: 1.0
In-Reply-To: <415126992.423440.1470663079681.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <evelu@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/08/2016 07:31 AM, Erwan Velu wrote:
> Hey Jens,
>
> Isn't that dangerous to sum many unsigned integers into a signed int ?
> Couldn't this trigger overflows ?
> +                sum += io_u_plat[j + k];

It'd probably be more appropriate to have it be an unsigned long at 
least, then we could kill the cast as well when we print it.

-- 
Jens Axboe


