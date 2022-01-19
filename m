Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E0EC433EF
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344200AbiASVTo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:19:44 -0500
Received: from mout.web.de ([212.227.15.14]:59041 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357287AbiASVTo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:19:44 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2022 16:19:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642627182;
        bh=iq0BobzIQ0kAmOeaqTI1gCJsEb1RvE9REDgHXh0aQXg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=QXnaXvnDbWS3ftqj54/Q5Tl8YmqQUBNVbOeF2uutbbwseRYD+swMuKDgIr5VhFmzb
         CapIYa8k/BsmD/PNRt8oExVbVrKeQAef7BoTuYYquOaP2gMgSBc4rRiQo3i/WLO1+a
         gAzwU+jVYat70Ye9RAwnr4FNdmECpMKaelU6O508=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N0Zns-1mP2pR1RMS-00wjdA; Wed, 19
 Jan 2022 22:14:41 +0100
Date:   Wed, 19 Jan 2022 21:14:40 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 8/8] iolog.c: Fix memory leak for blkparse case
Message-ID: <e4acf183ab789b7284bfa96089ebe1256e15f98d.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IoQkQfhzf6V1_FKIjgeg1Zm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:V0b4WlmOITe+WqGsvrhDqo/g5Zn2AOFOlPkthuZHhDmj4WPBPFu
 Dd2RKis4dDeK6daFTGZAMyMfxNNSXaglHJNV0zgSNGQnQ1utrq3cOjMXPGmF2hs7hDb3tvO
 oy0n1l5UpBMrb9mGQ2DwbS8fRze8hiOiP/Zgk2FYSn6m0fiWptKiPgo1f0qcKEDn4Mr7BvP
 TWCd+K4WKZI0QIX6Tux6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GEG5UQ0h/qA=:zYkQWS70hBUIVLNIpxfVsH
 EiO3Rw9PaSIadaXqRdn0Dvc8lwwgmL9QkFLbu/SqodBHKdvCPl6u9dndyWirHrEcayiMFhXk2
 hwEFB3k4ORx7O8c0Hs2Jo8C1oEW+a/AYv/HlwCBcvTD9Ru9/nLTqTidkDrFRoZeofVZd9Qi11
 yVNy4CPohuURxXVUJyYj2eO9fEYRr3E/4U+q1ucmftim4lxJML+QLkh/zFMFYXHb8E3SWFh/h
 CHTAX/1JzD07wk6bXZKiWZDXfiFQKYtj4QpU5ZvcY/JYSit0W4oZclQ2ayADZ6ynq4DbdMVPA
 UA3CpEjqv+bOUoNRlq2yb5pSwExXoDXcKxgAAgtnhc1AFRcslrrXVHbbfBBnpJtAWn6WA8XTA
 ZvczqTpFgBSxCB7xKASgLpIIIqbIiUDMQcAd/QOI7WgRX8krP/OrY9Iga+Ih5ijvSL8isTuDx
 eQFNVYS8XueEh5taYdpco2fGDG4UY1Xkcfdlfd0FiPjmF4MQ4njG+aTdr8jPiKvoWJs2As+0K
 TE40HiojMXxFrHHIF5XqB3RiU+xbMi9jtQ6k4A8s5Q+46wuqOA1BWVHhwAhw6WkQ+1D8VEuXL
 L82RRQO28GmMI675LAGMSfyzLzpMy51gAcxZ5DGDGcCR9SkfaEMMO97MV+oT8Ar6wt893hum1
 LwlMhrtvevWvPBV5C68mfaGBMBcMAr/v1301gXPvx0T8liazDK44NLb5j5ItY2St1JC1oOk8U
 WT6iUkUQyW/DwSxc1dK/7gsEY/Vp96DlvGIWtgfnbTu3MVNpdtHmL+ZlnkT+dyK0QJeprNWkJ
 z5ruYwTb/e0agoT10kqMz+HhEEiQjJccHuXxOLebaa/PqejPtxBh77ywZuowM1icuta4aycfx
 U+MmT114nPBpAKFlHcTntjyvtjw+FB5WV5s+N7FYyPD7v/mhfGuH5897LDFshsj7TXaXmfBRd
 xUoaAUUpDJ+C4uZlE+1dsemQsD3pRqGrWrBcfgwRr5soVWSPyk1EVT9VARzLXlXS2Bnbyn9EI
 GzZBgVZWgP6vy+IMzNzJVCwsviEahtxVcQrUUtCBWZUMZsV/DmbhjVp5iQ6Q0UZ1LO7gER78B
 /x06eM/Wd97olU=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/IoQkQfhzf6V1_FKIjgeg1Zm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

init_blkparse_read (load_blkparse previously) didn't free the
filename. Fix this by freeing it in the init_iolog function and
handling it for both init_iolog_read and init_blkparse_read.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 iolog.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/iolog.c b/iolog.c
index 5a41e93f..a2cf0c1c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -631,8 +631,6 @@ static bool init_iolog_read(struct thread_data *td, cha=
r *fname)
 	} else
 		f =3D fopen(fname, "r");
=20
-	free(fname);
-
 	if (!f) {
 		perror("fopen read iolog");
 		return false;
@@ -719,6 +717,7 @@ bool init_iolog(struct thread_data *td)
 			td->io_log_blktrace =3D 0;
 			ret =3D init_iolog_read(td, fname);
 		}
+		free(fname);
 	} else if (td->o.write_iolog_file)
 		ret =3D init_iolog_write(td);
 	else
--=20
2.34.1

--Sig_/IoQkQfhzf6V1_FKIjgeg1Zm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHof0AACgkQNasLKJxd
slihcBAArkTjOcKtRmntki1qtVJIIe4z/JExE8eWB+ILelUTcZmlhQuZs1fTiYCR
/qldt41qyVZbG5f4qV5AS6ZiNPVICpj3TkACDRUMU0zXK9K1hmhxs6z0HcHoD1QL
RoTWy9eq7ZbGftOlAHagkSjtLpkAMGWpJM/9bs2LqW8poiHDXydsffGfugfP1qB8
k6eUnJc4y8mUg8u0xh2FeQpif30a5TOUb9grHoEUVifbANtGbpAyv10+U/XT+m6U
dADb1oa7jH98R71BoUTxAtZXmiXP65VdDxVkCHxWBV2v8ZykrkKpol1WcAdr7P+C
uNGp9iS0em8zBPZ1F7it1jQ10cxFFtE4BsTqpcKX5ns8fzdqTuKc6in1crQ9L1qL
FQ3ecmnEGSk3FaHwV1WjIkHouvJU7hxPTDtBaFVK/6sSIuAHkD2Ojy5nT+obZh+p
FWSHCnyLAYROEjGUx8GbGJvV7sGiSPPyYT9afiHiCxin70/BIKpRTC/80IydWmZn
u1hMK9GN4MoBwtbyqPCVQsYWWpev4nqYBwwuWuhE/oi92WA17XMKtXMkbobMXVhP
Ejy5rhSZGTumgF25tuBqEFFTnUxOJhvg8xi+Z/jHSc9OuXif7CD9HvRE70pm5ZYN
wjSsqYfcek1iMQ4is2CxnEnwD0kAJsZeedvpr5hoMwFnqqjNV+Q=
=D8bF
-----END PGP SIGNATURE-----

--Sig_/IoQkQfhzf6V1_FKIjgeg1Zm--
