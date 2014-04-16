Return-Path: <axboe@kernel.dk>
Message-ID: <534E96B6.2060907@kernel.dk>
Date: Wed, 16 Apr 2014 08:41:58 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Question about FIO sequential writes
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com> <534DB18A.4050507@kernel.dk> <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com> <534DE08D.2070604@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Xiaofei Du <xiaofei.du008@gmail.com>
Cc: fio <fio@vger.kernel.org>, aaronc <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

On 04/15/2014 10:47 PM, Elliott, Robert (Server Storage) wrote:
>> On 2014-04-15 17:04, Xiaofei Du wrote:
>>> [global]
>>> bs=4k
>>> size=100m
>>> direct=1
>>> filename=100mfile
>>>
> 
> A few more tips:
> - I don't see ioengine=libaio or iodepth=nn in that excerpt.
> - use iostat -mxyz 2 while the test is running to see the IO sizes that the block layer is sending to the LLD, how many block layer merges are occurring, the IO depth being maintained to the LLD, and the IOPS rate.
> - set /sys/block/<drive name>/queue/nomerges to 2 to disable block layer/scheduler merging.
> - your LLD or controller might have its own cache and/or do sequential merging (coalescing) too.  What controller are you using?
> - by using a file, you don't know whether it's on the inner tracks or outer tracks or somewhere in between.
> - by using a file, you don't know whether it's fragmented, making sequential transfers really random to the drive.
> - by using a file, if using an "advanced format" drive (with large physical sectors), you have to be wary of unaligned transfers.  Is the partition aligned so all the accesses really go to the drive aligned to 4 KiB boundaries? 
> - by using a tiny file size like 100 MiB, writes could easily get buffered in a write cache somewhere along the way; 64 and 128 MiB HDD volatile write cache sizes are common nowadays, and RAID controllers have multi-GiB non-volatile write caches.
> - although you didn't report results with reads, beware that the drive could end up serving all 100 MiB of random read data from its cache (reads can always be cached, volatile or not), while throwing away sequential prefetched read data after returning that data because the drive does not expect the data to be read again.
> - to avoid filesystem interference, directly access the drive with /dev/disk/by-path, /dev/disk/by-id, or /dev/sdNN type names (or \\.\PhysicalDriveNN in Windows).  If using /dev/sdNN or PhysicalDriveNN, be very careful not to overwrite your boot drive, since the mapping can change every reboot; I don't think fio provides any protection from doing so.

Fio has a safeguard --readonly switch which will protect you from doing
something stupid. It wont help you from using the wrong drive, but it's
useful to know that your config doesn't contain writes that will then be
issued to a drive you don't want to destroy the data on.


-- 
Jens Axboe


