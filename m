Return-Path: <paolo.valente@linaro.org>
Return-Path: <paolo.valente@linaro.org>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: Re: time_based not working with randread
From: Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <CALjAwxiWDecVfJsUr2eiBnL4q4nc_v+XZwjVNiOE0rKj+hc_aQ@mail.gmail.com>
Date: Thu, 31 May 2018 10:55:16 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <42E4AE76-FC46-44EF-9B7A-430B0148E1AD@linaro.org>
References: <F0E1506A-A23F-4C12-B003-9860F71FC91A@linaro.org>
 <CALjAwxiWDecVfJsUr2eiBnL4q4nc_v+XZwjVNiOE0rKj+hc_aQ@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>



> Il giorno 27 mag 2018, alle ore 16:24, Sitsofe Wheeler =
<sitsofe@gmail.com> ha scritto:
>=20
> Hi Paolo!
>=20
> On 25 May 2018 at 20:20, Paolo Valente <paolo.valente@linaro.org> =
wrote:
>> Hi,
>> if I run this job (even with the last version GitHub version of fio) =
on an SSD:
>> [global]
>> ioengine=3Dsync
>> time_based=3D1
>> runtime=3D20
>> readwrite=3Drandread
>> size=3D100m
>> numjobs=3D1
>> invalidate=3D1
>> [job1]
>>=20
>> then, after little time (I think after 100MB have been read), fio =
reports a nonsensically large value for the throughput, while a simple =
iostat shows that no I/O is going on. By just replacing time_based with =
loops, i.e., with a job file like this:
>>=20
>> [global]
>> ioengine=3Dsync
>> loops=3D1000
>> readwrite=3Drandread
>> size=3D100m
>> numjobs=3D1
>> invalidate=3D1
>> [job1]
>>=20
>> the problem disappears.
>=20
> I've taken a stab at fixing this over in
> https://github.com/sitsofe/fio/tree/random_reinvalidate - does that
> solve the issue for you too?

Nope :(

> ...
> I know I'm "Teaching grandmother to suck eggs" given that you're the
> author of BFQ but just in case...
>=20
> This issue happens on loops=3D1000 too and I believe it's down to
> readahead.

I'm afraid there is a misunderstanding on this, grandson :)

As I wrote, this problem does not occur with loops=3D1000.  My
impression is that, with loops, as well as with time-based and read,
fio does invalidate the cache every time it restarts reading the same
file, while with time_based and randread it does not (or maybe it
tries to, but fails for some reason).

Thanks,
grandma

> Basically fio is trying to invalidate the cache but said
> cache is also being populated by readahead and in the end some data
> ends up reused from the cache:
>=20
> # modprobe null_blk completion_nsec=3D100000 irqmode=3D2
> #
> # ./fio --ioengine=3Dsync --runtime=3D10 --size=3D100m
> --filename=3D/dev/nullb0 --time_based --name=3Dcached --rw=3Dread =
--stats=3D0
> --invalidate=3D1
> cached: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dsync, iodepth=3D1
> fio-3.6-40-g854d
> Starting 1 process
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D2233MiB/s,w=3D0KiB/s][r=3D572k,w=3D0=

> IOPS][eta 00m:00s]
>=20
> Run status group 0 (all jobs):
>=20
> Disk stats (read/write):
>  nullb0: ios=3D266158/0, merge=3D0/0, ticks=3D26611/0, in_queue=3D26492,=
 util=3D82.39%
> # ./fio --ioengine=3Dsync --runtime=3D10 --size=3D100m
> --filename=3D/dev/nullb0 --time_based --name=3Dcached --rw=3Dread =
--stats=3D0
> --invalidate=3D1 --fadvise=3Drandom
> cached: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dsync, iodepth=3D1
> fio-3.6-40-g854d
> Starting 1 process
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D37.3MiB/s,w=3D0KiB/s][r=3D9561,w=3D0=

> IOPS][eta 00m:00s]
>=20
> Run status group 0 (all jobs):
>=20
> Disk stats (read/write):
>  nullb0: ios=3D94364/0, merge=3D0/0, ticks=3D9615/0, in_queue=3D9612, =
util=3D96.15%
> # ./fio --ioengine=3Dsync --runtime=3D10 --size=3D100m
> --filename=3D/dev/nullb0 --time_based --name=3Dcached --rw=3Dread =
--stats=3D0
> --invalidate=3D0
> cached: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dsync, iodepth=3D1
> fio-3.6-40-g854d
> Starting 1 process
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D3888MiB/s,w=3D0KiB/s][r=3D995k,w=3D0=

> IOPS][eta 00m:00s]
>=20
> Run status group 0 (all jobs):
>=20
> Disk stats (read/write):
>  nullb0: ios=3D1208/0, merge=3D0/0, ticks=3D122/0, in_queue=3D121, =
util=3D0.37%
> #
> # echo 0 > /sys/block/nullb0/queue/read_ahead_kb
> #
> # ./fio --ioengine=3Dsync --runtime=3D10 --size=3D100m
> --filename=3D/dev/nullb0 --time_based --name=3Dcached --rw=3Dread =
--stats=3D0
> --invalidate=3D1
> cached: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dsync, iodepth=3D1
> fio-3.6-40-g854d
> Starting 1 process
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D37.0MiB/s,w=3D0KiB/s][r=3D9478,w=3D0=

> IOPS][eta 00m:00s]
>=20
> Run status group 0 (all jobs):
>=20
> Disk stats (read/write):
>  nullb0: ios=3D93518/0, merge=3D0/0, ticks=3D9654/0, in_queue=3D9653, =
util=3D96.56%
> # ./fio --ioengine=3Dsync --runtime=3D10 --size=3D100m
> --filename=3D/dev/nullb0 --time_based --name=3Dcached --rw=3Dread =
--stats=3D0
> --invalidate=3D0
> cached: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dsync, iodepth=3D1
> fio-3.6-40-g854d
> Starting 1 process
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D3894MiB/s,w=3D0KiB/s][r=3D997k,w=3D0=

> IOPS][eta 00m:00s]
>=20
> Run status group 0 (all jobs):
>=20
> Disk stats (read/write):
>  nullb0: ios=3D25600/0, merge=3D0/0, ticks=3D2650/0, in_queue=3D2649, =
util=3D26.50%
>=20
> Note: readahead (if set) can still take place even when the
> ioscheduler has been set to none.
>=20
> --=20
> Sitsofe | http://sucs.org/~sits/


