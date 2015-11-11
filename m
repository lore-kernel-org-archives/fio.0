Return-Path: <axboe@kernel.dk>
Subject: Re: Aggregate values in logs
References: <94806C6A-BFE4-4B3A-BE4C-BAD60A294460@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5643825A.1060508@kernel.dk>
Date: Wed, 11 Nov 2015 11:00:58 -0700
MIME-Version: 1.0
In-Reply-To: <94806C6A-BFE4-4B3A-BE4C-BAD60A294460@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: GrAnt <626542@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/10/2015 10:38 AM, GrAnt wrote:
> Hello!
>
> How to get aggregate values in log (_bw,_lat,_iops) files?
> I use job with:
>
>> group_reporting=3D1
>> disable_lat=3D0
>> disable_clat=3D0
>> disable_slat=3D0
>> numjobs=3D4
>> per_job_logs=3D0
>
> After benchmarking I=EF=BF=BDve got output (normal) with aggregate (for a=
ll 4 jobs):
>
> read : io=3D148620MB, bw=3D253474KB/s, iops=3D247, runt=3D600404msec
>
> But in logs there are stats only about one job, job_bw.log:
>
>> 221, 3091, 0, 1048576
>> 934, 68936, 0, 1048576
>> 1477, 60457, 0, 1048576
>> 2182, 60457, 0, 1048576
>> 2714, 61709, 0, 1048576
>> 3371, 74926, 0, 1048576
>> 4130, 64844, 0, 1048576
>> 4644, 63750, 0, 1048576
>> 5184, 60794, 0, 1048576
>> ..
>
> May be I should multiply values in second column by 4? :)

Look further down, the log will have each of the jobs following each=20
other. They are not summed for you, you have to do that.


--=20
Jens Axboe


