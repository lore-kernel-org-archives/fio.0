Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CABtFm2UfFJ0m78qOh5C=-+5p3qQhCg77OdHXQtK1EdWY9aOHbA@mail.gmail.com>
References: <CABtFm2X1th74qPOKaT+UG7rA-X8bjiADLE7x3n3qBjS7YAibNg@mail.gmail.com>
 <185b7fb1-e59a-c0e4-9a8a-ed5a21b441e8@kernel.dk> <93206ce7-e4ea-2188-7809-48ea44f1aafa@kernel.dk>
 <CABtFm2UfFJ0m78qOh5C=-+5p3qQhCg77OdHXQtK1EdWY9aOHbA@mail.gmail.com>
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Date: Thu, 4 Aug 2016 18:53:01 +0800
Message-ID: <CABtFm2VX4H3579bJ9FbB+rAjW5WT4OEm_UnATg_pPYGD=aCrRQ@mail.gmail.com>
Subject: Re: create_on_open fails with "err=5/file:backend.c:498"
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Tried the latest git, i do not get the failure now. But i have the
following questions

1) The initial failure was due to the fact that there were no files in
the directory to read. In that case, it may be expected that we write
the files first and then do read (workload defaults to read if --rw is
not specified).
2) For Write or mixed jobs, create_on_open is expected not to layout
the IO files before the workload. Currently with the latest git, i see
that it says that files are layed out (but the size is 0) before the
workload starts. If i do not specify create_on_open, its not laying
out files at all. And i have to specify create_on_open=0 explicitly to
layout the files completely.

With create_on_open=1
# fio --name=test --directory=/testdata --nrfiles=10 --size=1g
--refill_buffers=1 --direct=1 --create_on_open=1 --rw=write
test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.13-38-gff56
Starting 1 process
test: Laying out IO file(s) (10 file(s) / 0MB)
Jobs: 1 (f=10): [W(1)] [100.0% done] [0KB/5684KB/0KB /s] [0/1421/0
iops] [eta 00m:00s]

Without create_on_open (No Initial layout of files)
# fio --name=test --directory=/testdata --nrfiles=10 --size=1g
--refill_buffers=1 --direct=1 --rw=write
test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.13-38-gff56
Starting 1 process
Jobs: 1 (f=10): [W(1)] [8.2% done] [0KB/6612KB/0KB /s] [0/1653/0 iops]
[eta 02m:37s]

With create_on_open=0 (its laying out files)
# fio --name=test --directory=/testdata --nrfiles=10 --size=1g
--refill_buffers=1 --direct=1 --rw=write --create_on_open=0
test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
fio-2.13-38-gff56
Starting 1 process
test: Laying out IO file(s) (10 file(s) / 1023MB)
Jobs: 1 (f=10): [W(1)] [5.1% done] [0KB/6328KB/0KB /s] [0/1582/0 iops]
[eta 02m:49s]

Just wanted to get confirmation on what's the default behavior. I was
under the impression that if create_on_open is not specified, default
behavior is to layout the files for jobs.

Thanks.


--
Srinivasa R Chamarthy


On Thu, Aug 4, 2016 at 12:01 AM, Srinivasa Chamarthy
<chamarthy.raju@gmail.com> wrote:
> It's failing when there are no files exist in the directory. If I have files
> that already exist, it's working. I think that's expected as it defaults to
> read if --rw is not specified.
>
> Will try the -git latest and let you know.
>
>
> On Wed 3 Aug, 2016, 11:54 PM Jens Axboe, <axboe@kernel.dk> wrote:
>>
>> On 08/03/2016 08:42 AM, Jens Axboe wrote:
>> > On 08/02/2016 07:29 AM, Srinivasa Chamarthy wrote:
>> >> Hi All,
>> >>
>> >> With the latest version of FIO, i see that create_on_open failing
>> >> always with error "err=5/file:backend.c:498"
>> >>
>> >> # fio --name=test --directory=/testdata --nrfiles=10 --size=1g
>> >> --refill_buffers=1 --direct=1 --create_on_open=1
>> >> test: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
>> >> fio-2.13-28-g059b6
>> >> Starting 1 process
>> >> fio: pid=8439, err=5/file:backend.c:498, func=full resid,
>> >> error=Input/output error
>> >>
>> >> test: (groupid=0, jobs=1): err= 5 (file:backend.c:498, func=full
>> >> resid, error=Input/output error): pid=8439: Tue Aug  2 10:24:08 2016
>> >>   cpu          : usr=0.00%, sys=0.00%, ctx=1, majf=0, minf=57
>> >>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>> >> >=64=0.0%
>> >>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >> >=64=0.0%
>> >>      complete  : 0=50.0%, 4=50.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> >> >=64=0.0%
>> >>      issued    : total=r=1/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>> >>      latency   : target=0, window=0, percentile=100.00%, depth=1
>> >>
>> >> Run status group 0 (all jobs):
>> >>
>> >> Disk stats (read/write):
>> >>     dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
>> >> aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
>> >> aggrutil=0.00%
>> >>   sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>> >>
>> >> # fio --version
>> >> fio-2.13-28-g059b6
>> >>
>> >> The execution was on RHEL7.2 and CentOS7.2
>> >
>> > Did that ever work for readable workloads? For a writeable workload it
>> > should be fine.
>>
>> I take it back, it should still work. Try current -git, I think I fixed
>> it for you.
>>
>> --
>> Jens Axboe
>>
>

