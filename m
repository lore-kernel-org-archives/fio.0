Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:33812 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbeJ2R4s (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 29 Oct 2018 13:56:48 -0400
Received: by mail-wr1-f44.google.com with SMTP id l6-v6so7769441wrt.1
        for <fio@vger.kernel.org>; Mon, 29 Oct 2018 02:09:01 -0700 (PDT)
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Federico Motta <federico@willer.it>
Message-ID: <380ecf33-d084-6f60-3873-390491f27913@willer.it>
Date: Mon, 29 Oct 2018 10:07:57 +0100
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="dn0beYoQDiKI8GJ31a93BI0QK7I2sEsKl"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Mark Brown <mark.brown@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dn0beYoQDiKI8GJ31a93BI0QK7I2sEsKl
Content-Type: multipart/mixed; boundary="SYegQt0soxPxRW9Kzkjkz1wl3PY9bnzyx";
 protected-headers="v1"
From: Federico Motta <federico@willer.it>
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>,
 Mark Brown <mark.brown@linaro.org>, Linus Walleij
 <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <380ecf33-d084-6f60-3873-390491f27913@willer.it>
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>

--SYegQt0soxPxRW9Kzkjkz1wl3PY9bnzyx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/25/18 7:55 AM, Elliott, Robert (Persistent Memory) wrote:
>> Paolo Valente and I found an unexpected surprise while investigating
>> iodepth impact on throughput. Both on my device (ssd samsung 960 pro
>> nvme m.2 512gb) and his one (ssd plextor px-256m5s), throughput
>> decreases as the iodepth increases.
> ...
>> What we observed is that with "iodepth=3D1 and ioengine=3Dsync"
>> throughput
>> is greater than with "iodepth=3D8 and ioengine=3Dlibaio".  For example=
:
>> - iodepth=3D1,  sync: 170.942 =C2=B1 11.122 [mb/s]
>> - iodepth=3D8, async: 161.360 =C2=B1 10.165 [mb/s]
>>
>>
>> So, I would like to ask:
>> 1) Is it normal that throughput drop? (shouldn't device internal
>> queues
>> be more filled with a greater iodepth and thus lead to a greater
>> throughput?)
Hi,
Thank you for your reply

>=20
> The drive specs are:
> * 3500 MB/s sequential read
> * 57.344 MB/s random read, QD1 (14000 IOPS doing random 4 KiB reads)
> * 1351.68 MB/s random read, QD4 (330000 IOPS doing random 4 KiB reads)
>=20
> so the bigger issue is why it's underachieving by 10x.
>=20
> direct=3D0 means you're involving the page cache, which distorts result=
s,
> especially with libaio:
>=20
>     iodepth=3Dint
>     Number of I/O units to keep in flight against the file. Note that
>     increasing iodepth beyond 1 will not affect synchronous ioengines
>     (except for small degress when verify_async is in use). Even async
>     engines may impose OS restrictions causing the desired depth not to=

>     be achieved. This may happen on Linux when using libaio and not
>     setting direct=3D1, since buffered IO is not async on that OS. Keep=

>     an eye on the IO depth distribution in the fio output to verify
>     that the achieved depth is as expected. Default: 1.=20
You are right, I'm sorry that I didn't read carefully enough the docs.

>=20
> If you're trying to test storage device performance, stick with direct=3D=
1.
In fact with direct=3D1, the "iodepth=3D8 and ioengine=3Dlibaio" now perf=
orms
much better than "iodepth=3D1 and ioengine=3Dsync"

Thank you again for your help,
Federico


--SYegQt0soxPxRW9Kzkjkz1wl3PY9bnzyx--

--dn0beYoQDiKI8GJ31a93BI0QK7I2sEsKl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREKAB0WIQQjpLt31k10FTLpDwzdnkSUycSdYAUCW9bN7gAKCRDdnkSUycSd
YCHiAP4jXglRi3yuhMsZvv0ZtovQVh/vAA69aQ54wWk8zuUXWAD/SxGSD7R9PYai
ohClAjLWKFRFOzJV3ydCDTpEV4SKm8o=
=dXeb
-----END PGP SIGNATURE-----

--dn0beYoQDiKI8GJ31a93BI0QK7I2sEsKl--

