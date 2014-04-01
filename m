Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <533B045B.9070607@kernel.dk>
References: <CANvN+ekEmEeFeXZ_b7-51QpetdWx2nwJHwoEsbsiFTOcpYwizw@mail.gmail.com>
 <533ACDDC.6010002@kernel.dk> <CANvN+emPxK2FmEAsbdruCMR0jDdjE-s6N6wovHtAqowFprJH4g@mail.gmail.com>
 <533B045B.9070607@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 1 Apr 2014 11:56:15 -0700
Message-ID: <CANvN+eknc=9Ncooprk6AUqOTvkju_JpYivy7EL5xRXka2qv+6g@mail.gmail.com>
Subject: Re: Shared files with thread=1: func=xfer, err=Bad file descriptor
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Seems to have fixed it: EBADF does not show up anymore even in a 120s run.

randrwrite: (groupid=0, jobs=1): err= 0: pid=11373: Tue Apr  1 11:54:39 2014
  write: io=25608KB, bw=218501B/s, iops=53, runt=120011msec
    clat (usec): min=317, max=281422, avg=3839.52, stdev=8501.45
     lat (usec): min=320, max=281427, avg=3847.68, stdev=8501.90
    clat percentiles (usec):
     |  1.00th=[  652],  5.00th=[  844], 10.00th=[  956], 20.00th=[ 1160],
     | 30.00th=[ 1512], 40.00th=[ 2160], 50.00th=[ 2576], 60.00th=[ 2960],
     | 70.00th=[ 3248], 80.00th=[ 3664], 90.00th=[ 4768], 95.00th=[15424],
     | 99.00th=[33024], 99.50th=[33536], 99.90th=[83456], 99.95th=[209920],
     | 99.99th=[280576]
    bw (KB  /s): min=    1, max= 1016, per=24.43%, avg=238.72, stdev=226.57
    lat (usec) : 500=0.05%, 750=2.58%, 1000=9.56%
    lat (msec) : 2=25.02%, 4=47.47%, 10=9.03%, 20=3.86%, 50=2.25%
    lat (msec) : 100=0.11%, 250=0.05%, 500=0.03%
  cpu          : usr=0.24%, sys=3.14%, ctx=20699, majf=0, minf=3
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=6402/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
randrwrite: (groupid=0, jobs=1): err= 0: pid=11374: Tue Apr  1 11:54:39 2014
  write: io=26880KB, bw=229370B/s, iops=55, runt=120003msec
    clat (usec): min=353, max=309465, avg=3914.37, stdev=9882.36
     lat (usec): min=356, max=309476, avg=3922.20, stdev=9882.87
    clat percentiles (usec):
     |  1.00th=[  636],  5.00th=[  812], 10.00th=[  924], 20.00th=[ 1112],
     | 30.00th=[ 1400], 40.00th=[ 1976], 50.00th=[ 2416], 60.00th=[ 2864],
     | 70.00th=[ 3184], 80.00th=[ 3600], 90.00th=[ 4640], 95.00th=[15424],
     | 99.00th=[33536], 99.50th=[36096], 99.90th=[166912], 99.95th=[232448],
     | 99.99th=[309248]
    bw (KB  /s): min=    2, max= 1208, per=24.62%, avg=240.54, stdev=228.83
    lat (usec) : 500=0.10%, 750=3.15%, 1000=10.70%
    lat (msec) : 2=26.32%, 4=45.31%, 10=8.14%, 20=3.41%, 50=2.68%
    lat (msec) : 100=0.06%, 250=0.07%, 500=0.04%
  cpu          : usr=0.29%, sys=3.12%, ctx=21225, majf=0, minf=1
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=6720/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
randrwrite: (groupid=0, jobs=1): err= 0: pid=11375: Tue Apr  1 11:54:39 2014
  write: io=30728KB, bw=262194B/s, iops=64, runt=120008msec
    clat (usec): min=305, max=315339, avg=4275.75, stdev=12442.00
     lat (usec): min=309, max=315347, avg=4284.04, stdev=12442.51
    clat percentiles (usec):
     |  1.00th=[  628],  5.00th=[  812], 10.00th=[  924], 20.00th=[ 1112],
     | 30.00th=[ 1384], 40.00th=[ 1960], 50.00th=[ 2384], 60.00th=[ 2832],
     | 70.00th=[ 3184], 80.00th=[ 3600], 90.00th=[ 4640], 95.00th=[16768],
     | 99.00th=[33536], 99.50th=[39680], 99.90th=[232448], 99.95th=[280576],
     | 99.99th=[313344]
    bw (KB  /s): min=    2, max= 1295, per=28.94%, avg=282.72, stdev=271.58
    lat (usec) : 500=0.09%, 750=3.37%, 1000=10.80%
    lat (msec) : 2=26.56%, 4=44.99%, 10=7.39%, 20=3.16%, 50=3.33%
    lat (msec) : 100=0.09%, 250=0.13%, 500=0.08%
  cpu          : usr=0.33%, sys=3.40%, ctx=22837, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=7682/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1
