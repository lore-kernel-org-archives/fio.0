Return-Path: <axboe@kernel.dk>
Received: from [192.168.3.11] (66.29.187.50.static.utbb.net. [66.29.187.50])
        by mx.google.com with ESMTPSA id c3sm8271018pdk.3.2014.09.27.13.03.54
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Sep 2014 13:03:55 -0700 (PDT)
Message-ID: <54271828.2040005@kernel.dk>
Date: Sat, 27 Sep 2014 14:03:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: New tools and changes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,

I have committed a few new tools to the fio repo, and enabled the 
building of these tools (and the older ones) by default now. Previously, 
you'd have to do

$ make t/<toolname>

manually to build them, that is no longer the case. Anyway, the new 
tools are:

t/dedupe: this is a dedupe checker. You run this on a device or a file, 
and it will tell you how well the blocks on that device will dedupe. The 
block size defaults to 4KB, but can be set to anything you wish. By 
default this will use a bloom filter, which (for my testing) is within 
1% or better of the actually fully tracked check. You can do a full 
check with -B0 to turn off the bloom, however that can consume large 
amounts of memory on larger devices. If you are truly paranoid, there's 
a -c option as well to do full checking in case there are checksum 
collisions. The checksum used is md5. The output looks like this:

axboe@nelson:/home/axboe/git/fio $ sudo t/dedupe /dev/sda5
Will check </dev/sda5>, size <49999249408>, using 8 threads
Threads(8): 12206848 items processed
Extents=12206848, Unique extents=1625328
De-dupe ratio: 1:6.51
Fio setting: dedupe_percentage=87

dedupe will default to using as many threads as there are CPUs in the 
system, to speed things up. This is also settable. dedupe will also give 
you the fio setting to use to create a write workload with similar 
dedupability. The dedupe_percentage is a new option that allows you to 
set that.

t/btrace2fio: this is a tool that takes a blkparse binary dump and 
generates a fio job file matching that dump. This tools needs a bit more 
development effort, and I'd welcome people joining in and helping out. 
Right now it figures out the queue depth, read vs write mix, block size 
distribution, etc. It makes no attempt to collapse identical threads 
into one job with numjobs=x for readability, however.

I should write up some documentation for these tools, and will do so in 
the not-so-distant future. The dedupe tool probably needs a bit of error 
checking and handling and option range checking, but apart from that, 
it's mostly done. The btrace2fio tool is a bit more rough around the 
edges. I'd welcome feedback, suggestions, improvements for both, as usual.

-- 
Jens Axboe


