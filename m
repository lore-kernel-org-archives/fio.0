Return-Path: <kishore.vinjam@gmail.com>
MIME-Version: 1.0
From: Kishore Vinjam <kishore.vinjam@gmail.com>
Date: Wed, 31 Aug 2016 10:40:35 -0700
Message-ID: <CAG1rLFekUcqFC4EBGXgop7e=NmuktcwvfDZt1Cpg4vSWOODc=A@mail.gmail.com>
Subject: fio reporting data corruption with bsrange and zoneskip.
Content-Type: multipart/alternative; boundary=047d7bd91a664c13df053b619817
To: fio@vger.kernel.org, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

--047d7bd91a664c13df053b619817
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E2=80=8B
Following command is reporting a data corruption. Wondering if it is a real
corruption from the backend disk or am I doing anything wrong on the FIO
command usage.

Looking in to the hexdump of the .expected and .received files (snippet in
the bottom), I have couple of observations that makes me suspect fio usage
more than the actual corruption from backend. I just want to make sure I am
right with the tool usage before digging in to the other end to far.

1. The expected data reports 1024 bytes of data and rest all zeros. My min
block size in bsrange is 3k, per my understanding the minimum block size
used for writes is min block in the bsrange. why is it expecting 1k data?
2. As shown below, the data mismatch is reported on "25-56" bytes and last
16 bytes of the first 1024 bytes.  Is there any significance to the blocks
25-56 in FIO. Some other tools i know use for signature. The device I am
testing is 4K fixed block and less chances(can't overrule) of 32 byte
corruption.


The hexdump of .expected file shows that frist 1KB has some data and rest
all are zeros.
`fio  --runtime=3D43200  --filename=3D/dev/mapper/mpathbkx --rw=3Drandrw
--ioengine=3Dlibaio --direct=3D1 --time_based --verify=3Dmd5 --verify_dump=
=3D1
--threads=3D8 --zonesize=3D1m --zoneskip=3D1024 --name=3Dzoning-unaligned-l=
arge
--bsrange=3D3k-1025k`
=E2=80=8B=E2=80=8B

**Corruption Comparision:**

> 00000000  ca ac 02 00 00 0c 00 00  02 8e 82 e5 32 c4 97 60  |   00000000
 ca ac 02 00 00 0c 00 00  02 8e 82 e5 32 c4 97 60  |
00000010  00 c0 32 00 00 00 00 00  01 00 00 00 10 07 0d 00  | | 00000010
 00 c0 32 00 00 00 00 00  4e 1e 00 00 61 76 0b 00  |
00000020  01 00 05 00 19 dc 0f 93  a9 ff d1 8a 62 9c 7e 9d  | | 00000020
 01 00 05 00 a1 2b a6 63  f9 ca 00 22 95 78 72 13  |
00000030  86 06 e8 ab cd b8 1d 91  15 3a a6 e5 b2 69 9e 1b  | | 00000030
 a6 0a 74 fa f8 45 bd d0  15 3a a6 e5 b2 69 9e 1b  |
00000040  42 47 aa 3f 63 5a ed 03  e8 48 54 44 77 0b 9a 1d  |   00000040
 42 47 aa 3f 63 5a ed 03  e8 48 54 44 77 0b 9a 1d  |
00000050  1d 89 16 c4 44 9f 4f 02  23 51 f4 53 dd 91 32 0d  |   00000050
 1d 89 16 c4 44 9f 4f 02  23 51 f4 53 dd 91 32 0d  |
....
_... trucated as there is no mismatch ..._
....
000003e0  f7 02 4f 6b 8e f1 1c 11  5e 60 ee 4b 8a 68 5d 0c  |   000003e0
 f7 02 4f 6b 8e f1 1c 11  5e 60 ee 4b 8a 68 5d 0c  |
000003f0  0b cc 4e 19 1a 87 58 10  81 59 24 dd 3b 04 0b 0c  |   000003f0
 0b cc 4e 19 1a 87 58 10  81 59 24 dd 3b 04 0b 0c  |
00000400  00 90 c4 9e 3e 00 00 00  00 90 56 42 1d 00 00 00  | | 00000400
 00 00 00 00 00 00 00 00  61 0d 02 00 00 00 00 00  |
00000410  00 90 d2 d0 3d 00 00 00  00 90 be d4 17 00 00 00  | | 00000410
 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |
00000420  00 90 d8 09 3a 00 00 00  00 90 f8 00 43 00 00 00  | | 00000420
 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |
00000430  00 90 42 6c 21 00 00 00  00 90 6a cf 26 00 00 00  | | 00000430
 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |

--047d7bd91a664c13df053b619817
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:tahoma,s=
ans-serif;font-size:small"><span style=3D"background-color:rgb(255,255,255)=
"><font color=3D"#000000"><br clear=3D"all"></font></span></div><div><div c=
lass=3D"gmail_signature"><span style=3D"background-color:rgb(255,255,255)">=
<font color=3D"#000000"><div class=3D"gmail_default" style=3D"font-family:t=
ahoma,sans-serif;font-size:small;display:inline">=E2=80=8B</div><font face=
=3D"tahoma, sans-serif">Following command is reporting a data corruption. W=
ondering if it is a real corruption from the backend disk or am I doing any=
thing wrong on the FIO command usage.</font></font></span></div><div class=
=3D"gmail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-=
color:rgb(255,255,255)" color=3D"#000000"><br></font></div><div class=3D"gm=
ail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-color:=
rgb(255,255,255)" color=3D"#000000">Looking in to the hexdump of the .expec=
ted and .received files (snippet in the bottom), I have couple of observati=
ons that makes me suspect fio usage more than the actual corruption from ba=
ckend. I just want to make sure I am right with the tool usage before diggi=
ng in to the other end to far.</font></div><div class=3D"gmail_signature"><=
font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)=
" color=3D"#000000"><br></font></div><div class=3D"gmail_signature"><font f=
ace=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" colo=
r=3D"#000000">1. The expected data reports 1024 bytes of data and rest all =
zeros. My min block size in bsrange is 3k, per my understanding the minimum=
 block size used for writes is min block in the bsrange. why is it expectin=
