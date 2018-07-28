Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:44607 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbeG1Ow4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jul 2018 10:52:56 -0400
Received: by mail-vk0-f44.google.com with SMTP id 125-v6so3751142vke.11
        for <fio@vger.kernel.org>; Sat, 28 Jul 2018 06:26:24 -0700 (PDT)
MIME-Version: 1.0
From: Jeevan Patnaik <g1patnaik@gmail.com>
Date: Sat, 28 Jul 2018 18:56:12 +0530
Message-ID: <CANyP7Cj4hNtq5aeQ-h1L3ZtyBch0GDfab+4E2cChnKJTwjYsLg@mail.gmail.com>
Subject: What exactly is iodepth in fio?
Content-Type: multipart/alternative; boundary="000000000000b893d005720f2c75"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--000000000000b893d005720f2c75
Content-Type: text/plain; charset="UTF-8"

Hi,

Is Iodepth of fio and queue depth of storage both same? Then, how is it
possible to control queue depth with an iodepth parameter from fio command?
Will that be creating parallel jobs, but then again there is an option to
run jobs in parallel also (will that not be a trivial or conflicting?)

I am struggling to understand how fio is controlling it's workloads
(especially about this iodepth). Can someone please explain the iodepth
parameter in detail.


-- 
Thanks and Regards
Jeevan.


[image: --]

--000000000000b893d005720f2c75
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">

<p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font-variant-numeric:=
inherit;font-variant-east-asian:inherit;font-stretch:inherit;line-height:in=
herit;font-family:Arial,&quot;Helvetica Neue&quot;,Helvetica,sans-serif;fon=
t-size:15px;vertical-align:baseline;box-sizing:inherit;clear:both;color:rgb=
(36,39,41);text-align:left;text-decoration-style:initial;text-decoration-co=
lor:initial">Hi,</p><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;f=
ont-variant-numeric:inherit;font-variant-east-asian:inherit;font-stretch:in=
herit;line-height:inherit;font-family:Arial,&quot;Helvetica Neue&quot;,Helv=
etica,sans-serif;font-size:15px;vertical-align:baseline;box-sizing:inherit;=
clear:both;color:rgb(36,39,41);text-align:left;text-decoration-style:initia=
l;text-decoration-color:initial">Is Iodepth of fio and queue depth of stora=
ge both same? Then, how is it possible to control queue depth with an iodep=
th parameter from fio command? Will that be creating parallel jobs, but the=
n again there is an option to run jobs in parallel also (will that not be a=
 trivial or conflicting?)<br></p><p style=3D"margin:0px 0px 1em;padding:0px=
;border:0px;font-variant-numeric:inherit;font-variant-east-asian:inherit;fo=
nt-stretch:inherit;line-height:inherit;font-family:Arial,&quot;Helvetica Ne=
ue&quot;,Helvetica,sans-serif;font-size:15px;vertical-align:baseline;box-si=
zing:inherit;clear:both;color:rgb(36,39,41);text-align:left;text-decoration=
-style:initial;text-decoration-color:initial">I am struggling to understand=
 how fio is controlling it&#39;s workloads (especially about this iodepth).=
 Can someone please explain the iodepth parameter in detail.</p>

<br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr" class=3D"gmail_sig=
nature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><div><font colo=
r=3D"#666666">Thanks and Regards</font></div><div><font color=3D"#666666">J=
eevan.</font></div><div><table border=3D"0" cellpadding=3D"0" cellspacing=
=3D"0" style=3D"margin:0px;padding:0px;border:0px;outline:0px;font-size:14p=
x;font-family:proxima-nova-1,proxima-nova-2,Tahoma,Helvetica,Verdana,sans-s=
erif;vertical-align:baseline;border-spacing:0px;color:rgb(51,51,51);line-he=
ight:18.2000007629395px"><tbody style=3D"margin:0px;padding:0px;border:0px;=
outline:0px;font-weight:inherit;font-style:inherit;font-family:inherit;vert=
ical-align:baseline"><tr style=3D"margin:0px;padding:0px;border:0px;outline=
:0px;font-weight:inherit;font-style:inherit;font-family:inherit;vertical-al=
ign:baseline"><td style=3D"padding:0px;border:0px;outline:0px;font-style:in=
herit;font-size:0px;font-family:inherit;vertical-align:baseline;width:auto;=
height:30px">=C2=A0</td></tr><tr style=3D"margin:0px;padding:0px;border:0px=
;outline:0px;font-weight:inherit;font-style:inherit;font-family:inherit;ver=
tical-align:baseline"><td style=3D"padding:0px;border:0px;outline:0px;font-=
style:inherit;font-family:inherit;vertical-align:baseline;width:auto"><div =
style=3D"margin:0px;padding:0px;border:0px;outline:0px;font-weight:inherit;=
font-style:inherit;font-family:inherit;vertical-align:baseline;line-height:=
0"><table border=3D"0" cellpadding=3D"0" cellspacing=3D"0" style=3D"margin:=
0px;padding:0px;border:0px;outline:0px;font-weight:inherit;font-style:inher=
it;font-family:inherit;vertical-align:baseline;border-spacing:0px"><tbody s=
tyle=3D"margin:0px;padding:0px;border:0px;outline:0px;font-weight:inherit;f=
ont-style:inherit;font-family:inherit;vertical-align:baseline"><tr style=3D=
"margin:0px;padding:0px;border:0px;outline:0px;font-weight:inherit;font-sty=
le:inherit;font-family:inherit;vertical-align:baseline"><td align=3D"left" =
valign=3D"top" style=3D"padding:0px;border:0px;outline:0px;font-style:inher=
it;font-family:inherit;vertical-align:top;width:auto;line-height:1"><img al=
t=3D"--" width=3D"0" height=3D"0" style=3D"margin:0px;padding:0px;border:0p=
x;outline:0px;font-weight:inherit;font-style:inherit;font-family:inherit;ve=
rtical-align:baseline;display:block;width:0px;height:0px;overflow:hidden"><=
/td></tr></tbody></table></div></td></tr><tr style=3D"margin:0px;padding:0p=
x;border:0px;outline:0px;font-weight:inherit;font-style:inherit;font-family=
:inherit;vertical-align:baseline"><td style=3D"padding:0px;border:0px;outli=
ne:0px;font-style:inherit;font-size:0px;font-family:inherit;vertical-align:=
baseline;width:auto;height:20px"></td></tr></tbody></table></div></div></di=
v></div>

--000000000000b893d005720f2c75--
