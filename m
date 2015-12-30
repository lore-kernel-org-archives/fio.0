Return-Path: <tbertaud@conforama.fr>
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: RE: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time
 Out
Date: Wed, 30 Dec 2015 18:34:31 +0000
Message-ID: <VI1PR05MB13435F5190D9D9A17C59315BB1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
References: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>,<56840F80.4060903@kernel.dk>
In-Reply-To: <56840F80.4060903@kernel.dk>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hello Jens,

>That's expected - when the main thread goes to sleep, it checks for this
>status dump file. If it exists, then it'll show the current summary of
>stats, then unlink it.
Thanks for explain this point.

Just to confirm my understanding the following option with engine 'posixaio=
'
iodepth=3D128 and numjobs=3D128 =3D>=20
I don't use 'thread' option so i think with iodpeth=3D128 the main fio proc=
ess will fork to create 128 process.
With numjob=3D128 that imply, i'll clone each forked process from fio (due =
to iodepth) that's imply 16384 process (128 * 128).
If i use threads enabled, with iodepth=3D128 the main fio process will crea=
te with pthread_create 128 threads for itself.
With numjobs=3D128, the ain fio process will clone to have  16384 threads i=
nto itselft  or it will fork to create  128 process and each process has 12=
8 threads.=20

> That's the main thread, what are the IO threads doing?
If i follow disk I/O there are no activities.
This kind of information for fio process can help or not to answer the ques=
tions?
The list of thread by process this:
   # ps -mo THREAD
       USER      PID     PPID        TID ST  CP PRI SC    WCHAN        F   =
  TT BND COMMAND
       root  9437428 10551472          - A    0  60  1        -   200001  p=
ts/0   - ksh
          -        -        -   18350143 S    0  60  1        -    10400   =
   -   - -
     padmin 10551472 11534386          - A    0  60  1        -   240001  p=
ts/0   - -rksh
          -        -        -   49873143 S    0  60  1        -    10400   =
   -   - -
       root 11206870  9437428          - A    1  60  1        -   200001  p=
ts/0   - bash
          -        -        -   48759011 S    1  60  1        -   410400   =
   -   - -
       root 62914724 11206870          - A    6  63  1        -   200001  p=
ts/0   - ps -mo THREAD
          -        -        -  116850921 R    6  63  1        -   400000   =
   -   - -
   #
Or thread for a given process like this:
   # ps -mp 9437428 -o THREAD
       USER      PID     PPID        TID ST  CP PRI SC    WCHAN        F   =
  TT BND COMMAND
       root  9437428 10551472          - A    0  60  1        -   200001  p=
ts/0   - ksh
          -        -        -   18350143 S    0  60  1        -    10400   =
   -   - -
   #

I tried to use gdb against the live process but i don't how to progress wit=
h it?
I can do gdb against the executable also but i don't know how to progress w=
hit it?

Regards,
Thierry

