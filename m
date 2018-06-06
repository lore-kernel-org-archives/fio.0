Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:33573 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbeFFT5H (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Jun 2018 15:57:07 -0400
Received: by mail-ua0-f177.google.com with SMTP id m21-v6so4893086uan.0
        for <fio@vger.kernel.org>; Wed, 06 Jun 2018 12:57:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FF90FB2@ORSMSX113.amr.corp.intel.com>
References: <DE927C68B458BE418D582EC97927A9287FF90FB2@ORSMSX113.amr.corp.intel.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 6 Jun 2018 20:56:36 +0100
Message-ID: <CALjAwxjBxm4o9H1=fZyavGKUUeyYbPXXqsiB35=YSTL=wgdG=w@mail.gmail.com>
Subject: Re: latency percentiles labels in fio minimal output
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Joseph,

On 6 June 2018 at 19:40, Gruher, Joseph R <joseph.r.gruher@intel.com> wrote=
:
> Hi folks-
>
> When using FIO minimal output such as this output example (from FIO v3.6)=
:
>
> 3;fio-3.6;1m-sr-01-01-32;0;0;150288384;2503763;2444;60025;0;17189;114.724=
224;942.095768;0;33799;12973.415812;9008.249487;1.000000%=3D0;5.000000%=3D0=
;10.000000%=3D173;20.000000%=3D3358;30.000000%=3D6586;40.000000%=3D9764;50.=
000000%=3D12648;60.000000%=3D16187;70.000000%=3D19267;80.000000%=3D22675;90=
.000000%=3D25821;95.000000%=3D27394;99.000000%=3D28704;99.500000%=3D28966;9=
9.900000%=3D29229;99.950000%=3D29491;99.990000%=3D32112;0%=3D0;0%=3D0;0%=3D=
0;0;33799;13088.507365;9021.958807;671744;1828428;49.297242%;1234286.100000=
;498063.813528;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000=
%=3D0;5.000000%=3D0;10.000000%=3D0;20.000000%=3D0;30.000000%=3D0;40.000000%=
=3D0;50.000000%=3D0;60.000000%=3D0;70.000000%=3D0;80.000000%=3D0;90.000000%=
=3D0;95.000000%=3D0;99.000000%=3D0;99.500000%=3D0;99.900000%=3D0;99.950000%=
=3D0;99.990000%=3D0;0%=3D0;0%=3D0;0%=3D0;0;0;0.000000;0.000000;0;0;0.000000=
%;0.000000;0.000000;2.967146%;23.249034%;175862;0;8208;0.1%;0.1%;0.1%;0.1%;=
0.1%;199.9%;0.0%;9.45%;0.01%;0.02%;0.03%;0.10%;0.16%;0.49%;0.77%;0.78%;0.79=
%;3.11%;6.25%;18.77%;31.26%;28.03%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00=
%
>
> What's the point of having the latency percentiles labeled in the output =
data, such as:
>
> 99.000000%=3D28704;99.500000%=3D28966;99.900000%=3D29229;99.950000%=3D294=
91;99.990000%=3D32112

If memory serves those boundaries are actually user definable (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-percentile-l=
ist
) so I would guess they appear in the header to ensure you know what
they were set to...

--=20
Sitsofe | http://sucs.org/~sits/
