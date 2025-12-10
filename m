Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD1421CC44
	for <fio@vger.kernel.org>; Wed, 10 Dec 2025 06:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346851; cv=none; b=rTxOe/t1Rww8X5zK/r6yjM9x9uv6wUU7Y3oPSKEerRm21gg8lKhcHyKi52VQMNmZ6pz/Qz1D3mnbZYsWsp4LEM0WRoRoDg7Rf0josXTqRHda1lcVqruhdLwPluKcGbCqA+1y4o76lFgGxkbmALDOl0d9nENZnDJAfDoFHXZqXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346851; c=relaxed/simple;
	bh=7x3aSUhOKMRj78Fvxwd5Te4LNaubhW4OWKYucgE75i8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=k7Zz7lgT0qQqa0MgtY+sM45b0Nc3dB0WGvw7KsFIeeGN1yvdUmS0NEGoTM0t5Hp7+y+jbAXYNG1KziEAiVqiD+RnVdN5yafv2i0K1T4zCtkw+iD1RU403NX/JJ7/mpI7GZ/oU2hNcR2yBrvzN+GkDxjVEOyTVsT4xC/gwfgyd0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1Sx39a6; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1Sx39a6"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78c33f74b72so33506587b3.2
        for <fio@vger.kernel.org>; Tue, 09 Dec 2025 22:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765346848; x=1765951648; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DlRml3/6tvhtUX/koXqp3LZ2xQ/wKngBjDQJLsuwWk4=;
        b=N1Sx39a6WX7kxAG6sm5Rx82sbWVDyr+lyTI5+QJBTlRBZRUKW6QvUJFJ9vbjTBnPhQ
         QzKHZGIPRmVUtO03aGvuzYqeJiJZVgPmFslfBjvaVAzMevJ6o7NkB38tAnirIJ2pbAU8
         P7o9jDOAKGV1vwWduImEAkxC0F7sM5Ox1TyfQAys3keei9fBm1LTATM8SJHAW0CbxxNC
         ozjGeYdkgpyfsY2pYufn87rq6/wMPkFOtRe4yljQr+/mA6C7WqqMVSnsTkGZO/goJmLc
         z5w4qPh7lBV4CiEAlM+v8TmrdPpSdEzdeow+UE80YS2weMeP7RIT3rbd49O0Ne83dgZm
         ps8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765346848; x=1765951648;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DlRml3/6tvhtUX/koXqp3LZ2xQ/wKngBjDQJLsuwWk4=;
        b=iglYd6dhH2v6vTZS46VP2E57+Q0d9AIs38PIZfVgdMVuX3o7C82vStaStZdc0y1G8k
         mgpGuJry0P5ckY208I92pQrQK5GCMb2sgf0vyK6sT96S5TWRw5ZsqGI56fSFISJzBH9v
         9AlX1JjNs1Vv4vO1mw+Zb2WHXgD4x85m/50gZx5e6/cZkKQ+YRenJRiFebpfHL0ZoeBg
         bC89yx+EHmpupnMttRH3EKU48cVmjxoJFDf32kBPG2stNfIWKX/0mgT1LVnU0iEATwqH
         NXdGgjFEm3zjvAyUmSRwlNu6IeKFAFZu6g310ANKbCIlWoN55QgIszyCGOjMDdbRKZG1
         FV+g==
X-Gm-Message-State: AOJu0YwHHn04EMOqSQkfQtwzVAaNEKc1cPnv0/RD/4zlylQOGGcjvt42
	lElCsLfWFH+qbhHuhl8f2CaOJscFdjpZfoD/sccV3jLL5tXTMHk/sbmtl+ZJmXIG0kheZ0NfnGT
	ZaBfodz7E5W1q1j7hP6EYz3L3z0O+09F9e+VK
