Return-Path: <fio-owner@vger.kernel.org>
Received: from micxer.de ([178.254.52.77]:42787 "EHLO micxer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbbEQUzr (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 17 May 2015 16:55:47 -0400
Received: from qonos.fritz.box (109.125.94.74.dynamic.cablesurf.de [109.125.94.74])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: micxer@micxer.de)
	by micxer.de (Postfix) with ESMTPSA id 7742F248134
	for <fio@vger.kernel.org>; Sun, 17 May 2015 20:55:44 +0000 (UTC)
Message-ID: <55590055.1080005@micxer.de>
Date: Sun, 17 May 2015 22:55:49 +0200
From: Michael Weinrich <micxer@micxer.de>
MIME-Version: 1.0
Subject: Re: Testing write master and multiple read clients on NFS share
References: <55551D18.2000405@micxer.de> <CALjAwxgWOokmtXWtN3GvZnvNoC-FTCJX=c3xFiuH5PrB97_kBw@mail.gmail.com>
In-Reply-To: <CALjAwxgWOokmtXWtN3GvZnvNoC-FTCJX=c3xFiuH5PrB97_kBw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080201030106020307010202"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080201030106020307010202
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Thanks for the hint. I also found another mistake in limiting the reads=20
and writes where I only wanted to limit the writes and have the reads as =

fast as possible. But in general this is a viable approach to my problem?=


Am 16.05.15 um 13:46 schrieb Sitsofe Wheeler:
> On 14 May 2015 at 23:09, Michael Weinrich <micxer@micxer.de> wrote:
>> Hi,
>>
>> in my company we have some sort of database that operates on bit lists=
 read
>> directly from the files on the hard disk. While this is ok if you have=
 an
>> SSD in your server it gets tricky to keep performance up when using an=
 NFS
>> share.
>>
>> While I was trying to assess different solutions I stumbled upon fio a=
nd was
>> happy to see that it can also run in client-server-mode. So I was tryi=
ng to
>> emulate the following scenario:
>>
>> - 1 node that takes care of updating the bit lists in the db files,
>>    nothing else
>> - 5 nodes that only read from those files and respond to queries, hope=
fully
>> leveraging the local filesystem or NFS client cache
>>
>> I read through the HOWTO and tried to pick the options that should sim=
ulate
>> the scenario as best as possible. This is what I came up with:
>>
>> [global]
>> ioengine=3Dsync
>> iodepth=3D1
>> size=3D100%
>> io_size=3D4g
>> filesize=3D4g
>> blocksize=3D64k
>> direct=3D0
>> numjobs=3D4
>> directory=3D/mnt/nfs
>> filename_format=3Dindex.$filenum
>> fadvise_hint=3D0
>> lockfile=3Dreadwrite
>> randrepeat=3D1
>> nrfiles=3D8
>> openfiles=3D4
>> runtime=3D120
>> ramp_time=3D10
>> blocksize=3D64k
>> file_service_type=3Drandom:8
>> overwrite=3D1
>> fsync_on_close=3D1
>> random_distribution=3Dzipf:0.6
>> norandommap
>> file_append=3D0
>> rate=3D1m
>>
>> [reader]
>> rw=3Drandread
>>
>> [writer]
>> rw=3Drandrw
>> rwmixwrite=3D80
>>
>>
>> Is this a viable approach or is this scenario not really testable with=
 fio?
>
> I could be wrong but won't this make 4 readers and 4 writers. If
> that's not what you wanted perhaps numjobs could be moved to the
> reader entry only?
>


