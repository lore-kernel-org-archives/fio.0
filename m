Return-Path: <htobonm@eafit.edu.co>
Subject: Re: [io_uring] Performance analysis
References: <2ce17fe4-3e39-a19e-b049-cd550d77a76d@eafit.edu.co>
 <CALjAwxiUY9TLKNsBKuDLk2aBwTAJJh9FkRSjqvmu7r1+SSKrnQ@mail.gmail.com>
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Message-ID: <c16c94c9-6182-1d6e-75f9-4683fcc47915@eafit.edu.co>
Date: Tue, 16 Jun 2020 15:07:57 -0400
In-Reply-To: <CALjAwxiUY9TLKNsBKuDLk2aBwTAJJh9FkRSjqvmu7r1+SSKrnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Return-Path: htobonm@eafit.edu.co
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 16/6/20 1:21 a.=C2=A0m., Sitsofe Wheeler wrote:

> Hi,
>
> On Tue, 16 Jun 2020 at 04:57, Hamilton Tobon Mosquera
> <htobonm@eafit.edu.co> wrote:
>> I've been using and analyzing io_uring's performance with fio. I'm
>> trying to replicate the results that Jens Axboe shows when he presents
>> io uring in Kernel Recipes 2019. The problem is that I'm not even closer
>> to that, nor that behavior. I have a server with two Intel Optanes (he
>> mentions that he had to use two devices), but I think the problem is
>> that I'm not using the proper fio parameter combination. Can you please
>> tell me what fio configuration is needed to get 1.6 million iops with
>> only one thread?, or at least that same behavior, not necesarily the 1.6
>> million iops. I'm comparing io_uring in polling mode vs libaio, but I
>> get the same iops with both of them, about 400K iops, issuing requests
>> to both devices through separate files.
> Have you seen https://nam01.safelinks.protection.outlook.com/?url=3Dhttps=
%3A%2F%2Fitpeernetwork.intel.com%2Ftuning-performance-intel-optane-ssds-lin=
ux-operating-systems%2F&amp;data=3D01%7C01%7Chtobonm%40eafit.edu.co%7C9fc53=
beeaf8344cbee6a08d811b52051%7C99f7b55e9cbe467b8143919782918afb%7C0&amp;sdat=
a=3DipmfFDLCOnP%2BCZ3hN3aiKlEgREFHxaq5rmCeI2buAL0%3D&amp;reserved=3D0
> by Intel's Frank Ober? For polling to actually do its work you need to
> ensure your kernel has been configured to do polling too. It would
> also be good to see what you were using as your fio command line (and
> I guess which kernel you are using).

Thanks for your answer.

Yes I saw that post and followed it. The CPU is in performance mode. I=20
activated polling in the nvme driver by loading it with the=20
poll_queues=3DN parameter, where N is the number of physical cores of the=20
CPU. I'm issuing 4K random and sequential reads, at different queue=20
depths (1,2,4,8,128,256). The peak performance is reached at a queue=20
depth of 128, as shown by Jens Axboe, but I'm still far away to get=20
those behaviors where io_uring over performs libaio. This is the jobfile:

[global]
ioengine=3Dio_uring
hipri
direct=3D1
thread=3D1
buffered=3D0
size=3D100%
randrepeat=3D0
time_based
ramp_time=3D0
norandommap
refill_buffers
log_max_value=3D1
log_avg_msec=3D1000
group_reporting
percentile_list=3D50:60:70:80:90:95:99

[optanes]
name=3Dtest-optanes
bs=3D4k
rw=3Drandread
numjobs=3D1
filename=3D/mnt/optane0/fiotest:/mnt/optane1/fiotest
iodepth=3D32
runtime=3D240

Thanks again. I will try with the jobfile that Frank Ober sent.

Hamilton.

>
> --
> Sitsofe | https://nam01.safelinks.protection.outlook.com/?url=3Dhttp:%2F%=
2Fsucs.org%2F~sits%2F&amp;data=3D01%7C01%7Chtobonm%40eafit.edu.co%7C9fc53be=
eaf8344cbee6a08d811b52051%7C99f7b55e9cbe467b8143919782918afb%7C0&amp;sdata=
=3Dteb4flHuOeyB%2BW%2BSujPM9AV90xmry12yQ3ieYR6YwGA%3D&amp;reserved=3D0
> La informaci=C3=B3n contenida en este correo electr=C3=B3nico est=C3=A1 d=
irigida =C3=BAnicamente a su destinatario y puede contener informaci=C3=B3n=
 confidencial, material privilegiado o informaci=C3=B3n protegida por derec=
ho de autor. Est=C3=A1 prohibida cualquier copia, utilizaci=C3=B3n, indebid=
a retenci=C3=B3n, modificaci=C3=B3n, difusi=C3=B3n, distribuci=C3=B3n o rep=
roducci=C3=B3n total o parcial. Si usted recibe este mensaje por error, por=
 favor contacte al remitente y elim=C3=ADnelo. La informaci=C3=B3n aqu=C3=
=AD contenida es responsabilidad exclusiva de su remitente por lo tanto la =
Universidad EAFIT no se hace responsable de lo que el mensaje contenga. The=
 information contained in this email is addressed to its recipient only and=
 may contain confidential information, privileged material or information p=
rotected by copyright. Its prohibited any copy, use, improper retention, mo=
dification, dissemination, distribution or total or partial reproduction. I=
f you receive this message by error, please contact the sender and delete i=
t. The information contained herein is the sole responsibility of the sende=
r therefore Universidad EAFIT is not responsible for what the message conta=
ins.


