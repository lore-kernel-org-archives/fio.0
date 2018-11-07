Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35492 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbeKGUjB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 15:39:01 -0500
Received: by mail-wm1-f47.google.com with SMTP id t15-v6so7539725wmt.0
        for <fio@vger.kernel.org>; Wed, 07 Nov 2018 03:09:07 -0800 (PST)
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
 <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Federico Motta <federico@willer.it>
Message-ID: <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
Date: Wed, 7 Nov 2018 12:08:45 +0100
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="O254XFVEXcjtrOeRvLLdQiidCrim2unrN"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Mark Brown <mark.brown@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--O254XFVEXcjtrOeRvLLdQiidCrim2unrN
Content-Type: multipart/mixed; boundary="uahaTYK7jeLSkXIxlhhJT8I1VwTL0GMMc";
 protected-headers="v1"
From: Federico Motta <federico@willer.it>
To: Jeff Furlong <jeff.furlong@wdc.com>,
 "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Paolo Valente <paolo.valente@linaro.org>,
 Mark Brown <mark.brown@linaro.org>, Linus Walleij
 <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
 <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>

--uahaTYK7jeLSkXIxlhhJT8I1VwTL0GMMc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

On 10/31/18 6:31 PM, Jeff Furlong wrote:
>> Is it normal that the sum of these percentages is not 100 but it is ar=
ound 133?
> Looks like you're running fio 3.9.  There was a recent patch, after the=
 3.11 release, to resolve.  Try the latest from git.
>=20
Thank you, the script I wrote to keep my fio updated to the latest
git-tag was missing a "--version-sort" :(

With fio-3.12 the sum is 100 as expected.


On 10/31/18 3:19 PM, Federico Motta wrote:
=2E..
> Is it possible to ask fio a measure of "how much device internal
queues are filled"?
> If yes, with which option(s)?
> If not, do you know some other tools or procedures which can tell us th=
at?

Does somebody has ideas about that ^  ?


> Regards,
> Jeff
>=20
>=20

Regards,
Federico


--uahaTYK7jeLSkXIxlhhJT8I1VwTL0GMMc--

--O254XFVEXcjtrOeRvLLdQiidCrim2unrN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREKAB0WIQQjpLt31k10FTLpDwzdnkSUycSdYAUCW+LHvQAKCRDdnkSUycSd
YGfdAP9wwQuLjcOR3NjatyxEyFHNUVaFUm8vnFcH0UdcEfpUMwD+LmdyGTUCBlq6
ZSIV3zqz/WenhVCONjLCEDHs6G4kluA=
=2qJq
-----END PGP SIGNATURE-----

--O254XFVEXcjtrOeRvLLdQiidCrim2unrN--

