Return-Path: <nikhil19kekan@gmail.com>
MIME-Version: 1.0
Date: Mon, 27 Jan 2014 15:04:16 +0530
Message-ID: <CA+MOiPbM53EdH9nw0ONovkMHAJYwFQ5ZhCy4xk05Yfibz8=9yw@mail.gmail.com>
Subject: asking a doubt
From: Nikhil Kekan <nikhil19kekan@gmail.com>
Content-Type: multipart/alternative; boundary=047d7b5d58684fab1704f0f0693c
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, amitkale@geeksofpune.in, Deepen Mehta <deepenmehta@gmail.com>, jayesh nair <jayesh5089@gmail.com>, Nikhil Kekan <nikhil19kekan@gmail.com>, Shrish Agone <shrish.agone@gmail.com>, tushar mungre <tusharmungre26@gmail.com>, virbhadra patil <patil.vir1@gmail.com>
List-ID: <fio@vger.kernel.org>

--047d7b5d58684fab1704f0f0693c
Content-Type: text/plain; charset=ISO-8859-1

Hello sir
I am nikhil,I am studying the fio source code.
I found that function "display_thread_status" from file "eta.c" displays
the thread status while simulating the workload.
With a single thread there is no issue since i can get
percentage done from "perc_str"(string variable)
read rate from "rate_str[DDIR_READ]"
write rate from "rate_str[DDIR_WRITE]"
read iops from "iops_str[DDIR_READ]"
and so on of the whole workload since there is a single thread
but when multiple threads are acting all the threads will one by one access
function "display_thread_status"(critical section) and will display there
respective iops,rate,eta etc.
my question is how can i get average aggregate rate,iops,eta of the
complete workload?
thank you for your time and concern
please kindly reply
thank you

--047d7b5d58684fab1704f0f0693c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello sir<br>I am nikhil,I am studying the fio source code=
.<br>I found that function &quot;display_thread_status&quot; from file &quo=
t;eta.c&quot; displays the thread status while simulating the workload.<div=
>
With a single thread there is no issue since i can get=A0</div><div>percent=
age done from &quot;perc_str&quot;(string variable)</div><div>read rate fro=
m &quot;rate_str[DDIR_READ]&quot;</div><div>write rate from &quot;rate_str[=
DDIR_WRITE]&quot;</div>
<div>read iops from &quot;iops_str[DDIR_READ]&quot;=A0</div><div>and so on =
of the whole workload since there is a single thread</div><div>but when mul=
tiple threads are acting all the threads will one by one access function &q=
uot;display_thread_status&quot;(critical section) and will display there re=
spective iops,rate,eta etc.</div>
<div>my question is how can i get average aggregate rate,iops,eta of the co=
mplete workload?</div><div>thank you for your time and concern</div><div>pl=
ease kindly reply</div><div>thank you</div><div><br></div></div>

--047d7b5d58684fab1704f0f0693c--


