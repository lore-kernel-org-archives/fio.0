Return-Path: <htobonm@eafit.edu.co>
Subject: Re: [io_uring] Problems using io_uring engine
References: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
 <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
 <ed949243-f657-5f41-79f2-dc8a34459f27@eafit.edu.co>
 <931cfc02-d662-f154-c453-276553e19a1e@kernel.dk>
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Message-ID: <c5f64029-31c3-a9c0-5bbf-8a71bdb13557@eafit.edu.co>
Date: Tue, 26 May 2020 09:57:43 -0400
In-Reply-To: <931cfc02-d662-f154-c453-276553e19a1e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Return-Path: htobonm@eafit.edu.co
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you for your answer.

This is how I'm making sure that it is polling. The workloads take 2=20
minutes, I'm checking the interrupts registered in /proc/interrupts for=20
the nvme device (the Intel Optane) when the workload starts and when the=20
workload ends. The interrupts count is almost zero, about 25 or so,=20
while when using an interrupt based engine I get about 600K interrupts.

Also, the way I'm loading the nvme driver is:

modprobe nvme poll_queues=3D4

As you said I'm using 4 polling queues because I only have 4 physical=20
cores. To check that they were actually created I use:

systool -vm nvme

Which shows that effectively there are 4 polling queues created.

I also checked the file /sys/block/nvme0n1/queue/io_poll and it is set=20
to 1. Sometimes I change the file /sys/block/nvme0n1/queue/io_poll_delay=20
to switch between hybrid and normal polling and it shows differences in=20
the CPU usage, the latencies, IOPS, ...

Another way is by checking the CPU usage, which says that the CPU is=20
almost completely occupied when polling.

Also, I tried with dmesg as you suggested and this is the output:

[627676.640431] nvme nvme0: 4/0/4 default/read/poll queues

I guess that shows that I was effectively using polling in the=20
workloads. What is weird is that when I don't use the flag HIPRI it runs=20
ok but using interrupts not polling. It might be important to say that=20
I'm always running with root user.

Does this information give you more hints about the problem?. Could you=20
please tell me in what filesystem polling is known to work 100% of the=20
time?.

Thank you for your help.

Hamilton.

On 26/05/20 12:17 a.=C2=A0m., Jens Axboe wrote:
> On 5/25/20 4:38 PM, Hamilton Tobon Mosquera wrote:
>> Thank you for your answer.
>>
>> I'm using ext4. I guess it supports polling because I could get sub 10
>> microseconds latency with an Intel Optane SSDPED1D280GA 260GB and
>> pvsync2. If it helps here's how I'm running it:
>>
>> fio global.fio --size=3D50G --ioengine=3Dio_uring --hipri --direct=3D1
>> --rw=3Drandwrite --iodepth=3D256 --bs=3D4K --numjobs=3D4 --offset_increm=
ent=3D25%
>>
>> The global.fio has:
>>
>> ioengine=3Dio_uring
>> hipri
>> direct=3D1
>> thread=3D1
>> buffered=3D0
>> size=3D100%
>> randrepeat=3D0
>> time_based
>> ramp_time=3D0
>> norandommap
>> refill_buffers
>> log_max_value=3D1
>> log_avg_msec=3D1000
>> group_reporting
>> percentile_list=3D50:60:70:80:90:95:99
>>
>> Your help is highly appreciated, thank you.
> I almost guarantee you that you are NOT using polling. Check with
> vmstat 1 and look at the interrupt rate. If it's about your IOPS
> rate, then you're doing IRQ based completions. If it's closer to 0,
> you're doing polled.
>
> If your fs supports it, then you likely did not allocate poll
> queues for NVMe. If nvme is builtin to the kernel, use nvme.poll_queues=
=3DN
> to allocate N poll queues, or use poll_queues=3DN as a module parameter
> if nvme is modular.
>
> Ideally you want N to be equal to the number of CPUs in the system.
> NVMe will report that it used at load time, here's an example from
> my laptop:
>
> [    2.396978] nvme nvme0: 1/8/8 default/read/poll queues
>
> You can check this right now by looking at dmesg. If you don't
> have any poll queues, preadv2 with IOCB_HIPRI will be IRQ based,
> not polled. io_uring just tells you this up front with -EOPNOTSUPP.
>
> --
> Jens Axboe
>
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


