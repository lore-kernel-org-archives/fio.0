Return-Path: <bfulton@google.com>
MIME-Version: 1.0
Date: Thu, 23 Oct 2014 11:51:51 -0700
Message-ID: <CANff2=MSq+tGGo9kSFVuXYN-ttbM==fWhWckwM5MNFczWVV2ZA@mail.gmail.com>
Subject: [RFC PATCH] Loop Iteration Offset Bug
From: Brian Fulton <bfulton@google.com>
Content-Type: multipart/alternative; boundary=001a113d65e8ae86ea05061b8eee
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Akash Verma <akashv@google.com>
List-ID: <fio@vger.kernel.org>

--001a113d65e8ae86ea05061b8eee
Content-Type: text/plain; charset=UTF-8

I have a proposal for a fix for the loop offset bug described here:
http://www.spinics.net/lists/fio/msg03386.html

- Brian


From 7272b3862cc3b3c22ddfb2d5b78348fe69c3fa2b Mon Sep 17 00:00:00 2001
From: Brian Fulton <bfulton@google.com>
Date: Thu, 23 Oct 2014 11:40:59 -0700
Subject: [PATCH 1/1] Reset file descriptor offset value to the initial value
 when file is closed and io state is cleared. This fixes the bug where
 previous offset values persist between loop iterations.

---
 libfio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libfio.c b/libfio.c
index 9ed802a..b823bd4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -108,8 +108,10 @@ void clear_io_state(struct thread_data *td)
  reset_io_counters(td);

  close_files(td);
- for_each_file(td, f, i)
+ for_each_file(td, f, i) {
  fio_file_clear_done(f);
+ f->file_offset = get_start_offset(td, f);
+ }

  /*
  * Set the same seed to get repeatable runs
-- 
2.1.0.rc2.206.gedb03e5

--001a113d65e8ae86ea05061b8eee
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have a proposal for a fix for the loop offset bug descri=
bed here:<br><a href=3D"http://www.spinics.net/lists/fio/msg03386.html">htt=
p://www.spinics.net/lists/fio/msg03386.html</a><div><br></div><div>- Brian<=
/div><div><div><br></div><div><br></div><div><div><div>From 7272b3862cc3b3c=
22ddfb2d5b78348fe69c3fa2b Mon Sep 17 00:00:00 2001</div><div>From: Brian Fu=
lton &lt;<a href=3D"mailto:bfulton@google.com">bfulton@google.com</a>&gt;</=
div><div>Date: Thu, 23 Oct 2014 11:40:59 -0700</div><div>Subject: [PATCH 1/=
1] Reset file descriptor offset value to the initial value</div><div>=C2=A0=
when file is closed and io state is cleared. This fixes the bug where</div>=
<div>=C2=A0previous offset values persist between loop iterations.</div><di=
v><br></div><div>---</div><div>=C2=A0libfio.c | 4 +++-</div><div>=C2=A01 fi=
le changed, 3 insertions(+), 1 deletion(-)</div><div><br></div><div>diff --=
git a/libfio.c b/libfio.c</div><div>index 9ed802a..b823bd4 100644</div><div=
>--- a/libfio.c</div><div>+++ b/libfio.c</div><div>@@ -108,8 +108,10 @@ voi=
d clear_io_state(struct thread_data *td)</div><div>=C2=A0<span class=3D"" s=
tyle=3D"white-space:pre">	</span>reset_io_counters(td);</div><div>=C2=A0</d=
iv><div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</span>close_file=
s(td);</div><div>-<span class=3D"" style=3D"white-space:pre">	</span>for_ea=
ch_file(td, f, i)</div><div>+<span class=3D"" style=3D"white-space:pre">	</=
span>for_each_file(td, f, i) {</div><div>=C2=A0<span class=3D"" style=3D"wh=
ite-space:pre">		</span>fio_file_clear_done(f);</div><div>+<span class=3D""=
 style=3D"white-space:pre">		</span>f-&gt;file_offset =3D get_start_offset(=
td, f);</div><div>+<span class=3D"" style=3D"white-space:pre">	</span>}</di=
v><div>=C2=A0</div><div>=C2=A0<span class=3D"" style=3D"white-space:pre">	<=
/span>/*</div><div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</span=
> * Set the same seed to get repeatable runs</div><div>--=C2=A0</div><div>2=
.1.0.rc2.206.gedb03e5</div></div></div></div><div><br></div></div>

--001a113d65e8ae86ea05061b8eee--

