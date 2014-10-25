Return-Path: <mark.kirkwood@catalyst.net.nz>
Message-ID: <544B2C19.7070009@catalyst.net.nz>
Date: Sat, 25 Oct 2014 17:50:33 +1300
From: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz> <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
In-Reply-To: <544B1D50.4010101@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org
Cc: "d.gollub@telekom.de >> Daniel Gollub" <d.gollub@telekom.de>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 25/10/14 16:47, Jens Axboe wrote:
>
> Since you're running rbd tests... Mind giving this patch a go? I don't
> have an easy way to test it myself. It has nothing to do with this
> issue, it's just a potentially faster way to do the rbd completions.
>

Sure - but note I'm testing this on my i7 workstation (4x osd's running 
on 2x Crucial M550) so not exactly server grade :-)

With that in mind, I'm seeing slightly *slower* performance with the 
patch applied: e.g: for 128k blocks - 2 runs, 1 uncached and the next 
cached.

Unpatched:

$ fio read-test.fio
rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K, 
ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
Jobs: 1 (f=1): [R(1)] [100.0% done] [588.5MB/0KB/0KB /s] [4707/0/0 iops] 
[eta 00m:00s]
rbd_thread: (groupid=0, jobs=1): err= 0: pid=4305: Sat Oct 25 17:39:32 2014
   read : io=4096.0MB, bw=596205KB/s, iops=4657, runt=  7035msec
     slat (usec): min=2, max=2967, avg=36.67, stdev=58.70
     clat (usec): min=1, max=28305, avg=6812.05, stdev=3062.44
      lat (usec): min=24, max=28330, avg=6848.72, stdev=3061.25
     clat percentiles (usec):
      |  1.00th=[ 2008],  5.00th=[ 2544], 10.00th=[ 3024], 20.00th=[ 3952],
      | 30.00th=[ 4832], 40.00th=[ 5664], 50.00th=[ 6560], 60.00th=[ 7456],
      | 70.00th=[ 8384], 80.00th=[ 9280], 90.00th=[10816], 95.00th=[11968],
      | 99.00th=[14912], 99.50th=[16512], 99.90th=[24192], 99.95th=[26496],
      | 99.99th=[28032]
     bw (KB  /s): min=568064, max=620288, per=100.00%, avg=596434.86, 
stdev=18741.30
     lat (usec) : 2=0.01%, 50=0.01%, 750=0.01%, 1000=0.01%
     lat (msec) : 2=0.94%, 4=19.48%, 10=65.18%, 20=14.16%, 50=0.22%
   cpu          : usr=12.84%, sys=1.96%, ctx=52370, majf=0, minf=78
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=25.6%, 32=74.3%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=99.6%, 8=0.4%, 16=0.1%, 32=0.1%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=32768/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32


$ fio read-test.fio
rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K, 
ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
Jobs: 1 (f=1): [R(1)] [100.0% done] [843.8MB/0KB/0KB /s] [6750/0/0 iops] 
[eta 00m:00s]
rbd_thread: (groupid=0, jobs=1): err= 0: pid=4393: Sat Oct 25 17:39:50 2014
   read : io=4096.0MB, bw=847163KB/s, iops=6618, runt=  4951msec
     slat (usec): min=2, max=3996, avg=46.39, stdev=106.38
     clat (usec): min=1, max=19652, avg=4699.45, stdev=2251.49
      lat (usec): min=14, max=19726, avg=4745.83, stdev=2244.04
     clat percentiles (usec):
      |  1.00th=[  916],  5.00th=[ 1400], 10.00th=[ 1864], 20.00th=[ 2704],
      | 30.00th=[ 3408], 40.00th=[ 3984], 50.00th=[ 4512], 60.00th=[ 5088],
      | 70.00th=[ 5664], 80.00th=[ 6432], 90.00th=[ 7584], 95.00th=[ 8640],
      | 99.00th=[11328], 99.50th=[11968], 99.90th=[14016], 99.95th=[14784],
      | 99.99th=[16320]
     bw (KB  /s): min=823808, max=885760, per=100.00%, avg=847975.33, 