g 1k data?</font></div><div class=3D"gmail_signature"><font face=3D"tahoma,=
 sans-serif" style=3D"background-color:rgb(255,255,255)" color=3D"#000000">=
2. As shown below, the data mismatch is reported on &quot;25-56&quot; bytes=
 and last 16 bytes of the first 1024 bytes.=C2=A0 Is there any significance=
 to the blocks 25-56 in FIO. Some other tools i know use for signature. The=
 device I am testing is 4K fixed block and less chances(can&#39;t overrule)=
 of 32 byte corruption.</font></div><div class=3D"gmail_signature"><font fa=
ce=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" color=
=3D"#000000"><br></font></div><div class=3D"gmail_signature"><font face=3D"=
tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" color=3D"#0=
00000"><br></font></div><div class=3D"gmail_signature"><font face=3D"tahoma=
, sans-serif" style=3D"background-color:rgb(255,255,255)" color=3D"#000000"=
>The hexdump of .expected file shows that frist 1KB has some data and rest =
all are zeros.=C2=A0</font></div><div class=3D"gmail_signature"><font face=
=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" color=
=3D"#000000">`fio =C2=A0--runtime=3D43200 =C2=A0--filename=3D/dev/mapper/mp=
athbkx --rw=3Drandrw --ioengine=3Dlibaio --direct=3D1 --time_based --verify=
=3Dmd5 --verify_dump=3D1 --threads=3D8 --zonesize=3D1m --zoneskip=3D1024 --=
name=3Dzoning-unaligned-large --bsrange=3D3k-1025k`</font></div><div class=
=3D"gmail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-=
color:rgb(255,255,255)" color=3D"#000000"><div class=3D"gmail_default" styl=
e=3D"font-family:tahoma,sans-serif;font-size:small;display:inline">=E2=80=
=8B=E2=80=8B</div><br></font></div><div class=3D"gmail_signature"><font fac=
e=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" color=
=3D"#000000">**Corruption Comparision:**</font></div><div class=3D"gmail_si=
gnature"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(25=
5,255,255)" color=3D"#000000"><br></font></div><div class=3D"gmail_signatur=
e"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,=
255)" color=3D"#000000">&gt; 00000000 =C2=A0ca ac 02 00 00 0c 00 00 =C2=A00=
2 8e 82 e5 32 c4 97 60 =C2=A0| =C2=A0 00000000 =C2=A0ca ac 02 00 00 0c 00 0=
0 =C2=A002 8e 82 e5 32 c4 97 60 =C2=A0|</font></div><div class=3D"gmail_sig=
nature"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255=
,255,255)" color=3D"#000000">00000010 =C2=A000 c0 32 00 00 00 00 00 =C2=A00=
1 00 00 00 10 07 0d 00 =C2=A0| | 00000010 =C2=A000 c0 32 00 00 00 00 00 =C2=
=A04e 1e 00 00 61 76 0b 00 =C2=A0|</font></div><div class=3D"gmail_signatur=
e"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,=
255)" color=3D"#000000">00000020 =C2=A001 00 05 00 19 dc 0f 93 =C2=A0a9 ff =
d1 8a 62 9c 7e 9d =C2=A0| | 00000020 =C2=A001 00 05 00 a1 2b a6 63 =C2=A0f9=
 ca 00 22 95 78 72 13 =C2=A0|</font></div><div class=3D"gmail_signature"><f=
