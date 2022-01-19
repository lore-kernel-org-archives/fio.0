Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA96AC433EF
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiASVOi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:14:38 -0500
Received: from mout.web.de ([212.227.15.4]:48565 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343608AbiASVOe (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642626871;
        bh=71JI6s1yPBXBXahs4ETkzjY8J8DoJgm/BIKLe1CUneA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=ZR9YE442cQjngukVDlPshtNI1QHqLGMIcJMDaCzkGgiWEjcdNAyKeG7IvclAstGb9
         5DroiYpzf+QYLrBg82VHFdBiPxwrpTn8bdHpqUjsIePfJAUWdvVN3aUJE8m/tLvF0b
         6V8Hokh/jMf5nwc6PamLkGqGVoTmMexU/UXhoPWc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N2BI2-1mAATR1OAg-013tYN; Wed, 19
 Jan 2022 22:14:31 +0100
Date:   Wed, 19 Jan 2022 21:14:30 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 5/8] blktrace.c: Don't hardcode direct-io
Message-ID: <239cc0c47c346408607772fb423aa5745a3779dd.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4uRbikNncaxX9HTbylvbYdF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:DOLf9wU3OIsHTq2KAANbOK9DyEu5Ot3jwc2b+IFUuWrniFjGzaE
 kXMih4kUsFKofu/+YLmmAifYmfSNEBZtxLhlIMnjl+U2XhZZKRo5Hltv6dmGkuwR1IAbB5k
 OD6qjXK+s9c7RqPd5xqiOZ/xxAq6SQdUEonIIALEtvS5KIEtrvo93x7PfPLb/caIcaouNW+
 VvIzJO4KOeQn+qpi62yEQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eGdFQgwyrwI=:EkyJIXkLoAdznbVMeGW7+P
 dB7hNL6/OPElNX01oy46qSfELiD2Bf9UR2LBZQ3i4GTtA8RUwLWsph0WQP3WAHoKoi4jtwWEi
 IphG3yfTW3ZnMxEI14dBUxhIaHXL7IqZFQpw03qkyDPmxmHX80JBJe8AsWmX0Ql3hhIqn1iHw
 Lq1qBhD/IQe2m5bhY1N6BHz/4DOQfiYRfnDbx8tcif7QX2D2nsXup1KyFr/93d0Nbza8oK7fx
 4Kb6LCmITeXytvpekcyb8XaR3KOe0tWw5v9TQnVDMA+zQ1oDfUJvVzbvYf3fPTNwX2UiXT2r6
 ExV37XpkWyPnEWNz5eDK2smN8aCt3ZvtQ3dxi5FTyMvMWnqT1Q3m3VVR32D9LsA600uJXkoI2
 G5IEyBOyAmi3YmiIN0hU2p5Ly5s2An4LlcY2dn2NUseru7DunJl3f2YflZsj9GDZGIe9LEsCH
 6OOaC8udksg5GhZw1g30gUmHzeyy6vtFY/iPtlg6sNzukUVMd8Ns08KFEi/9BnaHOPIZwTYa2
 ZvefMNumSDMdpME5EYqgJtfTvy56BzdyiDiUaByERMJaIYGIlxaOHcvwBsWqfdijInAdb2Abh
 N3V4H7sDvJWBXuMPx8+I2DnEW757Kr9FazhdbvrSuMQOw31BUIL9DOYqcPcecA1oIZXIT2zmy
 PgHgJibuYW2DWRLtKj702ahNbe5VeEJ7JFyWfJXRz4IL+b6FrPvuZgxQq+570OMCKxfOuEi29
 HavLoBbHOAVlz9VoiI5ENeDSsFbHrXTQYwPsa48uZpNrjaXlh3J+XgWe7htFArf6vu0L14TmR
 aY+kM1oF5afjXt75gDrfUJGVaBbo5pfAoyCzuTlsGIt8pxAWUsiaID0MPK1wsa+joewirQ9UI
 eOUf4FBpi91hmlrpuubaeMsPQWkkXRTeeHNSDw88zGkyRjiWRnC9htHHh+8v+j8aactGmTwt+
 D60nrfBmWjr5WRj1CIDNJbmJgLzQitbTJ3JeODF/6Tf8S9OGERURZvPH/k6SN1t2FyApxfZBx
 rJpRtklkg2HUhqn5kHspyk7CyuCeiO7ttwvkQ9vO44fPNC06vnN7KwLoOpXE0Ja1QKjFP/p16
 flchfe+HDcYbtg=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/4uRbikNncaxX9HTbylvbYdF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This is unexpected if one wants to test performance of a
standard filesystem (by pointing replay_redirect to a standard file)
with buffered io.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 blktrace.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/blktrace.c b/blktrace.c
index f1dbd1a6..7682a4d5 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -582,14 +582,6 @@ bool read_blktrace(struct thread_data* td)
 		td->o.max_bs[DDIR_TRIM] =3D rw_bs[DDIR_TRIM];
 	}
=20
-	/*
-	 * We need to do direct/raw ios to the device, to avoid getting
-	 * read-ahead in our way. But only do so if the minimum block size
-	 * is a multiple of 4k, otherwise we don't know if it's safe to do so.
-	 */
-	if (!fio_option_is_set(&td->o, odirect) && !(td_min_bs(td) & 4095))
-		td->o.odirect =3D 1;
-
 	/*
 	 * If depth wasn't manually set, use probed depth
 	 */
--=20
2.34.1


--Sig_/4uRbikNncaxX9HTbylvbYdF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofzYACgkQNasLKJxd
slgl9w//W98to9dHoCidTLV7b8ljnK2U0egsivcorPH4+c5J1Ky8W4yVsJ0CDrhy
mb5R4aJIkI1pI+8eOCfycy1vf9psySyecPyiZOW+vQuLZgYd8yL2NzBGFNvoeOOs
V3INTdDuAnM+fyTbzXV3KkZq9+HTyoCwY0h8GqFpy18WVEyJobwab98+n4BDwrRk
KnXTUgs6Gh2fHF1wMEUvQWZncwndPX2Mj8SZhyLBjF2jkYZzXWXT8qPqkQiSocSP
zKkAUps/Lbre1i9P06P5iiPhcmaSQ5mkiqQvMhW87B1d+BFx41QfGdkA3pCw9/oY
lLvKHym3QND1RM/bHqkCIfySqikvkITOkMP04mFlIp3aQyADVW+qb6fyPDJEp9YG
pC4BHFTYGGqZ9Y2m/d+lawv1cQt4KI++hYsa4lUbCLLOmg+K1u1Rq6fz5dhUWwYc
RkGk4yRbtmBIPBU5cs/1xJBDSI6MS/vjRdB2nIlgesimx5GNnbnRS8Ou+u8ZoWrw
OnQ+uSMmhTn1VbAHJRj7slflV580U8ldxS3ezr7Zy3tRE1YiH5itvF01/90kTWvD
SFWdg+ZfnURc4oriakDGmKK4bcu0Njo+NPbWrJGAe2caMc25WTUwy0cPgup3L9CH
PqNcHIav7sH760y0NzL3hM6lHYScGhxTMeqDR9r5ga4ZK4kL45c=
=y/oy
-----END PGP SIGNATURE-----

--Sig_/4uRbikNncaxX9HTbylvbYdF--
