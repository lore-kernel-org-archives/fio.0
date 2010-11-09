Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Sender: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>
Date: Tue, 9 Nov 2010 10:39:21 -0700
Subject: fio and multithreading
Message-ID: <AANLkTin+_h4qUpwWw_0-ANwpbfPaMueW+9JcnXJ3TkGD@mail.gmail.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_AANLkTinh4qUpwWw0ANwpbfPaMueW9JcnXJ3TkGDmailgmailcom_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_000_AANLkTinh4qUpwWw0ANwpbfPaMueW9JcnXJ3TkGDmailgmailcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 9, 2010 at 2:16 PM, Jens Axboe <jaxboe@fusionio.com<mailto:jaxb=
oe@fusionio.com>> wrote:
[ ... ]

This looks pretty straightforward - the file is created, but not filled
with a verifiable pattern. You want to run the workload with rw=3Dwrite
at least once first, then you can use a read-only verify workload later
if you want.

Hello Jens,

Sorry for the confusion. Something else I came across is the global variabl=
e last_tv in gettime.c. As far as I can see this variable is shared over al=
l fio threads and multiple threads can update this variable simultaneously =
? I was surprised to see that the variable last_tv is updated non-atomicall=
y and without being protected by any kind of lock. Shouldn't such behavior =
be documented ?

And if my analysis is correct, the variable thread_data.runstate is also sh=
ared over threads. Will the code that reads that variable work correctly on=
 a multiprocessor system that allows write reordering ? Or, in other words,=
 have any assumptions been made about values written by a worker thread bei=
ng available to the main thread as soon as the main thread notices that the=
 thread state has been updated ?

Something else I noticed is that the function print_thread_status() is invo=
ked from a SIGALRM signal handler, and that print_thread_status() invokes e=
.g. printf(). I'm afraid that that's not entirely POSIX-compliant: the POSI=
X specs define a limitative list of functions that may be invoked from sign=
al handlers, and printf() is not included in that list. That list can be fo=
und e.g. here: <http://www.opengroup.org/onlinepubs/009695399/functions/xsh=
_chap02_04.html#tag_02_04> http://www.opengroup.org/onlinepubs/9699919799/f=
unctions/V2_chap02.html. I'm not sure though what the consequences are of i=
nvoking functions that are not async-signal-safe from a signal handler.

Bart.

--_000_AANLkTinh4qUpwWw0ANwpbfPaMueW9JcnXJ3TkGDmailgmailcom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 9, 2010 at 2:16 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D=
"mailto:jaxboe@fusionio.com">jaxboe@fusionio.com</a>&gt;</span> wrote:<br><=
div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin=
: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-lef=
t: 1ex;">

<div><div></div><div class=3D"h5">[ ... ]<br><br>
</div></div>This looks pretty straightforward - the file is created, but no=
t filled<br>
with a verifiable pattern. You want to run the workload with rw=3Dwrite<br>
at least once first, then you can use a read-only verify workload later<br>
if you want.<br></blockquote></div><br>Hello Jens,<br><br>Sorry for the con=
fusion. Something else I came across is the global variable last_tv in gett=
ime.c. As far as I can see this variable is shared over all fio threads and=
 multiple threads can update this variable simultaneously ? I was surprised=
 to see that the variable last_tv is updated non-atomically and without bei=
ng protected by any kind of lock. Shouldn&#39;t such behavior be documented=
 ?<br>

<br>And if my analysis is correct, the variable thread_data.runstate is als=
o shared over threads. Will the code that reads that variable work correctl=
y on a multiprocessor system that allows write reordering ? Or, in other wo=
rds, have any assumptions been made about values written by a worker thread=
 being available to the main thread as soon as the main thread notices that=
 the thread state has been updated ?<br>

<br>Something else I noticed is that the function print_thread_status() is =
invoked from a SIGALRM signal handler, and that print_thread_status() invok=
es e.g. printf(). I&#39;m afraid that that&#39;s not entirely POSIX-complia=
nt: the POSIX specs define a limitative list of functions that may be invok=
ed from signal handlers, and printf() is not included in that list. That li=
st can be found e.g. here: <a href=3D"http://www.opengroup.org/onlinepubs/0=
09695399/functions/xsh_chap02_04.html#tag_02_04"></a><a href=3D"http://www.=
opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html">http://www.op=
engroup.org/onlinepubs/9699919799/functions/V2_chap02.html</a>. I&#39;m not=
 sure though what the consequences are of invoking functions that are not a=
sync-signal-safe from a signal handler.<br>

<br>Bart.<br>

--_000_AANLkTinh4qUpwWw0ANwpbfPaMueW9JcnXJ3TkGDmailgmailcom_--