ont face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)"=
 color=3D"#000000">00000030 =C2=A086 06 e8 ab cd b8 1d 91 =C2=A015 3a a6 e5=
 b2 69 9e 1b =C2=A0| | 00000030 =C2=A0a6 0a 74 fa f8 45 bd d0 =C2=A015 3a a=
6 e5 b2 69 9e 1b =C2=A0|</font></div><div class=3D"gmail_signature"><font f=
ace=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" colo=
r=3D"#000000">00000040 =C2=A042 47 aa 3f 63 5a ed 03 =C2=A0e8 48 54 44 77 0=
b 9a 1d =C2=A0| =C2=A0 00000040 =C2=A042 47 aa 3f 63 5a ed 03 =C2=A0e8 48 5=
4 44 77 0b 9a 1d =C2=A0|</font></div><div class=3D"gmail_signature"><font f=
ace=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" colo=
r=3D"#000000">00000050 =C2=A01d 89 16 c4 44 9f 4f 02 =C2=A023 51 f4 53 dd 9=
1 32 0d =C2=A0| =C2=A0 00000050 =C2=A01d 89 16 c4 44 9f 4f 02 =C2=A023 51 f=
4 53 dd 91 32 0d =C2=A0|</font></div><div class=3D"gmail_signature"><font f=
ace=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" colo=
r=3D"#000000">....</font></div><div class=3D"gmail_signature"><font face=3D=
"tahoma, sans-serif" style=3D"background-color:rgb(255,255,255)" color=3D"#=
000000">_... trucated as there is no mismatch ..._</font></div><div class=
=3D"gmail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-=
color:rgb(255,255,255)" color=3D"#000000">....</font></div><div class=3D"gm=
ail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-color:=
rgb(255,255,255)" color=3D"#000000">000003e0 =C2=A0f7 02 4f 6b 8e f1 1c 11 =
=C2=A05e 60 ee 4b 8a 68 5d 0c =C2=A0| =C2=A0 000003e0 =C2=A0f7 02 4f 6b 8e =
f1 1c 11 =C2=A05e 60 ee 4b 8a 68 5d 0c =C2=A0|</font></div><div class=3D"gm=
ail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-color:=
rgb(255,255,255)" color=3D"#000000">000003f0 =C2=A00b cc 4e 19 1a 87 58 10 =
=C2=A081 59 24 dd 3b 04 0b 0c =C2=A0| =C2=A0 000003f0 =C2=A00b cc 4e 19 1a =
87 58 10 =C2=A081 59 24 dd 3b 04 0b 0c =C2=A0|</font></div><div class=3D"gm=
ail_signature"><font face=3D"tahoma, sans-serif" style=3D"background-color:=
rgb(255,255,255)" color=3D"#000000">00000400 =C2=A000 90 c4 9e 3e 00 00 00 =
=C2=A000 90 56 42 1d 00 00 00 =C2=A0| | 00000400 =C2=A000 00 00 00 00 00 00=
 00 =C2=A061 0d 02 00 00 00 00 00 =C2=A0|</font></div><div class=3D"gmail_s=
ignature"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(2=
55,255,255)" color=3D"#000000">00000410 =C2=A000 90 d2 d0 3d 00 00 00 =C2=
=A000 90 be d4 17 00 00 00 =C2=A0| | 00000410 =C2=A000 00 00 00 00 00 00 00=
 =C2=A000 00 00 00 00 00 00 00 =C2=A0|</font></div><div class=3D"gmail_sign=
ature"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,=
255,255)" color=3D"#000000">00000420 =C2=A000 90 d8 09 3a 00 00 00 =C2=A000=
 90 f8 00 43 00 00 00 =C2=A0| | 00000420 =C2=A000 00 00 00 00 00 00 00 =C2=
=A000 00 00 00 00 00 00 00 =C2=A0|</font></div><div class=3D"gmail_signatur=
e"><font face=3D"tahoma, sans-serif" style=3D"background-color:rgb(255,255,=
255)" color=3D"#000000">00000430 =C2=A000 90 42 6c 21 00 00 00 =C2=A000 90 =
6a cf 26 00 00 00 =C2=A0| | 00000430 =C2=A000 00 00 00 00 00 00 00 =C2=A000=
 00 00 00 00 00 00 00 =C2=A0|</font></div></div><div><br></div>
</div>

--047d7bd91a664c13df053b619817--

