Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40648 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbeJYCbl (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Oct 2018 22:31:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id b203-v6so6381948wme.5
        for <fio@vger.kernel.org>; Wed, 24 Oct 2018 11:02:38 -0700 (PDT)
From: Federico Motta <federico@willer.it>
Subject: rand-read: increasing iodepth makes throughput drop
Message-ID: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
Date: Wed, 24 Oct 2018 20:02:21 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="CCdIBZyDNkCZOg7MtDtGoqVCocCiPUAQc"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Paolo Valente <paolo.valente@linaro.org>, Mark Brown <mark.brown@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CCdIBZyDNkCZOg7MtDtGoqVCocCiPUAQc
Content-Type: multipart/mixed; boundary="UkVe3ev5knYc61hZbus0d7V8WjhxpfFvH";
 protected-headers="v1"
From: Federico Motta <federico@willer.it>
To: fio@vger.kernel.org
Cc: Paolo Valente <paolo.valente@linaro.org>,
 Mark Brown <mark.brown@linaro.org>, Linus Walleij
 <linus.walleij@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Message-ID: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
Subject: rand-read: increasing iodepth makes throughput drop

--UkVe3ev5knYc61hZbus0d7V8WjhxpfFvH
Content-Type: multipart/mixed;
 boundary="------------ADE9EDEE5100651B3E4D2FD7"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------ADE9EDEE5100651B3E4D2FD7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
Paolo Valente and I found an unexpected surprise while investigating
iodepth impact on throughput. Both on my device (ssd samsung 960 pro
nvme m.2 512gb) and his one (ssd plextor px-256m5s), throughput
decreases as the iodepth increases.

What follows is a summary of the testbed details:
- mq-deadline scheduler
- 4 fio doing rand-read I/O (4 is the number of physical cores of our cpu=
s)
- throughput was measured with "iostat -tmd /dev/$disk 3"
- from the above command the first "mb_read/s" occurrence was ignored
because of ramp time and only on the following ones average and stdev
were computed
- duration of 15 sec

More details can be found in the jobfiles in attachment, please note that=
:
- global sections differ only for the first two lines (iodepth and ioengi=
ne)
- job sections differ only for N (0 to 3)


What we observed is that with "iodepth=3D1 and ioengine=3Dsync" throughpu=
t
is greater than with "iodepth=3D8 and ioengine=3Dlibaio".  For example:
- iodepth=3D1,  sync: 170.942 =C2=B1 11.122 [mb/s]
- iodepth=3D8, async: 161.360 =C2=B1 10.165 [mb/s]


So, I would like to ask:
1) Is it normal that throughput drop? (shouldn't device internal queues
be more filled with a greater iodepth and thus lead to a greater
throughput?)
2) If (1) is normal, for which reasons?
3) If (1) is not normal, we thought to investigate about the average
number of requests in software and hardware queues (especially the
latter ones). In fact we expect a correlation between that number and
throughput.
4) If (3) is correct, how can we measure the average number of requests
in the device internal queues? Is it possible to do that directly with fi=
o?
5) If (3) is not correct, what should we look for? and (if possible)
with which tools?

Under request I can give more details.
Thank you,
Federico

--------------ADE9EDEE5100651B3E4D2FD7
Content-Type: application/zip;
 name="fio_jobfiles.zip"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fio_jobfiles.zip"

