Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:34907 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbeKITKn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Nov 2018 14:10:43 -0500
Received: by mail-wr1-f52.google.com with SMTP id z16-v6so1141087wrv.2
        for <fio@vger.kernel.org>; Fri, 09 Nov 2018 01:30:59 -0800 (PST)
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
 <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
 <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>
From: Federico Motta <federico@willer.it>
Message-ID: <64b2647f-4644-c4ed-ee44-6f571d037e50@willer.it>
Date: Fri, 9 Nov 2018 10:30:36 +0100
MIME-Version: 1.0
In-Reply-To: <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="3fO6nHtajbrPSGheA1UVZ29qM28VXrNuk"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, fio <fio@vger.kernel.org>, Paolo Valente <paolo.valente@linaro.org>, mark.brown@linaro.org, linus.walleij@linaro.org, ulf.hansson@linaro.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3fO6nHtajbrPSGheA1UVZ29qM28VXrNuk
Content-Type: multipart/mixed; boundary="JfpbxX4JsbnR4UbbmdOyhNKkOw4Xig0OL";
 protected-headers="v1"
From: Federico Motta <federico@willer.it>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jeff Furlong <jeff.furlong@wdc.com>,
 "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
 fio <fio@vger.kernel.org>, Paolo Valente <paolo.valente@linaro.org>,
 mark.brown@linaro.org, linus.walleij@linaro.org, ulf.hansson@linaro.org
Message-ID: <64b2647f-4644-c4ed-ee44-6f571d037e50@willer.it>
Subject: Re: rand-read: increasing iodepth makes throughput drop
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it>
 <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
 <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>
In-Reply-To: <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>

--JfpbxX4JsbnR4UbbmdOyhNKkOw4Xig0OL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/7/18 4:38 PM, Sitsofe Wheeler wrote:
> On Wed, 7 Nov 2018 at 11:09, Federico Motta <federico@willer.it> wrote:=

>>
>> Hi,
>>
>> On 10/31/18 6:31 PM, Jeff Furlong wrote:
>>>> Is it normal that the sum of these percentages is not 100 but it is =
around 133?
>>> Looks like you're running fio 3.9.  There was a recent patch, after t=
he 3.11 release, to resolve.  Try the latest from git.
>>>
>> Thank you, the script I wrote to keep my fio updated to the latest
>> git-tag was missing a "--version-sort" :(
>>
>> With fio-3.12 the sum is 100 as expected.
>>
>>
>> On 10/31/18 3:19 PM, Federico Motta wrote:
>> ...
>>> Is it possible to ask fio a measure of "how much device internal
>> queues are filled"?
>>> If yes, with which option(s)?
>>> If not, do you know some other tools or procedures which can tell us =
that?
>>
>> Does somebody has ideas about that ^  ?
>=20
> I think fio will report something similar back on Linux when it is
> able to work it out - see the "And finally, the disk statistics are
> printed" section over in
> https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-outp=
ut
> . The util percentage might be as good as it gets (i.e. a device that
> can take more I/Os will have a low percentage). I think iostat
> produces similar output to that too...
>=20

Actually I was wondering if a more direct or low level measure exists,
but since I don't even know if that is possible I think the fio "util"
percentage could be a good trade-off between "a low level measure" and
"no measure available".

Thank you :)
Have a nice day,
Federico


--JfpbxX4JsbnR4UbbmdOyhNKkOw4Xig0OL--

--3fO6nHtajbrPSGheA1UVZ29qM28VXrNuk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREKAB0WIQQjpLt31k10FTLpDwzdnkSUycSdYAUCW+VTzwAKCRDdnkSUycSd
YCeoAP9GbzREOcHri9kUaYcjddyuXnkhCiSpmFlaxLqH3sMVdQD/Qycs2xTA4ULg
LdKY18QD4MglTAc6nFCXbps1kAOVMAU=
=aHVE
-----END PGP SIGNATURE-----

--3fO6nHtajbrPSGheA1UVZ29qM28VXrNuk--

