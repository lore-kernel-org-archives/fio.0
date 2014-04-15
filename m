Return-Path: <xiaofei.du008@gmail.com>
MIME-Version: 1.0
From: Xiaofei Du <xiaofei.du008@gmail.com>
Date: Tue, 15 Apr 2014 15:14:24 -0700
Message-ID: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
Subject: Question about FIO sequential writes
Content-Type: multipart/alternative; boundary=001a1134b51a261cf604f71c213b
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, aaronc@cse.unsw.edu.au
List-ID: <fio@vger.kernel.org>

--001a1134b51a261cf604f71c213b
Content-Type: text/plain; charset=UTF-8

Dear Jens,

I have a couple questions about FIO.

First question. For default ioengine, with direct IO option enabled. On a
hard drive with writing cache disabled. I got random writes faster than
sequential writes. I couldn't explain this. Can you please help me explain
if you know the reason. Could that be a bug?

Second question. For libaio ioengin, with direct IO option enabled and on a
hard drive with writing cache disabled, I could get very high IOPS for
sequential writes if I keep increasing the iodepth. The IOPS I got seems
unreasonable. It could go up to 16000 IOPS for 4k blocks. So is there
anything wrong with sequential writes in FIO?

Thanks a lot for your help.

Best,
Xiaofei

--001a1134b51a261cf604f71c213b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-family:arial,sans-serif;font-size:13px=
">Dear Jens,</span><div style=3D"font-family:arial,sans-serif;font-size:13p=
x"><br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">I h=
ave a couple questions about FIO.</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">First question. For de=
fault ioengine, with direct IO option enabled. On a hard drive with writing=
 cache disabled. I got random writes faster than sequential writes. I could=
n&#39;t explain this. Can you please help me explain if you know the reason=
. Could that be a bug?</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">Second question. For l=
ibaio ioengin, with direct IO option enabled and on a hard drive with writi=
ng cache disabled, I could get very high IOPS for sequential writes if I ke=
ep increasing the iodepth. The IOPS I got seems unreasonable. It could go u=
p to 16000 IOPS for 4k blocks. So is there anything wrong with sequential w=
rites in FIO?</div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">Thanks a lot for your =
help.</div><div style=3D"font-family:arial,sans-serif;font-size:13px"><br><=
/div>

<div style=3D"font-family:arial,sans-serif;font-size:13px">Best,</div><div =
style=3D"font-family:arial,sans-serif;font-size:13px">Xiaofei</div></div>

--001a1134b51a261cf604f71c213b--