X-Gm-Gg: AY/fxX6TCnNUuwf3nJg3WcxHOyL+ZzBFrfQWslow23JWuE+mqmvWvHnwEJ4DjOWvP6j
	BmEUzc5odBHAESLS07hFE5xsQrrVn8Ns/v33QlO0zfCZ870aHEZ6yfm1dGXOie4E9Cu6j9eC83p
	pwUQgMCJYsDxSm7PV30LEi5VZtTQdPtgoj8THeBiLxXEGg1j3gkudcVDzjwXUoIj0HwNTcnLfSI
	6hTTJkHyOYI9oGvZvq0nfVIWkfd/9mPBD9YiHHe25Pv7g80uLe1f1ztdpvmTJvOfhqdLdwgug==
X-Google-Smtp-Source: AGHT+IEZTmgZfIW5ZvPmGdDPbWiydggGrhzlbvVMb3GESfs44hSY47zMNWbzFI1L0bY7moACrdoGrEE5LxJ9aJyyvuc=
X-Received: by 2002:a05:690c:7244:b0:786:3ee8:66e3 with SMTP id
 00721157ae682-78c9d7bdc82mr11514277b3.32.1765346848470; Tue, 09 Dec 2025
 22:07:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anil Sharma <asharmaanil@gmail.com>
Date: Wed, 10 Dec 2025 17:06:51 +1100
X-Gm-Features: AQt7F2pwBm7rgWeZGYRc7t8gIk1Q8InrQf-58U3PKMVVkqcZ07w6XhAjBjAyfmM
Message-ID: <CAAJpEdjfZgqpyYDH4TWS3siCRca5rgy+Dj-a7dqCSaX0BObrjw@mail.gmail.com>
Subject: fdatasync behaviour in macOS
To: fio@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000cf99a0064592d70c"

--000000000000cf99a0064592d70c
Content-Type: multipart/alternative; boundary="000000000000cf999f064592d70a"

--000000000000cf999f064592d70a
Content-Type: text/plain; charset="UTF-8"

Hi,

I am using fio to benchmark serial fsync in macOS. From what I could
understand, both fsync and fdatasync are linked to F_FULLSYNC in macOS. But
the output is very different. fsync=1 can only get 110 tps where
fdatasync=1 option can get 5.5K tps. Which seems like we are only writing
to OS Page Cache.

Question:
Can we get a confirmation whether the fdatasync option is mapped to
F_FULLSYNC?

Commands:
# fsync=1
fio --name=wal_psync_fsync --filename=testfile --size=1G --rw=write \
      --bs=8k --ioengine=psync --fsync=1 --direct=1 --iodepth=1 \
      --numjobs=1 --time_based --runtime=60 --output=1_psync_fsync.txt

  # 2. fdatasync =1
  fio --name=wal_psync_fdatasync --filename=testfile --size=1G --rw=write \
      --bs=8k --ioengine=psync --fdatasync=1 --direct=1 --iodepth=1 \
      --numjobs=1 --time_based --runtime=60 --output=2_psync_fdatasync.txt



fio --version -> fio-3.41
OS/Machine details: Apple M1 Max, macOS Tahoe version 26.1


Please let me know if this needs to go in github issues.

-- 
Thanks & Regards
Anil
Contact # : 0420412630

--000000000000cf999f064592d70a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div>Hi,<br><br>I am usi=
ng fio to benchmark serial fsync in macOS. From what I could understand, bo=
th fsync and fdatasync are linked to F_FULLSYNC in macOS. But the output is=
 very different. fsync=3D1 can only get 110 tps where fdatasync=3D1 option =
