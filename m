Return-Path: <erwan@seanodes.com>
Message-ID: <49242C63.2040005@seanodes.com>
Date: Wed, 19 Nov 2008 16:10:27 +0100
From: Erwan Velu <erwan@seanodes.com>
MIME-Version: 1.0
Subject: Re: Passing argument to both write_bw_log & write_lat_log leads to
 segfault
References: <4923F729.1030200@seanodes.com> <20081119112829.GA26308@kernel.dk>
In-Reply-To: <20081119112829.GA26308@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote:

[....]
> Wow, you are handy at finding old bugs that nobody has hit :-). The
> below should fix it.
>   
Hehe :p
> Generally, fio always wants a '=' to assign a value to a parameter. But
> of course the parser should not crash...
>   
Ok. It that configuration correct ?

[global]
bsrange=64k-128k,64k-128k
direct=1
ioengine=libaio
iodepth=64
zonesize=256m
zoneskip=2g

[/dev/sdb]
rw=read
write_bw_log=read-bw
write_lat_log=read-lat

[/dev/sdb]
stonewall
rw=write
write_bw_log=write-bw
write_lat_log=write-lat

If yes, I have a problem because I only have files called : sdb_clat.log 
& sdb_slat.log

-- 
Erwan Velu
Pre-Sales Engineer
Seanodes
http://www.seanodes.com
+33 (0)1 41 22 13 83


