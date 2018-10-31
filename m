Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44455 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbeJaXR6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Oct 2018 19:17:58 -0400
Received: by mail-wr1-f50.google.com with SMTP id d17-v6so16377785wre.11
        for <fio@vger.kernel.org>; Wed, 31 Oct 2018 07:19:43 -0700 (PDT)
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Federico Motta <federico@willer.it>
Message-ID: <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
Date: Wed, 31 Oct 2018 15:19:34 +0100
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="E37LJfSRNBmJP4aLZ5dUMMxxXHZLKMJFJ"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Mark Brown <mark.brown@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--E37LJfSRNBmJP4aLZ5dUMMxxXHZLKMJFJ
Content-Type: multipart/mixed; boundary="RqNGMSWEJYpSYYC8yRfFp6tDhxnCSd9hp";
 protected-headers="v1"
From: Federico Motta <federico@willer.it>
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>,
 Mark Brown <mark.brown@linaro.org>, Linus Walleij
 <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>

--RqNGMSWEJYpSYYC8yRfFp6tDhxnCSd9hp
Content-Type: multipart/mixed;
 boundary="------------CEB762F546D710525361B38F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CEB762F546D710525361B38F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
I am back again, with new doubts, hoping someone can clarify them.

Although the previous issue was solved with iodirect=3D1; we are still
investigating possible reasons that in some scenarios make bfq
throughput about the 5-10% lower than mq-deadline one.

Is it possible to ask fio a measure of "how much device internal queues
are filled"?
If yes, with which option(s)?
If not, do you know some other tools or procedures which can tell us that=
?

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
About that "IO depth distribution" I have another question; with the
jobfile attached the iodepth distribution of the 4 jobs is something like=
:

IO depths: 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D133.4%, 16=3D0.0%, 32=3D0.0%=
, >=3D64=3D0.0%
IO depths: 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D133.3%, 16=3D0.0%, 32=3D0.0%=
, >=3D64=3D0.0%
IO depths: 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D133.2%, 16=3D0.0%, 32=3D0.0%=
, >=3D64=3D0.0%
IO depths: 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D133.2%, 16=3D0.0%, 32=3D0.0%=
, >=3D64=3D0.0%

Is it normal that the sum of these percentages is not 100 but it is
around 133? (for completeness in attachment you can also found the whole
fio output)

Thank you for your patience,
regards,
Federico


>=20
> If you're trying to test storage device performance, stick with direct=3D=
1.
>=20
>=20


--------------CEB762F546D710525361B38F
Content-Type: application/zip;
 name="attachment.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="attachment.zip"

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
--------------CEB762F546D710525361B38F--

--RqNGMSWEJYpSYYC8yRfFp6tDhxnCSd9hp--

--E37LJfSRNBmJP4aLZ5dUMMxxXHZLKMJFJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREKAB0WIQQjpLt31k10FTLpDwzdnkSUycSdYAUCW9m5/QAKCRDdnkSUycSd
YGjfAP489mLKq7b5q57h14CytEL/oc1RVImRiXjYbksxY86F7wEAladuhrTrxQus
I0cpqu41P6BYLNk3Ljf3NpJ524mOVHE=
=EMCq
-----END PGP SIGNATURE-----

--E37LJfSRNBmJP4aLZ5dUMMxxXHZLKMJFJ--

