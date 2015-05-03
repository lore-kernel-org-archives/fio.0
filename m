Return-Path: <chamarthy.raju@gmail.com>
MIME-Version: 1.0
Date: Sun, 3 May 2015 20:00:49 +0800
Message-ID: <CABtFm2Vmn_u39=pXTKKv9AsDBu=BM9gmSpUmtQpqFGm5Uy00yA@mail.gmail.com>
Subject: Unexpected runtime when running FIO in time based
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

I have a workload to write 10m to a file in a pattern or 1's and 0's
alternatively for each pass. I used stonewall to write and wait for
each job to finish.
Everything work fine till i specify runtime and time_based parameters
to run the same for a minute. It sees FIO is taking more time than the
specified timelines.

While running, the output constantly displays a static eta for a long
time and then completes

Jobs: 1 (f=1): [W(1),P(3)] [13.0% done] [0KB/3527MB/0KB /s] [0/3527/0
iops] [eta 01m:00s]
Jobs: 1 (f=1): [_(1),w(1),P(2)] [61.3% done] [0KB/3639MB/0KB /s]
[0/3639/0 iops] [eta 01m:00s]
Jobs: 1 (f=1): [_(1),w(1),P(2)] [63.9% done] [0KB/3580MB/0KB /s]
[0/3580/0 iops] [eta 01m:00s]
Jobs: 1 (f=1): [_(2),w(1),P(1)] [71.6% done] [0KB/3644MB/0KB /s]
[0/3644/0 iops] [eta 01m:00s]
Jobs: 1 (f=1): [_(2),w(1),P(1)] [73.2% done] [0KB/3614MB/0KB /s]
[0/3614/0 iops] [eta 01m:00s]
Jobs: 1 (f=1): [_(3),W(1)] [78.0% done] [0KB/3582MB/0KB /s] [0/3582/0
iops] [eta 00m:53s]
Jobs: 1 (f=1): [_(3),W(1)] [86.7% done] [0KB/3527MB/0KB /s] [0/3527/0
iops] [eta 00m:32s]
Jobs: 1 (f=1): [_(3),W(1)] [98.8% done] [0KB/3560MB/0KB /s] [0/3560/0
iops] [eta 00m:03s]

Total time taken for the job to complete is:
real    4m1.225s
user    0m4.816s
sys     3m55.760s

Without specifying the runtime parameters, the following is the time
taken for one pass

real    0m1.339s
user    0m0.232s
sys     0m0.108s

# fio -v
fio-2.2.7-26-g9451b

# cat test1.fio
[global]
ioengine=libaio
size=1m
blocksize=1024k,1024k
iodepth=8
iodepth_batch=4
iodepth_low=2
;runtime=60
;time_based
filename=testfile_test1
numjobs=1

[pattern_one_seq_write]
buffer_pattern=0xff
readwrite=write

[pattern_zero_rand_write]
zero_buffers
readwrite=randwrite
percentage_random=100
stonewall

[pattern_one_rand_write]
buffer_pattern=0xff
readwrite=randwrite
percentage_random=100
stonewall

[pattern_zero_seq_write]
zero_buffers
readwrite=write
stonewall


--
Srinivasa R Chamarthy

