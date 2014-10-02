Return-Path: <axboe@kernel.dk>
Message-ID: <542CA321.5090608@kernel.dk>
Date: Wed, 01 Oct 2014 18:58:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: linux /dev and normal files
References: <94D0CD8314A33A4D9D801C0FE68B402958CC5D81@G4W3202.americas.hpqcorp.net> <542B52B3.5060908@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC5EBE@G4W3202.americas.hpqcorp.net> <542B5632.8030404@kernel.dk> <542B784F.5090405@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958CC85F9@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CC85F9@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On 2014-10-01 17:52, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Tuesday, 30 September, 2014 10:43 PM
>> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
>> Cc: Sitsofe Wheeler; Jon Tango
>> Subject: Re: linux /dev and normal files
>>
>> On 2014-09-30 19:17, Jens Axboe wrote:
>>> On 2014-09-30 19:12, Elliott, Robert (Server Storage) wrote:
>>>>
>>>>
>>>>> -----Original Message-----
>>>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>>>> ...
>>>>> I'd much rather keep fio ignorant of any "special" directories, even if
>>>>> it means that sometimes you do potentially run into issues like the
>>>>> above, where you specify a block device that does not exist.
>>>>
>>>> How about an option in the script:
>>>> direct=2   file must exist and be a block device, otherwise skip it
>>>
>>> Might be a bit nasty to overload direct= like that. But I'd be open to
>>> adding an option that says must_be_bdev or something, which can be a
>>> bool as well.
>>
>> Totally untested patch attached (it compiles). There's a new option,
>> filetype. If not set, if will allow any file type. Can be set to:
>>
>> any        default, allow any file type
>> file       regular file
>> bdev       block device
>> chardev    character device
>> pipe       pipe
>>
>> So for your case, you'd set
>>
>> filetype=bdev
>>
>> and you'd avoid the issue. Note that it only works for files specified
>> with filename=. Any other way of adding a file (blktrace replay,
>> opendir=, or fio added files when no filename= given) will ignore the
>> filetype setting.
>
> Tested with 16 devices sdr to sdag, where sdaf and sdag are
> offline.
>
> It prints a message about sdaf and exits, and does not
> create a normal file in that location:
> parse    11480 [drive_af]
> parse    11480 Parsing section [drive_af]
> file     11480 dup files: 0
> parse    11480 filename=/dev/sdaf
> parse    11480
> parse    11480 [drive_ag]
> parse    11480 handle_option=filename, ptr=/dev/sdaf
> parse    11480 __handle_option=filename, type=5, ptr=/dev/sdaf
> file     11480 add file /dev/sdaf
> file     11480 resize file array to 1 files
> fio: dropping file '/dev/sdaf' of wrong type
> fio: wanted bdev, got file
> fio: failed parsing filename=/dev/sdaf
> fio: job drive_af dropped
> parse    11480 free options
> parse    11480 free options
> io       11480 ioengine cpuio unregistered
> io       11480 ioengine mmap unregistered
> io       11480 ioengine sync unregistered
> ...
>
> compared to a bdev that exists:
> parse    11480 handle_option=filename, ptr=/dev/sdae
> parse    11480 __handle_option=filename, type=5, ptr=/dev/sdae
> file     11480 add file /dev/sdae
> file     11480 resize file array to 1 files
> file     11480 file 0x7f7903703a90 "/dev/sdae" added at 0
> io       11480 load ioengine libaio
> parse    11480 init options
> drive_ae: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=96
> file     11480 dup files: 1
> io       11480 load ioengine libaio
>
> That is because the do {} while (!ret) loop in
> __parse_jobs_ini gives up on the first add_job failure.
> add_job calls parse_options which calls handle_option
> which fails.
>
> It might be better to continue to attempt to run the
> other jobs.

We should just go for the simpler create/nocreate solution, I prefer 
that. This is too involved, and it's hard to get all the cases right 
since there are a bunch of different ways that files are added. Which 
was why this patch only focused on filename=, since that is the one that 
is the most interesting. But it still isn't pretty. If we add the 
allow_file_create option, it's basically a two-liner change in a few 
places to not use O_CREAT.

-- 
Jens Axboe