can get 5.5K tps. Which seems like we are only writing to OS Page Cache. <b=
r><br>Question:<br>Can we get a confirmation whether the fdatasync option i=
s mapped to F_FULLSYNC?<br><br>Commands:<br># fsync=3D1<br>fio --name=3Dwal=
_psync_fsync --filename=3Dtestfile --size=3D1G --rw=3Dwrite \<br>=C2=A0 =C2=
=A0 =C2=A0 --bs=3D8k --ioengine=3Dpsync --fsync=3D1 --direct=3D1 --iodepth=
=3D1 \<br>=C2=A0 =C2=A0 =C2=A0 --numjobs=3D1 --time_based --runtime=3D60 --=
output=3D1_psync_fsync.txt<br><br>=C2=A0 # 2. fdatasync =3D1<br>=C2=A0 fio =
--name=3Dwal_psync_fdatasync --filename=3Dtestfile --size=3D1G --rw=3Dwrite=
 \<br>=C2=A0 =C2=A0 =C2=A0 --bs=3D8k --ioengine=3Dpsync --fdatasync=3D1 --d=
irect=3D1 --iodepth=3D1 \<br>=C2=A0 =C2=A0 =C2=A0 --numjobs=3D1 --time_base=
d --runtime=3D60 --output=3D2_psync_fdatasync.txt<br><br><br><br>fio --vers=
ion -&gt;=C2=A0fio-3.41<br>OS/Machine details: Apple M1 Max, macOS Tahoe ve=
rsion 26.1<br><br><br>Please let me know if this needs to go in github issu=
es.</div><div><br></div><span class=3D"gmail_signature_prefix">-- </span><b=
r><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr">Thanks &amp; =
Regards<div>Anil</div><div>Contact # : 0420412630</div></div></div></div></=
div></div>

--000000000000cf999f064592d70a--
--000000000000cf99a0064592d70c
Content-Type: text/plain; charset="US-ASCII"; name="1_psync_fsync.txt"
Content-Disposition: attachment; filename="1_psync_fsync.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mizlrf720>
X-Attachment-Id: f_mizlrf720