randrwrite: (groupid=0, jobs=1): err= 0: pid=11376: Tue Apr  1 11:54:39 2014
  write: io=34064KB, bw=290616B/s, iops=70, runt=120026msec
    clat (usec): min=351, max=376615, avg=4112.48, stdev=11571.34
     lat (usec): min=355, max=376621, avg=4120.65, stdev=11572.04
    clat percentiles (usec):
     |  1.00th=[  644],  5.00th=[  812], 10.00th=[  924], 20.00th=[ 1096],
     | 30.00th=[ 1352], 40.00th=[ 1864], 50.00th=[ 2384], 60.00th=[ 2768],
     | 70.00th=[ 3120], 80.00th=[ 3504], 90.00th=[ 4576], 95.00th=[16192],
     | 99.00th=[34048], 99.50th=[41728], 99.90th=[193536], 99.95th=[259072],
     | 99.99th=[374784]
    bw (KB  /s): min=    1, max= 1736, per=31.18%, avg=304.63, stdev=317.27
    lat (usec) : 500=0.09%, 750=3.43%, 1000=10.79%
    lat (msec) : 2=27.56%, 4=44.46%, 10=7.21%, 20=2.92%, 50=3.21%
    lat (msec) : 100=0.15%, 250=0.11%, 500=0.07%
  cpu          : usr=0.28%, sys=3.66%, ctx=24223, majf=0, minf=2
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=8516/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=117280KB, aggrb=977KB/s, minb=213KB/s, maxb=283KB/s,
mint=120003msec, maxt=120026msec

Disk stats (read/write):
  sda: ios=0/76211, merge=0/17768, ticks=0/99456, in_queue=98572, util=81.61%
Regards,
Andrey


On Tue, Apr 1, 2014 at 11:24 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/01/2014 09:56 AM, Andrey Kuzmin wrote:
>>
>> Thanks. On a separate (or may be related) note, shared files handling
>> in dup_files seems to be broken (unless I'm missing the logic behind
>> dropping non-shared files). The patch below has fixed it for me.
>>
>> diff --git a/init.c b/init.c
>> index 9b0666d..99038b2 100644
>> --- a/init.c
>> +++ b/init.c
>> @@ -1160,17 +1161,20 @@ static int add_job(struct thread_data *td, const
>> char *j
>>                  td_new->o.new_group = 0;
>>
>>                  if (file_alloced) {
>> -                       td_new->files_index = 0;
>> -                       td_new->files_size = 0;
>>                          if (td_new->files) {
>>                                  struct fio_file *f;
>>                                  for_each_file(td_new, f, i) {
>>                                          if (f->file_name)
>> -                                               free(f->file_name);
>> -                                       free(f);
>> +                                               sfree(f->file_name);
>> +                                       sfree(f);
>>                                  }
>> +                               free(td_new->files);
>>                                  td_new->files = NULL;
>>                          }
>> +                       td_new->files_index = 0;
>> +                       td_new->files_size = 0;
>>                          if (td_new->o.filename) {
>>                                  free(td_new->o.filename);
>>                                  td_new->o.filename = NULL;
>
>
> Thanks, I'll add this, definitely looks like a missing conversion at some
> point...
>
> And while this isn't the bug, I think it's touching in the right area. Can
> you try with this one-liner and see if that fixes your issues with EBADF?
>
> --
> Jens Axboe
>

