Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:3855 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbeKZKnl (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Nov 2018 05:43:41 -0500
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Re loading libaio engine error and pvsync2 operation not
 permitted error
Date: Sun, 25 Nov 2018 23:51:14 +0000
Message-ID: <BN3PR0401MB164063C824D35F22565924D3E7D60@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <CAFF4W0UPjgKPX2t=aqRPsjKN65DJHa46emuTckTOsNx4BYBoZg@mail.gmail.com>
 <CAFF4W0XUBMLn5TuYWonvoJntZfPUtUS7HypWpejw8Ofer9z9Sw@mail.gmail.com>
 <0E387D6D-E489-41E2-B535-577AD63036F9@emc.com>
 <CAFF4W0VUtSHm1BVAMS9WrFhkUBKMv-_SbyNLXia08OeyfVQ6FA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mohanraj B <bmohanraj91@gmail.com>, "Beierl, Mark" <Mark.Beierl@dell.com>
Cc: fio <fio@vger.kernel.org>

On 2018/11/26 5:01, Mohanraj B wrote:=0A=
> Hi,=0A=
> =0A=
> 1) How are you installing FIO =96 from the apt repos, or building from so=
urce?=0A=
> I build fio from source, below is my dockerfile.=0A=
> =0A=
> FROM centos:latest=0A=
> RUN yum update -y=0A=
> RUN yum install git gcc gcc-c++ make  -y=0A=
> RUN git clone https://github.com/axboe/fio=0A=
> RUN yum install zlib-devel libaio -y=0A=
=0A=
yum install libaio-devel ?=0A=
Otherwise, libaio will not be compiled...=0A=
=0A=
> WORKDIR  /fio=0A=
> RUN ./configure=0A=
> RUN make=0A=
> RUN make install=0A=
> VOLUME /tmp/fio-data=0A=
> WORKDIR /tmp/fio-data=0A=
> ENTRYPOINT ["fio"]=0A=
> =0A=
> =0A=
>  2) What storage are you using in the container =96 a mounted volume or=
=0A=
> are you trying to use the host OS/raw device?=0A=
> After reading this question, I getting more doubts, with the above=0A=
> docker file and few examples given below.=0A=
> docker run fio:6.0 --name:job1 --size=3D50m --rw=3Dread=0A=
> docker run fio:6.0 --name:job1 --size=3D100m --rw=3Dreadwrite=0A=
> =0A=
> Am I really testing the host HDD or testing docker volume only. If I=0A=
> am testing only the docker volume then its not my intended use case, I=0A=
> need to test host machine HDD.=0A=
> What is the best way to test host machine HDD ?=0A=
> =0A=
>  3) Is the container running as privileged if you are trying to access th=
e host?=0A=
> Only when I am trying to test a RAW device, I use --privileged=3Dtrue=0A=
> like below otherwise I dont supply --privileged=3Dtrue .=0A=
> docker run --privileged=3Dtrue fio:6.0 --name=3Dfile --size=3D100m=0A=
> --filename=3D/dev/sdc=0A=
> =0A=
> Thanks and Regards,=0A=
> Mohan=0A=
> =0A=
> On 11/26/18, Beierl, Mark <Mark.Beierl@dell.com> wrote:=0A=
>> Hello!=0A=
>>=0A=
>> I have a couple of questions, as I also build FIO in an Alpine container=
,=0A=
>> but there I build it from source so that I have all required libraries. =
 The=0A=
