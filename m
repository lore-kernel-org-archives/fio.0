Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <4E5CE96D.3000905@kernel.dk>
References: <1314664153-21134-1-git-send-email-dehrenberg@google.com>
	<4E5CE96D.3000905@kernel.dk>
Date: Tue, 30 Aug 2011 10:47:16 -0700
Message-ID: <CAAK6Zt23Aq86=5Cbe+Bzpy=8QoAmequf-9Keo7wE45hHWwxW7g@mail.gmail.com>
Subject: Re: [PATCH] Adding userspace_libaio_reap option
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: multipart/alternative; boundary=000e0cd4cc783c151704abbc9ac5
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--000e0cd4cc783c151704abbc9ac5
Content-Type: text/plain; charset=ISO-8859-1

On Tuesday, August 30, 2011, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-08-29 18:29, Dan Ehrenberg wrote:
>> When a single thread is reading from a libaio io_context_t object
>> in a non-blocking polling manner (that is, with the minimum number
>> of events to return being 0), then it is possible to safely read
>> events directly from user-space, taking advantage of the fact that
>> the io_context_t object is a pointer to memory with a certain layout.
>> This patch adds an option, userspace_libaio_reap, which allows
>> reading events in this manner when the libaio engine is used.
>>
>> You can observe its effect by setting iodepth_batch_complete=0
>> and seeing the change in distribution of system/user time based on
>> whether this new flag is set. If userspace_libaio_reap=1, then
>> busy polling takes place in userspace, and there is a larger amount of
>> usr CPU. If userspace_libaio_reap=0 (the default), then there is a
>> larger amount of sys CPU from the polling in the kernel.
>>
>> Polling from a queue in this manner is several times faster. In my
>> testing, it took less than an eighth as much time to execute a
>> polling operation in user-space than with the io_getevents syscall.
>
> Good stuff! The libaio side looks good, but I think we should add engine
> specific options under the specific engine. With all the
> commands/options that fio has, it quickly becomes a bit unwieldy. So,
> idea would be to have:
>
> ioengine=libaio:userspace_reap

Good idea. I was looking around for engine-specific options but didn't see
any examples. I like this convention.
>
> I'll look into that.
>
> One question on the code:
>
>> +static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
>> +                     struct io_event *events)
>> +{
>> +     long i = 0;
>> +     unsigned head;
>> +     struct aio_ring *ring = (struct aio_ring*)aio_ctx;
>> +
>> +     while (i < max) {
>> +             head = ring->head;
>> +
>> +             if (head == ring->tail) {
>> +                     /* There are no more completions */
>> +                     break;
>> +             } else {
>> +                     /* There is another completion to reap */
>> +                     events[i] = ring->events[head];
>> +                     ring->head = (head + 1) % ring->nr;
>> +                     i++;
>> +             }
>> +     }
>
> Don't we need a read barrier here before reading the head/tail?
>
Of course; how did I forget that?

I can make a fine barrier to run on my x64 machines, but it would be much
better to not introduce an architectural dependency. Is there any kind of
free library for this? Google has one (used in V8) but it's C++ and probably
isn't on enough architectures. And of course the Linux kernel has one, but
it would be a small project to extract it for use in user-space--or has
someone done this work?

> --
> Jens Axboe
>
>

Dan

--000e0cd4cc783c151704abbc9ac5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tuesday, August 30, 2011, Jens Axboe &lt;<a href=3D"mailto:axboe@kernel.=
dk">axboe@kernel.dk</a>&gt; wrote:<br>&gt; On 2011-08-29 18:29, Dan Ehrenbe=
rg wrote:<br>&gt;&gt; When a single thread is reading from a libaio io_cont=
ext_t object<br>
&gt;&gt; in a non-blocking polling manner (that is, with the minimum number=
<br>&gt;&gt; of events to return being 0), then it is possible to safely re=
ad<br>&gt;&gt; events directly from user-space, taking advantage of the fac=
t that<br>
&gt;&gt; the io_context_t object is a pointer to memory with a certain layo=
ut.<br>&gt;&gt; This patch adds an option, userspace_libaio_reap, which all=
ows<br>&gt;&gt; reading events in this manner when the libaio engine is use=
d.<br>
&gt;&gt;<br>&gt;&gt; You can observe its effect by setting iodepth_batch_co=
mplete=3D0<br>&gt;&gt; and seeing the change in distribution of system/user=
 time based on<br>&gt;&gt; whether this new flag is set. If userspace_libai=
o_reap=3D1, then<br>
&gt;&gt; busy polling takes place in userspace, and there is a larger amoun=
t of<br>&gt;&gt; usr CPU. If userspace_libaio_reap=3D0 (the default), then =
there is a<br>&gt;&gt; larger amount of sys CPU from the polling in the ker=
nel.<br>
&gt;&gt;<br>&gt;&gt; Polling from a queue in this manner is several times f=
aster. In my<br>&gt;&gt; testing, it took less than an eighth as much time =
to execute a<br>&gt;&gt; polling operation in user-space than with the io_g=
etevents syscall.<br>
&gt;<br>&gt; Good stuff! The libaio side looks good, but I think we should =
add engine<br>&gt; specific options under the specific engine. With all the=
<br>&gt; commands/options that fio has, it quickly becomes a bit unwieldy. =
So,<br>
&gt; idea would be to have:<br>&gt;<br>&gt; ioengine=3Dlibaio:userspace_rea=
p<br><br>Good idea. I was looking around for engine-specific options but di=
dn&#39;t see any examples. I like this convention.<br>&gt;<br>&gt; I&#39;ll=
 look into that.<br>
&gt;<br>&gt; One question on the code:<br>&gt;<br>&gt;&gt; +static int user=
_io_getevents(io_context_t aio_ctx, unsigned int max,<br>&gt;&gt; + =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct io_event *events)<br>&gt;&gt; +{<br=
>&gt;&gt; + =A0 =A0 long i =3D 0;<br>
&gt;&gt; + =A0 =A0 unsigned head;<br>&gt;&gt; + =A0 =A0 struct aio_ring *ri=
ng =3D (struct aio_ring*)aio_ctx;<br>&gt;&gt; +<br>&gt;&gt; + =A0 =A0 while=
 (i &lt; max) {<br>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 head =3D ring-&gt;hea=
d;<br>&gt;&gt; +<br>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 if (head =3D=3D ring=
-&gt;tail) {<br>
&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* There are no more com=
pletions */<br>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br=
>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 } else {<br>&gt;&gt; + =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 /* There is another completion to reap */<br>
&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 events[i] =3D ring-&gt;e=
vents[head];<br>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ring-&gt=
;head =3D (head + 1) % ring-&gt;nr;<br>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 i++;<br>&gt;&gt; + =A0 =A0 =A0 =A0 =A0 =A0 }<br>&gt;&gt; + =
=A0 =A0 }<br>
&gt;<br>&gt; Don&#39;t we need a read barrier here before reading the head/=
tail?<br>&gt;<br>Of course; how did I forget that?<br><br>I can make a fine=
 barrier to run on my x64 machines, but it would be much better to not intr=
oduce an architectural dependency. Is there any kind of free library for th=
is? Google has one (used in V8) but it&#39;s C++ and probably isn&#39;t on =
enough architectures. And of course the Linux kernel has one, but it would =
be a small project to extract it for use in user-space--or has someone done=
 this work?<br>
<br>&gt; --<br>&gt; Jens Axboe<br>&gt;<br>&gt;<br><br>Dan

--000e0cd4cc783c151704abbc9ac5--


