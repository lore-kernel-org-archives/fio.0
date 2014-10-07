Return-Path: <axboe@kernel.dk>
Message-ID: <54345B52.7060306@kernel.dk>
Date: Tue, 07 Oct 2014 15:29:54 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/07/2014 11:38 AM, Neto, Antonio Jose Rodrigues wrote:
> Hi All,
> 
> This is neto from Brazil
> 
> How are you?
> 
> One small suggestion:
> 
> Running Client and Server architecture on FIO, we need to have all config
> files "locally" to run it.
> 
> 
> Nossa Senhora:tools neto$ ls
> 151 152 fio
> 
> 
> 
> Nossa Senhora:tools neto$ ./fio --client 10.61.109.151 151 --client
> 10.61.109.152 152
> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
> flags=1
> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
> flags=1
> <s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
> bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
> iodepth=1
> ioengine=libaio, iodepth=1
> 
> If we are doing a test in an HPC environment with hundred of files,
> wouldn't be easier to try to point to a single location for the file and
> access it remotely (we won't need to copy it locally).
> 
> 
> For example:
> 
> ./fio --client 10.61.109.151 --remote-config /root/fio/151 --client
> 10.61.109.152 --remote-config /root/fio/152
> 
> 
> Thoughts?

That's a good idea, would not be hard to insert that step of having the
remote fio server load a local config file. I'll look into that.

-- 
Jens Axboe


