Return-Path: <axboe@kernel.dk>
Subject: Re: create_on_open fails with "err=5/file:backend.c:498"
References: <CABtFm2X1th74qPOKaT+UG7rA-X8bjiADLE7x3n3qBjS7YAibNg@mail.gmail.com>
 <185b7fb1-e59a-c0e4-9a8a-ed5a21b441e8@kernel.dk>
 <93206ce7-e4ea-2188-7809-48ea44f1aafa@kernel.dk>
 <CABtFm2UfFJ0m78qOh5C=-+5p3qQhCg77OdHXQtK1EdWY9aOHbA@mail.gmail.com>
 <CABtFm2VX4H3579bJ9FbB+rAjW5WT4OEm_UnATg_pPYGD=aCrRQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <86e61b86-3cd8-ee34-31b7-42a4b7254212@kernel.dk>
Date: Thu, 4 Aug 2016 19:39:20 -0600
MIME-Version: 1.0
In-Reply-To: <CABtFm2VX4H3579bJ9FbB+rAjW5WT4OEm_UnATg_pPYGD=aCrRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/04/2016 04:53 AM, Srinivasa Chamarthy wrote:
> Tried the latest git, i do not get the failure now. But i have the
> following questions
>
> 1) The initial failure was due to the fact that there were no files in
> the directory to read. In that case, it may be expected that we write
> the files first and then do read (workload defaults to read if --rw is
> not specified).

Right, but that's similar to how a normal read job without
create_on_open would also layout the files to be able to run the read
workload.

> 2) For Write or mixed jobs, create_on_open is expected not to layout
> the IO files before the workload. Currently with the latest git, i see
> that it says that files are layed out (but the size is 0) before the
> workload starts. If i do not specify create_on_open, its not laying
> out files at all. And i have to specify create_on_open=0 explicitly to
> layout the files completely.
>
> With create_on_open=1
> # fio --name=test --directory=/testdata --nrfiles=10 --size=1g
> --refill_buffers=1 --direct=1 --create_on_open=1 --rw=write
> test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio-2.13-38-gff56
> Starting 1 process
> test: Laying out IO file(s) (10 file(s) / 0MB)
> Jobs: 1 (f=10): [W(1)] [100.0% done] [0KB/5684KB/0KB /s] [0/1421/0
> iops] [eta 00m:00s]
>
> Without create_on_open (No Initial layout of files)
> # fio --name=test --directory=/testdata --nrfiles=10 --size=1g
> --refill_buffers=1 --direct=1 --rw=write
> test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio-2.13-38-gff56
> Starting 1 process
> Jobs: 1 (f=10): [W(1)] [8.2% done] [0KB/6612KB/0KB /s] [0/1653/0 iops]
> [eta 02m:37s]
>
> With create_on_open=0 (its laying out files)
> # fio --name=test --directory=/testdata --nrfiles=10 --size=1g
> --refill_buffers=1 --direct=1 --rw=write --create_on_open=0
> test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> fio-2.13-38-gff56
> Starting 1 process
> test: Laying out IO file(s) (10 file(s) / 1023MB)
> Jobs: 1 (f=10): [W(1)] [5.1% done] [0KB/6328KB/0KB /s] [0/1582/0 iops]
> [eta 02m:49s]
>
> Just wanted to get confirmation on what's the default behavior. I was
> under the impression that if create_on_open is not specified, default
> behavior is to layout the files for jobs.

Right, that was essentially the behaviour before the recent change. With
the recent change, it'll lay them out if it needs to. It needs to, if
the actual job doesn't do it, or if overwrite=1 is set, for instance,
and it's a writable job.

-- 
Jens Axboe


