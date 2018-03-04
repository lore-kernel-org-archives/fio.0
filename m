Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:40515 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932206AbeCDVu3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 4 Mar 2018 16:50:29 -0500
Received: by mail-it0-f43.google.com with SMTP id e64so7698634ita.5
        for <fio@vger.kernel.org>; Sun, 04 Mar 2018 13:50:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <923FC40148D42D44A828D320CE66E06A9E094EC9@MX204CL01.corp.emc.com>
References: <CANvN+emXGM9D5Pv3xdx_=nqbzJ_rG8FqGNYJxxCkA38xK7EARQ@mail.gmail.com>
 <923FC40148D42D44A828D320CE66E06A9E094EC9@MX204CL01.corp.emc.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 5 Mar 2018 00:50:08 +0300
Message-ID: <CANvN+ekYav7toZrFrLHVpMv=GWcL0kO7V4g7L=HXBmP7cjsQMw@mail.gmail.com>
Subject: Re: Size and time-based jobs under the same config file
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@dell.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Mar 5, 2018 at 12:45 AM, Ruvinsky, Konstantin
<Konstantin.Ruvinsky@dell.com> wrote:
> Hi,
>
> Do you see the same behavior for stonewalled size-based write-only and re=
ad-verify jobs?

I'm not using verify, so no idea re your question. That's the config
in question, with some (irrelevant) omissions.

[global]
thread=3D1
group_reporting=3D1
direct=3D1
verify=3D0
ramp_time=3D0

[precond]
numjobs=3D1
iodepth=3D128
rw=3Dwrite
bs=3D128k
size=3D4g

[randrw]
stonewall
numjobs=3D4
iodepth=3D32
rw=3Drandrw
bs=3D4k
runtime=3D1m

Regards,
Andrey
>
> Regards
> Konstantin
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of Andrey Kuzmin
> Sent: Sunday, March 4, 2018 11:36 PM
> To: fio@vger.kernel.org
> Subject: Size and time-based jobs under the same config file
>
> I see a run of the subj resulting in the second, time-based job (which is=
 stonewalled to start after the size-based one) ending prematurely, with it=
s lifetime apparently consumed by the size-based job. This used to work jus=
t a couple of years back ;). Am I missing something?
>
> Regards,
> Andrey
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the bod=
y of a message to majordomo@vger.kernel.org More majordomo info at  http://=
vger.kernel.org/majordomo-info.html
