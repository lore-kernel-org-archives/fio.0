Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
Sender: bart.vanassche@gmail.com
In-Reply-To: <20100202085305.GA13771@kernel.dk>
References: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com>
	 <20100202074135.GX13771@kernel.dk>
	 <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com>
	 <20100202081941.GY13771@kernel.dk>
	 <e2e108261002020024s7502f97eib68fd7489a50d061@mail.gmail.com>
	 <20100202083108.GZ13771@kernel.dk> <20100202085305.GA13771@kernel.dk>
Date: Tue, 2 Feb 2010 10:06:34 +0100
Message-ID: <e2e108261002020106x713dc3a0h40ee37c855dc7dc0@mail.gmail.com>
Subject: Re: Writing to /dev/null with fio
From: Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Feb 2, 2010 at 9:53 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> I committed a fix for this, it'll do it automatically now if you use
> latest -git. A quick test here on my desktop machine:
>
> fio --bs=4k --size=64G --buffered=1 --rw=write --verify=0
> --name=/dev/null --gtod_reduce=1 --disk_util=0
>
> 10378MB/s
>
> fio --bs=512 --size=8G --buffered=1 --rw=write --verify=0
> --name=/dev/null --gtod_reduce=1 --disk_util=0
>
> 1306MB/s
>
> dd if=/dev/zero of=/dev/null bs=4k count=16M
> 68719476736 bytes (69 GB) copied, 9,71235 s, 7,1 GB/s
>
> dd if=/dev/zero of=/dev/null bs=512 count=8M
> 4294967296 bytes (4,3 GB) copied, 3,3574 s, 1,3 GB/s
>
> So the same for 512b buffers, fio is much quicker for 64k (must be due
> to proper aligning). I'll boot the big box and see what that says.

Thanks, this helps: the ratio of fio to dd runtime is now reduced to
1.25 for a block size of 512 bytes and 0.96 for a block size of 4096
bytes.

$ count=$((2**25)); for bs in 512 4096; do size=$((count*bs)); dd
if=/dev/zero of=/dev/null bs=$bs count=$count 2>&1|grep copied; fio
--bs=$bs --size=$size --buffered=1 --rw=write --verify=0
--name=dev-null --filename=/dev/null 2>&1|grep runt; done
17179869184 bytes (17 GB) copied, 22.1017 s, 777 MB/s
  write: io=16,384MB, bw=621MB/s, iops=1,272K, runt= 26381msec
137438953472 bytes (137 GB) copied, 27.5793 s, 5.0 GB/s
  write: io=128GB, bw=4,964MB/s, iops=1,271K, runt= 26407msec

Bart.

