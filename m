Return-Path: <htobonm@eafit.edu.co>
Subject: Re: [io_uring] Problems using io_uring engine
References: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
 <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
 <ed949243-f657-5f41-79f2-dc8a34459f27@eafit.edu.co>
 <931cfc02-d662-f154-c453-276553e19a1e@kernel.dk>
 <c5f64029-31c3-a9c0-5bbf-8a71bdb13557@eafit.edu.co>
 <ae5acec8-b630-982f-b809-6d14f82e29b2@kernel.dk>
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Message-ID: <f5ba6ebb-afda-1570-5f40-49cb0ef81c88@eafit.edu.co>
Date: Tue, 26 May 2020 16:21:46 -0400
In-Reply-To: <ae5acec8-b630-982f-b809-6d14f82e29b2@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Return-Path: htobonm@eafit.edu.co
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 26/05/20 3:18 p.=C2=A0m., Jens Axboe wrote:

> On 5/26/20 7:57 AM, Hamilton Tobon Mosquera wrote:
>> Thank you for your answer.
>>
>> This is how I'm making sure that it is polling. The workloads take 2
>> minutes, I'm checking the interrupts registered in /proc/interrupts for
>> the nvme device (the Intel Optane) when the workload starts and when the
>> workload ends. The interrupts count is almost zero, about 25 or so,
>> while when using an interrupt based engine I get about 600K interrupts.
>>
>> Also, the way I'm loading the nvme driver is:
>>
>> modprobe nvme poll_queues=3D4
>>
>> As you said I'm using 4 polling queues because I only have 4 physical
>> cores. To check that they were actually created I use:
>>
>> systool -vm nvme
>>
>> Which shows that effectively there are 4 polling queues created.
>>
>> I also checked the file /sys/block/nvme0n1/queue/io_poll and it is set
>> to 1. Sometimes I change the file /sys/block/nvme0n1/queue/io_poll_delay
>> to switch between hybrid and normal polling and it shows differences in
>> the CPU usage, the latencies, IOPS, ...
>>
>> Another way is by checking the CPU usage, which says that the CPU is
>> almost completely occupied when polling.
>>
>> Also, I tried with dmesg as you suggested and this is the output:
>>
>> [627676.640431] nvme nvme0: 4/0/4 default/read/poll queues
>>
>> I guess that shows that I was effectively using polling in the
>> workloads. What is weird is that when I don't use the flag HIPRI it runs
>> ok but using interrupts not polling. It might be important to say that
>> I'm always running with root user.
>>
>> Does this information give you more hints about the problem?. Could you
>> please tell me in what filesystem polling is known to work 100% of the
>> time?.
>>
>> Thank you for your help.
> You did the right thing on the NVMe side, I'm guessing then that it's
> ext4 again. What kernel are you using? I think only 5.7 and newer
> supports polling on ext4, you'll have better luck with XFS.
>
> And btw, please don't top-post. Reply with proper quoting, top
> posting totally messes up the flow of conversation.
>
> --
> Jens Axboe


Thank you for your answer.

Effectively it seems to be ext4 the problem. I tried with XFS and it=20
works, which seems weird to me. Does this mean that pvsync2 wasn't=20
polling at all?.

I have kernel 5.5 on Centos 8.

PD: Sorry for screwing the conversation, I didn't notice that before.

Thanks for your time.

Hamilton.

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