d2FsX3BzeW5jX2ZzeW5jOiAoZz0wKTogcnc9d3JpdGUsIGJzPShSKSA4MTkyQi04MTkyQiwgKFcp
IDgxOTJCLTgxOTJCLCAoVCkgODE5MkItODE5MkIsIGlvZW5naW5lPXBzeW5jLCBpb2RlcHRoPTEK
ZmlvLTMuNDEKU3RhcnRpbmcgMSBwcm9jZXNzCgp3YWxfcHN5bmNfZnN5bmM6IChncm91cGlkPTAs
IGpvYnM9MSk6IGVycj0gMDogcGlkPTc0NjQ3OiBXZWQgRGVjIDEwIDE2OjQ1OjQ5IDIwMjUKICB3
cml0ZTogSU9QUz0xMDUsIEJXPTg0MktpQi9zICg4NjJrQi9zKSg0OS4zTWlCLzYwMDAzbXNlYyk7
IDAgem9uZSByZXNldHMKICAgIGNsYXQgKHVzZWMpOiBtaW49OSwgbWF4PTE2MjI3LCBhdmc9Mzk5
LjgxLCBzdGRldj00NjguNjQKICAgICBsYXQgKHVzZWMpOiBtaW49OSwgbWF4PTE2MjI3LCBhdmc9
NDAwLjg2LCBzdGRldj00NjguNzAKICAgIGNsYXQgcGVyY2VudGlsZXMgKHVzZWMpOgogICAgIHwg
IDEuMDB0aD1bICAxOTJdLCAgNS4wMHRoPVsgIDIyNV0sIDEwLjAwdGg9WyAgMjQ5XSwgMjAuMDB0
aD1bICAyODFdLAogICAgIHwgMzAuMDB0aD1bICAyOTddLCA0MC4wMHRoPVsgIDMxOF0sIDUwLjAw
dGg9WyAgMzM0XSwgNjAuMDB0aD1bICAzNTFdLAogICAgIHwgNzAuMDB0aD1bICAzNzVdLCA4MC4w
MHRoPVsgIDQxMl0sIDkwLjAwdGg9WyAgNTI5XSwgOTUuMDB0aD1bICA2NjhdLAogICAgIHwgOTku
MDB0aD1bIDE0NTBdLCA5OS41MHRoPVsgMjc2OV0sIDk5LjkwdGg9WyA3ODk4XSwgOTkuOTV0aD1b
IDg0NTVdLAogICAgIHwgOTkuOTl0aD1bMTYxODhdCiAgIGJ3ICggIEtpQi9zKTogbWluPSAgNTU0
LCBtYXg9IDExOTcsIHBlcj05OS45MiUsIGF2Zz04NDEuOTcsIHN0ZGV2PTEzOS4wOSwgc2FtcGxl
cz0xMTkKICAgaW9wcyAgICAgICAgOiBtaW49ICAgNjksIG1heD0gIDE0OSwgYXZnPTEwNC43Nywg
c3RkZXY9MTcuMzUsIHNhbXBsZXM9MTE5CiAgbGF0ICh1c2VjKSAgIDogMTA9MC4wMiUsIDIwPTAu
MDIlLCAyNTA9MTAuNTAlLCA1MDA9NzguMDElLCA3NTA9Ny43MSUKICBsYXQgKHVzZWMpICAgOiAx
MDAwPTEuNjYlCiAgbGF0IChtc2VjKSAgIDogMj0xLjQ0JSwgND0wLjMwJSwgMTA9MC4zMCUsIDIw
PTAuMDMlCiAgZnN5bmMvZmRhdGFzeW5jL3N5bmNfZmlsZV9yYW5nZToKICAgIHN5bmMgKHVzZWMp
OiBtaW49MzU0NSwgbWF4PTg0MTQ4LCBhdmc9OTA5MS41Mywgc3RkZXY9NDMyNC4zNQogICAgc3lu
YyBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAgMS4wMHRoPVsgMzg1MV0sICA1LjAwdGg9WyA0
MTQ2XSwgMTAuMDB0aD1bIDQ0OTBdLCAyMC4wMHRoPVsgNTQwN10sCiAgICAgfCAzMC4wMHRoPVsg
NjcxOF0sIDQwLjAwdGg9WyA3NTcwXSwgNTAuMDB0aD1bIDg0NTVdLCA2MC4wMHRoPVsgOTUwM10s
CiAgICAgfCA3MC4wMHRoPVsxMDY4M10sIDgwLjAwdGg9WzEyMjU2XSwgOTAuMDB0aD1bMTQyMjJd
LCA5NS4wMHRoPVsxNTc5NV0sCiAgICAgfCA5OS4wMHRoPVsxODQ4Ml0sIDk5LjUwdGg9WzIwMDU1
XSwgOTkuOTB0aD1bNjg2ODJdLCA5OS45NXRoPVs3NDk3NF0sCiAgICAgfCA5OS45OXRoPVs4NDQx
MV0KICBjcHUgICAgICAgICAgOiB1c3I9MC4xNiUsIHN5cz0yLjI5JSwgY3R4PTMzODkyLCBtYWpm
PTAsIG1pbmY9MTAKICBJTyBkZXB0aHMgICAgOiAxPTIwMC4wJSwgMj0wLjAlLCA0PTAuMCUsIDg9
MC4wJSwgMTY9MC4wJSwgMzI9MC4wJSwgPj02ND0wLjAlCiAgICAgc3VibWl0ICAgIDogMD0wLjAl
LCA0PTEwMC4wJSwgOD0wLjAlLCAxNj0wLjAlLCAzMj0wLjAlLCA2ND0wLjAlLCA+PTY0PTAuMCUK
ICAgICBjb21wbGV0ZSAgOiAwPTAuMCUsIDQ9MTAwLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMyPTAu
MCUsIDY0PTAuMCUsID49NjQ9MC4wJQogICAgIGlzc3VlZCByd3RzOiB0b3RhbD0wLDYzMTMsMCw2
MzEzIHNob3J0PTAsMCwwLDAgZHJvcHBlZD0wLDAsMCwwCiAgICAgbGF0ZW5jeSAgIDogdGFyZ2V0
PTAsIHdpbmRvdz0wLCBwZXJjZW50aWxlPTEwMC4wMCUsIGRlcHRoPTEKClJ1biBzdGF0dXMgZ3Jv
dXAgMCAoYWxsIGpvYnMpOgogIFdSSVRFOiBidz04NDJLaUIvcyAoODYya0IvcyksIDg0MktpQi9z
LTg0MktpQi9zICg4NjJrQi9zLTg2MmtCL3MpLCBpbz00OS4zTWlCICg1MS43TUIpLCBydW49NjAw
MDMtNjAwMDNtc2VjCg==
--000000000000cf99a0064592d70c
Content-Type: text/plain; charset="US-ASCII"; name="2_psync_fdatasync.txt"
Content-Disposition: attachment; filename="2_psync_fdatasync.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mizlrmln1>
X-Attachment-Id: f_mizlrmln1

