Return-Path: <xiaofei.du008@gmail.com>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956EDB8E4@G9W0745.americas.hpqcorp.net>
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
 <534DB18A.4050507@kernel.dk> <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com>
 <534DE08D.2070604@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
 <CAND_vCYxvpDc8cqpQCoZye-eBHCWDajKhecCixDKac7aUOimMw@mail.gmail.com> <94D0CD8314A33A4D9D801C0FE68B402956EDB8E4@G9W0745.americas.hpqcorp.net>
From: Xiaofei Du <xiaofei.du008@gmail.com>
Date: Thu, 17 Apr 2014 11:29:51 -0700
Message-ID: <CAND_vCYQo03ADr68sURiiGfFTm5AH+bqDe6W=u4dhguJfjHj=Q@mail.gmail.com>
Subject: Re: Question about FIO sequential writes
Content-Type: multipart/alternative; boundary=001a1134b51ad43ee204f7413992
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>, aaronc <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

--001a1134b51ad43ee204f7413992
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Robert -- Thank you for the explanation.

Jens -- Thank you for your help as well.

Have a great day!!

Best,
Xiaofei



On Thu, Apr 17, 2014 at 7:30 AM, Elliott, Robert (Server Storage) <
Elliott@hp.com> wrote:

>  > Thanks for the tips. I don't understand the last point (- to avoid
>
> > filesystem interference, directly access the drive with
>
> > /dev/disk/by-path, /dev/disk/by-id, ...)
>
>
>
> > I googled it, but didn't find something related directly. Maybe
>
> > I googled the wrong key words. So could you please help to
>
> > explain this last point, or send me some links to read? Thanks a lot.
>
>
>
> Point fio to a block device rather than a file, like:
>
> filename=3D/dev/sdb
>
>
>
> However, the /dev/sdNN names are not persistent and can change when you
> reboot.  It is dangerous to hardcode them in a job description file that
> does writes. You may use these types of paths instead:
>
>
>
> filename=3D/dev/disk/by-path/pci-0000\:04\:00.0-scsi-0\:0\:0\:15
>
> points to the controller=E2=80=99s PCI ID (e.g., from lspci) and the obso=
lete
> bus:target:LUN mapping provided for the drive.    The bus:target:LUN
> mapping might not be persistent, depending on your controller and its
> driver.
>
>
>
> filename=3D/dev/disk/by-id/wwn-0x5000cca02b042ef0
>
> points to the worldwide name of the drive (safest)
>
>
>
> ---
>
> Rob Elliott    HP Server Storage
>
>
>
>
>

--001a1134b51ad43ee204f7413992
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Robert -- Thank you for the explanation.</div><div><b=
r></div><div>Jens -- Thank you for your help as well.</div><div><br></div><=
div>Have a great day!!<br></div><div><br></div><div>Best,</div><div>Xiaofei=
</div>

<div><br></div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Thu, Apr 17, 2014 at 7:30 AM, Elliott, Robert (Server Storage) <=
span dir=3D"ltr">&lt;<a href=3D"mailto:Elliott@hp.com" target=3D"_blank">El=
liott@hp.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">





<div lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div><div class=3D"">
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">&gt; Thanks for the tips.=
 I don&#39;t understand the last point (- to avoid<u></u><u></u></span></p>


<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">&gt; filesystem interfere=
nce, directly access the drive with
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">&gt; /dev/disk/by-path, /=
dev/disk/by-id, ...)<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">&gt; I googled it, but di=
dn&#39;t find something related directly. Maybe
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">&gt; I googled the wrong =
key words. So could you please help to
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">&gt; explain this last po=
int, or send me some links to read? Thanks a lot.<u></u><u></u></span></p>


<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
</div><p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&q=
uot;Calibri&quot;,&quot;sans-serif&quot;;color:#1f497d">Point fio to a bloc=
k device rather than a file, like:<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">filename=3D/dev/sdb<u></u=
><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">However, the /dev/sdNN na=
mes are not persistent and can change when you reboot.=C2=A0 It is dangerou=
s to hardcode them in a job description file that does writes.
 You may use these types of paths instead:<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">filename=3D/dev/disk/by-p=
ath/pci-0000\:04\:00.0-scsi-0\:0\:0\:15<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">points to the controller=
=E2=80=99s PCI ID (e.g., from lspci) and the obsolete bus:target:LUN mappin=
g provided for the drive.=C2=A0 =C2=A0=C2=A0The bus:target:LUN mapping migh=
t not
 be persistent, depending on your controller and its driver.<u></u><u></u><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">filename=3D/dev/disk/by-i=
d/wwn-0x5000cca02b042ef0<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">points to the worldwide n=
ame of the drive (safest)<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">---<u></u><u></u></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d">Rob Elliott=C2=A0=C2=A0=
=C2=A0 HP Server Storage<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1f497d"><u></u>=C2=A0<u></u></spa=
n></p>
<p class=3D"MsoNormal"><u></u>=C2=A0<u></u></p>
</div>
</div>

</blockquote></div><br></div>

--001a1134b51ad43ee204f7413992--

