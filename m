Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.104.106.3]:42648 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab1JVQvH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 22 Oct 2011 12:51:07 -0400
Message-ID: <4EA2F479.3020607@kernel.dk>
Date: Sat, 22 Oct 2011 18:51:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug in io_u buf calculaiton.
References: <CAHwYU7uw-Jg5wkZ_NTpyT1cFgAe0G2pYQaUOjef3Bx_0sXb2YA@mail.gmail.com>
In-Reply-To: <CAHwYU7uw-Jg5wkZ_NTpyT1cFgAe0G2pYQaUOjef3Bx_0sXb2YA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jagadish Kumar <jagadish.mukku@gmail.com>
Cc: fio@vger.kernel.org

On 2011-10-21 07:49, Jagadish Kumar wrote:
> Hello,
> following are the details of the bug in fio.
> 
> This bug in fio can show up as corruption of data when performing verify.
> 
> Description:
> ----------------
> 
> if  the product of block size and queudepth is greater than 4GB, io_u
> buffer will not
> be assigned properly due to overflow.
> 
> fio --bsrange=256k-4m --ioengine=libaio --iodepth=2064 --direct=1
> --name=job3 --offset=2GB --size=14GB --rw=write
> --verify_pattern=0xdeadbeef --filename=/dev/sdb
> 
> can show false corruption.
> 
> Version:
> -----------
> 1.58
> 
> Explanation:
> -----------------
> 
> in a loop fio tries to assign the data buffer to each i/o request.
> 
> 
> static int init_io_u(struct thread_data *td)
> {
>         struct io_u *io_u;
>         unsigned int max_bs;
>         int cl_align, i, max_units;
>         char *p;
> ...
>          p = td->orig_buffer;
> ...
>          for (i = 0; i < max_units; i++) {
> ...
>                     io_u->buf = p + max_bs * i;
>          }
> }
> 
> at max_bs=4M i=1024, the integer overflows and the addresses are being
> used again.
> i,e i/o request 1024 will have the same data buffer as that of i/o request 0.
> 
> This is seen from fio debug log.
> 
> mem 11164 io_u alloc 0x219f530, index 0
> mem 11164 io_u 0x219f530, mem 0x7f09bb62d000
> mem 11164 io_u alloc 0x219f820, index 1
> mem 11164 io_u 0x219f820, mem 0x7f09bba2d000
> 
> 
> mem 11164 io_u alloc 0x225b530, index 1024
> mem 11164 io_u 0x225b530, mem 0x7f09bb62d000
> mem 11164 io_u alloc 0x225b820, index 1025
> mem 11164 io_u 0x225b820, mem 0x7f09bba2d000
> 
> the fix is as follows:
> 
>                         io_u->buf = p + (unsigned long long)max_bs * i;

Thanks, excellent bug report! I committed this fix:

http://git.kernel.dk/?p=fio.git;a=commitdiff;h=cf00f975d506d20ad5f02ee9dd8fec17af74bb2f

since it's a little simpler and avoids the overflow as well. Patch has
gone into stable-1.x and master branches.

-- 
Jens Axboe