d2FsX3BzeW5jX2ZkYXRhc3luYzogKGc9MCk6IHJ3PXdyaXRlLCBicz0oUikgODE5MkItODE5MkIs
IChXKSA4MTkyQi04MTkyQiwgKFQpIDgxOTJCLTgxOTJCLCBpb2VuZ2luZT1wc3luYywgaW9kZXB0
aD0xCmZpby0zLjQxClN0YXJ0aW5nIDEgcHJvY2VzcwoKd2FsX3BzeW5jX2ZkYXRhc3luYzogKGdy
b3VwaWQ9MCwgam9icz0xKTogZXJyPSAwOiBwaWQ9NzYzMjU6IFdlZCBEZWMgMTAgMTY6NTA6MDMg
MjAyNQogIHdyaXRlOiBJT1BTPTU1NzQsIEJXPTQzLjZNaUIvcyAoNDUuN01CL3MpKDI2MTNNaUIv
NjAwMDFtc2VjKTsgMCB6b25lIHJlc2V0cwogICAgY2xhdCAodXNlYyk6IG1pbj0xOSwgbWF4PTUz
NDUsIGF2Zz0xNTUuNTEsIHN0ZGV2PTM1MS4zMgogICAgIGxhdCAodXNlYyk6IG1pbj0xOSwgbWF4
PTUzNDUsIGF2Zz0xNTUuNTUsIHN0ZGV2PTM1MS4zMgogICAgY2xhdCBwZXJjZW50aWxlcyAodXNl
Yyk6CiAgICAgfCAgMS4wMHRoPVsgICAyMl0sICA1LjAwdGg9WyAgIDIyXSwgMTAuMDB0aD1bICAg
MjJdLCAyMC4wMHRoPVsgICAyNl0sCiAgICAgfCAzMC4wMHRoPVsgICAzMF0sIDQwLjAwdGg9WyAg
IDM2XSwgNTAuMDB0aD1bICAgOTRdLCA2MC4wMHRoPVsgIDExNl0sCiAgICAgfCA3MC4wMHRoPVsg
IDEyMl0sIDgwLjAwdGg9WyAgMTI5XSwgOTAuMDB0aD1bICAxNDNdLCA5NS4wMHRoPVsgMTUwMF0s
CiAgICAgfCA5OS4wMHRoPVsgMTcyOV0sIDk5LjUwdGg9WyAxNzk1XSwgOTkuOTB0aD1bIDE5MjZd
LCA5OS45NXRoPVsgMjE0N10sCiAgICAgfCA5OS45OXRoPVsgMjMxMV0KICAgYncgKCAgS2lCL3Mp
OiBtaW49MzY1NDgsIG1heD00OTE5NywgcGVyPTEwMC4wMCUsIGF2Zz00NDYyNi4zNywgc3RkZXY9
MjY5OC4xOSwgc2FtcGxlcz0xMTkKICAgaW9wcyAgICAgICAgOiBtaW49IDQ1NjgsIG1heD0gNjE0
OSwgYXZnPTU1NzcuOTIsIHN0ZGV2PTMzNy4zMSwgc2FtcGxlcz0xMTkKICBsYXQgKHVzZWMpICAg
OiAyMD0wLjAzJSwgNTA9NDguMDAlLCAxMDA9Mi4yMyUsIDI1MD00NC41OSUsIDUwMD0wLjA1JQog
IGxhdCAodXNlYykgICA6IDc1MD0wLjAyJSwgMTAwMD0wLjAxJQogIGxhdCAobXNlYykgICA6IDI9
NS4wMSUsIDQ9MC4wNiUsIDEwPTAuMDElCiAgZnN5bmMvZmRhdGFzeW5jL3N5bmNfZmlsZV9yYW5n
ZToKICAgIHN5bmMgKHVzZWMpOiBtaW49MTUsIG1heD0yOTM4MywgYXZnPTIzLjMwLCBzdGRldj05
OS4wNwogICAgc3luYyBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAgMS4wMHRoPVsgICAxN10s
ICA1LjAwdGg9WyAgIDE4XSwgMTAuMDB0aD1bICAgMThdLCAyMC4wMHRoPVsgICAxOV0sCiAgICAg
fCAzMC4wMHRoPVsgICAxOV0sIDQwLjAwdGg9WyAgIDIwXSwgNTAuMDB0aD1bICAgMjJdLCA2MC4w
MHRoPVsgICAyNF0sCiAgICAgfCA3MC4wMHRoPVsgICAyNF0sIDgwLjAwdGg9WyAgIDI1XSwgOTAu
MDB0aD1bICAgMzBdLCA5NS4wMHRoPVsgICAzM10sCiAgICAgfCA5OS4wMHRoPVsgICAzOV0sIDk5
LjUwdGg9WyAgIDQzXSwgOTkuOTB0aD1bICAgNjddLCA5OS45NXRoPVsgICA4OV0sCiAgICAgfCA5
OS45OXRoPVsgMzg1MV0KICBjcHUgICAgICAgICAgOiB1c3I9MC42NyUsIHN5cz04LjkxJSwgY3R4
PTY3MTYzOSwgbWFqZj0wLCBtaW5mPTEwCiAgSU8gZGVwdGhzICAgIDogMT0yMDAuMCUsIDI9MC4w
JSwgND0wLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMyPTAuMCUsID49NjQ9MC4wJQogICAgIHN1Ym1p
dCAgICA6IDA9MC4wJSwgND0xMDAuMCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9MC4wJSwgNjQ9MC4w
JSwgPj02ND0wLjAlCiAgICAgY29tcGxldGUgIDogMD0wLjAlLCA0PTEwMC4wJSwgOD0wLjAlLCAx
Nj0wLjAlLCAzMj0wLjAlLCA2ND0wLjAlLCA+PTY0PTAuMCUKICAgICBpc3N1ZWQgcnd0czogdG90
YWw9MCwzMzQ0NzgsMCwwIHNob3J0PTMzNDQ3OCwwLDAsMCBkcm9wcGVkPTAsMCwwLDAKICAgICBs
YXRlbmN5ICAgOiB0YXJnZXQ9MCwgd2luZG93PTAsIHBlcmNlbnRpbGU9MTAwLjAwJSwgZGVwdGg9
MQoKUnVuIHN0YXR1cyBncm91cCAwIChhbGwgam9icyk6CiAgV1JJVEU6IGJ3PTQzLjZNaUIvcyAo
NDUuN01CL3MpLCA0My42TWlCL3MtNDMuNk1pQi9zICg0NS43TUIvcy00NS43TUIvcyksIGlvPTI2
MTNNaUIgKDI3NDBNQiksIHJ1bj02MDAwMS02MDAwMW1zZWMK
--000000000000cf99a0064592d70c--
