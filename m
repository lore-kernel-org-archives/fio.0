Return-Path: <yuru.hong@gmail.com>
MIME-Version: 1.0
Sender: yuru.hong@gmail.com
In-Reply-To: <4E4A1069.606@kernel.dk>
References: <1313450590-22069-1-git-send-email-egouriou@google.com>
	<4E4A1069.606@kernel.dk>
Date: Mon, 22 Aug 2011 13:04:04 -0400
Message-ID: <CAE2LhvmL14G6S2ATRvV-pHUT_ZLYj7RYMZqPi2V8061ru9pgjw@mail.gmail.com>
Subject: Re: [PATCH] stats: fix io_u_plat out-of-bound accesses (round 2)
From: Yu-Ju Hong <yuju.hong@gmail.com>
Content-Type: multipart/alternative; boundary=20cf300e4f4bfcbcfa04ab1b1004
To: Jens Axboe <axboe@kernel.dk>
Cc: Eric Gouriou <egouriou@google.com>, Zhu Yanhai <zhu.yanhai@gmail.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>
List-ID: <fio@vger.kernel.org>

--20cf300e4f4bfcbcfa04ab1b1004
Content-Type: text/plain; charset=ISO-8859-1

Hi Jens, Zhu,

Sorry for all the troubles I caused for not checking the differences between
the Google internal version and the external version of fio. I couldn't
respond last week because I was out of town and did not have Internet access
nor my laptop last week. Also, my google.com account had been suspended
after I finished my internship, so I am currently using my gmail.com account
(which explains why the email got bounced). Thank you for discovering and
fixing the problem, and sorry again!

Eric,

Thank you very much for the follow-up!

Regards,
Yu-Ju


On Tue, Aug 16, 2011 at 2:38 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 2011-08-16 01:23, Eric Gouriou wrote:
> > Commit 833491908a1afd67 introduced the ability to report completion
> > latency percentiles. It also caused a memory corruption when running
> > with multiple threads due to out of bound accesses in show_run_stats().
> > The major index of the io_u_plat two-dimensional array is meant
> > to be DDIR_ value in {DDIR_READ, DDIR_WRITE} (i.e., {0, 1}). The
> > code in show_run_stats() incorrectly wrote into the array using
> > a major index with values {0, 1, 2}. Commit 0a0b49007cbce8d1 fixed
> > the out of bound accesses by increasing the size of the major
> > dimension of the io_u_plat array from 2 to 3.
> >
> > This patch reverts the size change from 0a0b49007cbce8d1 in favor
> > of avoiding the out-of-bound accesses in show_run_stats().
>
> This makes more sense, I didn't look carefully enough at this, the 3rd
> index is usually for trim.
>
> > Jens, Zhu,
> >
> > Yu-Ju is unlikely to be checking fio email traffic this week,
> > hence my follow-up. The error was introduced while porting
> > the patch between different versions of fio. The internal version
> > was tested appropriately but not the upstream version.
> >
> > Apologies for the trouble.
>
> No worries, thanks for following up on this so quickly. My group replies
> bounced on Yu-Ju's email.
>
> --
> Jens Axboe
>
>

--20cf300e4f4bfcbcfa04ab1b1004
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Jens, Zhu,<div><br></div><div>Sorry for all the troubles I caused for no=
t checking the differences between the Google internal version and the exte=
rnal version of fio. I couldn&#39;t respond last week because I was out of =
town and did not have Internet access nor my laptop last week. Also, my <a =
href=3D"http://google.com">google.com</a> account had been suspended after =
I finished my internship, so I am currently using my <a href=3D"http://gmai=
l.com">gmail.com</a> account (which explains why the email got bounced). Th=
ank you for discovering and fixing the problem, and sorry again!</div>
<div><br></div><div>Eric,</div><div><br></div><div>Thank you very much for =
the follow-up!</div><div><br></div><div>Regards,</div><div>Yu-Ju<br><font c=
lass=3D"Apple-style-span" color=3D"#333333" face=3D"arial, sans-serif"><br>=
<br>
</font><div><div class=3D"gmail_quote">On Tue, Aug 16, 2011 at 2:38 AM, Jen=
s Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kern=
el.dk</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">On 2011-08-16 01:23, Eric Gouriou wrote:<br>
&gt; Commit 833491908a1afd67 introduced the ability to report completion<br=
>
&gt; latency percentiles. It also caused a memory corruption when running<b=
r>
&gt; with multiple threads due to out of bound accesses in show_run_stats()=
.<br>
&gt; The major index of the io_u_plat two-dimensional array is meant<br>
&gt; to be DDIR_ value in {DDIR_READ, DDIR_WRITE} (i.e., {0, 1}). The<br>
&gt; code in show_run_stats() incorrectly wrote into the array using<br>
&gt; a major index with values {0, 1, 2}. Commit 0a0b49007cbce8d1 fixed<br>
&gt; the out of bound accesses by increasing the size of the major<br>
&gt; dimension of the io_u_plat array from 2 to 3.<br>
&gt;<br>
&gt; This patch reverts the size change from 0a0b49007cbce8d1 in favor<br>
&gt; of avoiding the out-of-bound accesses in show_run_stats().<br>
<br>
</div>This makes more sense, I didn&#39;t look carefully enough at this, th=
e 3rd<br>
index is usually for trim.<br>
<div class=3D"im"><br>
&gt; Jens, Zhu,<br>
&gt;<br>
&gt; Yu-Ju is unlikely to be checking fio email traffic this week,<br>
&gt; hence my follow-up. The error was introduced while porting<br>
&gt; the patch between different versions of fio. The internal version<br>
&gt; was tested appropriately but not the upstream version.<br>
&gt;<br>
&gt; Apologies for the trouble.<br>
<br>
</div>No worries, thanks for following up on this so quickly. My group repl=
ies<br>
bounced on Yu-Ju&#39;s email.<br>
<br>
--<br>
<font color=3D"#888888">Jens Axboe<br>
<br>
</font></blockquote></div><br></div></div>

--20cf300e4f4bfcbcfa04ab1b1004--