--------------ms080201030106020307010202
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMWjCC
Bh4wggUGoAMCAQICAwz6pjANBgkqhkiG9w0BAQsFADCBjDELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRl
IFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlh
dGUgQ2xpZW50IENBMB4XDTE1MDIxNDEyNTAwOFoXDTE2MDIxNTE1MjQ0NlowPDEZMBcGA1UE
AwwQbWljeGVyQG1pY3hlci5kZTEfMB0GCSqGSIb3DQEJARYQbWljeGVyQG1pY3hlci5kZTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKK0XQQqBJnBI/F/LooOGFLqGgTtMkbN
MWK844qnjeKCZ9xmDW9bmi4Hrk3Oojk0b4A8Ipv0kEM6aPkLLuC+FPjkkVjHBm3UrUtAi0sy
G2jF70IXiYRnXT4bMxC7mD5t3k3SHs67ZfoibM0in7t26XYDgkrIF91AiTOg5pVU/y2Os7qs
uobQERU8WQfC1ml8pizoCfGGFTaEr+3q1abFZGdju3ux6cbvykfDUWUliiiT5r+9x5hosMKa
Q28xPolbyBzj6VMq36WI2jPHip0jyeuVs15s/dcpRJfEBTEMTIMsgRzWgGtyzQjBVq/FyFDs
EMWtkTynmgD0YDvX3pVETZ8CAwEAAaOCAtYwggLSMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSw
MB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUEhEBaI348BxtlyLu
U0xjLjlCVDIwHwYDVR0jBBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwGwYDVR0RBBQwEoEQ
bWljeGVyQG1pY3hlci5kZTCCAUwGA1UdIASCAUMwggE/MIIBOwYLKwYBBAGBtTcBAgMwggEq
MC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMIH3Bggr
BgEFBQcCAjCB6jAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+
VGhpcyBjZXJ0aWZpY2F0ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBW
YWxpZGF0aW9uIHJlcXVpcmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxp
YW5jZSBvbmx5IGZvciB0aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRo
ZSByZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25zLjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8v
Y3JsLnN0YXJ0c3NsLmNvbS9jcnR1MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsG
AQUFBzABhi1odHRwOi8vb2NzcC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2Ew
QgYIKwYBBQUHMAKGNmh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEu
Y2xpZW50LmNhLmNydDAjBgNVHRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJ
KoZIhvcNAQELBQADggEBAJOdDLbeJhuMDBBxIiLrSLE5bRkYL3Vw7fTW+XQV56lLl+4wOwY+
ffbREuj4FocsHHVfEn4v1t8yj8PTmFRRhdt6mc9Q7Fb6eUhXjPe7fO0zYTJAcOCPwYjVVwQM
Xju8kWJBGOyOSwamSfKwtJZNUM3pZKh1Qn/0mu2SKZ5NF70z8dKqPMSEBY/QEnen1muxJf9m
GvfeuIgE7Gk2aXYvs0agqE/ERtURrQF4LBZGyRm5o/83izEKDFtSvevS89EnXpzJ5t9lTO/X
jN0lCrVqM8CRtsSQW5zOkfRogA0ArQwDBtth/Gapqft8Fc8Ua4ur5NBcJ3NKz/9e7Qp7FvGn
NzkwggY0MIIEHKADAgECAgEeMA0GCSqGSIb3DQEBBQUAMH0xCzAJBgNVBAYTAklMMRYwFAYD
VQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0
ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAe
Fw0wNzEwMjQyMTAxNTVaFw0xNzEwMjQyMTAxNTVaMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UE
ChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUg
U2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0
ZSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDHCYPMzi3YGrEp
pC4Tq5a+ijKDjKaIQZZVR63UbxIP6uq/I0fhCu+cQhoUfE6ERKKnu8zPf1Jwuk0tsvVCk6U9
b+0UjM0dLep3ZdE1gblK/1FwYT5Pipsu2yOMluLqwvsuz9/9f1+1PKHG/FaR/wpbfuIqu54q
zHDYeqiUfsYzoVflR80DAC7hmJ+SmZnNTWyUGHJbBpA8Q89lGxahNvuryGaC/o2/ceD2uYDX
9U8Eg5DpIpGQdcbQeGarV04WgAUjjXX5r/2dabmtxWMZwhZna//jdiSyrrSMTGKkDiXm6/3/
4ebfeZuCYKzN2P8O2F/Xe2AC/Y7zeEsnR7FOp+uXAgMBAAGjggGtMIIBqTAPBgNVHRMBAf8E
BTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUU3Ltkpzg2ssBXHx+ljVO8tS4UYIw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwZgYIKwYBBQUHAQEEWjBYMCcGCCsG
AQUFBzABhhtodHRwOi8vb2NzcC5zdGFydHNzbC5jb20vY2EwLQYIKwYBBQUHMAKGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNydDBbBgNVHR8EVDBSMCegJaAjhiFodHRwOi8v
d3d3LnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwJ6AloCOGIWh0dHA6Ly9jcmwuc3RhcnRzc2wu
Y29tL3Nmc2NhLmNybDCBgAYDVR0gBHkwdzB1BgsrBgEEAYG1NwECATBmMC4GCCsGAQUFBwIB
FiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRw
Oi8vd3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMA0GCSqGSIb3DQEBBQUAA4IC
AQAKgwh9eKssBly4Y4xerhy5I3dNoXHYfYa8PlVLL/qtXnkFgdtY1o95CfegFJTwqBBmf8py
TUnFsukDFUI22zF5bVHzuJ+GxhnSqN2sD1qetbYwBYK2iyYA5Pg7Er1A+hKMIzEzcduRkIMm
CeUTyMyikfbUFvIBivtvkR8ZFAk22BZy+pJfAoedO61HTz4qSfQoCRcLN5A0t4DkuVhTMXIz
uQ8CnykhExD6x4e6ebIbrjZLb7L+ocR0y4YjCl/Pd4MXU91y0vTipgr/O75CDUHDRHCCKBVm
z/Rzkc/b970MEeHt5LC3NiWTgBSvrLEuVzBKM586YoRD9Dy3OHQgWI270g+5MYA8GfgI/EPT
5G7xPbCDz+zjdH89PeR3U4So4lSXur6H6vp+m9TQXPF3a0LwZrp8MQ+Z77U1uL7TelWO5lAp
sbAonrqASfTpaprFVkL4nyGH+NHST2ZJPWIBk81i6Vw0ny0qZW2Niy/QvVNKbb43A43ny076
khXO7cNbBIRdJ/6qQNq9Bqb5C0Q5nEsFcj75oxQRqlKf6TcvGbjxkJh8BYtv9ePsXklAxtm8
J7GCUBthHSQgepbkOexhJ0wP8imUkyiPHQ0GvEnd83129fZjoEhdGwXV27ioRKbj/cIq7JRX
un0NbeY+UdMYu9jGfIpDLtUUGSgsg2zMGs5R4jGCA90wggPZAgEBMIGUMIGMMQswCQYDVQQG
EwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwg
Q2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5
IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwz6pjAJBgUrDgMCGgUAoIICHTAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNTA1MTcyMDU1NDlaMCMGCSqGSIb3
DQEJBDEWBBQHI5jgZBHg3qyhKZp5A2iie2MpRDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3
DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwx
CzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUg
RGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAx
IFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDDPqmMIGnBgsqhkiG9w0BCRACCzGB
l6CBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsT
IlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29t
IENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMM+qYwDQYJKoZIhvcN
AQEBBQAEggEADFToA+G11AqjlWcT4FFZ2dT4QFIzSkSQye6vFSblUvC6z9q+6nmfAhHirAyB
72Y9DzQ2NzH1wOTIwLH+oYwu/AWe+NR+iPsXqO9gqhN6GriKndb47n3FUg4regXfd2plDmaR
+QF3+GMP26evKa4K77L8IVIDqh45PHIOjnLTo7Yv0B75+emXcmUnb/6ef9FZKBcjRU1n2bSY
/GCeh86ljQyJTLFF1Ch5Hh8ecJVtm0CrGUlAKOl8LV6wvHo33athgjr0xetoEjBUSUVWc3Ik
c34uqUYEE6nbsAQyMdWQPz3I+IpTFZf0BMNFJBVDmoXCXlsI4pMEEg1Jw+AXpsbpCgAAAAAA
AA==
--------------ms080201030106020307010202--