>> source for the container is here [1] and it is part of the OPNFV StorPer=
f=0A=
>> project, which is for wrapping FIO in a web front end and making it easi=
er=0A=
>> to test against various distributions or VMs [2].=0A=
>>=0A=
>> My questions are:=0A=
>>=0A=
>> 1) How are you installing FIO =96 from the apt repos, or building from=
=0A=
>> source?=0A=
>> 2) What storage are you using in the container =96 a mounted volume or a=
re you=0A=
>> trying to use the host OS/raw device?=0A=
>> 3) Is the container running as privileged if you are trying to access th=
e=0A=
>> host?=0A=
>>=0A=
>> [1] https://git.opnfv.org/storperf/tree/docker/storperf-master/Dockerfil=
e=0A=
>> [2] https://wiki.opnfv.org/display/storperf=0A=
>>=0A=
>> Regards,=0A=
>> Mark=0A=
>>=0A=
>> Mark Beierl=0A=
>> SW System Sr Principal Developer=0A=
>> Dell EMC | Cloud & Communication Service Provider Solution=0A=
>> Mark.Beierl@Dell.com=0A=
>>=0A=
>> On 2018-11-25, 15:28, "fio-owner@vger.kernel.org on behalf of Mohanraj B=
"=0A=
>> <fio-owner@vger.kernel.org on behalf of bmohanraj91@gmail.com> wrote:=0A=
>>=0A=
>>=0A=
>>     [EXTERNAL EMAIL]=0A=
>>=0A=
>>     typo=0A=
>>     running in docker container.=0A=
>>=0A=
>>     On 11/26/18, Mohanraj B <bmohanraj91@gmail.com> wrote:=0A=
>>     > Hello,=0A=
>>     >=0A=
>>     > I am trying to use libaio engine for a job file in my docker=0A=
>>     > container, but it throws fio: engine libaio not loadable error.=0A=
>>     >=0A=
>>     > fio --name=3Dhello1 --size=3D1m --ioengine=3Dlibaio=0A=
>>     >=0A=
>>     > fio: engine libaio not loadable=0A=
>>     > fio: engine libaio not loadable=0A=
>>     > fio: failed to load engine=0A=
>>     > fio: file:ioengines.c:89, func=3Ddlopen, error=3Dlibaio: cannot op=
en=0A=
>>     > shared object file: No such file or directory=0A=
>>     >=0A=
>>     > Available IO engines:=0A=
>>     > [root@210df130f2c7 fio-data]# fio --enghelp=0A=
>>     > Available IO engines:=0A=
>>     > 	cpuio=0A=
>>     > 	mmap=0A=
>>     > 	sync=0A=
>>     > 	psync=0A=
>>     > 	vsync=0A=
>>     > 	pvsync=0A=
>>     > 	pvsync2=0A=
>>     > 	null=0A=
>>     > 	net=0A=
>>     > 	netsplice=0A=
>>     > 	ftruncate=0A=
>>     > 	filecreate=0A=
>>     > 	posixaio=0A=
>>     > 	falloc=0A=
>>     > 	e4defrag=0A=
>>     > 	splice=0A=
>>     > 	mtd=0A=
>>     > 	sg=0A=
>>     >=0A=
>>     >=0A=
>>     > libaio is not listed above, but its installed in container.=0A=
>>     >=0A=
>>     > yum install libaio=0A=
>>     > Loaded plugins: fastestmirror, ovl=0A=
>>     > Loading mirror speeds from cached hostfile=0A=
>>     >  * base: ftp.iitm.ac.in=0A=
>>     >  * extras: ftp.iitm.ac.in=0A=
>>     >  * updates: ftp.iitm.ac.in=0A=
>>     > Package libaio-0.3.109-13.el7.x86_64 already installed and latest=
=0A=
>> version=0A=
>>     > Nothing to do=0A=
>>     >=0A=
>>     > Centos docker container : centos-release-7-5.1804.5.el7.centos.x86=
_64=0A=
>>     >=0A=
>>     >=0A=
>>     > Re pvsync2 operation not permitted error=0A=
>>     >=0A=
>>     > fio --name=3Dhello --size=3D10m --ioengine=3Dpvsync2=0A=
>>     >=0A=
>>     > hello: (g=3D0): rw=3Dread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T)=0A=
>>     > 4096B-4096B, ioengine=3Dpvsync2, iodepth=3D1=0A=
>>     > fio-3.12-18-g92a1=0A=
>>     > Starting 1 process=0A=
>>     > hello: Laying out IO file (1 file / 10MiB)=0A=
>>     > fio: io_u error on file hello.0.0: Operation not permitted: read=
=0A=
>>     > offset=3D0, buflen=3D4096=0A=
>>     > fio: pid=3D59, err=3D1/file:io_u.c:1789, func=3Dio_u error, error=
=3DOperation=0A=
>>     > not permitted=0A=
>>     >=0A=
>>     > hello: (groupid=3D0, jobs=3D1): err=3D 1 (file:io_u.c:1789, func=
=3Dio_u=0A=
>> error,=0A=
>>     > error=3DOperation not permitted): pid=3D59: Sun Nov 25 19:23:14 20=
18=0A=
>>     >   cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D2, majf=3D0, minf=
=3D19=0A=
>>     >   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.=
0%, 32=3D0.0%,=0A=
>>     >>=3D64=3D0.0%=0A=
>>     >      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0=
.0%, 64=3D0.0%,=0A=
>>     >>=3D64=3D0.0%=0A=
>>     >      complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0=
.0%, 64=3D0.0%,=0A=
>>     >>=3D64=3D0.0%=0A=
>>     >      issued rwts: total=3D1,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,=
0=0A=
>>     >      latency   : target=3D0, window=3D0, percentile=3D100.00%, dep=
th=3D1=0A=
>>     >=0A=
>>     > Run status group 0 (all jobs):=0A=
>>     >=0A=
>>     > Disk stats (read/write):=0A=
>>     >   sda: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0=
.00%=0A=
>>     >=0A=
>>     > I dont have access to machine running centos, so running in centos=
=0A=
>>     > docker container. Are these issues occuring because of running in=
=0A=
>> fio?=0A=
>>     >=0A=
>>     > host machine OS is ubuntu 18.04.=0A=
>>     >=0A=
>>     > Thanks and Regards,=0A=
>>     > Mohan=0A=
>>     >=0A=
>>=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

