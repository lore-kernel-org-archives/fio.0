Return-Path: <htobonm@eafit.edu.co>
Subject: Re: [io_uring] Problems using io_uring engine
References: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
 <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Message-ID: <ed949243-f657-5f41-79f2-dc8a34459f27@eafit.edu.co>
Date: Mon, 25 May 2020 18:38:20 -0400
In-Reply-To: <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Return-Path: htobonm@eafit.edu.co
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thank you for your answer.

I'm using ext4. I guess it supports polling because I could get sub 10=20
microseconds latency with an Intel Optane SSDPED1D280GA 260GB and=20
pvsync2. If it helps here's how I'm running it:

fio global.fio --size=3D50G --ioengine=3Dio_uring --hipri --direct=3D1=20
--rw=3Drandwrite --iodepth=3D256 --bs=3D4K --numjobs=3D4 --offset_increment=
=3D25%

The global.fio has:

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

Your help is highly appreciated, thank you.

Hamilton.

On 25/05/20 3:21 p.=C2=A0m., Jens Axboe wrote:
> On 5/25/20 11:45 AM, Hamilton Tobon Mosquera wrote:
>> Hi there,
>>
>> I'm trying to run sequential and random reads/writes in parallel using
>> the io_uring engine with the HIPRI flag activated to enable polling. The
>> file size is 200G, the number of fio threads is 4. The --size flags is
>> set to 200/4, and the --offset_increment is set to 25%. I could
>> effectively do it with pvsync2 engine but when I switch to io_uring the
>> workloads immediately (they do not even work for 1 sec) fail with these
>> errors:
>>
>> fio: io_u error on file /path/to/file: Operation not supported: write
>> offset=3D3238043648, buflen=3D4096
>> fio: io_u error on file /path/to/file: Operation not supported: write
>> offset=3D88715874304, buflen=3D4096
>> fio: io_u error on file /path/to/file: Operation not supported: write
>> offset=3D174739943424, buflen=3D4096
>> fio: io_u error on file /path/to/file: Operation not supported: write
>> offset=3D112642154496, buflen=3D4096
>>
>>
>> The offsets are under 200G, I don't understand why it's returning those
>> errors. Can someone help please?.
> What file system are you using? I don't think it supports IO polling.
> io_uring actually checks for this, with preadv you just get normal
> schedule based IO.
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


