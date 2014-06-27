Return-Path: <axboe@kernel.dk>
Message-ID: <53ADA00A.7010401@kernel.dk>
Date: Fri, 27 Jun 2014 10:47:06 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: using fio client on 64-bit machine with fio server on 32-bit
 machine
References: <53AD168F.3070403@s3group.com>
In-Reply-To: <53AD168F.3070403@s3group.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Frank D'Arcy <frank.darcy@s3group.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-06-27 01:00, Frank D'Arcy wrote:
> Hi,
> I've been playing around with fio (which is really great thanks)
> with a view to testing hard disks on set-top boxes (which I don't have yet)
> and as prep for this I created a test environment consisting of
> 2 x virtual machines running 32-bit ubuntu (using "hashicorp/precise32"
> from vagrant cloud)
> running on a 64-bit machine with ubuntu 12.04.
>
> I started fio (v2.1.10) running in server mode on both virtual machines
> as follows
> $ fio --server=,8880
>
> and launched 2 fio (v2.1.10) instances in client mode on the host 64-bit
> machine,
> $ fio --client=ip:127.0.0.1,8882 test.fio
> $ fio --client=ip:127.0.0.1,8881 test.fio
> where ports 8881 and 8882 are forwarded to port 8880 on each VM
>
> The sample test.fio (below) runs for 25 seconds
> but the values printed by the clients look garbled.
> eg. runtime is a huge number ("runt= 107374182400000msec")
>
> Same issue is seen when I switched to using latest fio from "git clone"
> and the same issue is seen with all output formats (json, terse, normal)
>
> I changed one of the virtual machines to 64-bit ubuntu (using
> "hashicorp/precise64" from vagrant cloud)
> and the client talking to the fio server on that VM gave the correct
> results (eg. "runt= 25001msec")
> while the client talking to the 32-bit ubuntu VM continued to show
> garbled values.
>
> So it looks like support is not there for client-server setups on
> non-matching architectures ?
> eg. 32-bit client to 64-bit server in this case,
> and perhaps endianess differences would be a problem too? ( but I
> haven't tried that )
>
> Apologies if I've missed this issue raised elsewhere, I did a quick
> search and found no mention of it.
> It's not critical for us, as the simple workaround is to run fio
> standalone on each set-top box
> outputting results to a file and pulling the file back to a central
> machine for parsing.
> Just wanted to raise it if its unknown to you.

Any mix of 32 vs 64-bit and big vs little endian should work, all the 
data structures are sanitized across the wire. So if it doesn't work, 
then that is surely a bug! I'll take a look at this.

-- 
Jens Axboe