UEsDBBQAAAAIABiFWE1rbhZQnwAAANsAAAAjABwAdGVzdF9zdWl0ZS90ZXN0X2FzeW5jX3Fk
OC9maW9fMC5qb2JVVAkAA3CE0FtwhNBbdXgLAAEE6AMAAAToAwAALY1LDsIwDET3vgYHSCuB
xManYFlVlUvcxm0SV0mg4vYkCG88T5rPsHqdyY8gavkoDu9VcVwlMnqZSRQuMGe87mAl8bNg
9xeaPmicBjbF8caRzMOcmvZFPGcDEt/kxVJh7MGrHhn7rh7EV9i0NvaQKBxTkcB4g8RkzyTV
nSjaRlBce3UPhhqYuhFadaTq95RWblTrGi+i088DLZ2ZW+wLUEsDBBQAAAAIABiFWE2hVHYa
nwAAANsAAAAjABwAdGVzdF9zdWl0ZS90ZXN0X2FzeW5jX3FkOC9maW9fMS5qb2JVVAkAA3CE
0FtwhNBbdXgLAAEE6AMAAAToAwAALY1LDsIwDET3vgYHSCOBxManYFmhyiVu4zaJqzRQcXuS
Cm88T5pPPwcdKTxB1PFWPN6r4jRLYgwykihcYNzxuoKTzK+C3V9o/qLxGtkUzwsnMg9zaF4n
CbwbkPShII4Ko4Wguu1ou3qQ3nHR2mghU9yGIpHxBpnJHVmqO1NyjaD49uoe9DUw2Ce06kTV
HyjP3MjCyZPocHqgpXdmV+t/UEsDBBQAAAAIABiFWE3/G9bEoAAAANsAAAAjABwAdGVzdF9z
dWl0ZS90ZXN0X2FzeW5jX3FkOC9maW9fMi5qb2JVVAkAA3CE0FtwhNBbdXgLAAEE6AMAAATo
AwAALY1LDoMwDET3vkYPEECt1I1P0SWqkGkMMYQYJWlRb98E1RvPk+bTz15H8k8Qtbxnh/ei
OMwSGL2MJAoXGBNeV7AS+ZWx+QuNXzRONzbZ8cKBzMMcGtdJPCcDEj7kxVJmbMGr7gnbphyE
97ZoaWwh0rYPWTbGG0Qme0Qp7kjBVoLs6it70JfA0D2hVgcqfk9x5kodnDyJDqcHajoxW+zg
B1BLAwQUAAAACAAYhVhNkXTqZKAAAADcAAAAIwAcAHRlc3Rfc3VpdGUvdGVzdF9hc3luY19x
ZDgvZmlvXzMuam9iVVQJAANwhNBbcITQW3V4CwABBOgDAAAE6AMAAC2NSw6DMAxE975GDxAQ
rdSNT9ElqpBpDDGEGCVpUW/fBNUbz5Pm089eR/JPELW8Z4f3ojjMEhi9jCQKFxgTXlewEvmV
sfkLjV80Tjc22fHCgczDHBrXSTwnAxI+5MVSZmzBq+4J26YchPe2aGlsIdK2D1k2xhtEJntE
Ke5IwVaC7Oore9CXwNA9oVYHKn5PceZKHZw8iQ6nB2o6MVvsAH5QSwMEFAAAAAgAGIVYTU3p
+eCdAAAA2QAAACIAHAB0ZXN0X3N1aXRlL3Rlc3Rfc3luY19xZDEvZmlvXzAuam9iVVQJAANw
hNBbcITQW3V4CwABBOgDAAAE6AMAAC2NQQ6DMAwE7/5GHxCQ2mNe0SNCyDSGGJIYJWkRv69T
1RfvSruzwxpkxjACi6OjeturorRyIluu9IIbzMXed3Cc6VVt9xeSL2u8RDLV00YJzdOckveF
AxUDnD4Y2GElBQaRo9i+04P0jpsosYeM8ZgqR7IPyITuzKzpjMk1B9W3p3swaGHqRmjohJoP
mFdqTnHNLyzTLwOtXYha7QtQSwMEFAAAAAgAGIVYTYfTmaqdAAAA2QAAACIAHAB0ZXN0X3N1
aXRlL3Rlc3Rfc3luY19xZDEvZmlvXzEuam9iVVQJAANwhNBbcITQW3V4CwABBOgDAAAE6AMA
AC2NQQ6DMAwE7/5GHxAitce8okeEkCEGDCFGSVrE7+ug+uJdaXe2nYMMGDpg8XSUxVlVFGeO
5PIVR3jAkN1zA8+JxuKav5B0ObPITqYstFJE8zanpG3iQNkAxy8G9lhIgUHkyM42ehA/+ypK
tJBwP/rCO7kXJEJ/JtZ0wuirg7LUp3vQaqG3HVR0RM0HTDNVZ+H2E0t/Z6C2M5FX/A9QSwME
FAAAAAgAGIVYTdmcOXSeAAAA2QAAACIAHAB0ZXN0X3N1aXRlL3Rlc3Rfc3luY19xZDEvZmlv
XzIuam9iVVQJAANwhNBbcITQW3V4CwABBOgDAAAE6AMAAC2NTQ6DIBCF93ONHgA17ZJTdGmM
GWWUUWAM0BpvXzCdzbwveT/96mRCNwCLoSNb3RZFYeVAOl1hhgdMST93MBxpzrr5C4mXVlY8
qWxpo4DqrU6J+8KOkgIOX3RsMFMpdCJH0m1TDsLHb1IaW4jojzGzJ/2CSGjOyMUdMZhKkG19
ZQ/6Ehi7AWp1wOJ3GFeq1MHNC8t4e6CmE5HRHfwAUEsDBBQAAAAIABiFWE3rHle2ngAAANoA
AAAiABwAdGVzdF9zdWl0ZS90ZXN0X3N5bmNfcWQxL2Zpb18zLmpvYlVUCQADcITQW3CE0Ft1
eAsAAQToAwAABOgDAAAtjU0OgyAQhfdzjR4Aje2SU3RpjBlllFFgDNAab18wnc28L3k//epk
QjcAi6EjW90WRWHlQDpdYYYHTEk/dzAcac66+QuJl1ZWPKlsaaOA6q1OifvCjpICDl90bDBT
KXQiR9JtUw7Cx29SGluI6I8xsyf9gkhozsjFHTGYSpBtfWUP+hIYuwFqdcDidxhXqtTBzQvL
eHugphOR0R3AD1BLAQIeAxQAAAAIABiFWE1rbhZQnwAAANsAAAAjABgAAAAAAAEAAACkgQAA
AAB0ZXN0X3N1aXRlL3Rlc3RfYXN5bmNfcWQ4L2Zpb18wLmpvYlVUBQADcITQW3V4CwABBOgD
AAAE6AMAAFBLAQIeAxQAAAAIABiFWE2hVHYanwAAANsAAAAjABgAAAAAAAEAAACkgfwAAAB0
ZXN0X3N1aXRlL3Rlc3RfYXN5bmNfcWQ4L2Zpb18xLmpvYlVUBQADcITQW3V4CwABBOgDAAAE
6AMAAFBLAQIeAxQAAAAIABiFWE3/G9bEoAAAANsAAAAjABgAAAAAAAEAAACkgfgBAAB0ZXN0
X3N1aXRlL3Rlc3RfYXN5bmNfcWQ4L2Zpb18yLmpvYlVUBQADcITQW3V4CwABBOgDAAAE6AMA
AFBLAQIeAxQAAAAIABiFWE2RdOpkoAAAANwAAAAjABgAAAAAAAEAAACkgfUCAAB0ZXN0X3N1
aXRlL3Rlc3RfYXN5bmNfcWQ4L2Zpb18zLmpvYlVUBQADcITQW3V4CwABBOgDAAAE6AMAAFBL
AQIeAxQAAAAIABiFWE1N6fngnQAAANkAAAAiABgAAAAAAAEAAACkgfIDAAB0ZXN0X3N1aXRl
L3Rlc3Rfc3luY19xZDEvZmlvXzAuam9iVVQFAANwhNBbdXgLAAEE6AMAAAToAwAAUEsBAh4D
FAAAAAgAGIVYTYfTmaqdAAAA2QAAACIAGAAAAAAAAQAAAKSB6wQAAHRlc3Rfc3VpdGUvdGVz
dF9zeW5jX3FkMS9maW9fMS5qb2JVVAUAA3CE0Ft1eAsAAQToAwAABOgDAABQSwECHgMUAAAA
CAAYhVhN2Zw5dJ4AAADZAAAAIgAYAAAAAAABAAAApIHkBQAAdGVzdF9zdWl0ZS90ZXN0X3N5
bmNfcWQxL2Zpb18yLmpvYlVUBQADcITQW3V4CwABBOgDAAAE6AMAAFBLAQIeAxQAAAAIABiF
WE3rHle2ngAAANoAAAAiABgAAAAAAAEAAACkgd4GAAB0ZXN0X3N1aXRlL3Rlc3Rfc3luY19x
ZDEvZmlvXzMuam9iVVQFAANwhNBbdXgLAAEE6AMAAAToAwAAUEsFBgAAAAAIAAgARAMAANgH
AAAAAA==
--------------ADE9EDEE5100651B3E4D2FD7--

--UkVe3ev5knYc61hZbus0d7V8WjhxpfFvH--

--CCdIBZyDNkCZOg7MtDtGoqVCocCiPUAQc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREKAB0WIQQjpLt31k10FTLpDwzdnkSUycSdYAUCW9CzuAAKCRDdnkSUycSd
YN8aAP9BnELD5DATFQoikQOeMjggGdPp4ZT52UmMcGLrQCV6uAD+LojenW/veKXi
EdvHgu0d2pTDWvtqF55CU3BavtBnh18=
=GwB7
-----END PGP SIGNATURE-----

--CCdIBZyDNkCZOg7MtDtGoqVCocCiPUAQc--

