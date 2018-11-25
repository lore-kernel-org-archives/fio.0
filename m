Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f172.google.com ([209.85.166.172]:54567 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbeKZGxE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Nov 2018 01:53:04 -0500
Received: by mail-it1-f172.google.com with SMTP id m123-v6so931790ita.4
        for <fio@vger.kernel.org>; Sun, 25 Nov 2018 12:01:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0E387D6D-E489-41E2-B535-577AD63036F9@emc.com>
References: <CAFF4W0UPjgKPX2t=aqRPsjKN65DJHa46emuTckTOsNx4BYBoZg@mail.gmail.com>
 <CAFF4W0XUBMLn5TuYWonvoJntZfPUtUS7HypWpejw8Ofer9z9Sw@mail.gmail.com> <0E387D6D-E489-41E2-B535-577AD63036F9@emc.com>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Mon, 26 Nov 2018 01:31:12 +0530
Message-ID: <CAFF4W0VUtSHm1BVAMS9WrFhkUBKMv-_SbyNLXia08OeyfVQ6FA@mail.gmail.com>
Subject: Re: Re loading libaio engine error and pvsync2 operation not
 permitted error
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Beierl, Mark" <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>

Hi,

1) How are you installing FIO =E2=80=93 from the apt repos, or building fro=
m source?
I build fio from source, below is my dockerfile.

FROM centos:latest
RUN yum update -y
RUN yum install git gcc gcc-c++ make  -y
RUN git clone https://github.com/axboe/fio
RUN yum install zlib-devel libaio -y
WORKDIR  /fio
RUN ./configure
RUN make
RUN make install
VOLUME /tmp/fio-data
WORKDIR /tmp/fio-data
ENTRYPOINT ["fio"]


 2) What storage are you using in the container =E2=80=93 a mounted volume =
or
are you trying to use the host OS/raw device?
After reading this question, I getting more doubts, with the above
docker file and few examples given below.
docker run fio:6.0 --name:job1 --size=3D50m --rw=3Dread
docker run fio:6.0 --name:job1 --size=3D100m --rw=3Dreadwrite

Am I really testing the host HDD or testing docker volume only. If I
am testing only the docker volume then its not my intended use case, I
need to test host machine HDD.
What is the best way to test host machine HDD ?

 3) Is the container running as privileged if you are trying to access the =
host?
Only when I am trying to test a RAW device, I use --privileged=3Dtrue
like below otherwise I dont supply --privileged=3Dtrue .
docker run --privileged=3Dtrue fio:6.0 --name=3Dfile --size=3D100m
--filename=3D/dev/sdc

Thanks and Regards,
Mohan

On 11/26/18, Beierl, Mark <Mark.Beierl@dell.com> wrote:
> Hello!
>
> I have a couple of questions, as I also build FIO in an Alpine container,
> but there I build it from source so that I have all required libraries.  =
The
> source for the container is here [1] and it is part of the OPNFV StorPerf
> project, which is for wrapping FIO in a web front end and making it easie=
r
> to test against various distributions or VMs [2].
>
> My questions are:
>
> 1) How are you installing FIO =E2=80=93 from the apt repos, or building f=
rom
> source?
> 2) What storage are you using in the container =E2=80=93 a mounted volume=
 or are you
> trying to use the host OS/raw device?
> 3) Is the container running as privileged if you are trying to access the
> host?
>
> [1] https://git.opnfv.org/storperf/tree/docker/storperf-master/Dockerfile
> [2] https://wiki.opnfv.org/display/storperf
>
> Regards,
> Mark
>
> Mark Beierl
> SW System Sr Principal Developer
> Dell EMC | Cloud & Communication Service Provider Solution
> Mark.Beierl@Dell.com
>
> On 2018-11-25, 15:28, "fio-owner@vger.kernel.org on behalf of Mohanraj B"
> <fio-owner@vger.kernel.org on behalf of bmohanraj91@gmail.com> wrote:
>
>
>     [EXTERNAL EMAIL]
>
>     typo
>     running in docker container.
>
>     On 11/26/18, Mohanraj B <bmohanraj91@gmail.com> wrote:
>     > Hello,
>     >
>     > I am trying to use libaio engine for a job file in my docker
>     > container, but it throws fio: engine libaio not loadable error.
>     >
>     > fio --name=3Dhello1 --size=3D1m --ioengine=3Dlibaio
>     >
>     > fio: engine libaio not loadable
>     > fio: engine libaio not loadable
>     > fio: failed to load engine
>     > fio: file:ioengines.c:89, func=3Ddlopen, error=3Dlibaio: cannot ope=
n
>     > shared object file: No such file or directory
>     >
>     > Available IO engines:
>     > [root@210df130f2c7 fio-data]# fio --enghelp
>     > Available IO engines:
>     > 	cpuio
>     > 	mmap
>     > 	sync
>     > 	psync
>     > 	vsync
>     > 	pvsync
>     > 	pvsync2
>     > 	null
>     > 	net
>     > 	netsplice
>     > 	ftruncate
>     > 	filecreate
>     > 	posixaio
>     > 	falloc
>     > 	e4defrag
>     > 	splice
>     > 	mtd
>     > 	sg
>     >
>     >
>     > libaio is not listed above, but its installed in container.
>     >
>     > yum install libaio
>     > Loaded plugins: fastestmirror, ovl
>     > Loading mirror speeds from cached hostfile
>     >  * base: ftp.iitm.ac.in
>     >  * extras: ftp.iitm.ac.in
>     >  * updates: ftp.iitm.ac.in
>     > Package libaio-0.3.109-13.el7.x86_64 already installed and latest
> version
>     > Nothing to do
>     >
>     > Centos docker container : centos-release-7-5.1804.5.el7.centos.x86_=
64
>     >
>     >
>     > Re pvsync2 operation not permitted error
>     >
>     > fio --name=3Dhello --size=3D10m --ioengine=3Dpvsync2
>     >
>     > hello: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (=
T)
>     > 4096B-4096B, ioengine=3Dpvsync2, iodepth=3D1
>     > fio-3.12-18-g92a1
>     > Starting 1 process
>     > hello: Laying out IO file (1 file / 10MiB)
>     > fio: io_u error on file hello.0.0: Operation not permitted: read
>     > offset=3D0, buflen=3D4096
>     > fio: pid=3D59, err=3D1/file:io_u.c:1789, func=3Dio_u error, error=
=3DOperation
>     > not permitted
>     >
>     > hello: (groupid=3D0, jobs=3D1): err=3D 1 (file:io_u.c:1789, func=3D=
io_u
> error,
>     > error=3DOperation not permitted): pid=3D59: Sun Nov 25 19:23:14 201=
8
>     >   cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D2, majf=3D0, minf=
=3D19
>     >   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0=
%, 32=3D0.0%,
>     >>=3D64=3D0.0%
>     >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%,
>     >>=3D64=3D0.0%
>     >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%,
>     >>=3D64=3D0.0%
>     >      issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
>     >      latency   : target=3D0, window=3D0, percentile=3D100.00%, dept=
h=3D1
>     >
>     > Run status group 0 (all jobs):
>     >
>     > Disk stats (read/write):
>     >   sda: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.=
00%
>     >
>     > I dont have access to machine running centos, so running in centos
>     > docker container. Are these issues occuring because of running in
> fio?
>     >
>     > host machine OS is ubuntu 18.04.
>     >
>     > Thanks and Regards,
>     > Mohan
>     >
>
>
>

