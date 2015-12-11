Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhXYQ5UqOppn_VGdO+TnR5VZScKW=TTsfjVbF7aoe8AHA@mail.gmail.com>
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
	<5669B23C.1020001@kernel.dk>
	<CALjAwxjLXTCRe0Ky08DB6in2aq_czkx5Oz8Osi7Mo=+7eFH9PQ@mail.gmail.com>
	<CANvN+e=CtQBfUmj6fQPUgaqHUXwzwY1SLuXV76n=AG2kLFpWSQ@mail.gmail.com>
	<20151210181540.GB21415@kernel.dk>
	<CANvN+e=U5O4LC40uE59iGn1jtkBGygbboXGcKpfXO2uTX3=bVw@mail.gmail.com>
	<5669C364.9020100@kernel.dk>
	<CANvN+ekovkotiX=EVxrYxmh4DJv0=+Hh4LQD+X5Ut8jDYgTdHg@mail.gmail.com>
	<5669C46F.3090300@kernel.dk>
	<CANvN+emkTn1aLk2MB41Z0hD3y0NLjoS3cz4jcF4w+ytP4A1d5w@mail.gmail.com>
	<CANvN+e=sgRBJiS8Toefk6nOHdtod1pr6bDPeux_audc5fUBUJg@mail.gmail.com>
	<566AECA3.6000108@kernel.dk>
	<CALjAwxhXYQ5UqOppn_VGdO+TnR5VZScKW=TTsfjVbF7aoe8AHA@mail.gmail.com>
Date: Fri, 11 Dec 2015 23:32:09 +0300
Message-ID: <CANvN+e=Tsiizv7tXg7HsPs9wZ_AAr3CLKbf2e4qOVMN6E2L78w@mail.gmail.com>
Subject: Re: Exit all jobs on error
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Content-Type: multipart/alternative; boundary=089e010d8b02b852910526a5375b
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--089e010d8b02b852910526a5375b
Content-Type: text/plain; charset=UTF-8

On Dec 11, 2015 22:59, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>
> On 11 December 2015 at 15:32, Jens Axboe <axboe@kernel.dk> wrote:
> > On 12/11/2015 03:01 AM, Andrey Kuzmin wrote:
> >>
> >> ^Cbs: 1 (f=1): [w(1)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> >> 01d:12h:24m:29s]
> >> Program received signal SIGINT, Interrupt.
> >> 0x00007ffff6b7ff3d in nanosleep () at
> >> ../sysdeps/unix/syscall-template.S:81
> >> 81 ../sysdeps/unix/syscall-template.S: No such file or directory.
> >> (gdb) bt
> >> #0  0x00007ffff6b7ff3d in nanosleep () at
> >> ../sysdeps/unix/syscall-template.S:81
> >> #1  0x00007ffff6bb14a4 in usleep (useconds=<optimized out>) at
> >> ../sysdeps/unix/sysv/linux/usleep.c:32
> >> #2  0x000000000045a7ed in do_usleep (usecs=10000) at backend.c:1951
> >> #3  0x000000000045b33c in run_threads () at backend.c:2216
> >> #4  0x000000000045b6a8 in fio_backend () at backend.c:2333
> >> #5  0x00000000004991cb in main (argc=4, argv=0x7fffffffdda8,
> >> envp=0x7fffffffddd0) at fio.c:60
> >
> >
> > That's not one of the IO threads, that's the main thread. It'll sit and
wait
> > in that loop until jobs finish. You'll need the backtrace of one of the
> > stuck IO thread instead, this trace is quite normal and expected of
backend.
> >
> > --
> > Jens Axboe
> >
>
> Andrey:
>
> Could you try
> thread apply all bt full
> (found over on
https://wiki.gentoo.org/wiki/Project:Quality_Assurance/Backtraces
> )?
>

That test case is already gone, but - if interested - you can easily
simulate it by randomly dropping an io_u inside the engine.

Regards,
Andrey

>
> --
> Sitsofe | http://sucs.org/~sits/

--089e010d8b02b852910526a5375b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Dec 11, 2015 22:59, &quot;Sitsofe Wheeler&quot; &lt;<a href=3D"mailto:si=
tsofe@gmail.com">sitsofe@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; On 11 December 2015 at 15:32, Jens Axboe &lt;<a href=3D"mailto:axboe@k=
ernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>
&gt; &gt; On 12/11/2015 03:01 AM, Andrey Kuzmin wrote:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; ^Cbs: 1 (f=3D1): [w(1)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 i=
ops] [eta<br>
&gt; &gt;&gt; 01d:12h:24m:29s]<br>
&gt; &gt;&gt; Program received signal SIGINT, Interrupt.<br>
&gt; &gt;&gt; 0x00007ffff6b7ff3d in nanosleep () at<br>
&gt; &gt;&gt; ../sysdeps/unix/syscall-template.S:81<br>
&gt; &gt;&gt; 81 ../sysdeps/unix/syscall-template.S: No such file or direct=
ory.<br>
&gt; &gt;&gt; (gdb) bt<br>
&gt; &gt;&gt; #0=C2=A0 0x00007ffff6b7ff3d in nanosleep () at<br>
&gt; &gt;&gt; ../sysdeps/unix/syscall-template.S:81<br>
&gt; &gt;&gt; #1=C2=A0 0x00007ffff6bb14a4 in usleep (useconds=3D&lt;optimiz=
ed out&gt;) at<br>
&gt; &gt;&gt; ../sysdeps/unix/sysv/linux/usleep.c:32<br>
&gt; &gt;&gt; #2=C2=A0 0x000000000045a7ed in do_usleep (usecs=3D10000) at b=
ackend.c:1951<br>
&gt; &gt;&gt; #3=C2=A0 0x000000000045b33c in run_threads () at backend.c:22=
16<br>
&gt; &gt;&gt; #4=C2=A0 0x000000000045b6a8 in fio_backend () at backend.c:23=
33<br>
&gt; &gt;&gt; #5=C2=A0 0x00000000004991cb in main (argc=3D4, argv=3D0x7ffff=
fffdda8,<br>
&gt; &gt;&gt; envp=3D0x7fffffffddd0) at fio.c:60<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; That&#39;s not one of the IO threads, that&#39;s the main thread.=
 It&#39;ll sit and wait<br>
&gt; &gt; in that loop until jobs finish. You&#39;ll need the backtrace of =
one of the<br>
&gt; &gt; stuck IO thread instead, this trace is quite normal and expected =
of backend.<br>
&gt; &gt;<br>
&gt; &gt; --<br>
&gt; &gt; Jens Axboe<br>
&gt; &gt;<br>
&gt;<br>
&gt; Andrey:<br>
&gt;<br>
&gt; Could you try<br>
&gt; thread apply all bt full<br>
&gt; (found over on <a href=3D"https://wiki.gentoo.org/wiki/Project:Quality=
_Assurance/Backtraces">https://wiki.gentoo.org/wiki/Project:Quality_Assuran=
ce/Backtraces</a><br>
&gt; )?<br>
&gt;</p>
<p dir=3D"ltr">That test case is already gone, but - if interested - you ca=
n easily simulate it by randomly dropping an io_u inside the engine.</p>
<p dir=3D"ltr">Regards,<br>
Andrey</p>
<p dir=3D"ltr">&gt;<br>
&gt; --<br>
&gt; Sitsofe | <a href=3D"http://sucs.org/~sits/">http://sucs.org/~sits/</a=
><br>
</p>

--089e010d8b02b852910526a5375b--