stdev=24137.14
     lat (usec) : 2=0.01%, 20=0.01%, 50=0.01%, 100=0.01%, 500=0.03%
     lat (usec) : 750=0.32%, 1000=1.15%
     lat (msec) : 2=10.05%, 4=28.67%, 10=57.42%, 20=2.34%
   cpu          : usr=15.31%, sys=3.15%, ctx=48359, majf=0, minf=82
   IO depths    : 1=0.1%, 2=0.1%, 4=0.5%, 8=2.3%, 16=43.4%, 32=53.7%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=98.3%, 8=1.0%, 16=0.4%, 32=0.3%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=32768/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32


patched:

$ fio read-test.fio
rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K, 
ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
Jobs: 1 (f=1): [R(1)] [100.0% done] [424.9MB/0KB/0KB /s] [3399/0/0 iops] 
[eta 00m:00s]
rbd_thread: (groupid=0, jobs=1): err= 0: pid=4528: Sat Oct 25 17:40:31 2014
   read : io=4096.0MB, bw=429744KB/s, iops=3357, runt=  9760msec
     slat (usec): min=2, max=1450, avg=24.89, stdev=28.80
     clat (usec): min=0, max=29343, avg=9504.27, stdev=3355.50
      lat (usec): min=14, max=29352, avg=9529.17, stdev=3351.45
     clat percentiles (usec):
      |  1.00th=[  852],  5.00th=[ 2960], 10.00th=[ 4512], 20.00th=[ 6688],
      | 30.00th=[ 8512], 40.00th=[ 9408], 50.00th=[10304], 60.00th=[10944],
      | 70.00th=[11456], 80.00th=[11968], 90.00th=[12480], 95.00th=[13632],
      | 99.00th=[18048], 99.50th=[19072], 99.90th=[21376], 99.95th=[21888],
      | 99.99th=[22400]
     bw (KB  /s): min=400606, max=463141, per=100.00%, avg=429940.42, 
stdev=19324.84
     lat (usec) : 2=0.07%, 500=0.01%, 750=0.56%, 1000=0.78%
     lat (msec) : 2=1.70%, 4=5.10%, 10=38.37%, 20=53.20%, 50=0.21%
   cpu          : usr=6.36%, sys=0.79%, ctx=18607, majf=0, minf=81
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.9%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=32768/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32

$ fio read-test.fio
rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K, 
ioengine=rbd, iodepth=32
fio-2.1.13-88-gb2ee7
Starting 1 process
rbd engine: RBD version: 0.1.8
Jobs: 1 (f=0): [R(1)] [100.0% done] [711.9MB/0KB/0KB /s] [5695/0/0 iops] 
[eta 00m:00s]
rbd_thread: (groupid=0, jobs=1): err= 0: pid=4594: Sat Oct 25 17:40:43 2014
   read : io=4096.0MB, bw=719311KB/s, iops=5619, runt=  5831msec
     slat (usec): min=2, max=3965, avg=32.65, stdev=86.47
     clat (usec): min=0, max=16050, avg=5658.86, stdev=2230.99
      lat (usec): min=17, max=16074, avg=5691.51, stdev=2222.24
     clat percentiles (usec):
      |  1.00th=[  796],  5.00th=[ 1880], 10.00th=[ 2864], 20.00th=[ 3888],
      | 30.00th=[ 4576], 40.00th=[ 5088], 50.00th=[ 5536], 60.00th=[ 6112],
      | 70.00th=[ 6624], 80.00th=[ 7328], 90.00th=[ 8384], 95.00th=[ 9408],
      | 99.00th=[11968], 99.50th=[12864], 99.90th=[15552], 99.95th=[15552],
      | 99.99th=[15680]
     bw (KB  /s): min=631040, max=795904, per=100.00%, avg=719788.73, 
stdev=49266.37
     lat (usec) : 2=0.03%, 250=0.01%, 500=0.08%, 750=0.69%, 1000=0.99%
     lat (msec) : 2=3.76%, 4=15.47%, 10=75.63%, 20=3.35%
   cpu          : usr=11.17%, sys=1.22%, ctx=22614, majf=0, minf=83
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.9%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=32768/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32


I'll try it out next week on our real cluster (3x hosts, 24x osds on 
spinners + ssd journals), Mark Nelson will probably beat me to it mind you!

Cheers

Mark

